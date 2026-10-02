---
title: Fundações, segurança e ambiente de testes
weeks: 2
status: planeada
---

## Objetivo
A app atual fica segura e vigiada antes de receber dados mais sensíveis (IBAN, salários, faturas). Há um link de testes separado da produção. Esforço estimado: 4–6 dias. Pode arrancar já, sem esperar pelo mock-up.

## Features

### Fechar o registo público e proteger casas
- Requisitos: plataforma-operacao
As contas novas passam a ser criadas só por um administrador. Apagar uma casa com dados financeiros deixa de ser possível; passa a existir só "Desativar".
1. Em `backend/src/auth/auth.controller.ts`, retirar `@Public()` de `register` (ou rejeitar quando quem cria não é administrador, com `isAdminLike` de `role.util.ts`). Proteger a página `frontend/src/pages/register.tsx` como já se faz em `usuarios.tsx`.
2. Em `restaurantes.service.ts`, `remove` devolve 409 se a casa tiver fecho, faturação, distribuição ou acerto, e indica `toggle-active`. O endpoint fica só para SUPER_ADMIN. Muda só o código, não o esquema.
3. Juntar os eventos de auditoria que faltam ao fecho e ao acerto final (mesmo padrão `audit.action` dos outros serviços).
4. Testes jest: registo anónimo recusado; administrador cria gerente com casas; eliminar uma casa com dados devolve 409.

### Ambiente de testes com link próprio
- Requisitos: plataforma-operacao
Um segundo ambiente, com base de dados própria, para o cliente experimentar sem tocar na produção.
1. Criar um droplet pequeno e separado, com um subdomínio no túnel Cloudflare, protegido por login.
2. Reutilizar `docker-compose.localtest.yml` (projeto `pwa_sandbox`) com um volume próprio. Nunca partilhar o volume `pwa_gorjetas_postgres_data`.
3. Carregar uma cópia anonimizada de um dump recente, criada numa base nova e nunca sobre produção.
4. Documentar em `docs/procedures/SANDBOX_AND_DEPLOY.md` como publicar no ambiente de testes.

### Backups fora do droplet e monitorização
- Requisitos: plataforma-operacao
Saber quando a app cai, quando há erros e se o backup da noite correu.
1. Corrigir o nome do contentor no cron de backup, depois de verificar no droplet que hoje falha. Juntar uma cópia diária para DigitalOcean Spaces e um ping de "backup feito" para um serviço de alertas.
2. Criar `GET /health` (verifica a base de dados) e usá-lo no `scripts/deploy.sh` em vez de `/auth/me`.
3. Ligar um monitor de disponibilidade externo, rastreio de erros no backend e frontend, e rotação de logs Docker (`max-size`).
4. Ligar os alertas DigitalOcean de CPU, memória e disco a 80%.

### Atualização técnica e CI
- Requisitos: plataforma-operacao
1. Passar a imagem de Node 18 para Node 20 LTS e ensaiar com `scripts/sandbox-test.sh`.
2. Criar um workflow GitHub Actions que corre `npm test` do backend e `tsc --noEmit` do frontend em cada push.
3. Propor ao dono `MIGRATE_STRICT=true` em produção, para uma migração falhada parar o arranque.

## Entregáveis
- Registo fechado e casas protegidas, publicados com uma release `release-AAAA-MM-DD-N`
- Link de testes a funcionar, com base própria
- Backups diários fora do droplet, com alerta se falharem
- Endpoint `/health`, monitor de disponibilidade e rastreio de erros ativos
- Node 20 e CI a correr os testes
