## Entidade: Restaurante
| Campo | Tipo | Notas |
|---|---|---|
| restID | inteiro | chave; tabela `restaurantes` |
| name | texto | nome da casa |
| percentagem_gorjeta_base | decimal(5,2) | base de gorjeta, ex.: 11 |
| ativo | booleano | desativar em vez de apagar |
| food_cost_max_pct | decimal(5,2) | novo, por omissão 28 |
| taxa_seguranca_social | decimal(5,2) | novo, por omissão 23,75 |
| regra_cash_desde | data | novo, nulo; data a partir da qual se usa a regra nova do cash |
| modulo_financeiro_ativo | booleano | novo, por omissão falso; liga os ecrãs novos (piloto) |
Hoje apagar uma casa apaga em cascata o histórico. Passa a ser recusado quando há dados financeiros, mudando só o código. As tabelas novas usam `Restrict` na ligação à casa.

## Entidade: Funcionario
| Campo | Tipo | Notas |
|---|---|---|
| funcID | inteiro | chave; tabela `funcionarios` |
| name | texto | |
| funcao | texto | texto livre: staff, cozinha, chamador… |
| restID | inteiro | casa principal (opcional) |
| data_admissao | data | |
| iban | texto | só administradores veem completo |
| salario | decimal(12,2) | salário atual; a folha guarda o valor de cada mês |
| ativo, deletedAt | booleano, data | eliminação suave |
Já existe. Os períodos de atividade estão em `FuncionarioPeriodoAtivo`.

## Entidade: FuncionarioPeriodoAtivo
| Campo | Tipo | Notas |
|---|---|---|
| id | inteiro | tabela `funcionario_periodo_ativo` |
| funcID | inteiro | |
| inicio | data | |
| fim | data | nulo enquanto ativo |
Já existe. Decide quem participa em cada dia e passa a servir também para o salário proporcional.

## Entidade: FaturamentoDiario
| Campo | Tipo | Notas |
|---|---|---|
| restID, data | inteiro, data | únicos juntos; tabela `faturamento_diario` |
| faturamento_inserido | decimal(12,2) | faturação escrita pelo gerente |
| faturamento_sem_gorjeta | decimal(12,2) | faturação − gorjetas: a base dos indicadores |
| valor_total_gorjetas | decimal(12,2) | pool de gorjetas do dia |
| ativo | booleano | eliminação suave |
Já existe.

## Entidade: FaturamentoDiarioDistribuicao
| Campo | Tipo | Notas |
|---|---|---|
| restID, data, funcID, role | | únicos juntos; tabela `faturamento_diario_distribuicao` |
| valor_pool, valor_direto, valor_teorico, valor_pago, desconto | decimal(12,2) | |
| employee_name, employee_funcao | texto | cópia do nome e função no dia |
| payment_source | texto | novo, nulo; origem do pagamento no dia, para mudanças de regras não alterarem meses passados |
Já existe. Os chamadores são linhas com o papel de chamador e valor direto.

## Entidade: FechoFinanceiro
| Campo | Tipo | Notas |
|---|---|---|
| restID, data | inteiro, data | únicos juntos; tabela `fecho_financeiro` |
| faturamento_global | decimal(12,2) | faturação total do dia |
| valor_multibanco | decimal(12,2) | só existe desde abril 2026; antes estava numa linha de texto |
| sobra_especie | decimal(12,2) | cash guardado com o dia |
| dinheiro_a_depositar | decimal(12,2) | |
| regra_calculo | inteiro | novo, nulo = regra antiga (nunca recalculada); 2 = total − multibanco − despesas |
| deposito_data | data | novo, nulo |
| notas | texto | |
As linhas antigas de `FechoFinanceiroItem` (texto livre) ficam como estão e aparecem como "não classificado".

## Entidade: DespesaCaixa
| Campo | Tipo | Notas |
|---|---|---|
| id | inteiro | nova; tabela `despesa_caixa` |
| restID | inteiro | obrigatório; `Restrict` |
| data | data | índice com restID |
| categoria | enum | FORNECEDOR, ORDENADO_CASH, FERIADO, OUTROS |
| valor | decimal(12,2) | maior que zero |
| descricao | texto | |
| fornecedorID | inteiro | nulo; obrigatório quando a categoria é FORNECEDOR, a partir da fase 05 |
| funcID | inteiro | nulo; obrigatório quando a categoria é ORDENADO_CASH ou FERIADO |
| faturaID | inteiro | nulo; liga a uma fatura para não contar duas vezes no food cost |
| ativo | booleano | eliminação suave |
| criadoPor | inteiro | utilizador |
| criadoEm, atualizadoEm | data e hora | |
Gravada linha a linha, com auditoria em cada escrita. É a única fonte das despesas em dinheiro.

## Entidade: Fornecedor
| Campo | Tipo | Notas |
|---|---|---|
| id | inteiro | nova; tabela `fornecedor`; do grupo, sem casa |
| nome | texto | |
| nif | texto | nulo |
| iban | texto | nulo; só administradores veem e alteram |
| categoria_padrao | enum | COMIDA, OUTRO |
| pagamento_habitual | enum | TRANSFERENCIA, DINHEIRO |
| ativo | booleano | nunca se apaga um fornecedor com faturas |
| criadoEm, atualizadoEm | data e hora | |

## Entidade: FaturaFornecedor
| Campo | Tipo | Notas |
|---|---|---|
| id | inteiro | nova; tabela `fatura_fornecedor` |
| restID | inteiro | obrigatório; `Restrict` |
| fornecedorID | inteiro | obrigatório; `Restrict` |
| numero | texto | aviso se repetido para o mesmo fornecedor e tipo |
| data | data | decide o mês (a confirmar com o cliente) |
| tipo | enum | FATURA, NOTA_CREDITO; o sinal aplica-se num só sítio |
| categoria | enum | COMIDA, OUTRO; vem do fornecedor e pode mudar |
| valor | decimal(12,2) | positivo, com IVA |
| pago_em | data | nulo = pendente |
| forma_pagamento | enum | nulo; TRANSFERENCIA, DINHEIRO |
| aguarda_nota_credito | booleano | por omissão falso |
| notas | texto | |
| ativo | booleano | eliminação suave |
| criadoPor | inteiro | utilizador |

## Entidade: ValorMensal
| Campo | Tipo | Notas |
|---|---|---|
| id | inteiro | nova; tabela `valor_mensal` |
| restID, ano, mes, tipo | | únicos juntos |
| tipo | enum | AGUA_GAS_LUZ, CUSTO_FIXO, FATURACAO_REFERENCIA |
| valor | decimal(12,2) | |
| estimado | booleano | verdadeiro até haver valor real |
| descricao | texto | nulo; para CUSTO_FIXO |
Guarda o que não vem do dia a dia: custos fixos e a faturação do ano anterior.

## Entidade: FolhaMensalLinha
| Campo | Tipo | Notas |
|---|---|---|
| id | inteiro | nova; tabela `folha_mensal_linha` |
| restID, funcID, ano, mes | | únicos juntos; `Restrict` |
| employee_name, employee_funcao | texto | cópia no mês |
| dias_ativos | inteiro | dos períodos de atividade |
| salario | decimal(12,2) | proporcional, guardado no mês |
| ferias | decimal(12,2) | escrito à mão |
| feriado | decimal(12,2) | das despesas FERIADO do funcionário |
| extra | decimal(12,2) | das despesas ORDENADO_CASH do funcionário |
| gorjetas | decimal(12,2) | da distribuição do mês |
| taxa_ss | decimal(5,2) | taxa usada no mês |
| valor_ss | decimal(12,2) | |
| notas | texto | |
| fechadoEm | data e hora | nulo = mês aberto; depois de fechado não se recalcula |

## Entidade: AcertoFinalPeriodo
| Campo | Tipo | Notas |
|---|---|---|
| restID, periodo_inicio, periodo_fim | | únicos juntos; tabela `acerto_final_periodo` |
| motivo_dias_em_falta | texto | novo, nulo; motivo para guardar com dias por preencher |
Já existe. Os valores por funcionário estão em `AcertoFinalEntry`.
