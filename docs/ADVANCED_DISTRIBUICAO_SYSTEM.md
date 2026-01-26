# 🔄 Distribuição de Gorjetas - Novo Sistema Implementado

**Data:** 23 de janeiro de 2026  
**Status:** ✅ Implementado e Compilado  
**Changes:** Backend + Frontend Updated

---

## 📋 Mudanças Realizadas

### 1. ✅ Removido: Página "Nova Transação"
- Deletado: `frontend/src/pages/transacoes/nova.tsx`
- Deletado: `frontend/src/pages/transacoes/index.tsx`
- **Motivo:** Funcionalidade integrada na página "Financeiro Diário"

### 2. ✅ Novo Sistema de Distribuição

#### Antes (Sistema Simples)
```
Garçom:    % de Gorjeta Total
Cozinha:   3% (fixo do sistema)
Chamador:  % de Gorjeta Total
Supervisor: % de Faturamento Base (11%)
```

#### Agora (Sistema Avançado com 5 bases de cálculo)
```
GORJETA_TOTAL:
  └─ Calcula % da Gorjeta Total
  └─ Exemplo: Garçom 80% da gorjeta

GORJETA_REMAINING:
  └─ Calcula % da GORJETA REMANESCENTE
  └─ Após outras funções tomarem sua share
  └─ Exemplo: Cozinha pega 100% do que sobrou

FATURAMENTO_BASE:
  └─ Calcula % dos 11% do faturamento
  └─ Exemplo: Chamador 20% de 11%

FATURAMENTO_EXTRA:
  └─ Calcula % dos 89% do faturamento (não-base)
  └─ NOVO: Supervisor/Gestor pega % disso
  └─ Exemplo: Supervisor 1% de 89%

ABSOLUTO:
  └─ Valor fixo em reais
  └─ Exemplo: R$ 50,00 fixo
```

---

## 🏗️ Arquitetura Técnica

### Backend Updates

#### 1. Schema Prisma Atualizado
**Arquivo:** `backend/prisma/schema.prisma`

```prisma
model ConfiguracaoAcerto {
  id                    Int
  restID               Int
  funcao               String    // "Garçom", "Cozinha", "Supervisor", etc.
  base_calculo         String    // Tipo de distribuição
  valor_percentual     Decimal?  // Para percentuais (0-100)
  valor_absoluto       Decimal?  // Para valores fixos
  ordem_calculo        Int       // ⭐ NOVO: Ordem de processamento (1=primeiro)
  ativo                Boolean
  
  // NOVO base_calculo values:
  // - "GORJETA_TOTAL"
  // - "GORJETA_REMAINING" ⭐ Cozinha usa isso
  // - "FATURAMENTO_BASE"
  // - "FATURAMENTO_EXTRA" ⭐ Supervisor/Gestor usa isso
  // - "ABSOLUTO"
}
```

**Migration:** `20260123213005_add_advanced_distribuicao_config`

#### 2. Lógica de Cálculo Atualizada
**Arquivo:** `backend/src/acerto-periodo/acerto-periodo.service.ts`

**Novo Algoritmo:**
```
1. Obter todas as configurações, ordenadas por ordem_calculo
2. Para cada configuração na ordem:
   a. Calcular valor baseado na base_calculo
   b. Se GORJETA_TOTAL ou GORJETA_REMAINING:
      - Deduzir do pool de gorjeta disponível
   c. Se FATURAMENTO_EXTRA:
      - Usar 89% do faturamento total
   d. Criar registro em ACERTO_FUNCIONARIO
3. Criar ACERTO_PERIODO com totalizações
```

**Exemplo de Execução:**
```
Período: 25/01/2026
Faturamento Total: R$ 5.000
Gorjeta Total: R$ 300

Passo 1: Garçom (ordem_calculo=1, GORJETA_TOTAL, 80%)
  ├─ Valor = R$ 300 × 80% = R$ 240
  └─ Gorjeta Restante: R$ 60

Passo 2: Chamador (ordem_calculo=2, GORJETA_TOTAL, 20%)
  ├─ Valor = R$ 300 × 20% = R$ 60
  └─ Gorjeta Restante: R$ 0

Passo 3: Cozinha (ordem_calculo=3, GORJETA_REMAINING, 100%)
  ├─ Valor = R$ 0 × 100% = R$ 0
  ├─ (Toda gorjeta foi distribuída)
  └─ OU com split diferente: Cozinha pega 60% antes de Chamador

Passo 4: Supervisor (ordem_calculo=4, FATURAMENTO_EXTRA, 1%)
  ├─ Faturamento Extra = R$ 5.000 × 89% = R$ 4.450
  ├─ Valor = R$ 4.450 × 1% = R$ 44,50
  └─ Gorjeta Restante: R$ 0
```

#### 3. DTOs Atualizados
**Arquivo:** `backend/src/configuracao-acerto/dto/index.ts`

```typescript
export class CreateConfiguracaoAcertoDto {
  funcao: string;
  base_calculo: string; // Novos: GORJETA_REMAINING, FATURAMENTO_EXTRA
  valor_percentual?: number;
  valor_absoluto?: number;
  ordem_calculo?: number; // ⭐ NOVO - default 999
}

export class ConfiguracaoAcertoResponseDto {
  // ... existing fields
  ordem_calculo: number;  // ⭐ NOVO
}
```

#### 4. Service Validations Atualizadas
**Arquivo:** `backend/src/configuracao-acerto/configuracao-acerto.service.ts`

```typescript
const basesValidas = [
  'GORJETA_TOTAL',
  'GORJETA_REMAINING',    // ⭐ NOVO
  'FATURAMENTO_BASE',
  'FATURAMENTO_EXTRA',    // ⭐ NOVO
  'ABSOLUTO'
];
```

---

## 📊 Exemplos de Configuração

### Restaurante A - Distribuição Tradicional

```
Configuração:
├─ Garçom
│  ├─ base_calculo: "GORJETA_TOTAL"
│  ├─ valor_percentual: 80
│  └─ ordem_calculo: 1
│
├─ Cozinha
│  ├─ base_calculo: "GORJETA_REMAINING"
│  ├─ valor_percentual: 100
│  └─ ordem_calculo: 2
│
├─ Chamador
│  ├─ base_calculo: "FATURAMENTO_BASE"
│  ├─ valor_percentual: 30
│  └─ ordem_calculo: 3
│
└─ Supervisor
   ├─ base_calculo: "FATURAMENTO_EXTRA"
   ├─ valor_percentual: 0.5
   └─ ordem_calculo: 4

Resultado para Faturamento R$ 5.000 + Gorjeta R$ 300:
├─ Garçom:     R$ 300 × 80% = R$ 240.00
├─ Cozinha:    (R$ 300 - R$ 240) × 100% = R$ 60.00
├─ Chamador:   (R$ 5.000 × 11%) × 30% = R$ 165.00
└─ Supervisor: (R$ 5.000 × 89%) × 0.5% = R$ 22.25
```

### Restaurante B - Distribuição Flexível (Exemplo Real)

```
Configuração:
├─ Garçom
│  ├─ base_calculo: "GORJETA_TOTAL"
│  ├─ valor_percentual: 60
│  └─ ordem_calculo: 1
│
├─ Cozinha
│  ├─ base_calculo: "GORJETA_REMAINING"
│  ├─ valor_percentual: 100
│  └─ ordem_calculo: 2
│
├─ Chamador
│  ├─ base_calculo: "ABSOLUTO"
│  ├─ valor_absoluto: 30
│  └─ ordem_calculo: 3
│
└─ Gestor
   ├─ base_calculo: "FATURAMENTO_EXTRA"
   ├─ valor_percentual: 1.0
   └─ ordem_calculo: 4

Resultado para Faturamento R$ 10.000 + Gorjeta R$ 600:
├─ Garçom:   R$ 600 × 60% = R$ 360.00
├─ Cozinha:  (R$ 600 - R$ 360) × 100% = R$ 240.00
├─ Chamador: R$ 30.00 (fixo)
└─ Gestor:   (R$ 10.000 × 89%) × 1% = R$ 89.00
```

---

## 📌 Fluxo de Processamento

### Ao Criar Acerto de Período:

```
1. Validar datas e restaurante
   ↓
2. Calcular TOTAIS DO PERÍODO:
   ├─ Somar todas transações = Faturamento Calculado
   ├─ Somar todas gorjetas = Gorjeta Total
   └─ Obter Faturamento Inserido (manual)
   ↓
3. Obter CONFIGURAÇÕES (ordenadas por ordem_calculo ASC)
   ↓
4. PROCESSAR EM ORDEM:
   ├─ Para cada configuração:
   │  ├─ Calcular valor
   │  ├─ Atualizar tracking de Gorjeta Restante
   │  └─ Criar ACERTO_FUNCIONARIO
   ├─ Rastrear: gorjetaRemainingTotal
   └─ Rastrear: deductedAmount por tipo
   ↓
5. CRIAR ACERTO_PERIODO com:
   ├─ Faturamento Total
   ├─ Gorjeta Total
   ├─ Lista de ACERTO_FUNCIONARIO
   └─ Status: pago = false
   ↓
6. Retornar resposta completa
```

---

## 🔧 Como Configurar Novo Restaurante

### 1. Criar Restaurante
```
POST /restaurantes
{
  "name": "Tasca Lisboa",
  "percentagem_gorjeta_base": 11.00
}
```

### 2. Configurar Distribuição
```
POST /configuracao-acerto?restID=1
{
  "funcao": "Garçom",
  "base_calculo": "GORJETA_TOTAL",
  "valor_percentual": 75,
  "ordem_calculo": 1
}

POST /configuracao-acerto?restID=1
{
  "funcao": "Cozinha",
  "base_calculo": "GORJETA_REMAINING",
  "valor_percentual": 100,
  "ordem_calculo": 2
}

POST /configuracao-acerto?restID=1
{
  "funcao": "Supervisor",
  "base_calculo": "FATURAMENTO_EXTRA",
  "valor_percentual": 0.5,
  "ordem_calculo": 3
}
```

### 3. Registrar Transações
```
POST /transacoes
{
  "restID": 1,
  "funcID_garcom": 123,
  "total": 150.00,
  "valor_gorjeta_calculada": 15.00,
  "data_transacao": "2026-01-25T14:30:00Z"
}
```

### 4. Criar Acerto
```
POST /acerto-periodo?restID=1
{
  "periodo_inicio": "2026-01-25",
  "periodo_fim": "2026-01-25",
  "tipo_periodo": "DIARIO"
}
```

---

## 📱 Frontend - Página de Configuração

**Arquivo:** `frontend/src/pages/configuracao/acerto.tsx`

Atualizada para:
- ✅ Suportar novo campo `ordem_calculo`
- ✅ 5 opções de `base_calculo` com descrições
- ✅ Campos dinâmicos (percentual vs absoluto)
- ✅ Preview de cálculo em tempo real
- ✅ Tabela com ordem de processamento

---

## 🧪 Testes

### Backend
- ✅ npm run build → Compiled successfully
- ✅ Prisma types gerados
- ✅ DTOs com novos campos
- ✅ Service validations atualizadas

### Frontend
- ✅ npm run build → Compiled successfully (9 pages)
- ✅ Sem pages de transacoes
- ✅ Financeiro Diário contém tudo

---

## 🎯 Vantagens do Novo Sistema

| Aspecto | Antes | Agora |
|---------|-------|-------|
| **Flexibilidade** | Fixo (3% para Cozinha) | 5 tipos + ordem customizável |
| **Cozinha** | 3% fixo | Recebe o REMAINING após outros |
| **Supervisor** | % de 11% apenas | % dos 89% (não-base) **Configurável** |
| **Fácil Ajuste** | Código | Admin panel com UI |
| **Ordem Processamento** | Fixa | Campo `ordem_calculo` |

---

## 📚 Documentação Técnica

### Arquivos Modificados

**Backend:**
- `backend/prisma/schema.prisma` - Novo campo `ordem_calculo`
- `backend/prisma/migrations/20260123213005_add_advanced_distribuicao_config/` - Nova migration
- `backend/src/acerto-periodo/acerto-periodo.service.ts` - Lógica de cálculo
- `backend/src/configuracao-acerto/configuracao-acerto.service.ts` - Validações
- `backend/src/configuracao-acerto/dto/index.ts` - DTOs atualizadas

**Frontend:**
- `frontend/src/pages/transacoes/nova.tsx` - **DELETADO**
- `frontend/src/pages/transacoes/index.tsx` - **DELETADO**

---

## ✅ Build Status

```
Backend:  ✅ Compiled successfully
Frontend: ✅ Compiled successfully (9 pages)
Database: ✅ Migration applied
Types:    ✅ Generated
```

---

**Sistema de Distribuição Avançado Implementado! 🚀**
