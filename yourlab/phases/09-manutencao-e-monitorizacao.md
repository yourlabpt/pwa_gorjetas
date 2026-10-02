---
title: Manutenção e monitorização
weeks: 4
status: planeada
---

## Objetivo
Depois de a app estar em produção, mantê-la estável, segura e atualizada, num ciclo mensal contínuo (as 4 semanas são um ciclo). Hoje a manutenção custa 95 €/mês. Com os módulos novos estima-se mais 50% de carga, o que dá 120 €/mês durante o piloto e 145 €/mês depois da implantação total. A infraestrutura nova (ambiente de testes e cópia dos backups) é cobrada à parte, a confirmar com os preços DigitalOcean.

## Features

### Vigilância
- Requisitos: plataforma-operacao
1. Rever todos os meses os alertas de disponibilidade, os erros registados, o disco e a memória do droplet.
2. Confirmar todas as semanas que os backups diários existem fora do droplet. Fazer um teste de reposição por trimestre numa base nova.

### Atualizações
- Requisitos: plataforma-operacao
1. Rever as dependências todos os meses (NestJS, Prisma, Next.js, Node LTS), sempre com ensaio em `scripts/sandbox-test.sh` e release com tag.
2. Rever os acessos a cada trimestre (utilizadores ativos, administradores, quem vê IBAN e salários).

### Pequenas mudanças e apoio
- Requisitos: painel-kpis, custos-mensais
Ajustes de taxas (segurança social, IVA, limite de food cost), novas casas, novos fornecedores em massa, dúvidas dos utilizadores.

## Entregáveis
- Relatório mensal curto: disponibilidade, incidentes, backups, atualizações
- Teste de reposição de backup por trimestre
