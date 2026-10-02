# Custos do mês Specification
<!-- yourlab: capability=custos-mensais; module=Backend -->

## Purpose

Guardar por casa e por mês o que não vem do dia a dia (água/gás/luz, outros custos fixos, faturação de referência do ano anterior) e as definições que entram nos cálculos.

## Requirements

### Requirement: Estimativa ou valor real
<!-- yourlab: id=FR-16; type=functional; module=Backend; priority=medium -->

Cada custo mensal SHALL ter valor e indicação de estimado. O painel SHALL usar o valor real quando existir e marcar a estimativa quando não.

### Requirement: Faturação de referência
<!-- yourlab: id=FR-17; type=functional; module=Backend; priority=medium -->

O sistema SHALL guardar a faturação de cada mês do ano anterior por casa, introduzida uma vez, para a comparação anual enquanto a app não tiver dados próprios desse ano.

### Requirement: Definições da casa
<!-- yourlab: id=FR-18; type=functional; module=Backend; priority=high -->

Cada casa SHALL ter limite de food cost (por omissão 28%), taxa de segurança social (por omissão 23,75%), data de início da regra nova do cash e indicação de piloto. Só administradores SHALL alterá-las, com auditoria.
