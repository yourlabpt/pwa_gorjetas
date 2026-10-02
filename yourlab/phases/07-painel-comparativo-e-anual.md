---
title: Painel, comparativo e anual
weeks: 2
status: planeada
---

## Objetivo
Os donos leem cada casa e o grupo sem copiar nada à mão: conta de exploração do mês, food cost face ao limite, balanço, comparação entre casas e com o ano anterior. Substitui os separadores CONTROLE COM GRÁFICO e PORCENTAGENS ANO. Esforço estimado: 7–9 dias. Só arranca depois de o mock-up ser aceite.

## Features

### Painel da casa
- Requisitos: painel-kpis
1. Módulo `painel`, só de leitura: `GET /painel/mensal?restID&ano&mes`. Os valores são somados em `Decimal` na base de dados e só passam a número na resposta.
   - Faturação vem do fecho; gorjetas e chamadores da distribuição.
   - Food cost = faturas + fornecedores pagos em dinheiro.
   - Pessoal vem da folha; custos fixos de `valor_mensal`.
   - Inclui a contagem dos dias por preencher.
2. Testes com julho da folha:
   - faturação c/ IVA s/ gorjetas = 196 281,15 €;
   - food cost = 59 567,51 € (30,35%);
   - máximo de 28% = 54 958,72 €;
   - crescimento = 33,41%;
   - balanço sem pessoal = 121 348,79 €.
3. Ecrã `painel.tsx`: cartões de indicadores, alertas, gráfico diário em SVG próprio (sem biblioteca) com tabela alternativa, conta de exploração com ligação para a origem de cada linha.

### Comparativo de casas
- Requisitos: painel-kpis
`GET /painel/comparativo?ano&mes` com as casas a que o utilizador tem acesso (`getAllowedRestaurantes`). Mostra uma tabela com semáforo e as barras de food cost com a linha de 28%.

### Visão anual
- Requisitos: painel-kpis
`GET /painel/anual?restID&ano`: 12 meses face ao ano anterior, com "—" nos meses sem dados.

### Exportação e página inicial
- Requisitos: painel-kpis
1. Exportar CSV feito no browser a partir da mesma resposta; imprimir com CSS próprio.
2. Página inicial com o estado de cada casa: fecho de ontem, dias por preencher, faturas pendentes, food cost do mês.

## Entregáveis
- Painel, comparativo e anual nas casas do piloto
- Testes dos indicadores com os números da folha
- Exportação CSV
