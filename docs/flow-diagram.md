# Flow Diagram - Gorjetas Management System

## Application Flow

```mermaid
graph TD
    A[User Opens App] --> B{Navigation}
    
    B -->|Funcionários| C[List/Create/Edit Employees]
    B -->|Configuração| D[Edit Tip Percentages]
    B -->|Nova Transação| E[Register New Bill]
    B -->|Transações| F[View Transactions]
    B -->|Relatórios| G[View Reports]
    
    C --> C1["POST /funcionarios<br/>GET /funcionarios<br/>PUT /funcionarios/:id<br/>DELETE /funcionarios/:id"]
    
    D --> D1["GET /configuracao-gorjetas<br/>PUT /configuracao-gorjetas/:id"]
    
    E --> E1["Fill Form:<br/>- Mesa/Conta<br/>- Total<br/>- Garçom<br/>- MB WAY"]
    E1 --> E2["POST /transacoes"]
    E2 --> E3["Backend: Calculate Tip<br/>Validate Configs<br/>Generate Distributions"]
    E3 --> E4["Atomic DB Transaction:<br/>1. Create Transacao<br/>2. Create DistribuicaoGorjetas rows"]
    E4 --> E5["Return Transaction<br/>+ Distributions"]
    E5 --> E6["Show Distribution<br/>Breakdown to User"]
    
    F --> F1["Fetch Transactions<br/>Optional: Filter by date"]
    F1 --> F2["GET /transacoes?restID=1&from=&to="]
    F2 --> F3["Display Table<br/>with Summary"]
    F3 --> F4["Click Detail → Modal<br/>Shows Distribution"]
    
    G --> G1["Select Date Range"]
    G1 --> G2["Load 3 Reports:<br/>1. By Employee<br/>2. Summary<br/>3. Faturamento"]
    G2 --> G3["GET /relatorios/funcionarios<br/>GET /relatorios/resumo<br/>GET /relatorios/faturamento"]
    G3 --> G4["Display:<br/>- Totals by Employee<br/>- Breakdown by Type<br/>- Reverse Billing"]
```

## Transaction Creation Flow (Details)

```mermaid
graph TD
    A["User submits form:<br/>nome, total, funcID_garcom, mbway"] -->B["Client: apiClient.createTransacao()"]
    B --> C["Server: POST /transacoes"]
    C --> D["TipCalculatorService.calculateAndGenerateDistributions()"]
    D --> D1["Fetch Restaurant<br/>Get base_percentage"]
    D1 --> D2["Calculate total_tip =<br/>total * base_percent / 100"]
    D2 --> D3["Fetch active Configs<br/>for all functions"]
    D3 --> D4["Validate Config exists<br/>for each function"]
    D4 --> D4A{"All configs<br/>exist?"}
    D4A -->|No| D5["Return 400:<br/>Missing configs"]
    D4A -->|Yes| D6["For each config:<br/>Fetch active employee<br/>by function"]
    D6 --> D7{"All employees<br/>exist?"}
    D7 -->|No| D8["Return 400:<br/>Missing employees"]
    D7 -->|Yes| D9["Generate distribution<br/>payloads:<br/>- Calculate amount for each"]
    D9 --> D10["Return distributions array"]
    D10 --> E["Prisma $transaction:"]
    E --> E1["1. Create Transacao record"]
    E1 --> E2["2. Create DistribuicaoGorjetas rows<br/>one per distribution"]
    E2 --> E3{"Atomic?"}
    E3 -->|Error| E4["Rollback all"]
    E3 -->|Success| E5["Commit"]
    E5 --> F["Return Transaction<br/>+ Distributions<br/>to Client"]
    F --> G["Show preview<br/>with breakdown"]
```

## Report Generation Flow

```mermaid
graph TD
    A["User requests Report<br/>Optional: date filter"] --> B["Frontend: Select filters"]
    B --> C["Call 3 API endpoints"]
    C --> C1["GET /relatorios/funcionarios"]
    C --> C2["GET /relatorios/resumo"]
    C --> C3["GET /relatorios/faturamento"]
    
    C1 --> D1["Backend: Query Distribuicoes<br/>Group by funcID"]
    D1 --> D1A["For each employee:<br/>- Sum total_gorjeta<br/>- Group by tipo<br/>- Count transactions<br/>- Sum MB WAY"]
    D1A --> D1B["Return sorted array"]
    
    C2 --> D2["Backend: Query Distribuicoes<br/>Sum all values"]
    D2 --> D2A["Group by tipo_distribuicao<br/>Count unique transactions"]
    D2A --> D2B["Return summary object"]
    
    C3 --> D3["Backend: Query Transacoes<br/>Fetch restaurant base %"]
    D3 --> D3A["For each transaction:<br/>faturamento = gorjeta / (base% / 100)"]
    D3A --> D3B["Return faturamento calc"]
    
    C1 --> E["Frontend: Display all 3 reports"]
    C2 --> E
    C3 --> E
    E --> F["Show cards with metrics<br/>+ tables with breakdown"]
```

## Data Flow Architecture

```mermaid
graph LR
    A["Frontend<br/>React/Next.js"] -->|HTTP/JSON| B["NestJS API<br/>Port 3001"]
    B -->|Prisma ORM| C["PostgreSQL<br/>Port 5432"]
    
    A --> A1["Pages:<br/>- funcionarios<br/>- configuracao-gorjetas<br/>- transacoes/nova<br/>- transacoes<br/>- relatorios"]
    
    B --> B1["Modules:<br/>- FuncionariosController<br/>- ConfiguracaoController<br/>- TransacoesController<br/>- DistribuicaoController<br/>- RelatoriosController"]
    
    B --> B2["Services:<br/>- FuncionariosService<br/>- TransacoesService<br/>- TipCalculatorService<br/>- RelatoriosService"]
    
    C --> C1["Tables:<br/>- restaurantes<br/>- funcionarios<br/>- configuracao_gorjetas<br/>- transacoes<br/>- distribuicao_gorjetas"]
    
    B2 --> B2A["Business Logic:<br/>- Tip Calculation<br/>- Distribution Generation<br/>- Report Aggregation<br/>- Validation"]
```

## State Management (Frontend)

```
Component State:
├── functionarios: Funcionario[]
├── configurations: Configuracao[]
├── transactions: Transacao[]
├── reports: Reports
├── loading: boolean
├── error: string
└── filters: DateRange
```

## Error Handling Flow

```mermaid
graph TD
    A["API Request"] --> B{"Success?"}
    B -->|Yes| C["Return 200 + data"]
    B -->|No| D{"Error Type?"}
    
    D -->|Validation| E["Return 400<br/>+ error details"]
    D -->|Not Found| F["Return 404"]
    D -->|Business Logic| G["Return 400<br/>+ message"]
    D -->|Server| H["Return 500"]
    
    C --> I["Frontend: Display data"]
    E --> J["Frontend: Show validation errors<br/>in form"]
    F --> K["Frontend: Show not found alert"]
    G --> L["Frontend: Show error message<br/>with requirements"]
    H --> M["Frontend: Show generic<br/>error + retry"]
```

---

**Architecture Summary:**
- **Frontend:** React/Next.js with simple forms and table views
- **Backend:** NestJS with modular structure and Prisma ORM
- **Database:** PostgreSQL with atomic transactions for data consistency
- **Multi-tenancy:** All queries filtered by `restID`
- **Validation:** Both frontend (client-side) and backend (server-side)
- **Atomic Operations:** Transaction + Distributions created in single DB transaction
