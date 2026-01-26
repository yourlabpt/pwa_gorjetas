# Proposta de Estrutura do Banco de Dados - Sistema Financeiro

## Mudanças no Schema Prisma

### 1. Novas Tabelas a Adicionar

#### A) FATURAMENTO_DIARIO

```prisma
model FaturamentoDiario {
  id                          Int      @id @default(autoincrement())
  restID                      Int
  data                        DateTime @db.Date // Única por (restID, data)
  faturamento_inserido        Decimal  @db.Decimal(12, 2) // Manual do gestor
  faturamento_calculado       Decimal  @db.Decimal(12, 2) @default(0) // Soma de transacoes
  diferenca_percentual        Decimal  @db.Decimal(5, 2) @default(0) // |(insert-calc)/calc|
  notas                       String?  // Motivo da diferença
  ativo                       Boolean  @default(true) // Soft delete
  criadoEm                    DateTime @default(now())
  atualizadoEm                DateTime @updatedAt

  // Relations
  restaurante                 Restaurante @relation(fields: [restID], references: [restID], onDelete: Cascade)

  @@unique([restID, data]) // Uma entrada por dia por restaurante
  @@index([restID])
  @@index([data])
  @@map("faturamento_diario")
}
```

#### B) CONFIGURACAO_ACERTO

```prisma
model ConfiguracaoAcerto {
  id                          Int      @id @default(autoincrement())
  restID                      Int
  funcao                      String   // "Garçom", "Cozinha", "Chamador", "Supervisor", etc.
  base_calculo                String   // ENUM: "GORJETA_TOTAL" | "FATURAMENTO_BASE" | "ABSOLUTO"
  valor_percentual            Decimal? @db.Decimal(5, 2) // NULL se ABSOLUTO
  valor_absoluto              Decimal? @db.Decimal(10, 2) // NULL se PERCENTUAL
  ativo                       Boolean  @default(true)
  criadoEm                    DateTime @default(now())
  atualizadoEm                DateTime @updatedAt

  // Relations
  restaurante                 Restaurante @relation(fields: [restID], references: [restID], onDelete: Cascade)
  acertos_funcionarios        AcertoFuncionario[]

  @@unique([restID, funcao]) // Uma config por função por restaurante
  @@index([restID])
  @@map("configuracao_acerto")
}
```

#### C) ACERTO_PERIODO

```prisma
model AcertoPeriodo {
  id                          Int      @id @default(autoincrement())
  restID                      Int
  periodo_inicio              DateTime @db.Date
  periodo_fim                 DateTime @db.Date
  tipo_periodo                String   // ENUM: "DIARIO" | "SEMANAL"
  faturamento_total           Decimal  @db.Decimal(12, 2) // Snapshot do período
  gorjeta_total               Decimal  @db.Decimal(12, 2) // Snapshot das gorjetas
  pago                        Boolean  @default(false)
  data_pagamento              DateTime? // Quando foi marcado como pago
  usuario_pagamento_id        Int? // FK → Gestor que marcou como pago
  criadoEm                    DateTime @default(now())
  atualizadoEm                DateTime @updatedAt

  // Relations
  restaurante                 Restaurante @relation(fields: [restID], references: [restID], onDelete: Cascade)
  acertos_funcionarios        AcertoFuncionario[]
  transacoes                  Transacao[]

  @@index([restID])
  @@index([pago])
  @@index([periodo_inicio])
  @@map("acerto_periodo")
}
```

#### D) ACERTO_FUNCIONARIO

```prisma
model AcertoFuncionario {
  id                          Int      @id @default(autoincrement())
  acerto_periodo_id           Int
  funcID                      Int
  configuracao_acerto_id      Int      // Link para config (snapshot)
  funcao                      String   // Snapshot da função
  valor_base                  Decimal  @db.Decimal(12, 2) // Base de cálculo
  percentual_aplicado         Decimal? @db.Decimal(5, 2) // % se aplicável
  valor_absoluto_aplicado     Decimal? @db.Decimal(10, 2) // Valor fixo se aplicável
  valor_calculado             Decimal  @db.Decimal(12, 2) // Resultado final
  pago                        Boolean  @default(false) // Atualiza com acerto_periodo.pago
  criadoEm                    DateTime @default(now())
  atualizadoEm                DateTime @updatedAt

  // Relations
  acerto_periodo              AcertoPeriodo @relation(fields: [acerto_periodo_id], references: [id], onDelete: Cascade)
  funcionario                 Funcionario @relation(fields: [funcID], references: [funcID], onDelete: Cascade)
  configuracao_acerto         ConfiguracaoAcerto @relation(fields: [configuracao_acerto_id], references: [id])

  @@index([acerto_periodo_id])
  @@index([funcID])
  @@map("acerto_funcionario")
}
```

---

### 2. Alterações em Tabelas Existentes

#### A) TRANSACAO - Adicionar campos de acerto

```prisma
model Transacao {
  tranID                        Int      @id @default(autoincrement())
  total                         Decimal  @db.Decimal(10, 2)
  valor_gorjeta_calculada       Decimal  @db.Decimal(10, 2)
  percentagem_aplicada          Decimal  @db.Decimal(5, 2)
  mbway                         Decimal  @db.Decimal(10, 2) @default(0)
  funcID_garcom                 Int
  restID                        Int
  data_transacao                DateTime
  
  // NOVOS CAMPOS
  acerto_periodo_id             Int?     // FK → AcertoPeriodo (NULL até ser acertado)
  pago                          Boolean  @default(false) // Atualiza quando acerto marcado
  
  criadoEm                     DateTime @default(now())
  updatedAt                    DateTime @updatedAt

  // Relations
  garcom                        Funcionario @relation("garcom", fields: [funcID_garcom], references: [funcID])
  restaurante                   Restaurante @relation(fields: [restID], references: [restID])
  distribuicoes                 DistribuicaoGorjetas[]
  acerto_periodo                AcertoPeriodo? @relation(fields: [acerto_periodo_id], references: [id]) // NOVO

  @@index([restID])
  @@index([funcID_garcom])
  @@index([createdAt])
  @@index([pago]) // NOVO
  @@map("transacoes")
}
```

#### B) RESTAURANTE - Adicionar relações

```prisma
model Restaurante {
  restID                        Int      @id @default(autoincrement())
  name                          String
  endereco                      String?
  contacto                      String?
  percentagem_gorjeta_base      Decimal  @db.Decimal(5, 2)
  ativo                         Boolean  @default(true)
  createdAt                     DateTime @default(now())
  updatedAt                     DateTime @updatedAt

  // Relations
  funcionarios_diretos          Funcionario[] @relation("FuncionarioDireto")
  funcionarios_many             FuncionarioRestaurante[]
  configuracoes_gorjetas        ConfiguracaoGorjetas[]
  transacoes                    Transacao[]
  limpeza                       Limpeza[]
  
  // NOVAS RELAÇÕES
  faturamentos_diarios          FaturamentoDiario[]      // NOVO
  configuracoes_acerto          ConfiguracaoAcerto[]     // NOVO
  acertos_periodo               AcertoPeriodo[]          // NOVO

  @@map("restaurantes")
}
```

---

## Diagrama de Relações

```
┌─────────────────┐
│  RESTAURANTES   │
│   (restID)      │
└────────┬────────┘
         │
         ├──→ (1:N) FATURAMENTO_DIARIO
         │           ├─ data (UNIQUE com restID)
         │           ├─ faturamento_inserido
         │           └─ faturamento_calculado
         │
         ├──→ (1:N) CONFIGURACAO_ACERTO
         │           ├─ funcao
         │           ├─ base_calculo
         │           ├─ valor_percentual
         │           └─ valor_absoluto
         │
         ├──→ (1:N) ACERTO_PERIODO
         │           ├─ periodo_inicio
         │           ├─ periodo_fim
         │           ├─ pago
         │           └─ ↓
         │            └──→ (1:N) ACERTO_FUNCIONARIO
         │                    ├─ funcID
         │                    ├─ valor_calculado
         │                    ├─ pago
         │                    └─ ← FK configuracao_acerto
         │
         └──→ (1:N) TRANSACOES (com novo campo acerto_periodo_id)
                    ├─ acerto_periodo_id (FK)
                    └─ pago (atualiza com acerto)
```

---

## Fluxo de Cálculo: Como Funciona

### Cenário Prático

**Restaurante:** Tasca do João  
**Data:** 25 janeiro 2026  
**Faturamento inserido:** R$ 5.000,00

#### Passo 1: Sistema calcula faturamento do dia

```
Transações do dia (observações):
- João (Garçom):    Mesa 5,  Total R$ 50,   Gorjeta R$ 5     (10%)
- Maria (Garçom):   Mesa 8,  Total R$ 75,   Gorjeta R$ 7,50  (10%)
- Carlos (Garçom):  Mesa 3,  Total R$ 100,  Gorjeta R$ 0     (SEM GORJETA)
- [... mais transações]

Faturamento_calculado = R$ 4.950,00 (soma de todos os "Total")
Gorjeta_total = R$ 300,00 (soma de todas as gorjetas)
Faturamento_base (11%) = R$ 550,00 (faturamento_calculado * 0,11)

VALIDAÇÃO:
- Faturamento_calculado (4.950) < Faturamento_inserido (5.000)?
  → NÃO, então sem aviso
- Se fosse 5.100 > 5.000?
  → SIM, então exibe ⚠️ "Faturamento calculado (5.100) > inserido (5.000)"
```

#### Passo 2: Armazena em FATURAMENTO_DIARIO

```
INSERT INTO faturamento_diario:
- restID = 1
- data = 2026-01-25
- faturamento_inserido = 5000.00
- faturamento_calculado = 4950.00
- diferenca_percentual = 1.01%
- notas = NULL
```

#### Passo 3: Gestor cria acerto para período (25-25 janeiro)

```
INSERT INTO acerto_periodo:
- restID = 1
- periodo_inicio = 2026-01-25
- periodo_fim = 2026-01-25
- tipo_periodo = "DIARIO"
- faturamento_total = 5000.00 (usa inserido)
- gorjeta_total = 300.00
- pago = false
```

#### Passo 4: Sistema calcula distribuição por função

**Configuração (CONFIGURACAO_ACERTO):**
```
- Garçom:    base_calculo = "GORJETA_TOTAL",      valor_percentual = 80%
- Cozinha:   base_calculo = "FATURAMENTO_BASE",   valor_percentual = 50%
- Chamador:  base_calculo = "ABSOLUTO",           valor_absoluto = R$ 50.00
- Supervisor: base_calculo = "GORJETA_TOTAL",     valor_percentual = 20%
```

**Cálculo:**

```
João (Garçom):
- valor_base = R$ 300 (gorjeta_total * 80%)
- valor_calculado = R$ 240

Maria (Garçom):
- valor_base = R$ 300 * 80% = R$ 240

Cozinha (Função):
- valor_base = R$ 550 (faturamento_base * 50%)
- valor_calculado = R$ 275

Chamador (Função):
- valor_base = R$ 50 (absoluto)
- valor_calculado = R$ 50
```

#### Passo 5: Insere em ACERTO_FUNCIONARIO (1 por funcionário por período)

```
INSERT INTO acerto_funcionario:
- acerto_periodo_id = 1
- funcID = 101 (João)
- funcao = "Garçom"
- valor_base = 300.00
- percentual_aplicado = 80
- valor_calculado = 240.00
- pago = false
```

#### Passo 6: Gestor marca como "Acertado"

```
UPDATE acerto_periodo SET pago = true WHERE id = 1

UPDATE acerto_funcionario SET pago = true WHERE acerto_periodo_id = 1

UPDATE transacoes SET pago = true, acerto_periodo_id = 1 
WHERE restID = 1 AND data_transacao BETWEEN 2026-01-25 AND 2026-01-25
```

---

## Validação do Cliente ✅

**Confirmações recebidas:**

1. ✅ **Página Unificada:** "Acerto" é uma abinha/seção dentro de "Financeiro Diário" (não é página separada)
2. ✅ **Gorjetas são PARTE do faturamento:** A soma das gorjetas não é o total, é apenas uma parte
3. ✅ **Sem obrigatoriedade de gorjeta:** Cliente pode optar por não ter gorjeta em uma transação
4. ✅ **Validação de diferença:** Apenas **avisa** se `faturamento_calculado > faturamento_inserido` (não bloqueia)
5. ✅ **Edição retroativa:** Poder editar dados de dia anterior
6. ✅ **Estrutura de 4 tabelas:** Aprovada

**Próximas etapas:**
- Criar migrations Prisma
- Implementar endpoints backend
- Criar página unificada "Financeiro Diário" com abinha "Acerto"

