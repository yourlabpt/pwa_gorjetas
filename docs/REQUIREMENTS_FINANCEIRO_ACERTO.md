# Requirements: Sistema de Financeiro Diário e Acerto de Contas

**Data:** 23 janeiro 2026  
**Status:** Especificação Detalhada  
**Versão:** 2.0

---

## 1. Visão Geral

O sistema deve evoluir para um modelo de **Financeiro Diário** que:
- Registra faturamento total por restaurante por dia
- Distribui receita entre funcionários, gerentes e supervisores
- Permite "acerto" (liquidação/pagamento) de contas por período
- Valida faturamento inserido vs calculado

### Diagrama Conceitual

```
FATURAMENTO TOTAL DIÁRIO (Manual + Calculado)
        ↓
    ├─ Faturamento COM gorjetas
    │   └─ Distribuição entre funcionários (Garçons, Cozinha, etc)
    │
    └─ Faturamento SEM gorjetas (11% base ou configurado)
        └─ Distribuição entre Gestores e Supervisores
```

---

## 2. Épico 1: Faturamento Total Diário

### 2.1 Funcionalidade

- **Quando:** Diariamente por restaurante
- **O quê:** Um campo manual onde usuário insere faturamento total do dia
- **Como:** 
  - Permite inserir faturamento_manual em qualquer dia posterior
  - Sistema calcula faturamento_calculado = soma de todas transações daquele dia
  - Exibe ambos para conferência
  - Permite editar o valor manual depois

### 2.2 Campos Necessários

Nova tabela: **FATURAMENTO_DIARIO**

```sql
FATURAMENTO_DIARIO (
  id: UUID PK,
  restID: FK → RESTAURANTES,
  data: DATE (única por restID),
  faturamento_inserido: DECIMAL (Manual),
  faturamento_calculado: DECIMAL (Soma de transações),
  diferenca_percentual: DECIMAL (Validação: |(insert-calc)/calc|),
  notas: TEXT (Motivo da diferença),
  criado_em: TIMESTAMP,
  atualizado_em: TIMESTAMP,
  ativo: BOOLEAN (Soft delete)
)
```

### 2.3 Fluxo

1. Usuário acessa "Financeiro Diário" → seleciona data
2. Sistema calcula faturamento do dia (soma transações)
3. Usuário insere faturamento_manual
4. Sistema exibe diferença em tempo real
5. ⚠️ **Se faturamento_calculado > faturamento_inserido:** Exibe aviso (não bloqueia)
6. Usuário pode adicionar notas explicativas
7. Sistema permite editar qualquer dia (retroativo)

### 2.4 Validações

- Faturamento inserido deve ser ≥ 0
- ⚠️ **Aviso se:** faturamento_calculado > faturamento_inserido (permite prosseguir)
- Campo data é única por combinação (restID, data)
- Permite editar dias passados (retroativo)

---

## 3. Épico 2: Acerto de Contas (Settlement)

### 3.1 Conceito

**"Acerto" = Liquidação de contas em um período (diário ou semanal)**

Após o faturamento total do dia, gestores/supervisores precisam distribuir o dinheiro:
- Quanto cada funcionário recebe (gorjeta + base)
- Quanto a cozinha recebe (cálculo complexo)
- Quanto o gestor/supervisor recebe

### 3.2 Fórmula de Cálculo

```
FATURAMENTO TOTAL = Faturamento com Gorjetas + Faturamento Base (11%)

DISTRIBUIÇÃO:
  ├─ GARÇOM (Gorjetas): Recebe % das gorjetas totais
  ├─ COZINHA: Valor Base - Gestor - Supervisor - Outras Funções
  ├─ GESTOR: % do Faturamento Base (11% ou configurado)
  ├─ SUPERVISOR: % do Faturamento Base ou % das Gorjetas Totais
  └─ FUNÇÕES CUSTOMIZADAS: % ou valor absoluto (configurável)
```

### 3.3 Estrutura de Dados

Nova tabela: **CONFIGURACAO_ACERTO**

```sql
CONFIGURACAO_ACERTO (
  id: UUID PK,
  restID: FK → RESTAURANTES,
  funcao: STRING (ex: "Garçom", "Cozinha", "Chamador", "Supervisor")
  base_calculo: ENUM ["GORJETA_TOTAL", "FATURAMENTO_BASE", "ABSOLUTO"],
  valor_percentual: DECIMAL (NULL se ABSOLUTO),
  valor_absoluto: DECIMAL (NULL se PERCENTUAL),
  ativo: BOOLEAN,
  criado_em: TIMESTAMP,
  atualizado_em: TIMESTAMP
)
```

Nova tabela: **ACERTO_PERIODO**

```sql
ACERTO_PERIODO (
  id: UUID PK,
  restID: FK → RESTAURANTES,
  periodo_inicio: DATE,
  periodo_fim: DATE,
  tipo_periodo: ENUM ["DIARIO", "SEMANAL"],
  faturamento_total: DECIMAL (snapshot),
  gorjeta_total: DECIMAL (snapshot),
  pago: BOOLEAN (default: false),
  data_pagamento: TIMESTAMP,
  usuario_pagamento: FK → GESTORES,
  criado_em: TIMESTAMP,
  atualizado_em: TIMESTAMP
)
```

Nova tabela: **ACERTO_FUNCIONARIO** (Detalhes do acerto por funcionário)

```sql
ACERTO_FUNCIONARIO (
  id: UUID PK,
  acerto_periodo_id: FK → ACERTO_PERIODO,
  funcID: FK → FUNCIONARIOS,
  funcao: STRING (snapshot da configuração),
  valor_base: DECIMAL,
  percentual_aplicado: DECIMAL,
  valor_calculado: DECIMAL (base * percentual OU absoluto),
  pago: BOOLEAN (atualiza quando acerto_periodo.pago = true),
  criado_em: TIMESTAMP,
  atualizado_em: TIMESTAMP
)
```

### 3.4 Campos a Adicionar em Transações (TRANSACOES)

Adicionar para rastreamento:

```sql
TRANSACOES (
  -- Campos existentes...
  acerto_periodo_id: FK → ACERTO_PERIODO (NULL até ser marcado como pago),
  pago: BOOLEAN (default: false, atualiza quando acerto marcado como pago)
)
```

### 3.5 Fluxo do Acerto

1. Gestor acessa página "Acerto"
2. Seleciona período (data início, fim ou tipo "semanal")
3. Sistema calcula automaticamente:
   - Faturamento total do período
   - Gorjeta total do período
   - Valor para cada funcionário baseado em CONFIGURACAO_ACERTO
4. Exibe tabela com:
   - Nome do funcionário
   - Função
   - Valor base
   - Percentual
   - Valor final a receber
5. Botão "Marcar como Acertado"
   - Se clicado → marca ACERTO_PERIODO.pago = true
   - → Atualiza ACERTO_FUNCIONARIO.pago = true
   - → Atualiza todas TRANSACOES do período com pago = true
6. Permite filtrar por:
   - Data inicial/final
   - Tipo período (diário/semanal)
   - Status (pago/não pago)

---

## 4. Épico 3: Configuração de Acerto por Função

### 4.1 Funcionalidade

Página: **Configuração > Acerto e Distribuição** (por restaurante)

Permite admin/gestor configurar:
- Quais funções existem no restaurante
- Como cada função recebe (% gorjeta, % faturamento, ou valor absoluto)
- Criar funções customizadas

### 4.2 Interface de Configuração

```
Restaurante: [Dropdown]

Tabela de Funções:
┌─────────────────────────────────────────────────────────────┐
│ Função      │ Base Cálculo    │ Valor %     │ Valor Absoluto │
├─────────────────────────────────────────────────────────────┤
│ Garçom      │ Gorjeta Total   │ 80%         │ —              │
│ Cozinha     │ Faturamento Base│ 50%         │ —              │
│ Chamador    │ Absoluto        │ —           │ R$ 50,00       │
│ Supervisor  │ Gorjeta Total   │ 20%         │ —              │
│ [+ Nova]    │                 │             │                │
└─────────────────────────────────────────────────────────────┘
```

### 4.3 Regras

- **Supervisor:** Pode estar vinculado a múltiplos restaurantes
- **Gestor:** Exclusivo de um restaurante (múltiplos gestores por restaurante)
- **Funcionários:** Podem ter múltiplas funções no mesmo restaurante

### 4.4 Validação

- Se base_calculo = PERCENTUAL, valor_percentual obrigatório
- Se base_calculo = ABSOLUTO, valor_absoluto obrigatório
- Soma de percentuais não deve exceder 100% por base_calculo

---

## 5. Mudança de Paradigma: Financeiro Diário com Acerto Integrado

### 5.1 Antes
- Página "Transações": Lista de transações individuais
- Página "Relatórios": Agregações
- Página "Acerto": Separada

### 5.2 Depois
- **Página UNIFICADA "Financeiro Diário"**: 
  - Abinha 1: **Resumo Diário** (faturamento + transações)
  - Abinha 2: **Acerto** (distribuição + liquidação)
  - Permite editar dias anteriores
  - Relatório visual com valores claros

### 5.3 Estrutura da Página "Financeiro Diário"

#### Abinha 1: RESUMO DIÁRIO

```
┌──────────────────────────────────────────────────────┐
│ Financeiro Diário  [Resumo] [Acerto]  [Data] [◀ ▶]   │
├──────────────────────────────────────────────────────┤
│ Restaurante: [Dropdown]                              │
│                                                      │
│ RESUMO DO DIA:                                       │
│  Faturamento Inserido:     R$ 5.000,00  [Editar]     │
│  Faturamento Calculado:    R$ 4.950,00               │
│  ⚠️ Faturamento calculado é menor (diferença)       │
│  [+ Adicionar Notas]                                 │
│                                                      │
│ DISTRIBUIÇÃO DIÁRIA:                                 │
│  ├─ Gorjeta Total:         R$ 300,00                 │
│  ├─ Faturamento Base (11%): R$ 550,00                │
│  └─ Total:                 R$ 5.000,00               │
│                                                      │
│ TRANSAÇÕES DO DIA (12 transações):                   │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Hora │ Funcionário │ Mesa │ Total │ Gorjeta │ - │ │
│ ├──────────────────────────────────────────────────┤ │
│ │ 12:30│ João        │ 5    │ 50    │ 5       │ x │ │
│ │ 13:00│ Maria       │ 8    │ 75    │ 7,5     │ x │ │
│ │ 14:15│ Carlos      │ 3    │ 100   │ 0       │ - │ │
│ └──────────────────────────────────────────────────┘ │
│ [Adicionar Transação] [Editar]                       │
└──────────────────────────────────────────────────────┘
```

#### Abinha 2: ACERTO

```
┌──────────────────────────────────────────────────────┐
│ Financeiro Diário  [Resumo] [Acerto]  [Data] [◀ ▶]   │
├──────────────────────────────────────────────────────┤
│ Restaurante: [Dropdown]                              │
│                                                      │
│ ACERTO DE CONTAS:                                    │
│ Período: [Data Início] até [Data Fim]  [Tipo: Diário▼]
│                                                      │
│ RESUMO DO PERÍODO:                                   │
│  Faturamento Total:        R$ 5.000,00               │
│  Gorjeta Total:            R$ 300,00                 │
│  Faturamento Base (11%):   R$ 550,00                 │
│                                                      │
│ DISTRIBUIÇÃO POR FUNCIONÁRIO:                        │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Nome     │ Função   │ Base  │ %  │ Valor    │   │ │
│ ├──────────────────────────────────────────────────┤ │
│ │ João     │ Garçom   │ 300   │ 80%│ R$ 240   │ ✓ │ │
│ │ Maria    │ Garçom   │ 300   │ 80%│ R$ 240   │ ✓ │ │
│ │ Cozinha  │ Cozinha  │ 550   │ 50%│ R$ 275   │ ✓ │ │
│ │ Chamador │ Chamador │ 50    │ - │ R$ 50    │ - │ │
│ └──────────────────────────────────────────────────┘ │
│                                                      │
│ TOTAL A DISTRIBUIR: R$ 805,00                        │
│                                                      │
│ [Marcar como Acertado] [Status: Não pago]            │
└──────────────────────────────────────────────────────┘
```

---

## 6. Casos de Uso Principais

### UC1: Registrar Faturamento Diário

**Ator:** Gestor  
**Pré-condição:** Dia anterior já finalizado  
**Fluxo:**

1. Acessa "Financeiro Diário"
2. Seleciona data do dia
3. Sistema mostra transações do dia e faturamento calculado
4. Usuário insere faturamento_manual
5. Sistema calcula diferença
6. Usuario clica "Salvar"
7. Dados persistem na FATURAMENTO_DIARIO

### UC2: Editar Faturamento Anterior

**Ator:** Gestor  
**Pré-condição:** Faturamento já registrado  
**Fluxo:**

1. Acessa "Financeiro Diário"
2. Seleciona data anterior
3. Sistema carrega dados existentes
4. Usuário altera faturamento_inserido ou notas
5. Clica "Atualizar"
6. BD atualiza registro

### UC3: Criar Acerto de Período

**Ator:** Gestor  
**Pré-condição:** Faturamentos registrados para período  
**Fluxo:**

1. Acessa "Acerto"
2. Seleciona período (ex: 20-25 janeiro)
3. Sistema:
   - Calcula faturamento total do período
   - Calcula gorjeta total
   - Para cada funcionário, aplica CONFIGURACAO_ACERTO
   - Cria registro ACERTO_PERIODO
   - Cria registros ACERTO_FUNCIONARIO
4. Exibe tabela com valores
5. Gestor revisa e clica "Marcar como Acertado"
6. Sistema:
   - ACERTO_PERIODO.pago = true
   - ACERTO_FUNCIONARIO.pago = true
   - Todas TRANSACOES do período: pago = true

### UC4: Configurar Acerto de Função

**Ator:** Admin  
**Pré-condição:** Restaurante criado  
**Fluxo:**

1. Acessa "Configuração > Acerto e Distribuição"
2. Seleciona restaurante
3. Para cada função:
   - Define base_calculo (GORJETA_TOTAL, FATURAMENTO_BASE, ABSOLUTO)
   - Define valor (% ou R$)
   - Salva em CONFIGURACAO_ACERTO
4. Alterações aplicadas a acertos futuros

---

## 7. Banco de Dados - Resumo de Mudanças

### Novas Tabelas

1. **FATURAMENTO_DIARIO** (Faturamento total por dia)
2. **CONFIGURACAO_ACERTO** (Config de distribuição por função)
3. **ACERTO_PERIODO** (Acerto de período)
4. **ACERTO_FUNCIONARIO** (Detalhes do acerto por funcionário)

### Alterações em Tabelas Existentes

- **TRANSACOES**: Adicionar `acerto_periodo_id`, `pago`

### Relacionamentos

```
RESTAURANTES (1) ──→ (N) FATURAMENTO_DIARIO
RESTAURANTES (1) ──→ (N) CONFIGURACAO_ACERTO
RESTAURANTES (1) ──→ (N) ACERTO_PERIODO
ACERTO_PERIODO (1) ──→ (N) ACERTO_FUNCIONARIO
ACERTO_PERIODO (1) ──→ (N) TRANSACOES
FUNCIONARIOS (1) ──→ (N) ACERTO_FUNCIONARIO
```

---

## 8. Endpoints Backend (NestJS)

### Faturamento Diário

```
POST   /faturamento-diario
GET    /faturamento-diario?restID=&data=
GET    /faturamento-diario/:id
PUT    /faturamento-diario/:id
```

### Configuração Acerto

```
GET    /configuracao-acerto?restID=
POST   /configuracao-acerto
PUT    /configuracao-acerto/:id
DELETE /configuracao-acerto/:id
```

### Acerto de Período

```
GET    /acerto-periodo?restID=&dataInicio=&dataFim=&pago=
POST   /acerto-periodo (Cria + calcula automaticamente)
GET    /acerto-periodo/:id
PUT    /acerto-periodo/:id/marcar-pago (Atualiza pago + transações)
GET    /acerto-periodo/:id/funcionarios (Lista detalhes)
```

---

## 9. Páginas Frontend (Next.js)

### 1. `/financeiro-diario` (PÁGINA UNIFICADA)

**Abinha 1: Resumo Diário**
- Datepicker (com navegação ◀ ▶)
- Resumo faturamento (inserido vs calculado)
- Aviso se faturamento calculado > inserido
- Lista transações do dia (com possibilidade de editar/deletar)
- Poder editar faturamento e notas

**Abinha 2: Acerto**
- Filtros: data início/fim, tipo período (diário/semanal)
- Tabela com: Nome, Função, Valor Base, %, Valor Final
- Status: Pago/Não Pago
- Botão "Marcar como Acertado" (apenas se não pago)
- Histórico de acertos

### 2. `/configuracao/acerto` (Configuração de Distribuição)

- Seletor restaurante
- Tabela CRUD de funções
- Campos: Função, Base Cálculo, Valor (% ou R$)
- Adicionar/Editar/Deletar funções

---

## 10. Timeline Proposta

| Fase | Tarefas | Horas |
|------|---------|-------|
| **1** | Schema BD + Migrations Prisma | 4h |
| **2** | Backend endpoints (Faturamento + Acerto) | 6h |
| **3** | Lógica de cálculo de distribuição | 4h |
| **4** | Frontend Financeiro Diário (UNIFICADO com 2 abinhas) | 8h |
| **5** | Frontend Configuração Acerto | 3h |
| **6** | Testes + Integração | 4h |
| **TOTAL** | | **29h** |

**Páginas a Criar/Atualizar:**
- ✅ `/financeiro-diario` (Unificada com abinhas)
- ✅ `/configuracao/acerto` (Configuração de funções)
- ❌ Remover página separada `/acerto` (integrada em Financeiro Diário)

---

## Próximas Etapas

1. ✅ Validar este documento
2. ⏳ Confirmar estrutura do banco de dados
3. ⏳ Gerar migrations Prisma
4. ⏳ Implementar backend
5. ⏳ Implementar frontend

