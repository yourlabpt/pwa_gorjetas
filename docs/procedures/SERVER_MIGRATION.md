# Migração para outro servidor (restore a partir de backup)

Guia para mover a aplicação para um servidor novo **com paragem planeado**, restaurando o banco a partir de um ficheiro `.dump`, sem perder dados.

Use este procedimento quando:

- Está a migrar de um servidor para outro
- O `app` falha com `P1010: User 'app' was denied access on the database 'app.public'`
- Já tentou corrigir permissões/senha mas o volume do Postgres ficou num estado inconsistente

> **Importante:** o backup mais recente no git pode estar desatualizado. Antes de desligar o servidor antigo, crie sempre um backup fresco com `./db-backup-restore.sh backup` e use esse ficheiro `.dump` na migração.

---

## Pré-requisitos no servidor novo

1. Docker e Docker Compose instalados
2. Repositório clonado (`git clone ...`)
3. `.env.production` copiado do servidor antigo (ou criado a partir de `.env.production.example`)

Confirme que estas variáveis estão **iguais ao servidor antigo** (sem aspas à volta dos valores):

| Variável | Porquê |
|----------|--------|
| `POSTGRES_USER` | Deve coincidir com o utilizador do backup |
| `POSTGRES_PASSWORD` | Usada pelo Postgres e pelo `DATABASE_URL` da app |
| `POSTGRES_DB` | Nome da base de dados a restaurar |
| `JWT_SECRET` | Se mudar, todos os utilizadores são deslogados |
| `SUPER_ADMIN_*` | Conta de bootstrap da plataforma |
| `CLOUDFLARED_TUNNEL_TOKEN` | Se usar Cloudflare Named Tunnel |

**Evite aspas no `.env`:**

```bash
# ERRADO
POSTGRES_PASSWORD="minha_senha"

# CERTO
POSTGRES_PASSWORD=minha_senha
```

Use uma senha **simples** (só letras e números) para evitar problemas de parsing no `DATABASE_URL`.

---

## No servidor antigo (antes de migrar)

```bash
cd /path/to/pwa_gorjetas

# 1) Backup final com todos os dados atuais
./db-backup-restore.sh backup

# 2) Parar tudo (pode ficar offline — é esperado)
sudo docker compose --env-file .env.production \
  -f docker-compose.prod.yml -f docker-compose.tunnel.yml down
```

Copie o ficheiro `.dump` mais recente para o servidor novo:

```bash
scp backups/backup_YYYY-MM-DD_HH-MM-SS.dump user@NOVO_SERVIDOR:/path/to/pwa_gorjetas/backups/
```

Ou faça `git add`, `commit` e `push` do backup e `git pull` no servidor novo.

---

## No servidor novo — procedimento completo

Defina o alias de compose (ajuste se **não** usar Cloudflare tunnel):

```bash
cd /path/to/pwa_gorjetas

# Com Cloudflare tunnel:
COMPOSE="sudo docker compose --env-file .env.production -f docker-compose.prod.yml -f docker-compose.tunnel.yml"

# Sem tunnel (só Caddy + domínio público):
# COMPOSE="sudo docker compose --env-file .env.production -f docker-compose.prod.yml"

source <(grep -E '^POSTGRES_' .env.production | sed 's/^/export /')
```

### Passo 1 — Apagar volume antigo corrompido

```bash
$COMPOSE down -v
```

**Porquê:** erros de migração (restore parcial, senha errada, permissões) ficam gravados no volume Docker `postgres_data`. O `-v` apaga esse volume para começar com Postgres virgem. Os dados vêm do backup — não se perde nada se o `.dump` estiver correto.

---

### Passo 2 — Subir só o Postgres

```bash
$COMPOSE up -d db
sleep 20
$COMPOSE ps
```

**Porquê:** o Postgres precisa de estar a correr e **healthy** antes do restore. Subir só `db` evita que a `app` tente ligar a uma base ainda vazia ou mal configurada.

---

### Passo 3 — Restaurar o backup

```bash
ls -lh backups/*.dump

sudo docker exec -i $(sudo docker ps -qf "name=db") pg_restore \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  --no-owner --no-privileges \
  < backups/backup_YYYY-MM-DD_HH-MM-SS.dump
```

Substitua o nome do ficheiro pelo backup mais recente.

**Porquê cada flag:**

| Flag | Motivo |
|------|--------|
| `--no-owner` | O dono original dos objetos pode não existir neste servidor; os objetos passam a pertencer ao utilizador que faz o restore |
| `--no-privileges` | Evita conflitos de `GRANT` do servidor antigo |
| Sem `--clean` em volume fresco | Num volume novo não é necessário; reduz avisos |

Avisos no output são normais. Preocupe-se apenas com linhas `FATAL` ou `ERROR` no final.

Se o restore falhar porque a base já tem objetos:

```bash
sudo docker exec -i $(sudo docker ps -qf "name=db") pg_restore \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  --clean --if-exists --no-owner --no-privileges \
  < backups/backup_YYYY-MM-DD_HH-MM-SS.dump
```

---

### Passo 4 — Corrigir permissões

```bash
sudo docker exec -i $(sudo docker ps -qf "name=db") psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<SQL
ALTER DATABASE $POSTGRES_DB OWNER TO $POSTGRES_USER;
ALTER SCHEMA public OWNER TO $POSTGRES_USER;
GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
GRANT ALL ON SCHEMA public TO $POSTGRES_USER;
GRANT ALL ON ALL TABLES IN SCHEMA public TO $POSTGRES_USER;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO $POSTGRES_USER;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO $POSTGRES_USER;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO $POSTGRES_USER;
SQL
```

**Porquê:** o `pg_restore --no-privileges` não reaplica grants. Sem este passo, a app pode falhar com `P1010` mesmo com a senha correta, porque o utilizador `app` não tem acesso ao schema `public`.

---

### Passo 5 — Sincronizar a senha com o `.env`

```bash
sudo docker exec -i $(sudo docker ps -qf "name=db") psql -U "$POSTGRES_USER" -d postgres \
  -c "ALTER USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';"
```

**Porquê:** dentro do container `db`, `psql -U app` sem `-h` usa autenticação local (socket) e **não testa a senha**. A app liga-se via rede (`db:5432`) com password no `DATABASE_URL`. Este passo garante que a senha no Postgres é exatamente a do `.env.production`.

---

### Passo 6 — Verificar ligação e dados (antes de subir a app)

Teste autenticação por TCP (como a app faz):

```bash
sudo docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" $(sudo docker ps -qf "name=db") \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT 1;"
```

Deve devolver `1`. Se falhar com `password authentication failed`, volte ao Passo 5.

Confirme que os dados do backup estão presentes. **Nota:** no Prisma, o model `User` mapeia para a tabela `users` (não `"User"`):

```bash
sudo docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" $(sudo docker ps -qf "name=db") \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT COUNT(*) AS users FROM users;"

sudo docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" $(sudo docker ps -qf "name=db") \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT COUNT(*) AS restaurantes FROM restaurantes;"
```

Listar todas as tabelas:

```bash
sudo docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" $(sudo docker ps -qf "name=db") \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "\dt"
```

Compare as contagens com o que espera do backup (utilizadores, restaurantes, registos recentes).

---

### Passo 7 — Subir a stack completa

```bash
$COMPOSE up -d --build
$COMPOSE logs -f app
```

**Porquê `--build`:** garante que a imagem da app está atualizada com o código do repositório.

Logs de sucesso esperados:

```
Migrations complete.
[Nest] ... Nest application successfully started
```

As migrações Prisma (`entrypoint.sh`) só aplicam migrações pendentes — **não apagam dados**.

---

### Passo 8 — Verificação final na aplicação

1. Abrir a URL de produção (Cloudflare tunnel ou domínio)
2. Fazer login com uma conta existente
3. Verificar restaurantes, funcionários e um registo de faturamento recente
4. Criar um registo de teste, refrescar a página e confirmar que persiste

---

## Cloudflare no servidor novo

Se o servidor antigo usava Cloudflare Named Tunnel:

- **Não** instale Cloudflare manualmente — corre como container Docker (`cloudflared` em `docker-compose.tunnel.yml`)
- Com o servidor antigo já em `down`, suba `cloudflared` no novo servidor com o mesmo `CLOUDFLARED_TUNNEL_TOKEN`
- Não corra o mesmo token em dois servidores ao mesmo tempo

---

## Resumo da ordem

```
Servidor antigo:  backup → docker down
Servidor novo:    down -v → db up → restore → permissões → senha → verificar → up --build
Verificar:        login + dados + registo de teste
```

---

## Erros comuns

### `P1010: User 'app' was denied access on the database 'app.public'`

Causas habituais:

1. Volume Postgres criado com senha diferente da do `.env` → resolver com `down -v` + restore (este guia)
2. Permissões em falta após restore → Passo 4
3. Senha no Postgres diferente da do `DATABASE_URL` → Passo 5
4. Caracteres especiais na senha (`@`, `#`, `%`) → usar senha alfanumérica simples

### `psql -U app` funciona mas a app não

`psql` sem `-h` dentro do container `db` usa socket local e **não valida a password**. Teste sempre com `-h 127.0.0.1` e `PGPASSWORD`.

### `SELECT COUNT(*) FROM "User"` falha

A tabela chama-se `users` (ver `@@map("users")` em `backend/prisma/schema.prisma`). Use:

```sql
SELECT COUNT(*) FROM users;
```

### Dados desatualizados após migração

Se restaurou um backup antigo do git, os dados refletem a data desse backup. Para dados atuais, use o backup criado no Passo «servidor antigo» imediatamente antes do `docker down`.

---

## Rollback

Se algo correr mal no servidor novo:

1. Pare o servidor novo: `$COMPOSE down`
2. Volte a ligar o servidor antigo com o backup pré-migração ainda intacto no volume ou restaure o `.dump` lá

Mantenha o backup `.dump` até confirmar que o novo servidor está estável durante 24–48 horas.
