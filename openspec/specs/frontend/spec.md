# Frontend Specification
<!-- yourlab: capability=frontend; module=frontend -->

## Purpose

Por definir.

## Requirements

### Requirement: Ver vários dias de uma vez
<!-- yourlab: id=STK-04; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL ver numa só tabela o que cada funcionário recebeu em cada dia do período, sem abrir dia a dia.

### Requirement: Períodos
<!-- yourlab: id=FR-25; type=functional; priority=medium; module=Frontend -->

O utilizador SHALL poder escolher semana, 15 dias, 30 dias, mês ou datas à escolha, e andar período a período com setas.

### Requirement: Dias em falta
<!-- yourlab: id=FR-26; type=functional; priority=high; module=Frontend -->

Os dias sem gorjetas guardadas SHALL aparecer destacados, com ligação para os corrigir. Guardar um acerto com dias em falta SHALL pedir confirmação e motivo (ou ser bloqueado, conforme a decisão do cliente).

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

### Requirement: Gerente fecha o dia num só ecrã
<!-- yourlab: id=STK-01; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL conseguir lançar a caixa e as gorjetas de um dia no mesmo ecrã, com um só "Guardar dia", e mudar de dia com setas sem sair da página.

### Requirement: Gorjetas e chamadores preenchidos sozinhos
<!-- yourlab: id=FR-03; type=functional; priority=medium; module=Frontend -->

O fecho SHALL mostrar as gorjetas do dia (`faturamento_diario.valor_total_gorjetas`) e o total dos chamadores (valores diretos da distribuição) só para leitura. A faturação do fecho SHALL vir pré-preenchida com a do dia e mostrar a diferença quando forem diferentes.

### Requirement: Escritório vê o que há para pagar
<!-- yourlab: id=STK-02; type=stakeholder; priority=high; module=Frontend -->

O escritório SHALL ver, por mês, as faturas pendentes por fornecedor com o IBAN e o total, e marcar várias como pagas de uma vez.

### Requirement: Ver vários dias de uma vez
<!-- yourlab: id=STK-04; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL ver numa só tabela o que cada funcionário recebeu em cada dia do período, sem abrir dia a dia.

### Requirement: Períodos
<!-- yourlab: id=FR-25; type=functional; priority=medium; module=Frontend -->

O utilizador SHALL poder escolher semana, 15 dias, 30 dias, mês ou datas à escolha, e andar período a período com setas.

### Requirement: Dias em falta
<!-- yourlab: id=FR-26; type=functional; priority=high; module=Frontend -->

Os dias sem gorjetas guardadas SHALL aparecer destacados, com ligação para os corrigir. Guardar um acerto com dias em falta SHALL pedir confirmação e motivo (ou ser bloqueado, conforme a decisão do cliente).

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

### Requirement: Gerente fecha o dia num só ecrã
<!-- yourlab: id=STK-01; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL conseguir lançar a caixa e as gorjetas de um dia no mesmo ecrã, com um só "Guardar dia", e mudar de dia com setas sem sair da página.

### Requirement: Gorjetas e chamadores preenchidos sozinhos
<!-- yourlab: id=FR-03; type=functional; priority=medium; module=Frontend -->

O fecho SHALL mostrar as gorjetas do dia (`faturamento_diario.valor_total_gorjetas`) e o total dos chamadores (valores diretos da distribuição) só para leitura. A faturação do fecho SHALL vir pré-preenchida com a do dia e mostrar a diferença quando forem diferentes.

### Requirement: Escritório vê o que há para pagar
<!-- yourlab: id=STK-02; type=stakeholder; priority=high; module=Frontend -->

O escritório SHALL ver, por mês, as faturas pendentes por fornecedor com o IBAN e o total, e marcar várias como pagas de uma vez.

### Requirement: Ver vários dias de uma vez
<!-- yourlab: id=STK-04; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL ver numa só tabela o que cada funcionário recebeu em cada dia do período, sem abrir dia a dia.

### Requirement: Períodos
<!-- yourlab: id=FR-25; type=functional; priority=medium; module=Frontend -->

O utilizador SHALL poder escolher semana, 15 dias, 30 dias, mês ou datas à escolha, e andar período a período com setas.

### Requirement: Dias em falta
<!-- yourlab: id=FR-26; type=functional; priority=high; module=Frontend -->

Os dias sem gorjetas guardadas SHALL aparecer destacados, com ligação para os corrigir. Guardar um acerto com dias em falta SHALL pedir confirmação e motivo (ou ser bloqueado, conforme a decisão do cliente).

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

### Requirement: Gerente fecha o dia num só ecrã
<!-- yourlab: id=STK-01; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL conseguir lançar a caixa e as gorjetas de um dia no mesmo ecrã, com um só "Guardar dia", e mudar de dia com setas sem sair da página.

### Requirement: Gorjetas e chamadores preenchidos sozinhos
<!-- yourlab: id=FR-03; type=functional; priority=medium; module=Frontend -->

O fecho SHALL mostrar as gorjetas do dia (`faturamento_diario.valor_total_gorjetas`) e o total dos chamadores (valores diretos da distribuição) só para leitura. A faturação do fecho SHALL vir pré-preenchida com a do dia e mostrar a diferença quando forem diferentes.

### Requirement: Escritório vê o que há para pagar
<!-- yourlab: id=STK-02; type=stakeholder; priority=high; module=Frontend -->

O escritório SHALL ver, por mês, as faturas pendentes por fornecedor com o IBAN e o total, e marcar várias como pagas de uma vez.

### Requirement: Ver vários dias de uma vez
<!-- yourlab: id=STK-04; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL ver numa só tabela o que cada funcionário recebeu em cada dia do período, sem abrir dia a dia.

### Requirement: Períodos
<!-- yourlab: id=FR-25; type=functional; priority=medium; module=Frontend -->

O utilizador SHALL poder escolher semana, 15 dias, 30 dias, mês ou datas à escolha, e andar período a período com setas.

### Requirement: Dias em falta
<!-- yourlab: id=FR-26; type=functional; priority=high; module=Frontend -->

Os dias sem gorjetas guardadas SHALL aparecer destacados, com ligação para os corrigir. Guardar um acerto com dias em falta SHALL pedir confirmação e motivo (ou ser bloqueado, conforme a decisão do cliente).

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

#### Scenario: Dia 12 de julho por guardar
<!-- yourlab: id=TC-001; requirementId=FR-26 -->
- **WHEN** o período é 1–15 jul e a distribuição de 12 jul não foi guardada
- **THEN** a coluna 12 aparece a vermelho, o aviso lista "dom, 12 jul" e guardar pede o motivo

### Requirement: Gerente fecha o dia num só ecrã
<!-- yourlab: id=STK-01; type=stakeholder; priority=high; module=Frontend -->

O gerente SHALL conseguir lançar a caixa e as gorjetas de um dia no mesmo ecrã, com um só "Guardar dia", e mudar de dia com setas sem sair da página.

### Requirement: Gorjetas e chamadores preenchidos sozinhos
<!-- yourlab: id=FR-03; type=functional; priority=medium; module=Frontend -->

O fecho SHALL mostrar as gorjetas do dia (`faturamento_diario.valor_total_gorjetas`) e o total dos chamadores (valores diretos da distribuição) só para leitura. A faturação do fecho SHALL vir pré-preenchida com a do dia e mostrar a diferença quando forem diferentes.

### Requirement: Escritório vê o que há para pagar
<!-- yourlab: id=STK-02; type=stakeholder; priority=high; module=Frontend -->

O escritório SHALL ver, por mês, as faturas pendentes por fornecedor com o IBAN e o total, e marcar várias como pagas de uma vez.

### Requirement: Donos leem o mês sem copiar nada
<!-- yourlab: id=STK-03; type=stakeholder; priority=high; module=Frontend -->

Os donos SHALL ver, para qualquer casa e mês, faturação, crescimento face ao ano anterior, média diária, food cost, pessoal, balanço e alertas, sem preencher nenhuma folha.

### Requirement: Meses sem dados
<!-- yourlab: id=FR-21; type=functional; priority=medium; module=Frontend -->

A visão anual SHALL mostrar "—" nos meses sem dados, nunca erros de divisão.

### Requirement: Alertas
<!-- yourlab: id=FR-22; type=functional; priority=medium; module=Frontend -->

O painel e a página inicial SHALL avisar sobre food cost acima do limite, dias sem fecho ou sem gorjetas guardadas, e faturas pendentes.

### Requirement: Exportação
<!-- yourlab: id=FR-23; type=functional; priority=low; module=Frontend -->

Cada tabela do painel SHALL poder ser exportada em CSV e impressa.

### Requirement: Donos leem o mês sem copiar nada
<!-- yourlab: id=STK-03; type=stakeholder; priority=high; module=Frontend -->

Os donos SHALL ver, para qualquer casa e mês, faturação, crescimento face ao ano anterior, média diária, food cost, pessoal, balanço e alertas, sem preencher nenhuma folha.

### Requirement: Meses sem dados
<!-- yourlab: id=FR-21; type=functional; priority=medium; module=Frontend -->

A visão anual SHALL mostrar "—" nos meses sem dados, nunca erros de divisão.

### Requirement: Alertas
<!-- yourlab: id=FR-22; type=functional; priority=medium; module=Frontend -->

O painel e a página inicial SHALL avisar sobre food cost acima do limite, dias sem fecho ou sem gorjetas guardadas, e faturas pendentes.

### Requirement: Exportação
<!-- yourlab: id=FR-23; type=functional; priority=low; module=Frontend -->

Cada tabela do painel SHALL poder ser exportada em CSV e impressa.

### Requirement: Donos leem o mês sem copiar nada
<!-- yourlab: id=STK-03; type=stakeholder; priority=high; module=Frontend -->

Os donos SHALL ver, para qualquer casa e mês, faturação, crescimento face ao ano anterior, média diária, food cost, pessoal, balanço e alertas, sem preencher nenhuma folha.

### Requirement: Meses sem dados
<!-- yourlab: id=FR-21; type=functional; priority=medium; module=Frontend -->

A visão anual SHALL mostrar "—" nos meses sem dados, nunca erros de divisão.

### Requirement: Alertas
<!-- yourlab: id=FR-22; type=functional; priority=medium; module=Frontend -->

O painel e a página inicial SHALL avisar sobre food cost acima do limite, dias sem fecho ou sem gorjetas guardadas, e faturas pendentes.

### Requirement: Exportação
<!-- yourlab: id=FR-23; type=functional; priority=low; module=Frontend -->

Cada tabela do painel SHALL poder ser exportada em CSV e impressa.

### Requirement: Donos leem o mês sem copiar nada
<!-- yourlab: id=STK-03; type=stakeholder; priority=high; module=Frontend -->

Os donos SHALL ver, para qualquer casa e mês, faturação, crescimento face ao ano anterior, média diária, food cost, pessoal, balanço e alertas, sem preencher nenhuma folha.

### Requirement: Gráficos de comparação entre casas
<!-- yourlab: id=FR-28; type=functional; priority=high; module=Frontend -->

Para quem tem acesso a mais de uma casa, o comparativo SHALL mostrar:
- a faturação por casa, com a do ano anterior;
- o balanço por casa e a sua parte no balanço do grupo;
- um gráfico circular com a divisão da faturação do grupo (food cost, pessoal, chamadores, água/gás/luz, outras despesas, balanço);
- a mesma divisão por casa em barras de 100%;
- a evolução mensal por casa, todas na mesma escala.

Cada categoria SHALL ter sempre a mesma cor. Cada gráfico SHALL ter os valores numa tabela ou legenda com números. O utilizador SHALL poder escolher as casas e o período (mês, trimestre, ano até hoje, datas à escolha).

#### Scenario: As partes somam a faturação
<!-- yourlab: id=TC-009; requirementId=FR-28 -->
- **WHEN** o gráfico circular mostra uma casa ou o grupo
- **THEN** a soma das seis partes é igual à faturação c/ IVA s/ gorjetas desse período

#### Scenario: Gerente com uma casa
<!-- yourlab: id=TC-014; requirementId=FR-28 -->
- **WHEN** um gerente só tem acesso à Ferrary
- **THEN** não vê o comparativo, e no Painel vê o gráfico circular da Ferrary sem a média do grupo

### Requirement: Meses sem dados
<!-- yourlab: id=FR-21; type=functional; priority=medium; module=Frontend -->

A visão anual SHALL mostrar "—" nos meses sem dados, nunca erros de divisão.

### Requirement: Alertas
<!-- yourlab: id=FR-22; type=functional; priority=medium; module=Frontend -->

O painel e a página inicial SHALL avisar sobre food cost acima do limite, dias sem fecho ou sem gorjetas guardadas, e faturas pendentes.

### Requirement: Exportação
<!-- yourlab: id=FR-23; type=functional; priority=low; module=Frontend -->

Cada tabela do painel SHALL poder ser exportada em CSV e impressa.
