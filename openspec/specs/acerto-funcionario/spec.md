# Acerto por funcionário Specification
<!-- yourlab: capability=acerto-funcionario; module=Frontend -->

## Purpose

Mostrar todos os dias de cada funcionário num período e impedir que um acerto seja fechado sem se saber que faltam dias.

## Requirements

### Requirement: Ver vários dias de uma vez
<!-- yourlab: id=STK-04; type=stakeholder; module=Frontend; priority=high -->

O gerente SHALL ver numa só tabela o que cada funcionário recebeu em cada dia do período, sem abrir dia a dia.

### Requirement: Matriz funcionário × dia
<!-- yourlab: id=FR-24; type=functional; module=Backend; priority=high -->

O sistema SHALL devolver, por casa e período, o valor efetivo de cada funcionário em cada dia, as folgas e os dias sem distribuição guardada. Valor efetivo = pago + direto − desconto, ou só o direto para papéis externos.

### Requirement: Períodos
<!-- yourlab: id=FR-25; type=functional; module=Frontend; priority=medium -->

O utilizador SHALL poder escolher semana, 15 dias, 30 dias, mês ou datas à escolha, e andar período a período com setas.

### Requirement: Dias em falta
<!-- yourlab: id=FR-26; type=functional; module=Frontend; priority=high -->

Os dias sem gorjetas guardadas SHALL aparecer destacados, com ligação para os corrigir. Guardar um acerto com dias em falta SHALL pedir confirmação e motivo (ou ser bloqueado, conforme a decisão do cliente).

#### Scenario: Dia 12 de julho por guardar
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo
