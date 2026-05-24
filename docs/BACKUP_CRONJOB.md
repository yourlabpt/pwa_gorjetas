# Cronjob de backup diário

Este guia cria um agendamento diário para o banco atual, rodando às 00:00 e removendo backups com mais de 30 dias.

A rotina usa o script existente `db-backup-restore.sh`, que agora executa a limpeza automaticamente ao final de cada backup.

## O que o cron faz

- Executa um backup completo do Postgres todo dia à meia-noite.
- Gera dois arquivos por execução:
  - `.sql` para restore legível.
  - `.dump` para restore mais seguro.
- Remove automaticamente arquivos `.sql` e `.dump` com mais de 30 dias.

## Configuração sugerida

Edite o crontab do usuário que tem acesso ao Docker:

```bash
crontab -e
```

Adicione esta linha, ajustando o caminho absoluto do projeto se necessário:

```cron
0 0 * * * cd /home/yourlab/pwa_gorjetas && CONTAINER_NAME=pwa_restaurantes_db BACKUP_DIR=/home/yourlab/pwa_gorjetas/backups ENV_FILE=/home/yourlab/pwa_gorjetas/.env.production /bin/bash /home/yourlab/pwa_gorjetas/db-backup-restore.sh backup >> /home/yourlab/pwa_gorjetas/backups/backup-cron.log 2>&1
```

## Como a retenção funciona

A retenção é controlada pelo parâmetro `BACKUP_RETENTION_DAYS` no script.

- Valor padrão: `30`
- Para alterar, defina a variável no cron, por exemplo:

```cron
0 0 * * * cd /home/yourlab/pwa_gorjetas && CONTAINER_NAME=pwa_restaurantes_db BACKUP_DIR=/home/yourlab/pwa_gorjetas/backups ENV_FILE=/home/yourlab/pwa_gorjetas/.env.production BACKUP_RETENTION_DAYS=30 /bin/bash /home/yourlab/pwa_gorjetas/db-backup-restore.sh backup >> /home/yourlab/pwa_gorjetas/backups/backup-cron.log 2>&1
```

## Observações importantes

- O caminho do `BACKUP_DIR` precisa existir e ser gravável pelo usuário do cron.
- Se você usar outro ambiente, ajuste `CONTAINER_NAME` para o nome real do container do Postgres.
- Para validar manualmente, rode:

```bash
CONTAINER_NAME=pwa_restaurantes_db BACKUP_DIR=/home/yourlab/pwa_gorjetas/backups ENV_FILE=/home/yourlab/pwa_gorjetas/.env.production /bin/bash /home/yourlab/pwa_gorjetas/db-backup-restore.sh backup
```
