# API Documentation - Phase 1 Endpoints

## Base URL
```
http://localhost:3001
```

---

## Funcionarios (Employees)

### List Employees
```bash
curl -X GET "http://localhost:3001/funcionarios?restID=1&ativo=true"
```

Response:
```json
[
  {
    "funcID": 1,
    "name": "João Silva",
    "contacto": "912345678",
    "funcao": "garcom",
    "ativo": true,
    "restID": 1,
    "createdAt": "2026-01-14T10:00:00Z",
    "updatedAt": "2026-01-14T10:00:00Z"
  }
]
```

### Create Employee
```bash
curl -X POST http://localhost:3001/funcionarios \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Pedro Costa",
    "contacto": "912345670",
    "funcao": "garcom",
    "restID": 1
  }'
```

### Update Employee
```bash
curl -X PUT http://localhost:3001/funcionarios/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva Updated",
    "contacto": "912345679"
  }'
```

### Delete Employee (Soft Delete)
```bash
curl -X DELETE http://localhost:3001/funcionarios/1
```

---

## Configuracao Gorjetas (Tip Configuration)

### List Configurations
```bash
curl -X GET "http://localhost:3001/configuracao-gorjetas?restID=1"
```

Response:
```json
[
  {
    "configID": 1,
    "restID": 1,
    "funcao": "garcom",
    "percentagem": "7.00",
    "ativo": true,
    "createdAt": "2026-01-14T10:00:00Z",
    "updatedAt": "2026-01-14T10:00:00Z"
  },
  {
    "configID": 2,
    "restID": 1,
    "funcao": "cozinha",
    "percentagem": "3.00",
    "ativo": true,
    "createdAt": "2026-01-14T10:00:00Z",
    "updatedAt": "2026-01-14T10:00:00Z"
  },
  {
    "configID": 3,
    "restID": 1,
    "funcao": "douglas",
    "percentagem": "1.00",
    "ativo": true,
    "createdAt": "2026-01-14T10:00:00Z",
    "updatedAt": "2026-01-14T10:00:00Z"
  }
]
```

### Create Configuration
```bash
curl -X POST http://localhost:3001/configuracao-gorjetas \
  -H "Content-Type: application/json" \
  -d '{
    "restID": 1,
    "funcao": "supervisor",
    "percentagem": 2.5
  }'
```

### Update Configuration
```bash
curl -X PUT http://localhost:3001/configuracao-gorjetas/1 \
  -H "Content-Type: application/json" \
  -d '{
    "percentagem": 7.5
  }'
```

---

## Transacoes (Transactions)

### Create Transaction (Most Important)
The core operation that creates transaction + distributions atomically.

```bash
curl -X POST http://localhost:3001/transacoes \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Mesa 5",
    "total": 150.00,
    "funcID_garcom": 1,
    "mbway": 10.00,
    "restID": 1
  }'
```

Response:
```json
{
  "tranID": 1,
  "nome": "Mesa 5",
  "total": "150.00",
  "valor_gorjeta_calculada": "16.50",
  "percentagem_aplicada": "11.00",
  "mbway": "10.00",
  "funcID_garcom": 1,
  "restID": 1,
  "createdAt": "2026-01-14T10:30:00Z",
  "updatedAt": "2026-01-14T10:30:00Z",
  "garcom": {
    "funcID": 1,
    "name": "João Silva",
    "contacto": "912345678",
    "funcao": "garcom",
    "ativo": true,
    "restID": 1
  },
  "distribuicoes": [
    {
      "distID": 1,
      "tranID": 1,
      "funcID": 1,
      "tipo_distribuicao": "garcom",
      "percentagem_aplicada": "7.00",
      "valor_calculado": "10.50",
      "createdAt": "2026-01-14T10:30:00Z",
      "updatedAt": "2026-01-14T10:30:00Z",
      "funcionario": {
        "funcID": 1,
        "name": "João Silva"
      }
    },
    {
      "distID": 2,
      "tranID": 1,
      "funcID": 3,
      "tipo_distribuicao": "cozinha",
      "percentagem_aplicada": "3.00",
      "valor_calculado": "4.50",
      "createdAt": "2026-01-14T10:30:00Z",
      "updatedAt": "2026-01-14T10:30:00Z",
      "funcionario": {
        "funcID": 3,
        "name": "Chef Nunes"
      }
    },
    {
      "distID": 3,
      "tranID": 1,
      "funcID": 4,
      "tipo_distribuicao": "douglas",
      "percentagem_aplicada": "1.00",
      "valor_calculado": "1.50",
      "createdAt": "2026-01-14T10:30:00Z",
      "updatedAt": "2026-01-14T10:30:00Z",
      "funcionario": {
        "funcID": 4,
        "name": "Douglas Silva"
      }
    }
  ]
}
```

**Calculation details:**
- Total: €150.00
- Base tip: 11% → €16.50
- Distributed:
  - Garcom (7%): €10.50
  - Cozinha (3%): €4.50
  - Douglas (1%): €1.50
- Total distributed = €16.50 ✓

### List Transactions
```bash
curl -X GET "http://localhost:3001/transacoes?restID=1&from=2026-01-01&to=2026-01-31"
```

### Get Single Transaction
```bash
curl -X GET "http://localhost:3001/transacoes/1"
```

---

## Distribuicao Gorjetas (Distribution Records)

### Get Distributions by Transaction
```bash
curl -X GET "http://localhost:3001/distribuicao-gorjetas/transacao/1"
```

### Get Distributions by Employee
```bash
curl -X GET "http://localhost:3001/distribuicao-gorjetas/funcionario/1?from=2026-01-01&to=2026-01-31&restID=1"
```

---

## Relatorios (Reports)

### Report by Employee
```bash
curl -X GET "http://localhost:3001/relatorios/funcionarios?restID=1&from=2026-01-01&to=2026-01-31"
```

Response:
```json
[
  {
    "funcID": 1,
    "name": "João Silva",
    "total_gorjeta": 25.50,
    "breakdown": {
      "garcom": 25.50
    },
    "count_transacoes": 3,
    "total_mbway": 10.00
  },
  {
    "funcID": 3,
    "name": "Chef Nunes",
    "total_gorjeta": 10.50,
    "breakdown": {
      "cozinha": 10.50
    },
    "count_transacoes": 3,
    "total_mbway": 0.00
  }
]
```

### Summary Report
```bash
curl -X GET "http://localhost:3001/relatorios/resumo?restID=1&from=2026-01-01&to=2026-01-31"
```

Response:
```json
{
  "total_gorjeta": 49.50,
  "count_transacoes": 3,
  "breakdown_by_type": {
    "garcom": 31.50,
    "cozinha": 13.50,
    "douglas": 4.50
  }
}
```

### Reverse Billing (Faturamento)
Calculate original bill from tip total.

```bash
curl -X GET "http://localhost:3001/relatorios/faturamento?restID=1&from=2026-01-01&to=2026-01-31"
```

Response:
```json
{
  "base_percentage": "11.00",
  "total_gorjeta": 49.50,
  "total_faturamento": 450.00,
  "count_transacoes": 3
}
```

**Calculation:**
- Total tips: €49.50
- Base %: 11%
- Faturamento = €49.50 × 100 / 11 = €450.00

---

## Error Responses

### Validation Error (400)
```json
{
  "statusCode": 400,
  "message": "Missing active employee(s) for function(s): douglas",
  "error": "Bad Request"
}
```

### Configuration Conflict (400)
```json
{
  "statusCode": 400,
  "message": "Active configuration already exists for function garcom in restaurant 1",
  "error": "Bad Request"
}
```

### Not Found (404)
```json
{
  "statusCode": 404,
  "message": "Cannot GET /funcionarios/999",
  "error": "Not Found"
}
```

---

## Testing Workflow

### 1. Create Employees (if not seeded)
```bash
# Create first garçom
curl -X POST http://localhost:3001/funcionarios \
  -H "Content-Type: application/json" \
  -d '{"name":"Ana","contacto":"911111111","funcao":"garcom","restID":1}'

# Create second garçom
curl -X POST http://localhost:3001/funcionarios \
  -H "Content-Type: application/json" \
  -d '{"name":"Bruno","contacto":"922222222","funcao":"garcom","restID":1}'

# Create cozinha
curl -X POST http://localhost:3001/funcionarios \
  -H "Content-Type: application/json" \
  -d '{"name":"Carlos","contacto":"933333333","funcao":"cozinha","restID":1}'

# Create douglas
curl -X POST http://localhost:3001/funcionarios \
  -H "Content-Type: application/json" \
  -d '{"name":"Diana","contacto":"944444444","funcao":"douglas","restID":1}'
```

### 2. Verify Configurations
```bash
curl -X GET "http://localhost:3001/configuracao-gorjetas?restID=1"
```

### 3. Create Sample Transactions
```bash
# Transaction 1
curl -X POST http://localhost:3001/transacoes \
  -H "Content-Type: application/json" \
  -d '{"nome":"Mesa 1","total":100,"funcID_garcom":1,"mbway":0,"restID":1}'

# Transaction 2
curl -X POST http://localhost:3001/transacoes \
  -H "Content-Type: application/json" \
  -d '{"nome":"Mesa 2","total":200,"funcID_garcom":2,"mbway":20,"restID":1}'

# Transaction 3
curl -X POST http://localhost:3001/transacoes \
  -H "Content-Type: application/json" \
  -d '{"nome":"Mesa 3","total":150,"funcID_garcom":1,"mbway":15,"restID":1}'
```

### 4. View Reports
```bash
# By employee
curl -X GET "http://localhost:3001/relatorios/funcionarios?restID=1"

# Summary
curl -X GET "http://localhost:3001/relatorios/resumo?restID=1"

# Faturamento
curl -X GET "http://localhost:3001/relatorios/faturamento?restID=1"
```

---

## HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200  | OK - Success |
| 201  | Created - Resource created |
| 400  | Bad Request - Validation or business logic error |
| 404  | Not Found - Resource doesn't exist |
| 500  | Internal Server Error |

---

## Data Types

- **Decimal/Money:** Use string format (e.g., "11.50") or number
- **Dates:** ISO 8601 format (2026-01-14T10:30:00Z)
- **Booleans:** true/false
- **IDs:** Positive integers

---

**Last Updated:** January 2026 | Phase 1 MVP
