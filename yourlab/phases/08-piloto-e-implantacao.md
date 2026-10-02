---
title: Piloto em 3 casas e implantação
weeks: 5
status: planeada
---

## Objetivo
Três casas usam a app durante um mês completo em paralelo com a folha de cálculo. Os totais batem certo e depois a app chega às restantes casas. Esforço estimado: 5–7 dias de trabalho, espalhados por cerca de 5 semanas.

## Features

### Ligar o piloto
- Requisitos: plataforma-operacao, custos-mensais
1. Ligar `modulo_financeiro_ativo` e a regra nova do cash nas 3 casas escolhidas, a partir do primeiro dia de um mês.
2. Formação curta para os gerentes (fecho, despesas, acerto) e para o escritório (faturas, pagamentos).

### Mês em paralelo e reconciliação
- Requisitos: painel-kpis
1. Durante o mês a folha continua a ser preenchida.
2. No fim, comparar folha e app linha a linha: faturação, multibanco, despesas, cash, faturas, food cost, balanço.
3. Explicar cada diferença: erro da folha, erro de lançamento ou erro da app. Corrigir as da app.

### Implantação nas restantes casas
- Requisitos: plataforma-operacao
1. Ligar as casas em grupos, sempre no início do mês, com uma release ensaiada em `scripts/sandbox-test.sh`.
2. Deixar a folha só de leitura depois do primeiro mês sem diferenças.

## Entregáveis
- Relatório de reconciliação do mês de piloto
- Todas as casas na app
- Folha de cálculo arquivada
