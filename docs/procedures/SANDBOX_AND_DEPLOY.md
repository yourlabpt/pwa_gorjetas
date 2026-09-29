# Procedimento: testar na sandbox e fazer deploy na DigitalOcean

> ⛔ **REGRA N.º 1 — NUNCA APAGAR A BASE DE DADOS.** Nenhum passo deste procedimento apaga base, volumes, tabelas, dados ou backups. Não acrescente comandos que o façam (`down -v`, `prisma migrate reset`, `DROP`, `TRUNCATE`, `docker volume rm`...). Lista completa em [README.md](../../README.md).

## Resumo: cada release são 6 comandos

No portátil, na pasta do projeto:

```bash
git switch main
```
```bash
git pull --ff-only
```
```bash
scripts/sandbox-test.sh --pull-latest
```
```bash
git tag -a release-2026-09-29-1 -m "Descrição curta da release"
```
```bash
git push origin release-2026-09-29-1
```
```bash
scripts/deploy-remote.sh release-2026-09-29-1
```

Nome da tag: `release-AAAA-MM-DD-N` (N = 1, 2, ... se houver mais de uma no mesmo dia).

O código chega ao `main` como sempre: branch, pull request, merge. Só se faz release a partir do `main`.

## O que cada passo garante

| Passo | O que faz | Para se |
|---|---|---|
| `sandbox-test.sh` | Constrói **a mesma imagem Docker da produção** e corre-a contra uma cópia do backup mais recente da produção, restaurada numa base **nova e vazia** da sandbox. | Migração destrutiva, testes unitários falham, build falha, migrações falham, alguma tabela perde linhas, a API lê valores diferentes dos que estão na base. |
| `git tag` + `git push` | Fixa exatamente o código que foi testado. | — |
| `deploy-remote.sh` | Confirma que a tag está no GitHub e no `main`, que **essa mesma commit passou na sandbox**, pede para escrever o nome da tag, e corre o deploy no droplet por SSH. | Tag inexistente, fora do `main`, sem sandbox aprovada, confirmação errada. |
| Deploy no droplet | 1) verificações; 2) copia backups e qualquer ficheiro que o git fosse remover para fora do repositório; 3) backup verificado da base; 4) `git checkout` da tag; 5) build e arranque (migrações aditivas aplicam-se sozinhas); 6) saúde da API/frontend, migrações e contagem de linhas. | Ficheiros editados no servidor, compose errado, pouco disco, migração destrutiva. Se a nova versão não arrancar, **volta sozinha à versão anterior** (só código; os dados ficam). |

## Rollback

Voltar a publicar a tag anterior. É só código; a base de dados não é tocada e tabelas/colunas novas ficam (a versão anterior ignora-as).

```bash
scripts/deploy-remote.sh release-2026-09-22-1
```

Se essa tag antiga não tiver marca de sandbox neste portátil, em emergência use `--skip-sandbox`. Restaurar um backup por cima da produção **não** é rollback: só com aprovação explícita do responsável.

## Configuração única

### Portátil
1. Docker Desktop, Node 18+, Python 3 e acesso SSH por chave ao droplet (`ssh-copy-id yourlab@<ip-do-droplet>`).
2. Configuração do deploy:
   ```bash
   cp deploy/deploy.env.example deploy/deploy.env
   ```
   Preencher `DEPLOY_SSH` (ex.: `yourlab@<ip>`) e `DEPLOY_PATH` (ex.: `/home/yourlab/pwa_gorjetas`). O ficheiro não vai para o git.

### Droplet DigitalOcean (Ubuntu)
1. Docker Engine + plugin `docker compose`; o utilizador do deploy no grupo `docker`.
2. Clone do repositório em `DEPLOY_PATH` e `.env.production` preenchido (ver README).
3. Configuração do servidor:
   ```bash
   cp deploy/server.env.example deploy/server.env
   ```
   - `COMPOSE_ARGS`: os ficheiros compose que gerem a stack **que está a correr** (com ou sem Cloudflare tunnel).
   - `DB_CONTAINER`: nome real do container Postgres (`docker ps`).
   - `SAFE_BACKUP_DIR`: pasta **fora** do clone (ex.: `/home/yourlab/pwa_gorjetas_safe_backups`). O git nunca lhe toca.
4. Backup diário por cron: [BACKUP_CRONJOB.md](BACKUP_CRONJOB.md). O `CONTAINER_NAME` do cron tem de ser o mesmo `DB_CONTAINER`.
5. Firewall: só SSH (e 80/443 se usar Caddy sem tunnel).
6. Validar tudo sem mudar nada (a tag deve ser a versão que já está em produção):
   ```bash
   scripts/deploy-remote.sh --check release-2026-09-29-1
   ```
   Se disser `COMPOSE_ARGS does not manage ...`, corrija `deploy/server.env`: deployar com os ficheiros compose errados iniciaria uma segunda stack.

### Droplet novo e vazio (migração de servidor)
1. No droplet, com o `.env.production` final, arrancar **só a base**: `docker compose $COMPOSE_ARGS up -d db`.
2. Copiar para o droplet o backup mais recente do servidor antigo e restaurá-lo nessa base vazia: `./db-backup-restore.sh restore <ficheiro.dump>` (o script faz primeiro um backup do estado atual).
3. `scripts/deploy-remote.sh <tag>` a partir do portátil.
4. Só desligar o servidor antigo depois de confirmar os dados no novo. Nunca apagar os volumes do antigo.

## Sandbox em detalhe

- `--pull-latest` descarrega o `.dump` mais recente do droplet para `sandbox/` (fora do git). Sem esta opção usa o backup mais recente que existir em `sandbox/` ou `backups/`.
- Cada execução cria uma base nova `sandbox_AAAAMMDD_HHMMSS` no container isolado `pwa_sandbox_db`. As bases da sandbox nunca são apagadas.
- No fim, a app fica aberta em http://localhost:3300 (utilizador em `.env.localtest`, criado automaticamente com segredos só da sandbox).
- `--e2e` corre também o cenário de ativar/desativar colaboradores.
- Relatório de cada execução: `sandbox/report_*.txt`.
- Parar a sandbox (sem apagar nada): `docker compose -f docker-compose.localtest.yml stop`.
- A marca `sandbox/passed_<commit>` só é escrita com a árvore limpa (tudo em commit), porque o deploy publica a commit e não os ficheiros locais.

## Onde ficam os registos (droplet)

Em `SAFE_BACKUP_DIR`:
- `deploy-history.log`: uma linha por deploy (de → para, resultado, backup usado).
- `predeploy_*.dump`: backup verificado feito antes de cada deploy.
- `deploy_*.log`: saída completa de cada deploy.
- `counts_before_*` / `counts_after_*`: linhas por tabela antes e depois.
- `repo-backups/` e `git-removed/`: cópias de backups e de ficheiros que uma release removeu do git.

## Quando o deploy para

| Mensagem | O que fazer |
|---|---|
| `migration guard` | A release tem `DROP`, `DELETE`, `TRUNCATE`, `UPDATE`, `RENAME` ou mudança de tipo numa migração. Reescrever como migração aditiva. Exceção só com aprovação explícita do responsável, ensaio na sandbox e o nome da pasta em `APPROVED_MIGRATIONS`. |
| `tracked files were edited on the server` | Alguém editou ficheiros no droplet. Levar essa alteração para o repositório por PR; não editar no servidor. |
| `COMPOSE_ARGS does not manage ...` | Corrigir `deploy/server.env` (ver configuração única). |
| `less than N GB free disk` | Libertar espaço de forma controlada pelo responsável. Não usar `prune` de volumes. |
| `did not become healthy` | Já voltou sozinho à versão anterior. Ver o `deploy_*.log`, corrigir, nova release. |
| `ALERT: rows decreased` | Parar tudo e avisar o responsável. O `predeploy_*.dump` indicado tem os dados de antes. |
| `no sandbox pass for ...` | Correr a sandbox nessa commit exata (`git checkout <tag>` e `scripts/sandbox-test.sh --pull-latest`). |
