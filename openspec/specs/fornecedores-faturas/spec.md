# Fornecedores e faturas Specification
<!-- yourlab: capability=fornecedores-faturas; module=Backend -->

## Purpose

Manter a lista de fornecedores do grupo e o registo de faturas e notas de crédito por casa, com o estado de pagamento para o escritório.

## Requirements

### Requirement: Escritório vê o que há para pagar
<!-- yourlab: id=STK-02; type=stakeholder; module=Frontend; priority=high -->

O escritório SHALL ver, por mês, as faturas pendentes por fornecedor com o IBAN e o total, e marcar várias como pagas de uma vez.

### Requirement: Fornecedores do grupo
<!-- yourlab: id=FR-09; type=functional; module=Backend; priority=high -->

O sistema SHALL guardar fornecedores sem casa (lista do grupo), com categoria habitual e forma de pagamento habitual. Um fornecedor com faturas SHALL só poder ser desativado, nunca apagado.

### Requirement: IBAN protegido
<!-- yourlab: id=RNF-03; type=non_functional; module=Backend; priority=high -->

Só administradores SHALL ver e alterar o IBAN completo. Os outros perfis veem-no mascarado e o VISUALIZADOR nunca o vê. Ler fornecedores SHALL exigir acesso a pelo menos uma casa.

### Requirement: Faturas e notas de crédito
<!-- yourlab: id=FR-10; type=functional; module=Backend; priority=high -->

Cada fatura SHALL ter casa, fornecedor, número, data, tipo (FATURA ou NOTA_CREDITO), categoria e valor positivo com IVA. As notas de crédito SHALL descontar no total.

#### Scenario: Aviludo em julho
- **WHEN** a Aviludo tem faturas de 2 627,31 € e uma nota de crédito de 570,11 €
- **THEN** o total da Aviludo no mês é 2 057,20 €

#### Scenario: Total de julho da folha
- **WHEN** estão registadas as 79 faturas e notas de crédito de julho
- **THEN** o total do mês é 36 676,47 €

### Requirement: Aviso de fatura repetida
<!-- yourlab: id=FR-11; type=functional; module=Backend; priority=medium -->

Ao gravar, o sistema SHALL avisar quando já existe uma fatura ativa com o mesmo fornecedor, número e tipo.

### Requirement: Estado de pagamento
<!-- yourlab: id=FR-12; type=functional; module=Backend; priority=high -->

Uma fatura com `pago_em` nulo SHALL estar pendente. Marcar como paga SHALL guardar a data e a forma de pagamento, com auditoria. Uma fatura pode ficar marcada "aguarda nota de crédito".

### Requirement: Pagamentos automáticos ao banco
<!-- yourlab: id=OOS-01; type=out_of_scope; module=Backend -->

Gerar o ficheiro SEPA ou pagar diretamente no banco fica fora destas fases (ver `ideas.md`).
