# Fecho de caixa Specification
<!-- yourlab: capability=fecho-caixa; module=Backend -->

## Purpose

Registar o fecho diário de cada casa (faturação, multibanco, gorjetas, chamadores, cash e depósito) e calcular o cash na app, sem mudar os dias já guardados.

## Requirements

### Requirement: Gerente fecha o dia num só ecrã
<!-- yourlab: id=STK-01; type=stakeholder; module=Frontend; priority=high -->

O gerente SHALL conseguir lançar a caixa e as gorjetas de um dia no mesmo ecrã, com um só "Guardar dia", e mudar de dia com setas sem sair da página.

### Requirement: Cash calculado com a regra nova
<!-- yourlab: id=FR-01; type=functional; module=Backend; priority=high -->

Numa casa com a regra nova ativa, o sistema SHALL calcular o cash do dia como faturação total − multibanco − soma das despesas em dinheiro ativas do dia, e SHALL guardá-lo em `fecho_financeiro.sobra_especie` com `regra_calculo = 2`. Gorjetas e chamadores SHALL NOT ser descontados.

#### Scenario: Dia 2 de julho da folha
- **WHEN** a faturação total é 7 088,49 €, o multibanco 4 938,44 € e as despesas em dinheiro 1 200,14 €
- **THEN** o cash guardado é 949,91 €

#### Scenario: Dia 1 de julho da folha
- **WHEN** a faturação total é 7 088,49 €, o multibanco 4 938,44 € e as despesas 1 179,71 €
- **THEN** o cash guardado é 970,34 €

### Requirement: Dias antigos não mudam
<!-- yourlab: id=FR-02; type=functional; module=Backend; priority=high -->

Um fecho com `regra_calculo` nulo SHALL manter o valor guardado e SHALL NOT ser recalculado com a regra nova, nem ao abrir nem ao voltar a guardar. A regra nova só se aplica a dias iguais ou posteriores a `restaurante.regra_cash_desde`.

#### Scenario: Reabrir um dia de março
- **WHEN** a casa liga a regra nova em 1 de julho e alguém abre e guarda o fecho de 10 de março
- **THEN** o cash de 10 de março fica igual ao que estava guardado

### Requirement: Gorjetas e chamadores preenchidos sozinhos
<!-- yourlab: id=FR-03; type=functional; module=Frontend; priority=medium -->

O fecho SHALL mostrar as gorjetas do dia (`faturamento_diario.valor_total_gorjetas`) e o total dos chamadores (valores diretos da distribuição) só para leitura. A faturação do fecho SHALL vir pré-preenchida com a do dia e mostrar a diferença quando forem diferentes.

### Requirement: Registo do depósito
<!-- yourlab: id=FR-04; type=functional; module=Backend; priority=low -->

O fecho SHALL guardar a data (`deposito_data`) e o valor depositado.

### Requirement: Fecho auditado
<!-- yourlab: id=RNF-01; type=non_functional; module=Backend; priority=high -->

Cada gravação do fecho SHALL emitir um evento de auditoria com utilizador, casa, dia e valores antes e depois.
