# pwa_gorjetas
Aplicação para gestão de faturamento diário e distribuição de gorjetas.

## ⛔ REGRA N.º 1 — NUNCA APAGAR A BASE DE DADOS
**NEVER RUN, SUGGEST OR SCRIPT ANY COMMAND THAT DELETES THE DATABASE OR ITS DATA.**

Esta aplicação guarda dados financeiros reais de clientes. Nenhum deploy, atualização, correção ou "reset" pode apagar dados. Não existe exceção para "é só o ambiente de teste" quando o comando é executado no servidor.

**Proibido, sempre (em produção e no servidor):**

| Comando | Porque é proibido |
|---|---|
| `docker compose ... down -v` / `down --volumes` | Apaga o volume do Postgres. `docker-compose.yml` e `docker-compose.prod.yml` usam o **mesmo** volume (`pwa_gorjetas_postgres_data`) quando executados nesta pasta. |
| `docker volume rm ...`, `docker volume prune`, `docker system prune --volumes` | Apaga volumes com dados. |
| `npx prisma migrate reset` | Apaga e recria a base inteira. |
| `npx prisma db push --accept-data-loss` / `--force-reset` | Apaga colunas/tabelas para acertar o schema. |
| `DROP DATABASE`, `DROP SCHEMA`, `DROP TABLE`, `TRUNCATE`, `dropdb` | Apagam dados diretamente. |
| `DELETE FROM <tabela>` sem `WHERE` específico, ou qualquer `DELETE`/`UPDATE` manual em produção | Perda ou corrupção de dados financeiros. |
| Apagar ficheiros em `backups/` ou a pasta de dados do Postgres | Remove a única forma de recuperação. |
| `./setup.sh` no servidor de produção | É um script **só para desenvolvimento local**. |

**Migrações:** só são aceites migrações **aditivas** (criar tabela, criar coluna opcional, criar índice). Qualquer migração com `DROP`, `DELETE`, `TRUNCATE`, remoção/renomeação de coluna ou mudança de tipo precisa de aprovação explícita do responsável, backup feito antes e ensaio numa cópia restaurada (ver abaixo). O container aplica migrações pendentes no arranque (`prisma migrate deploy`), por isso uma migração destrutiva no repositório é executada automaticamente no próximo deploy.

**Rollback:** faz-se voltando a publicar a versão anterior do código. Tabelas ou colunas novas ficam na base (a versão anterior ignora-as). Nunca se faz rollback apagando tabelas.

**Restaurar um backup** (`./db-backup-restore.sh restore`) substitui os dados atuais. Só em recuperação de desastre, com aprovação explícita do responsável. O script tira automaticamente um backup dos dados atuais antes de restaurar e aborta se esse backup falhar.

**Deploy seguro:** use sempre o procedimento [Sandbox + deploy na DigitalOcean](docs/procedures/SANDBOX_AND_DEPLOY.md) (`scripts/sandbox-test.sh`, tag git, `scripts/deploy-remote.sh`). Ele faz, por esta ordem: teste na sandbox com cópia da produção, backup verificado, bloqueio de migrações destrutivas, deploy, verificação de saúde e de contagens, e rollback automático do código se a nova versão não arrancar.

Qualquer pessoa ou ferramenta (incluindo assistentes de IA) que proponha um dos comandos proibidos está errada: pare e peça confirmação ao responsável.

## Documentação

A documentação está organizada por tipo em [docs/README.md](docs/README.md).

## Deploy em produção (Ubuntu + Docker)
### 0) Pré-requisitos
1. Docker e Docker Compose instalados no servidor.
2. Copiar o arquivo de ambiente:
```bash
cp .env.production.example .env.production
```
3. Editar `.env.production` com valores reais:
```bash
nano .env.production
```

Variáveis obrigatórias:
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`
- `JWT_SECRET`
- `JWT_EXPIRES_IN`
- `SUPER_ADMIN_NAME`
- `SUPER_ADMIN_EMAIL`
- `SUPER_ADMIN_PASSWORD`
- `CORS_ORIGINS`

Se usar domínio com Caddy/HTTPS público (sem tunnel), também preencher:
- `DOMAIN`
- `ACME_EMAIL`

### 1) Primeiro deploy (sem Cloudflare tunnel)
Use quando o servidor tem portas 80/443 abertas e domínio apontando para o IP.

```bash
sudo docker compose --env-file .env.production -f docker-compose.prod.yml up -d --build
sudo docker compose --env-file .env.production -f docker-compose.prod.yml ps
sudo docker compose --env-file .env.production -f docker-compose.prod.yml logs -f app
```

### 2) Primeiro deploy (com Cloudflare tunnel)
Use quando não há portas públicas (ex.: CGNAT).

Pré-requisito:
- Criar um **Named Tunnel** no Cloudflare Zero Trust.
- Copiar o token do túnel para `.env.production`:
  - `CLOUDFLARED_TUNNEL_TOKEN=<seu_token>`

```bash
sudo docker compose --env-file .env.production -f docker-compose.prod.yml -f docker-compose.tunnel.yml up -d --build
sudo docker compose --env-file .env.production -f docker-compose.prod.yml -f docker-compose.tunnel.yml logs -f cloudflared
```

Observação:
- Evite Quick Tunnel (`trycloudflare`) em produção: pode sofrer limite/rate limit (`429/1015`).
- Com Named Tunnel, o endpoint fica estável e sem rotação automática de URL.

### 3) Deploy de atualização (nova versão do código)
Forma normal: [Sandbox + deploy na DigitalOcean](docs/procedures/SANDBOX_AND_DEPLOY.md).

Só em último caso, manualmente no servidor, sem apagar dados (**REGRA N.º 1**). Primeiro, sempre, o backup:
```bash
./db-backup-restore.sh backup
```
Depois (note: `down` **sem** `-v`):

Sem tunnel:
```bash
sudo docker compose --env-file .env.production -f docker-compose.prod.yml down
sudo docker compose --env-file .env.production -f docker-compose.prod.yml up -d --build
```

Com tunnel:
```bash
sudo docker compose --env-file .env.production -f docker-compose.prod.yml -f docker-compose.tunnel.yml down
sudo docker compose --env-file .env.production -f docker-compose.prod.yml -f docker-compose.tunnel.yml up -d --build
```

### 4) Senha do banco (importante)
#### Primeiro uso
- Defina uma senha forte em `POSTGRES_PASSWORD` antes do primeiro `up`.
- Essa senha é usada para criar o usuário do Postgres no volume inicial.

#### Ambiente já em produção (volume existente)
Trocar `POSTGRES_PASSWORD` no `.env.production` sozinho não altera a senha dentro do banco já criado.

Altere a senha dentro do banco, preservando os dados:
```bash
sudo docker compose --env-file .env.production -f docker-compose.prod.yml exec db psql -U <usuario> -d <database>
# no prompt do psql:
ALTER USER <usuario> WITH PASSWORD '<nova_senha>';
```
Depois atualize `POSTGRES_PASSWORD` no `.env.production` com o mesmo valor.

⛔ Nunca recrie o banco do zero para trocar a senha (`down -v` apaga todos os dados). Ver **REGRA N.º 1**.

### 5) SUPER_ADMIN (bootstrap)
- No startup, a API sincroniza automaticamente o `SUPER_ADMIN` usando:
  - `SUPER_ADMIN_NAME`
  - `SUPER_ADMIN_EMAIL`
  - `SUPER_ADMIN_PASSWORD`
- Se o usuário já existir, ele é atualizado (nome/email/senha/role).

### 6) Backup automático diário
Veja a configuração pronta de cron em [docs/BACKUP_CRONJOB.md](docs/BACKUP_CRONJOB.md) para executar backup à meia-noite e manter apenas os últimos 30 dias.

### 7) Migração para outro servidor (restore a partir de backup)

Use quando está a mover a app para um servidor novo e quer restaurar o banco a partir de um ficheiro `.dump`. Aceita paragem planeado — não precisa de manter o servidor antigo online durante a migração.

**Guia completo (com explicação de cada passo):** [docs/procedures/SERVER_MIGRATION.md](docs/procedures/SERVER_MIGRATION.md)

Resumo:

```bash
cd /path/to/pwa_gorjetas
COMPOSE="sudo docker compose --env-file .env.production -f docker-compose.prod.yml -f docker-compose.tunnel.yml"
source <(grep -E '^POSTGRES_' .env.production | sed 's/^/export /')

# 1) Volume fresco (apaga estado corrompido; dados vêm do backup)
$COMPOSE down -v

# 2) Só Postgres
$COMPOSE up -d db && sleep 20

# 3) Restore
sudo docker exec -i $(sudo docker ps -qf "name=db") pg_restore \
  -U "$POSTGRES_USER" -d "$POSTGRES_DB" --no-owner --no-privileges \
  < backups/backup_YYYY-MM-DD_HH-MM-SS.dump

# 4) Permissões + senha (ver guia completo para os comandos SQL)

# 5) Stack completa
$COMPOSE up -d --build
$COMPOSE logs -f app
```

**No servidor antigo, antes de migrar:** `./db-backup-restore.sh backup` e depois `docker compose down`.

**Verificar dados após restore** (a tabela Prisma `User` chama-se `users` na base de dados):

```bash
sudo docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" $(sudo docker ps -qf "name=db") \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT COUNT(*) FROM users;"
```
