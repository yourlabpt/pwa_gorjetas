# gestao-restaurantes Specification
<!-- yourlab: capability=gestao-restaurantes; module=backend -->

## Purpose

Gerado do código em backend, por rever. Gestão de restaurantes, funcionários, gorjetas e transações.

## Requirements

### Requirement: criar_restaurante
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir a criação de restaurantes com informações básicas como nome, endereço, contacto e percentagem de gorjeta base.

#### Scenario: criar_restaurante_valido
- **WHEN** Quando um novo restaurante é criado com todos os campos obrigatórios
- **THEN** Então o restaurante é registado na base de dados com um ID único.

#### Scenario: criar_restaurante_sem_endereco
- **WHEN** Quando um novo restaurante é criado sem endereço
- **THEN** Então o restaurante é registado com o campo de endereço como nulo.

### Requirement: gerir_funcionarios
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir a gestão de funcionários, incluindo a associação a um ou mais restaurantes.

#### Scenario: adicionar_funcionario
- **WHEN** Quando um novo funcionário é adicionado com todos os campos obrigatórios
- **THEN** Então o funcionário é registado na base de dados com um ID único.

#### Scenario: associar_funcionario_restaurante
- **WHEN** Quando um funcionário é associado a um restaurante
- **THEN** Então a associação é registada na tabela de funcionario_restaurante.

### Requirement: configurar_gorjetas
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir a configuração de percentagens de gorjetas por função em cada restaurante.

#### Scenario: configurar_gorjeta_valida
- **WHEN** Quando uma nova configuração de gorjeta é criada com todos os campos obrigatórios
- **THEN** Então a configuração é registada na base de dados com um ID único.

### Requirement: registar_transacoes
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir o registo de transações, incluindo o cálculo automático da gorjeta.

#### Scenario: registar_transacao_valida
- **WHEN** Quando uma nova transação é registada com todos os campos obrigatórios
- **THEN** Então a transação é registada na base de dados com um ID único.

#### Scenario: calcular_gorjeta_transacao
- **WHEN** Quando uma transação é registada
- **THEN** Então a gorjeta é calculada com base na percentagem aplicada.

### Requirement: distribuir_gorjetas
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir a distribuição de gorjetas aos funcionários com base em regras configuradas.

#### Scenario: distribuir_gorjeta_valida
- **WHEN** Quando uma distribuição de gorjeta é registada com todos os campos obrigatórios
- **THEN** Então a distribuição é registada na base de dados com um ID único.

### Requirement: gerar_faturamento_diario
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir o registo do faturamento diário de cada restaurante.

#### Scenario: registar_faturamento_diario
- **WHEN** Quando o faturamento diário é registado com todos os campos obrigatórios
- **THEN** Então o faturamento é registado na base de dados com um ID único.

### Requirement: configurar_acerto
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir a configuração de regras de acerto para funcionários.

#### Scenario: configurar_acerto_valido
- **WHEN** Quando uma nova configuração de acerto é criada com todos os campos obrigatórios
- **THEN** Então a configuração é registada na base de dados com um ID único.

### Requirement: gerar_acerto_periodo
<!-- yourlab: type=functional; module=backend -->

O sistema SHALL permitir o registo de acertos por período para funcionários.

#### Scenario: registar_acerto_periodo
- **WHEN** Quando um acerto por período é registado com todos os campos obrigatórios
- **THEN** Então o acerto é registado na base de dados com um ID único.

### Requirement: manter_historico_atualizacoes
<!-- yourlab: type=non_functional; module=backend -->

O sistema SHALL manter um histórico de atualizações para todas as entidades principais.

#### Scenario: atualizar_restaurante
- **WHEN** Quando um restaurante é atualizado
- **THEN** Então a data de atualização é registada.

#### Scenario: atualizar_funcionario
- **WHEN** Quando um funcionário é atualizado
- **THEN** Então a data de atualização é registada.

### Requirement: garantir_integridade_dados
<!-- yourlab: type=non_functional; module=backend -->

O sistema SHALL garantir a integridade dos dados através de chaves primárias e estrangeiras.

#### Scenario: registar_transacao_sem_restaurante
- **WHEN** Quando uma transação é registada sem um restaurante válido
- **THEN** Então a transação não é registada e um erro é retornado.
