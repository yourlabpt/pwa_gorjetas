# Backend Specification
<!-- yourlab: capability=backend; module=backend -->

## Purpose

Por definir.

## Requirements

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-001; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-002; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-003; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-004; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….

### Requirement: Histórico financeiro imune a alterações de estado do colaborador
<!-- yourlab: id=UQ-005; type=functional; priority=high; module=Backend -->

O sistema SHALL registar períodos de atividade por colaborador (`funcionario_periodo_ativo`: `inicio`, `fim`), abertos na criação/ativação e fechados na desativação/eliminação, com a data do dia (Europe/Lisbon).

O sistema SHALL determinar os participantes de um dia D como os colaboradores ativos em D (período com `inicio <= D` e `fim` nulo ou `>= D`) mais os já registados nas linhas guardadas desse dia. O cálculo, a gravação e o recálculo do Financeiro Diário SHALL usar apenas esse conjunto, nunca o estado atual do colaborador.

Desativar um colaborador na data X SHALL deixar inalterados todos os dias anteriores a X. Reativar em X+N SHALL deixar inalterados os dias no intervalo [X, X+N), mesmo que voltem a ser gravados. Gravar um dia SHALL preservar os valores guardados de participantes omitidos pelo cliente e SHALL ignorar entradas de não participantes.

Alterações de estado (ativar, desativar, eliminar) SHALL emitir evento de auditoria com valores antes/depois.

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-006; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-007; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-008; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-008; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….
