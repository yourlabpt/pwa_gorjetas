# Quick Reference - Phase 1 MVP

## File Structure

```
pwa_restaurantes_lisboa/
├── docker-compose.yml              # PostgreSQL config
├── setup.sh                        # Automated setup script
├── README.md                       # Main documentation
├── .gitignore
│
├── backend/                        # NestJS server
│   ├── prisma/
│   │   ├── schema.prisma          # Database models
│   │   └── seed.ts                # Sample data
│   ├── src/
│   │   ├── main.ts                # Entry point
│   │   ├── app.module.ts          # Root module
│   │   ├── prisma/                # PrismaService
│   │   ├── funcionarios/          # Employees CRUD
│   │   ├── configuracao-gorjetas/ # Tip configs
│   │   ├── transacoes/            # Transactions + atomic ops
│   │   ├── distribuicao-gorjetas/ # Distribution records
│   │   ├── relatorios/            # Reports
│   │   └── tip-calculator/        # Calculation engine
│   ├── .env                       # DATABASE_URL
│   ├── tsconfig.json
│   ├── package.json
│   └── README.md
│
├── frontend/                       # Next.js app
│   ├── src/
│   │   ├── pages/
│   │   │   ├── _app.tsx           # App wrapper
│   │   │   ├── index.tsx          # Home
│   │   │   ├── funcionarios.tsx   # Employees
│   │   │   ├── configuracao-gorjetas.tsx
│   │   │   ├── relatorios.tsx
│   │   │   └── transacoes/
│   │   │       ├── nova.tsx       # Create transaction
│   │   │       └── index.tsx      # List transactions
│   │   ├── components/
│   │   │   ├── Layout.tsx
│   │   │   └── Navigation.tsx
│   │   ├── lib/
│   │   │   └── api.ts            # API client
│   │   └── styles/
│   │       └── globals.css        # Styling
│   ├── .env.local                # NEXT_PUBLIC_API_URL
│   ├── tsconfig.json
│   ├── package.json
│   └── next.config.js
│
└── docs/
    ├── er-diagram.md             # Database schema diagram
    ├── flow-diagram.md           # Application flow
    └── api-documentation.md      # API reference
```

---

## Quick Commands

### Database
```bash
# Start DB
docker-compose up -d

# Stop DB
docker-compose down

# View logs
docker-compose logs postgres
```

### Backend
```bash
# Install
cd backend && npm install

# Run migrations
npx prisma migrate dev

# Seed data
npx prisma db seed

# Start dev server
npm run start:dev

# View Prisma Studio
npx prisma studio
```

### Frontend
```bash
# Install
cd frontend && npm install

# Start dev server
npm run dev

# Build for production
npm run build
```

---

## Key Concepts

### Atomic Transactions
```typescript
// Transaction + Distributions created together
prisma.$transaction(async (tx) => {
  const trans = await tx.transacao.create(...)
  await tx.distribuicaoGorjetas.create(...)
})
```

### Decimal Precision
```typescript
// Always use Decimal for money
const tip = new Decimal(total)
  .times(percent)
  .dividedBy(100)
  .toDecimalPlaces(2)
```

### Multi-Tenant
```typescript
// All queries filtered by restID
findMany(restID: number) {
  where: { restID }
}
```

### Soft Delete
```typescript
// Mark inactive, don't delete
update(id, { ativo: false })
```

---

## Testing Checklist

- [ ] Docker starts without errors
- [ ] Migrations run successfully
- [ ] Seed creates 4 employees + 3 configs
- [ ] POST /funcionarios creates employee
- [ ] POST /transacoes creates transaction + 3 distributions
- [ ] GET /transacoes returns transactions with distributions
- [ ] GET /relatorios/funcionarios shows correct totals
- [ ] GET /relatorios/faturamento calculates reverse billing
- [ ] Frontend connects to API (check Network tab)
- [ ] Can create employee from UI
- [ ] Can create transaction and see breakdown
- [ ] Reports show correct data

---

## Common Issues

### DB Connection Failed
```bash
# Check DB is running
docker ps | grep pwa_restaurantes_db

# Restart
docker-compose restart
```

### Prisma Errors
```bash
# Reset DB (careful!)
npx prisma migrate reset

# Check migrations
npx prisma migrate status
```

### CORS Issues
- Check NEXT_PUBLIC_API_URL in frontend/.env.local
- Verify backend enables CORS in main.ts

### Decimal Rounding
- Always use Decimal.js, not JavaScript numbers
- 2 decimal places for all currency

---

## Environment Variables

### Backend (.env)
```
DATABASE_URL=postgresql://restaurantes_user:restaurantes_pass@localhost:5432/restaurantes_db
```

### Frontend (.env.local)
```
NEXT_PUBLIC_API_URL=http://localhost:3001
```

---

## Phase 1 Scope

✅ **Included:**
- Employee CRUD
- Tip configuration
- Transaction creation with automatic distribution
- Distribution records
- Reports (by employee, summary, faturamento)
- No authentication
- Single restaurant (restID=1)
- Soft deletes

❌ **Not Included:**
- Authentication/Login
- Role-based access
- Restaurant management UI
- Supplier management
- Cleaning inventory
- Image uploads

---

## Browser Support

- Chrome/Edge: ✅ Full support
- Firefox: ✅ Full support
- Safari: ✅ Full support (iOS 12+)
- IE11: ❌ Not supported

---

## Performance Notes

- Reports pre-aggregate in backend
- No real-time websockets
- Frontend queries full dataset and filters
- Database indexes on restID, createdAt, funcID

---

## Backup & Recovery

```bash
# Backup database
docker exec pwa_restaurantes_db pg_dump -U restaurantes_user restaurantes_db > backup.sql

# Restore from backup
cat backup.sql | docker exec -i pwa_restaurantes_db psql -U restaurantes_user restaurantes_db
```

---

## Production Considerations (Future)

- Implement proper auth (JWT)
- Add request rate limiting
- Cache reports with Redis
- Use connection pooling (PgBouncer)
- Add monitoring/logging
- Enable HTTPS
- Database backups
- Frontend PWA manifest
- Offline support

---

**For detailed API documentation, see:** [api-documentation.md](api-documentation.md)
**For database schema, see:** [er-diagram.md](er-diagram.md)
**For application flow, see:** [flow-diagram.md](flow-diagram.md)
