# Backend Specification
<!-- yourlab: capability=backend; module=backend -->

## Purpose

Por definir.

## Requirements

### Requirement: Matriz funcionário × dia
<!-- yourlab: id=FR-24; type=functional; priority=high; module=Backend -->

O sistema SHALL devolver, por casa e período, o valor efetivo de cada funcionário em cada dia, as folgas e os dias sem distribuição guardada. Valor efetivo = pago + direto − desconto, ou só o direto para papéis externos.

### Requirement: Estimativa ou valor real
<!-- yourlab: id=FR-16; type=functional; priority=medium; module=Backend -->

Cada custo mensal SHALL ter valor e indicação de estimado. O painel SHALL usar o valor real quando existir e marcar a estimativa quando não.

### Requirement: Faturação de referência
<!-- yourlab: id=FR-17; type=functional; priority=medium; module=Backend -->

O sistema SHALL guardar a faturação de cada mês do ano anterior por casa, introduzida uma vez, para a comparação anual enquanto a app não tiver dados próprios desse ano.

### Requirement: Definições da casa
<!-- yourlab: id=FR-18; type=functional; priority=high; module=Backend -->

Cada casa SHALL ter limite de food cost (por omissão 28%), taxa de segurança social (por omissão 23,75%), data de início da regra nova do cash e indicação de piloto. Só administradores SHALL alterá-las, com auditoria.

### Requirement: Uma linha por despesa, com categoria
<!-- yourlab: id=FR-05; type=functional; priority=high; module=Backend -->

O sistema SHALL guardar cada despesa em `despesa_caixa` com casa, dia, categoria (FORNECEDOR, ORDENADO_CASH, FERIADO, OUTROS), valor maior que zero e descrição. A gravação SHALL ser linha a linha, nunca apagando e recriando as linhas do dia.

### Requirement: Campos obrigatórios por categoria
<!-- yourlab: id=FR-06; type=functional; priority=high; module=Backend -->

Uma despesa FORNECEDOR SHALL ter fornecedor (a partir da fase 05). Uma despesa ORDENADO_CASH ou FERIADO SHALL ter funcionário.

#### Scenario: Extra sem funcionário
<!-- yourlab: id=TC-002; requirementId=FR-06 -->
- **WHEN** o gerente grava um extra de 600,00 € sem escolher funcionário
- **THEN** o sistema recusa e pede o funcionário

### Requirement: Compra com fatura conta uma vez
<!-- yourlab: id=FR-07; type=functional; priority=medium; module=Backend -->

Uma despesa ligada a uma fatura (`faturaID`) SHALL NOT entrar no food cost pela despesa, só pela fatura.

### Requirement: Totais do mês sem dupla digitação
<!-- yourlab: id=TC-01; type=functional; priority=high; module=Backend -->

Os totais por categoria do mês SHALL ser a soma das linhas ativas.

#### Scenario: Julho da folha
<!-- yourlab: id=TC-003; requirementId=TC-01 -->
- **WHEN** as despesas de julho são as da especificação da folha
- **THEN** fornecedores = 22 891,04 €, extras = 857,32 €, outros = 1 148,53 € e total = 24 896,89 €

### Requirement: Linhas antigas preservadas
<!-- yourlab: id=FR-08; type=functional; priority=high; module=Backend -->

As linhas existentes de `fecho_financeiro_item` SHALL ficar inalteradas e aparecer como "não classificado".

### Requirement: Despesas auditadas
<!-- yourlab: id=RNF-02; type=non_functional; priority=high; module=Backend -->

Criar, editar ou desativar uma despesa SHALL emitir um evento de auditoria.

### Requirement: Cash calculado com a regra nova
<!-- yourlab: id=FR-01; type=functional; priority=high; module=Backend -->

Numa casa com a regra nova ativa, o sistema SHALL calcular o cash do dia como faturação total − multibanco − soma das despesas em dinheiro ativas do dia, e SHALL guardá-lo em `fecho_financeiro.sobra_especie` com `regra_calculo = 2`. Gorjetas e chamadores SHALL NOT ser descontados.

#### Scenario: Dia 2 de julho da folha
<!-- yourlab: id=TC-004; requirementId=FR-01 -->
- **WHEN** a faturação total é 7 088,49 €, o multibanco 4 938,44 € e as despesas em dinheiro 1 200,14 €
- **THEN** o cash guardado é 949,91 €

#### Scenario: Dia 1 de julho da folha
<!-- yourlab: id=TC-005; requirementId=FR-01 -->
- **WHEN** a faturação total é 7 088,49 €, o multibanco 4 938,44 € e as despesas 1 179,71 €
- **THEN** o cash guardado é 970,34 €

### Requirement: Dias antigos não mudam
<!-- yourlab: id=FR-02; type=functional; priority=high; module=Backend -->

Um fecho com `regra_calculo` nulo SHALL manter o valor guardado e SHALL NOT ser recalculado com a regra nova, nem ao abrir nem ao voltar a guardar. A regra nova só se aplica a dias iguais ou posteriores a `restaurante.regra_cash_desde`.

#### Scenario: Reabrir um dia de março
<!-- yourlab: id=TC-006; requirementId=FR-02 -->
- **WHEN** a casa liga a regra nova em 1 de julho e alguém abre e guarda o fecho de 10 de março
- **THEN** o cash de 10 de março fica igual ao que estava guardado

### Requirement: Registo do depósito
<!-- yourlab: id=FR-04; type=functional; priority=low; module=Backend -->

O fecho SHALL guardar a data (`deposito_data`) e o valor depositado.

### Requirement: Fecho auditado
<!-- yourlab: id=RNF-01; type=non_functional; priority=high; module=Backend -->

Cada gravação do fecho SHALL emitir um evento de auditoria com utilizador, casa, dia e valores antes e depois.

### Requirement: Fornecedores do grupo
<!-- yourlab: id=FR-09; type=functional; priority=high; module=Backend -->

O sistema SHALL guardar fornecedores sem casa (lista do grupo), com categoria habitual e forma de pagamento habitual. Um fornecedor com faturas SHALL só poder ser desativado, nunca apagado.

### Requirement: IBAN protegido
<!-- yourlab: id=RNF-03; type=non_functional; priority=high; module=Backend -->

Só administradores SHALL ver e alterar o IBAN completo. Os outros perfis veem-no mascarado e o VISUALIZADOR nunca o vê. Ler fornecedores SHALL exigir acesso a pelo menos uma casa.

### Requirement: Faturas e notas de crédito
<!-- yourlab: id=FR-10; type=functional; priority=high; module=Backend -->

Cada fatura SHALL ter casa, fornecedor, número, data, tipo (FATURA ou NOTA_CREDITO), categoria e valor positivo com IVA. As notas de crédito SHALL descontar no total.

#### Scenario: Aviludo em julho
<!-- yourlab: id=TC-007; requirementId=FR-10 -->
- **WHEN** a Aviludo tem faturas de 2 627,31 € e uma nota de crédito de 570,11 €
- **THEN** o total da Aviludo no mês é 2 057,20 €

#### Scenario: Total de julho da folha
<!-- yourlab: id=TC-008; requirementId=FR-10 -->
- **WHEN** estão registadas as 79 faturas e notas de crédito de julho
- **THEN** o total do mês é 36 676,47 €

### Requirement: Aviso de fatura repetida
<!-- yourlab: id=FR-11; type=functional; priority=medium; module=Backend -->

Ao gravar, o sistema SHALL avisar quando já existe uma fatura ativa com o mesmo fornecedor, número e tipo.

### Requirement: Estado de pagamento
<!-- yourlab: id=FR-12; type=functional; priority=high; module=Backend -->

Uma fatura com `pago_em` nulo SHALL estar pendente. Marcar como paga SHALL guardar a data e a forma de pagamento, com auditoria. Uma fatura pode ficar marcada "aguarda nota de crédito".

### Requirement: Pagamentos automáticos ao banco
<!-- yourlab: id=OOS-01; type=out_of_scope; priority=medium; module=Backend -->

Gerar o ficheiro SEPA ou pagar diretamente no banco fica fora destas fases (ver `ideas.md`).

### Requirement: Fórmulas do painel
<!-- yourlab: id=FR-19; type=functional; priority=high; module=Backend -->

O sistema SHALL calcular:
- faturação c/ IVA s/ gorjetas = faturação total − gorjetas;
- food cost = faturas (com notas de crédito, categoria COMIDA) + despesas FORNECEDOR sem fatura ligada;
- food cost % = food cost ÷ faturação c/ IVA s/ gorjetas;
- máximo = limite × faturação c/ IVA s/ gorjetas;
- crescimento = (faturação − faturação do ano anterior) ÷ faturação do ano anterior;
- balanço = faturação c/ IVA s/ gorjetas − food cost − outras despesas − folha − segurança social − extras − chamadores − custos fixos.

As somas SHALL ser feitas em decimal.

#### Scenario: Julho da folha
<!-- yourlab: id=TC-003; requirementId=FR-19 -->
- **WHEN** faturação 219 743,19 €, gorjetas 23 462,04 €, faturas 36 676,47 € e fornecedores em dinheiro 22 891,04 €
- **THEN** faturação c/ IVA s/ gorjetas = 196 281,15 €, food cost = 59 567,51 € (30,35%), máximo = 54 958,72 € e diferença = 4 608,79 €

#### Scenario: Crescimento sobre o ano anterior
<!-- yourlab: id=TC-010; requirementId=FR-19 -->
- **WHEN** julho 2026 = 219 743,19 € e julho 2025 = 164 716,03 €
- **THEN** o crescimento é 33,41% (não 25,04% como na folha)

#### Scenario: Balanço sem pessoal
<!-- yourlab: id=TC-011; requirementId=FR-19 -->
- **WHEN** a folha e a segurança social estão a zero, outras = 1 148,53 €, extras = 857,32 €, chamadores = 4 359,00 € e água/gás/luz = 9 000,00 €
- **THEN** o balanço é 121 348,79 €, igual ao da folha

### Requirement: Comparativo só das casas acessíveis
<!-- yourlab: id=FR-20; type=functional; priority=high; module=Backend -->

O comparativo SHALL incluir só as casas a que o utilizador tem acesso.

### Requirement: Base do food cost
<!-- yourlab: id=UQ-033; type=undefined; priority=high; module=Backend -->

Faturação com ou sem IVA, e se papel, táxis e ferramentas contam como food cost: a confirmar com o cliente (ver `questions.md`).

### Requirement: Folha gerada a partir da app
<!-- yourlab: id=FR-13; type=functional; priority=high; module=Backend -->

"Gerar" SHALL criar ou atualizar uma linha por funcionário com atividade no mês:
- salário = salário atual × dias ativos no mês ÷ dias do mês;
- extras e feriados = soma das despesas ORDENADO_CASH e FERIADO desse funcionário;
- gorjetas = soma dos valores efetivos da distribuição do mês.

As férias e as notas SHALL ser escritas à mão e mantidas ao gerar de novo.

#### Scenario: Entrada a meio do mês
<!-- yourlab: id=TC-012; requirementId=FR-13 -->
- **WHEN** um funcionário com salário de 920,00 € entra a 15 de julho
- **THEN** tem 17 dias ativos e o salário de julho é 504,52 €

### Requirement: Segurança social
<!-- yourlab: id=FR-14; type=functional; priority=high; module=Backend -->

A segurança social de cada linha SHALL ser `taxa_seguranca_social` da casa × (salário + férias + feriados). A taxa usada SHALL ficar guardada na linha.

### Requirement: Mês fechado não muda
<!-- yourlab: id=FR-15; type=functional; priority=high; module=Backend -->

Depois de "Fechar mês" (`fechadoEm` preenchido), "Gerar" SHALL NOT alterar as linhas desse mês, e mudar o salário em Funcionários SHALL NOT alterar meses fechados.

### Requirement: Mesmo valor de gorjetas que o acerto
<!-- yourlab: id=TC-02; type=functional; priority=high; module=Backend -->

As gorjetas de um funcionário na folha SHALL ser iguais à soma do acerto dele no mesmo período, porque usam a mesma função de valor efetivo.

### Requirement: Salários visíveis só a administradores
<!-- yourlab: id=RNF-04; type=non_functional; priority=high; module=Backend -->

Só administradores SHALL ver e alterar a folha do mês.

### Requirement: Regra de proporcionalidade
<!-- yourlab: id=UQ-032; type=undefined; priority=high; module=Backend -->

Dias de calendário ou regra dos 30 dias, e o significado de "Férias" (subsídio ou parte mensal): a confirmar com o cliente e o contabilista.

### Requirement: Contas só por administrador
<!-- yourlab: id=RNF-05; type=non_functional; priority=high; module=Backend -->

Criar contas SHALL exigir um administrador autenticado. O registo público SHALL deixar de existir.

#### Scenario: Registo anónimo
<!-- yourlab: id=TC-013; requirementId=RNF-05 -->
- **WHEN** alguém sem sessão chama o registo com um perfil e casas
- **THEN** o sistema recusa com 401 ou 403 e não cria a conta

### Requirement: Nunca apagar dados financeiros
<!-- yourlab: id=RNF-06; type=non_functional; priority=high; module=Backend -->

Apagar uma casa com dados financeiros SHALL ser recusado (409), indicando que deve ser desativada. As tabelas novas SHALL usar ligações `Restrict` e eliminação suave. As migrações SHALL ser só aditivas.

### Requirement: Backups fora do servidor
<!-- yourlab: id=RNF-07; type=non_functional; priority=high; module=Backend -->

Deve existir uma cópia diária da base de dados fora do droplet, e um alerta quando a cópia não chega em 26 horas. Um teste de reposição SHALL ser feito por trimestre numa base nova.

### Requirement: Monitorização
<!-- yourlab: id=RNF-08; type=non_functional; priority=high; module=Backend -->

O sistema SHALL ter um endpoint `/health` que verifica a base de dados, um monitor de disponibilidade externo, rastreio de erros, rotação de logs e alertas de CPU, memória e disco.

### Requirement: Ambiente de testes separado
<!-- yourlab: id=RNF-09; type=non_functional; priority=high; module=Backend -->

Deve existir um link de testes com base de dados própria, sem acesso aos dados nem ao volume de produção.

### Requirement: Piloto por casa
<!-- yourlab: id=FR-27; type=functional; priority=high; module=Backend -->

Os ecrãs financeiros novos SHALL aparecer só nas casas com `modulo_financeiro_ativo`. A seleção da casa SHALL ser única para todas as páginas.

### Requirement: Releases ensaiadas
<!-- yourlab: id=RNF-10; type=non_functional; priority=high; module=Backend -->

Cada release SHALL passar por `scripts/sandbox-test.sh` numa base nova e vazia, com tag `release-AAAA-MM-DD-N` em `main` e publicação por `scripts/deploy-remote.sh`. O CI SHALL correr os testes do backend em cada push.

### Requirement: Primeiro requisito
<!-- yourlab: id=UQ-001; type=undefined; priority=high; module=Backend -->

O sistema SHALL ….
