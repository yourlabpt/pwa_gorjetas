# Pessoal e folha do mês Specification
<!-- yourlab: capability=pessoal-folha; module=Backend -->

## Purpose

Montar a folha de cada mês com o que a app já guarda (salário, períodos de atividade, extras e feriados do fecho, gorjetas) e congelar o mês quando fecha.

## Requirements

### Requirement: Folha gerada a partir da app
<!-- yourlab: id=FR-13; type=functional; module=Backend; priority=high -->

"Gerar" SHALL criar ou atualizar uma linha por funcionário com atividade no mês:
- salário = salário atual × dias ativos no mês ÷ dias do mês;
- extras e feriados = soma das despesas ORDENADO_CASH e FERIADO desse funcionário;
- gorjetas = soma dos valores efetivos da distribuição do mês.

As férias e as notas SHALL ser escritas à mão e mantidas ao gerar de novo.

#### Scenario: Entrada a meio do mês
- **WHEN** um funcionário com salário de 920,00 € entra a 15 de julho
- **THEN** tem 17 dias ativos e o salário de julho é 504,52 €

### Requirement: Segurança social
<!-- yourlab: id=FR-14; type=functional; module=Backend; priority=high -->

A segurança social de cada linha SHALL ser `taxa_seguranca_social` da casa × (salário + férias + feriados). A taxa usada SHALL ficar guardada na linha.

### Requirement: Mês fechado não muda
<!-- yourlab: id=FR-15; type=functional; module=Backend; priority=high -->

Depois de "Fechar mês" (`fechadoEm` preenchido), "Gerar" SHALL NOT alterar as linhas desse mês, e mudar o salário em Funcionários SHALL NOT alterar meses fechados.

### Requirement: Mesmo valor de gorjetas que o acerto
<!-- yourlab: id=TC-02; type=test_case; module=Backend; priority=high -->

As gorjetas de um funcionário na folha SHALL ser iguais à soma do acerto dele no mesmo período, porque usam a mesma função de valor efetivo.

### Requirement: Salários visíveis só a administradores
<!-- yourlab: id=RNF-04; type=non_functional; module=Backend; priority=high -->

Só administradores SHALL ver e alterar a folha do mês.

### Requirement: Regra de proporcionalidade
<!-- yourlab: id=UQ-032; type=undefined; module=Backend -->

Dias de calendário ou regra dos 30 dias, e o significado de "Férias" (subsídio ou parte mensal): a confirmar com o cliente e o contabilista.
