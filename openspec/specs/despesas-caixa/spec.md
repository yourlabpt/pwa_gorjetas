# Despesas em dinheiro Specification
<!-- yourlab: capability=despesas-caixa; module=Backend -->

## Purpose

Registar cada despesa paga em dinheiro numa casa uma única vez, com categoria, para que os totais do mês, o cash e o food cost saiam da mesma fonte.

## Requirements

### Requirement: Uma linha por despesa, com categoria
<!-- yourlab: id=FR-05; type=functional; module=Backend; priority=high -->

O sistema SHALL guardar cada despesa em `despesa_caixa` com casa, dia, categoria (FORNECEDOR, ORDENADO_CASH, FERIADO, OUTROS), valor maior que zero e descrição. A gravação SHALL ser linha a linha, nunca apagando e recriando as linhas do dia.

### Requirement: Campos obrigatórios por categoria
<!-- yourlab: id=FR-06; type=functional; module=Backend; priority=high -->

Uma despesa FORNECEDOR SHALL ter fornecedor (a partir da fase 05). Uma despesa ORDENADO_CASH ou FERIADO SHALL ter funcionário.

#### Scenario: Extra sem funcionário
- **WHEN** o gerente grava um extra de 600,00 € sem escolher funcionário
- **THEN** o sistema recusa e pede o funcionário

### Requirement: Compra com fatura conta uma vez
<!-- yourlab: id=FR-07; type=functional; module=Backend; priority=medium -->

Uma despesa ligada a uma fatura (`faturaID`) SHALL NOT entrar no food cost pela despesa, só pela fatura.

### Requirement: Totais do mês sem dupla digitação
<!-- yourlab: id=TC-01; type=test_case; module=Backend; priority=high -->

Os totais por categoria do mês SHALL ser a soma das linhas ativas.

#### Scenario: Julho da folha
- **WHEN** as despesas de julho são as da especificação da folha
- **THEN** fornecedores = 22 891,04 €, extras = 857,32 €, outros = 1 148,53 € e total = 24 896,89 €

### Requirement: Linhas antigas preservadas
<!-- yourlab: id=FR-08; type=functional; module=Backend; priority=high -->

As linhas existentes de `fecho_financeiro_item` SHALL ficar inalteradas e aparecer como "não classificado".

### Requirement: Despesas auditadas
<!-- yourlab: id=RNF-02; type=non_functional; module=Backend; priority=high -->

Criar, editar ou desativar uma despesa SHALL emitir um evento de auditoria.
