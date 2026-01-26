# ER Diagram - Restaurantes DB Schema

## Entity Relationship Diagram

```mermaid
erDiagram
    RESTAURANTE ||--o{ FUNCIONARIO : "contains"
    RESTAURANTE ||--o{ CONFIGURACAO_GORJETAS : "has"
    RESTAURANTE ||--o{ TRANSACAO : "records"
    FUNCIONARIO ||--o{ TRANSACAO : "assigned"
    FUNCIONARIO ||--o{ DISTRIBUICAO_GORJETAS : "receives"
    TRANSACAO ||--o{ DISTRIBUICAO_GORJETAS : "generates"
    RESTAURANTE ||--o{ LIMPEZA : "manages"
    LIMPEZA ||--o{ LIMPEZA_RECORD : "tracks"
    FUNCIONARIO ||--o{ LIMPEZA_RECORD : "uses"

    RESTAURANTE {
        int restID PK
        string name
        string endereco
        string contacto
        decimal percentagem_gorjeta_base
        boolean ativo
        timestamp createdAt
        timestamp updatedAt
    }

    FUNCIONARIO {
        int funcID PK
        string name
        string contacto
        string photo
        string funcao
        boolean ativo
        int restID FK
        timestamp createdAt
        timestamp updatedAt
    }

    CONFIGURACAO_GORJETAS {
        int configID PK
        int restID FK
        string funcao
        decimal percentagem
        boolean ativo
        timestamp createdAt
        timestamp updatedAt
    }

    TRANSACAO {
        int tranID PK
        string nome
        decimal total
        decimal valor_gorjeta_calculada
        decimal percentagem_aplicada
        decimal mbway
        int funcID_garcom FK
        int restID FK
        timestamp createdAt
        timestamp updatedAt
    }

    DISTRIBUICAO_GORJETAS {
        int distID PK
        int tranID FK
        int funcID FK
        string tipo_distribuicao
        decimal percentagem_aplicada
        decimal valor_calculado
        timestamp createdAt
        timestamp updatedAt
    }

    LIMPEZA {
        int prodID PK
        int restID FK
        string name
        decimal quantidade
        string unidade
        decimal preco_unitario
        boolean ativo
        timestamp createdAt
        timestamp updatedAt
    }

    LIMPEZA_RECORD {
        int recordID PK
        int prodID FK
        int funcID FK
        decimal quantidade_usada
        timestamp data
        timestamp createdAt
        timestamp updatedAt
    }
```

## Key Relationships

### Restaurant (1:N) → Employees
- One restaurant has many employees
- Soft delete via `ativo=false`

### Employee (N:1) → Restaurant
- Each employee belongs to one restaurant
- Scoped by `restID` for multi-tenant isolation

### Configuration (1:1) → (Restaurant, Function)
- One active config per (restID, funcao)
- Defines tip distribution %

### Transaction (1:N) → Distribution
- One transaction generates many distribution rows
- All distributions created atomically on transaction creation

### Distribution (N:1) → Employee & Transaction
- Links employee to transaction
- Stores calculated tip amount for that employee

## Data Constraints

- **Primary Keys:** All auto-incrementing integers
- **Foreign Keys:** Enforced with CASCADE delete where applicable
- **Unique Constraints:** (restID, funcao) on ConfiguracaoGorjetas and Funcionario
- **Decimal Precision:** 2 decimal places for all currency fields
- **Soft Delete:** `ativo` boolean flag (defaults to true)

## Multi-Tenant Isolation

All queries for a specific restaurant filter by `restID`:

```sql
SELECT * FROM transacoes WHERE restID = 1
SELECT * FROM funcionarios WHERE restID = 1 AND ativo = true
```

## Timestamps

All tables include:
- `createdAt` — Record creation time (immutable)
- `updatedAt` — Last update time (auto-managed by Prisma)

Enables audit trail and sorting for reports.
