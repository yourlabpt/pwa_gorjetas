---
title: Painel, comparativo e anual
weeks: 2
status: planeada
---

## Objetivo
Os donos leem cada casa e o grupo sem copiar nada à mão: conta de exploração do mês, food cost face ao limite, balanço, comparação entre casas e com o ano anterior. Substitui os separadores CONTROLE COM GRÁFICO e PORCENTAGENS ANO. Esforço estimado: 8–10 dias (com os gráficos de comparação entre casas). Só arranca depois de o mock-up ser aceite.

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
Ecrã para donos e administradores com várias casas. Quem tem uma só casa não o vê.
1. `GET /painel/comparativo?inicio&fim&casas=` com as casas a que o utilizador tem acesso (`getAllowedRestaurantes`), para um mês, trimestre, ano até hoje ou datas à escolha. Devolve, por casa, a faturação e a do ano anterior, o balanço, as seis partes da faturação (food cost, pessoal, chamadores, água/gás/luz, outras despesas, balanço) e a faturação mês a mês.
2. Gráficos em SVG próprio, sem biblioteca. Cada categoria tem sempre a mesma cor (as seis primeiras cores categóricas validadas para daltonismo, sempre pela mesma ordem):
   - faturação por casa, com a marca do ano anterior;
   - balanço por casa e parte do ganho do grupo;
   - gráfico circular da divisão da faturação do grupo, com a tabela de valores ao lado;
   - barras de 100% com a mesma divisão por casa;
   - food cost face ao limite de 28%;
   - evolução mensal por casa, todas na mesma escala.
3. Escolher que casas comparar; exportar o relatório em PDF ou CSV e imprimir.
4. O Painel de cada casa também tem o gráfico circular, e a comparação com a média do grupo para quem tem várias casas.

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
