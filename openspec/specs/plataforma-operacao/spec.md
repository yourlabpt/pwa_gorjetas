# Plataforma e operação Specification
<!-- yourlab: capability=plataforma-operacao; module=Infraestrutura -->

## Purpose

Garantir que a app em produção é segura, tem cópias de segurança fora do servidor, é vigiada e evolui sem perder dados.

## Requirements

### Requirement: Contas só por administrador
<!-- yourlab: id=RNF-05; type=non_functional; module=Backend; priority=high -->

Criar contas SHALL exigir um administrador autenticado. O registo público SHALL deixar de existir.

#### Scenario: Registo anónimo
- **WHEN** alguém sem sessão chama o registo com um perfil e casas
- **THEN** o sistema recusa com 401 ou 403 e não cria a conta

### Requirement: Nunca apagar dados financeiros
<!-- yourlab: id=RNF-06; type=non_functional; module=Backend; priority=high -->

Apagar uma casa com dados financeiros SHALL ser recusado (409), indicando que deve ser desativada. As tabelas novas SHALL usar ligações `Restrict` e eliminação suave. As migrações SHALL ser só aditivas.

### Requirement: Backups fora do servidor
<!-- yourlab: id=RNF-07; type=non_functional; module=Infraestrutura; priority=high -->

Deve existir uma cópia diária da base de dados fora do droplet, e um alerta quando a cópia não chega em 26 horas. Um teste de reposição SHALL ser feito por trimestre numa base nova.

### Requirement: Monitorização
<!-- yourlab: id=RNF-08; type=non_functional; module=Infraestrutura; priority=high -->

O sistema SHALL ter um endpoint `/health` que verifica a base de dados, um monitor de disponibilidade externo, rastreio de erros, rotação de logs e alertas de CPU, memória e disco.

### Requirement: Ambiente de testes separado
<!-- yourlab: id=RNF-09; type=non_functional; module=Infraestrutura; priority=high -->

Deve existir um link de testes com base de dados própria, sem acesso aos dados nem ao volume de produção.

### Requirement: Piloto por casa
<!-- yourlab: id=FR-27; type=functional; module=Backend; priority=high -->

Os ecrãs financeiros novos SHALL aparecer só nas casas com `modulo_financeiro_ativo`. A seleção da casa SHALL ser única para todas as páginas.

### Requirement: Releases ensaiadas
<!-- yourlab: id=RNF-10; type=non_functional; module=Infraestrutura; priority=high -->

Cada release SHALL passar por `scripts/sandbox-test.sh` numa base nova e vazia, com tag `release-AAAA-MM-DD-N` em `main` e publicação por `scripts/deploy-remote.sh`. O CI SHALL correr os testes do backend em cada push.
