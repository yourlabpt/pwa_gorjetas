# Testing Guide - Phase 1 MVP

## Setup Verification

Before testing the application, verify all components are properly initialized.

### 1. Project Structure ✓

Verify all files exist:

```bash
# Backend files
backend/package.json
backend/tsconfig.json
backend/prisma/schema.prisma
backend/src/main.ts
backend/src/app.module.ts

# Frontend files
frontend/package.json
frontend/tsconfig.json
frontend/next.config.js
frontend/src/pages/index.tsx

# Documentation
docs/er-diagram.md
docs/flow-diagram.md
docs/api-documentation.md

# Docker
docker-compose.yml
```

### 2. Dependencies Installation

```bash
# Backend
cd backend
npm install
npm list | grep -E "@nestjs|prisma|class-validator|decimal"

# Frontend
cd frontend
npm install
npm list | grep -E "next|react|axios"
```

---

## Database Testing

### 1. PostgreSQL Connection

```bash
# Start container
docker-compose up -d

# Check status
docker ps | grep pwa_restaurantes_db
# Should output: pwa_restaurantes_db  postgres:16-alpine

# Test connection
docker exec pwa_restaurantes_db psql -U restaurantes_user -d restaurantes_db -c "SELECT version();"
# Should show PostgreSQL version
```

### 2. Prisma Setup

```bash
cd backend

# Run migrations
npx prisma migrate dev --name init

# Expected output:
# ✓ Prisma schema loaded from prisma/schema.prisma
# ✓ Datasource "db": PostgreSQL database
# ✓ 6 migrations found
# ✓ Migration 0_init applied

# Check database
npx prisma db execute --stdin < /dev/null
# Should succeed

# View database in Prisma Studio
npx prisma studio
# Opens http://localhost:5555
```

### 3. Seed Data

```bash
cd backend

# Run seed
npx prisma db seed

# Expected output:
# ✓ Created restaurant: Restaurante Test
# ✓ Created 4 employees
# ✓ Created 3 tip configurations

# Verify in studio
npx prisma studio
# Should show:
# - 1 restaurant
# - 4 employees
# - 3 configurations
```

### 4. Data Validation

```bash
cd backend

# Connect to database
npx prisma db execute --stdin

# Run queries
SELECT COUNT(*) as restaurantes FROM restaurantes;
# Should return: 1

SELECT COUNT(*) as funcionarios FROM funcionarios WHERE ativo = true;
# Should return: 4

SELECT COUNT(*) as configs FROM configuracao_gorjetas WHERE ativo = true;
# Should return: 3

# Check employee functions
SELECT funcao, COUNT(*) as count FROM funcionarios WHERE ativo = true GROUP BY funcao;
# Should return:
# garcom | 2
# cozinha | 1
# douglas | 1
```

---

## Backend API Testing

### 1. Start Backend Server

```bash
cd backend
npm run start:dev

# Expected output:
# [Nest] 12345 - 01/14/2026, 10:30:00 AM     LOG [NestFactory] Starting Nest application...
# ✅ Server running on http://localhost:3001
```

### 2. Health Check

```bash
curl http://localhost:3001

# Should return 404 (no route) or routing message
# (If error, backend didn't start properly)
```

### 3. Funcionarios Endpoints

#### List Employees
```bash
curl -X GET "http://localhost:3001/funcionarios?restID=1&ativo=true"

# Response should contain:
# - 4 employees
# - Fields: funcID, name, contacto, funcao, ativo, restID
# - All should have ativo=true
```

#### Create Employee
```bash
curl -X POST http://localhost:3001/funcionarios \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Employee",
    "contacto": "999999999",
    "funcao": "supervisor",
    "restID": 1
  }'

# Should return 201 with created employee
# New funcID should be > 4
```

#### Update Employee
```bash
curl -X PUT http://localhost:3001/funcionarios/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva Updated"
  }'

# Should return 200 with updated record
```

#### Delete Employee (Soft Delete)
```bash
curl -X DELETE http://localhost:3001/funcionarios/5

# Should return 200
# Verify: GET /funcionarios?restID=1&ativo=true
# Should no longer show employee 5
```

### 4. Configuracao Gorjetas Endpoints

#### List Configurations
```bash
curl -X GET "http://localhost:3001/configuracao-gorjetas?restID=1"

# Should return:
# - 3 configurations
# - garcom: 7.00
# - cozinha: 3.00
# - douglas: 1.00
```

#### Update Configuration
```bash
curl -X PUT http://localhost:3001/configuracao-gorjetas/1 \
  -H "Content-Type: application/json" \
  -d '{
    "percentagem": 8.0
  }'

# Should return 200
# Verify: GET should show 8.00
```

### 5. Transacoes Endpoints (Core Logic)

#### Create Transaction
```bash
curl -X POST http://localhost:3001/transacoes \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Mesa 5",
    "total": 100.00,
    "funcID_garcom": 1,
    "mbway": 0,
    "restID": 1
  }'

# Verify response:
# {
#   "tranID": 1,
#   "nome": "Mesa 5",
#   "total": "100.00",
#   "valor_gorjeta_calculada": "11.00",  # 100 * 11%
#   "percentagem_aplicada": "11.00",
#   "distribuicoes": [
#     { "tipo_distribuicao": "garcom", "valor_calculado": "7.00" },
#     { "tipo_distribuicao": "cozinha", "valor_calculado": "3.00" },
#     { "tipo_distribuicao": "douglas", "valor_calculado": "1.00" }
#   ]
# }
```

**Math Verification:**
- Total tip: 100 × 11% = 11.00 ✓
- Garcom: 11.00 × 7/11 = 7.00 ✓
- Cozinha: 11.00 × 3/11 = 3.00 ✓
- Douglas: 11.00 × 1/11 = 1.00 ✓

#### List Transactions
```bash
curl -X GET "http://localhost:3001/transacoes?restID=1"

# Should return transactions with distributions nested
```

#### Get Single Transaction
```bash
curl -X GET "http://localhost:3001/transacoes/1"

# Should return transaction with full distribution array
```

### 6. Distribuicao Gorjetas Endpoints

#### Get by Transaction
```bash
curl -X GET "http://localhost:3001/distribuicao-gorjetas/transacao/1"

# Should return 3 distribution records
```

#### Get by Employee
```bash
curl -X GET "http://localhost:3001/distribuicao-gorjetas/funcionario/1"

# Should return distributions for garcom/supervisor
```

### 7. Relatorios Endpoints

#### Funcionarios Report
```bash
curl -X GET "http://localhost:3001/relatorios/funcionarios?restID=1"

# Should return array with employee summaries:
# [
#   {
#     "funcID": 1,
#     "name": "João Silva",
#     "total_gorjeta": 7.00,
#     "breakdown": { "garcom": 7.00 },
#     "count_transacoes": 1,
#     "total_mbway": 0
#   },
#   ...
# ]
```

#### Resumo Report
```bash
curl -X GET "http://localhost:3001/relatorios/resumo?restID=1"

# Should return summary:
# {
#   "total_gorjeta": 11.00,
#   "count_transacoes": 1,
#   "breakdown_by_type": {
#     "garcom": 7.00,
#     "cozinha": 3.00,
#     "douglas": 1.00
#   }
# }
```

#### Faturamento Report
```bash
curl -X GET "http://localhost:3001/relatorios/faturamento?restID=1"

# Should return:
# {
#   "base_percentage": 11.00,
#   "total_gorjeta": 11.00,
#   "total_faturamento": 100.00,  # 11 / (11/100)
#   "count_transacoes": 1
# }
```

### 8. Error Handling

#### Missing Employee Function
```bash
# First, delete the douglas employee
curl -X DELETE http://localhost:3001/funcionarios/4

# Try to create transaction
curl -X POST http://localhost:3001/transacoes \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Mesa 5",
    "total": 100.00,
    "funcID_garcom": 1,
    "restID": 1
  }'

# Should return 400:
# {
#   "statusCode": 400,
#   "message": "Missing active employee(s) for function(s): douglas",
#   "error": "Bad Request"
# }
```

#### Invalid Garcom
```bash
curl -X POST http://localhost:3001/transacoes \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Mesa 5",
    "total": 100.00,
    "funcID_garcom": 999,
    "restID": 1
  }'

# Should return 400 with "Waiter not found" message
```

---

## Frontend Testing

### 1. Start Frontend

```bash
cd frontend
npm run dev

# Expected output:
# ▲ Next.js 14.0.0
# - Local:        http://localhost:3000
# - Environments: .env.local
#
# Ready in 2.5s
```

### 2. Home Page

Visit: http://localhost:3000

**Verify:**
- [ ] Navigation shows all 6 links
- [ ] 3 cards visible (Funcionários, Configurações, Transações)
- [ ] Links are clickable
- [ ] No console errors

### 3. Funcionarios Page

Click "Funcionários" or visit http://localhost:3000/funcionarios

**Verify:**
- [ ] Table shows 4 employees
- [ ] Columns: Nome, Função, Contacto, Ações
- [ ] "+ Novo Funcionário" button visible
- [ ] Edit and Delete buttons work

**Test Create:**
- [ ] Click "+ Novo Funcionário"
- [ ] Form appears with 3 fields
- [ ] Fill: name="Test", contacto="999", funcao="supervisor"
- [ ] Click "Criar"
- [ ] Table updates with new employee

**Test Edit:**
- [ ] Click "Editar" on any employee
- [ ] Form pre-fills
- [ ] Update name
- [ ] Click "Atualizar"
- [ ] Table updates

**Test Delete:**
- [ ] Click "Deletar" on test employee
- [ ] Confirm dialog
- [ ] Employee removed from table

### 4. Configuracao Page

Visit http://localhost:3000/configuracao-gorjetas

**Verify:**
- [ ] Table shows 3 configurations
- [ ] Columns: Função, Percentagem, Status, Ações
- [ ] Percentages: garcom=7%, cozinha=3%, douglas=1%
- [ ] Status shows "✓ Ativo"

**Test Edit:**
- [ ] Click "Editar" on garcom
- [ ] Input changes to editable field
- [ ] Change to 7.5
- [ ] Click "Salvar"
- [ ] Table updates to 7.5%
- [ ] Click "Editar" again to verify

### 5. Nova Transação Page

Visit http://localhost:3000/transacoes/nova

**Verify:**
- [ ] Form shows 4 fields
- [ ] Garcom dropdown populated with 2 employees
- [ ] Form layout is 2-column

**Test Create Transaction:**
- [ ] Fill: nome="Mesa 10", total=150.00
- [ ] Select garcom (e.g., João Silva)
- [ ] Fill mbway=10.00
- [ ] Click "Criar Transação"
- [ ] Preview card appears on right
- [ ] Shows:
  - Total: €150.00
  - Gorjeta (11%): €16.50
  - Distribution table with 3 rows

**Verify Math:**
- Total tip = 150 × 11% = 16.50 ✓
- Garcom: 10.50
- Cozinha: 4.50
- Douglas: 1.50

### 6. Transacoes Page

Visit http://localhost:3000/transacoes

**Verify:**
- [ ] Table shows transactions
- [ ] Columns: Mesa/Conta, Garçom, Total, Gorjeta, Data, Ação
- [ ] Multiple transactions visible

**Test Filter:**
- [ ] Select date range
- [ ] Click "Filtrar"
- [ ] Table updates
- [ ] Click "Limpar"
- [ ] Shows all transactions again

**Test Details Modal:**
- [ ] Click "Detalhes" button
- [ ] Modal opens
- [ ] Shows transaction summary
- [ ] Shows distribution table with 3 rows
- [ ] Click X to close

### 7. Relatorios Page

Visit http://localhost:3000/relatorios

**Verify:**
- [ ] Page loads (may show no data initially)
- [ ] 3 cards: Total Gorjetas, Nº Transações, Gorjeta Média
- [ ] Shows "Distribuição por Tipo" table
- [ ] Shows "Análise de Faturamento"
- [ ] Shows "Relatório por Funcionário"

**Test Filter:**
- [ ] Set date range
- [ ] Click "Filtrar"
- [ ] All sections update with filtered data

**Verify Data:**
- [ ] Totals sum correctly
- [ ] Faturamento calculation correct

### 8. Navigation

**Verify all links work:**
- [ ] Início → Home
- [ ] Funcionários → Employees
- [ ] Configuração → Config
- [ ] Nova Transação → Create transaction
- [ ] Transações → List
- [ ] Relatórios → Reports

---

## Integration Testing

### Full Workflow

1. **Start Services**
   ```bash
   # Terminal 1
   docker-compose up -d
   cd backend && npm run start:dev

   # Terminal 2
   cd frontend && npm run dev
   ```

2. **Create Employee**
   - UI: Funcionários → + Novo → Create
   - Verify in GET /funcionarios

3. **Configure Tip**
   - Ensure configs exist via GET /configuracao-gorjetas

4. **Create Transaction**
   - UI: Nova Transação → Fill form → Create
   - API: Verify POST /transacoes returns transaction + 3 distributions
   - DB: Verify 4 rows created (1 transacao + 3 distribuicao)

5. **View Transaction**
   - UI: Transações → See in table
   - Click details → See distribution breakdown

6. **View Reports**
   - UI: Relatórios → See all 3 report sections
   - Verify totals match transaction data

---

## Performance Testing

### Load Test: Create Multiple Transactions

```bash
# Create 100 transactions
for i in {1..100}; do
  curl -X POST http://localhost:3001/transacoes \
    -H "Content-Type: application/json" \
    -d "{
      \"nome\": \"Mesa $i\",
      \"total\": $((50 + RANDOM % 200)),
      \"funcID_garcom\": $((1 + RANDOM % 2)),
      \"mbway\": 0,
      \"restID\": 1
    }"
done

# Check performance
time curl -X GET "http://localhost:3001/relatorios/funcionarios?restID=1"
```

---

## Cleanup & Reset

### Reset Everything

```bash
# Stop all services
docker-compose down

# Remove data
docker-compose down -v

# Restart
docker-compose up -d
cd backend && npx prisma migrate reset
npx prisma db seed
```

---

## Success Criteria

All of the following must pass:

- ✅ Docker starts and Postgres runs
- ✅ Migrations apply without errors
- ✅ Seed creates 4 employees + 3 configs
- ✅ All 5 funcionarios endpoints return correct data
- ✅ POST /transacoes creates atomic transaction + distributions
- ✅ Math is correct (tip calc, distribution breakdown)
- ✅ All 3 report endpoints return correct aggregations
- ✅ Frontend loads all 6 pages without errors
- ✅ Can create, edit, delete employees from UI
- ✅ Can view transactions with distribution details
- ✅ Reports show correct totals and breakdowns
- ✅ All date filters work correctly
- ✅ No API errors in browser console

---

**If all tests pass, Phase 1 MVP is complete! 🎉**
