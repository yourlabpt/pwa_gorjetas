# Painel e indicadores Specification
<!-- yourlab: capability=painel-kpis; module=Backend -->

## Purpose

Mostrar aos donos a conta de exploração de cada casa, o food cost face ao limite, o balanço, a comparação entre casas e com o ano anterior, calculados a partir do que é lançado.

## Requirements

### Requirement: Donos leem o mês sem copiar nada
<!-- yourlab: id=STK-03; type=stakeholder; module=Frontend; priority=high -->

Os donos SHALL ver, para qualquer casa e mês, faturação, crescimento face ao ano anterior, média diária, food cost, pessoal, balanço e alertas, sem preencher nenhuma folha.

### Requirement: Fórmulas do painel
<!-- yourlab: id=FR-19; type=functional; module=Backend; priority=high -->

O sistema SHALL calcular:
- faturação c/ IVA s/ gorjetas = faturação total − gorjetas;
- food cost = faturas (com notas de crédito, categoria COMIDA) + despesas FORNECEDOR sem fatura ligada;
- food cost % = food cost ÷ faturação c/ IVA s/ gorjetas;
- máximo = limite × faturação c/ IVA s/ gorjetas;
- crescimento = (faturação − faturação do ano anterior) ÷ faturação do ano anterior;
- balanço = faturação c/ IVA s/ gorjetas − food cost − outras despesas − folha − segurança social − extras − chamadores − custos fixos.

As somas SHALL ser feitas em decimal.

#### Scenario: Julho da folha
- **WHEN** faturação 219 743,19 €, gorjetas 23 462,04 €, faturas 36 676,47 € e fornecedores em dinheiro 22 891,04 €
- **THEN** faturação c/ IVA s/ gorjetas = 196 281,15 €, food cost = 59 567,51 € (30,35%), máximo = 54 958,72 € e diferença = 4 608,79 €

#### Scenario: Crescimento sobre o ano anterior
- **WHEN** julho 2026 = 219 743,19 € e julho 2025 = 164 716,03 €
- **THEN** o crescimento é 33,41% (não 25,04% como na folha)

#### Scenario: Balanço sem pessoal
- **WHEN** a folha e a segurança social estão a zero, outras = 1 148,53 €, extras = 857,32 €, chamadores = 4 359,00 € e água/gás/luz = 9 000,00 €
- **THEN** o balanço é 121 348,79 €, igual ao da folha

### Requirement: Comparativo só das casas acessíveis
<!-- yourlab: id=FR-20; type=functional; module=Backend; priority=high -->

O comparativo SHALL incluir só as casas a que o utilizador tem acesso.

### Requirement: Gráficos de comparação entre casas
<!-- yourlab: id=FR-28; type=functional; module=Frontend; priority=high -->

Para quem tem acesso a mais de uma casa, o comparativo SHALL mostrar:
- a faturação por casa, com a do ano anterior;
- o balanço por casa e a sua parte no balanço do grupo;
- um gráfico circular com a divisão da faturação do grupo (food cost, pessoal, chamadores, água/gás/luz, outras despesas, balanço);
- a mesma divisão por casa em barras de 100%;
- a evolução mensal por casa, todas na mesma escala.

Cada categoria SHALL ter sempre a mesma cor. Cada gráfico SHALL ter os valores numa tabela ou legenda com números. O utilizador SHALL poder escolher as casas e o período (mês, trimestre, ano até hoje, datas à escolha).

#### Scenario: As partes somam a faturação
- **WHEN** o gráfico circular mostra uma casa ou o grupo
- **THEN** a soma das seis partes é igual à faturação c/ IVA s/ gorjetas desse período

#### Scenario: Gerente com uma casa
- **WHEN** um gerente só tem acesso à Ferrary
- **THEN** não vê o comparativo, e no Painel vê o gráfico circular da Ferrary sem a média do grupo

### Requirement: Meses sem dados
<!-- yourlab: id=FR-21; type=functional; module=Frontend; priority=medium -->

A visão anual SHALL mostrar "—" nos meses sem dados, nunca erros de divisão.

### Requirement: Alertas
<!-- yourlab: id=FR-22; type=functional; module=Frontend; priority=medium -->

O painel e a página inicial SHALL avisar sobre food cost acima do limite, dias sem fecho ou sem gorjetas guardadas, e faturas pendentes.

### Requirement: Exportação
<!-- yourlab: id=FR-23; type=functional; module=Frontend; priority=low -->

Cada tabela do painel SHALL poder ser exportada em CSV e impressa.

### Requirement: Base do food cost
<!-- yourlab: id=UQ-033; type=undefined; module=Backend -->

Faturação com ou sem IVA, e se papel, táxis e ferramentas contam como food cost: a confirmar com o cliente (ver `questions.md`).
