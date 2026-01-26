# Gorjeta Distribution Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐   │
│  │   Restaurantes   │  │  Configuração    │  │ Nova Transação│   │
│  │    (Setup)       │  │   (Management)   │  │  (Register)  │   │
│  └──────────┬───────┘  └────────┬─────────┘  └──────┬───────┘   │
│             │                   │                    │            │
│             └───────────┬───────┴────────────────────┘            │
│                         │                                          │
└─────────────────────────┼──────────────────────────────────────────┘
                          │ API Calls
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND SERVICES                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         ConfiguracaoGorjetasService                       │   │
│  │  • Create function configuration                          │   │
│  │  • Update percentages                                     │   │
│  │  • Delete functions                                       │   │
│  │  • List configurations per restaurant                     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │          TipCalculatorService                             │   │
│  │  • Fetch configured functions                             │   │
│  │  • Calculate tip distribution                             │   │
│  │  • Validate employees exist                               │   │
│  │  • Generate distribution records                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         TransacoesService                                 │   │
│  │  • Create transaction                                     │   │
│  │  • Store distribution splits                              │   │
│  │  • Query transactions                                     │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │      RestaurantesService                                  │   │
│  │  • Create restaurant with default configs                 │   │
│  │  • Update restaurant                                      │   │
│  │  • List restaurants                                       │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                          │
                          │ Database Queries
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                   DATABASE (PostgreSQL)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─ RESTAURANTES (restID, name, percentagem_gorjeta_base)      │
│  │  • Stores restaurant master data                            │
│  │  • Base percentage for tip calculation                       │
│  │                                                               │
│  ├─ CONFIGURACAO_GORJETAS (configID, restID, funcao, %)       │
│  │  • Dynamic function configurations per restaurant            │
│  │  • One config per (restaurant, function)                     │
│  │  • Stores percentage for each function                       │
│  │                                                               │
│  ├─ FUNCIONARIOS (funcID, name, funcao, restID)                │
│  │  • Employees linked to restaurants                           │
│  │  • Role determines which configuration applies               │
│  │                                                               │
│  ├─ TRANSACOES (tranID, total, valor_gorjeta_calculada, restID)│
│  │  • Transaction records with calculated tip                   │
│  │  • Stores base percentage used                               │
│  │                                                               │
│  └─ DISTRIBUICAO_GORJETAS (distID, tranID, funcID, %)         │
│     • Distribution splits created per transaction               │
│     • One record per configured function                        │
│     • Stores percentage and calculated value                    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. Restaurant Creation Flow
```
User Input (Restaurant Data)
    ↓
RestaurantesController.create()
    ↓
RestaurantesService.create()
    ├─ Create restaurant record
    └─ Create default configurations (garcom 7%, cozinha 3%, douglas 1%)
    ↓
Database Transaction (Atomic)
    ├─ INSERT INTO restaurantes
    └─ INSERT INTO configuracao_gorjetas (x3)
    ↓
Frontend Configuration Wizard
    ├─ Show configured functions
    ├─ Allow add/edit/delete
    └─ Save any modifications
```

### 2. Transaction Registration Flow
```
User Selects Restaurant
    ↓
Frontend Fetches Configurations
    ├─ GET /configuracao-gorjetas?restID=123
    └─ Display pre-filled form
    ↓
User Enters Transaction Data
    ├─ tip value (€11.00)
    ├─ transaction date
    ├─ waiter
    └─ optionally override percentages
    ↓
TransacoesController.create(CreateTransacaoDto)
    ↓
TransacoesService.create()
    ├─ Validate waiter exists
    └─ Call TipCalculatorService
    ↓
TipCalculatorService.calculateAndGenerateDistributions()
    ├─ Fetch restaurant base percentage
    ├─ Fetch all active configurations
    ├─ Calculate total tip = bill × base%
    ├─ For each configuration:
    │  ├─ Find employee for function
    │  ├─ Calculate: value = total_tip × (func_% / base%)
    │  └─ Create distribution payload
    └─ Return all distributions
    ↓
Atomic Transaction
    ├─ CREATE transacao record
    └─ CREATE distribuicao_gorjetas records (one per function)
    ↓
Return Transaction with Distributions
    ↓
Frontend Shows Preview with Breakdown
```

### 3. Configuration Management Flow
```
User Navigates to Configuration Page
    ↓
Frontend Fetches All Configurations
    ├─ GET /configuracao-gorjetas?restID=1
    └─ Display in table
    ↓
User Actions:
    
    ADD FUNCTION:
    ├─ POST /configuracao-gorjetas
    └─ {restID, funcao, percentagem}
    
    EDIT PERCENTAGE:
    ├─ PUT /configuracao-gorjetas/:id
    └─ {percentagem: 7.5}
    
    DELETE FUNCTION:
    ├─ DELETE /configuracao-gorjetas/:id
    └─ Remove configuration
    ↓
Update Reflected in Form
    └─ Next transaction uses new values
```

## Key Components

### ConfiguracaoGorjetas Table
Stores the dynamic configuration for each function per restaurant.

```
configID (PK)    | restID (FK) | funcao       | percentagem | ativo
─────────────────┼─────────────┼──────────────┼─────────────┼──────
1                | 1           | garcom       | 7.00        | true
2                | 1           | cozinha      | 3.00        | true
3                | 1           | douglas      | 1.00        | true
```

### TipCalculatorService
Core business logic that:
1. Fetches configured functions from ConfiguracaoGorjetas
2. Calculates distribution for each function
3. Validates that employees exist for all functions
4. Returns structured distribution payloads

**Calculation Formula:**
```
total_tip = table_total × (base_percentage / 100)

For each function:
  amount = total_tip × (function_percentage / base_percentage)
```

### Distribution Records
Created atomically per transaction, storing what each employee receives.

```
distID | tranID | funcID | tipo_distribuicao | percentagem_aplicada | valor_calculado
───────┼────────┼────────┼──────────────────┼─────────────────────┼─────────────────
1      | 1      | 1      | garcom           | 7.00                | 7.00
2      | 1      | 3      | cozinha          | 3.00                | 3.00
3      | 1      | 4      | douglas          | 1.00                | 1.00
```

## API Endpoints

### Configurations
```
GET    /configuracao-gorjetas?restID=1         # List all configurations
POST   /configuracao-gorjetas                   # Create new configuration
PUT    /configuracao-gorjetas/:id               # Update configuration
DELETE /configuracao-gorjetas/:id               # Delete configuration
```

### Transactions
```
POST   /transacoes                              # Create transaction (uses configs)
GET    /transacoes?restID=1&funcID=2            # Query transactions
GET    /transacoes/:id                          # Get single transaction
```

### Distributions
```
GET    /distribuicao-gorjetas/transacao/:id     # Get distributions for transaction
GET    /distribuicao-gorjetas/funcionario/:id   # Get distributions for employee
```

## Validation Rules

### Configuration
- ✅ One configuration per (restaurant, function) combination
- ✅ Percentages must be decimal values (> 0)
- ✅ Total should sum to base percentage (typically 11%)

### Transaction
- ✅ All configured functions must have active employees
- ✅ Employee function must match configuration function name exactly
- ✅ Restaurant must exist and be active

### Distribution
- ✅ One distribution record per configured function
- ✅ Values calculated from formula, not user input
- ✅ Stored as audit trail

## Error Handling

### Missing Configuration
```
Error: "No tip configurations found for restaurant 1"
Solution: Add functions via Configuração page
```

### Missing Employee
```
Error: "Missing active employee(s) for function(s): cozinha"
Solution: Create employee with "cozinha" role
```

### Invalid Configuration
```
Error: "Active configuration already exists for function garcom in restaurant 1"
Solution: Modify existing or delete and recreate
```

## Performance Considerations

1. **Configuration Caching:** Frontend caches configurations per restaurant
2. **Database Indexing:** Unique index on (restID, funcao) for fast lookups
3. **Atomic Operations:** All transaction + distribution creates are atomic
4. **Efficient Queries:** Minimal database calls per transaction creation

## Security Considerations

1. **Restaurant Isolation:** Each restaurant's configurations are separate
2. **Soft Deletes:** Configurations have `ativo` flag instead of hard delete
3. **Audit Trail:** All distributions stored for verification
4. **Validation:** Server-side validation of all inputs and calculations

## Future Extensibility

The system is designed to support:
- Multiple restaurants with different configurations ✓
- Dynamic function addition/removal ✓
- Override per-transaction ✓
- Historical configuration tracking (add timestamp versioning)
- Percentage templates for quick setup
- Advanced reporting by role and period
