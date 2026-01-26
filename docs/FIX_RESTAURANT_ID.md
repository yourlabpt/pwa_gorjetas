# Fix Summary: Frontend Restaurant Selection & API Integration

## Problem
The frontend was hardcoding `REST_ID = 1` in all pages, but when the database was reinitialized, the seeded restaurant was created with a different `restID` (e.g., `restID = 5`). This caused foreign key constraint violations when trying to create funcionarios or other entities.

## Root Cause
- Frontend pages had `const REST_ID = 1` hardcoded
- Database seed created restaurant with auto-increment ID, which could be any number
- Mismatch between hardcoded frontend ID and actual database restaurant ID

## Solution Implemented

### 1. Dynamic Restaurant Loading
Updated all frontend pages to dynamically load the first active restaurant from the API instead of hardcoding the ID:

**Pages Updated:**
- `frontend/src/pages/funcionarios.tsx`
- `frontend/src/pages/configuracao-gorjetas.tsx`
- `frontend/src/pages/relatorios.tsx`
- `frontend/src/pages/transacoes/index.tsx`

### 2. Implementation Pattern
Each updated page now:
1. Declares `const [restID, setRestID] = useState<number | null>(null)`
2. Calls `loadRestaurant()` on mount to fetch first active restaurant
3. Uses `useEffect` to refetch data when `restID` changes
4. Passes `restID` to all API calls instead of `REST_ID`

**Example:**
```typescript
const loadRestaurant = async () => {
  try {
    const response = await apiClient.getRestaurantes(true);
    if (response.data && response.data.length > 0) {
      setRestID(response.data[0].restID);
    } else {
      setError('Nenhum restaurante ativo encontrado.');
    }
  } catch (err) {
    setError('Erro ao carregar restaurantes');
  }
};
```

### 3. Utility File
Created `frontend/src/lib/restaurant.ts` with helper functions for future use:
- `getActiveRestaurant()` - Fetches and caches the active restaurant
- `resetRestaurantCache()` - Clears the cache

## Testing

### Prerequisites
✅ Database seeded with at least one restaurant
✅ Backend running on http://localhost:3001
✅ Frontend running on http://localhost:3000

### Verify Fixes Work

**1. Create Restaurante:**
- Navigate to http://localhost:3000/restaurantes
- Click "+ Novo Restaurante"
- Fill form and submit
- Restaurant should appear in list

**2. Create Funcionario:**
- Navigate to http://localhost:3000/funcionarios
- Should automatically load employees from first active restaurant
- Click "+ Novo Funcionário"
- Fill form and submit
- Employee should be added ✅ (no more foreign key errors!)

**3. Other Pages:**
- Configuração de Gorjetas - Should load configurations for active restaurant
- Relatórios - Should show reports for active restaurant
- Transações - Should list transactions for active restaurant

## Benefits

✅ **No More Hardcoded IDs** - Works with any restaurant ID
✅ **Multi-Restaurant Ready** - Foundation for Phase 2 restaurant selection dropdown
✅ **Error Handling** - Shows message if no active restaurant exists
✅ **Automatic Loading** - Restaurant ID loaded on page load

## Future Improvements (Phase 2)

For Phase 2, you can easily add:
1. Restaurant dropdown selector on each page
2. User role filtering (gestor sees only their restaurants)
3. Admin page to manage restaurant assignments
4. Restaurant context/provider for entire app

## Files Modified
- `frontend/src/pages/funcionarios.tsx`
- `frontend/src/pages/configuracao-gorjetas.tsx`
- `frontend/src/pages/relatorios.tsx`
- `frontend/src/pages/transacoes/index.tsx`
- `frontend/src/lib/restaurant.ts` (new)
- `frontend/src/lib/api.ts` (added restaurant methods)

## Status
✅ All pages now dynamically load restaurant IDs
✅ Frontend successfully builds without errors
✅ Ready for testing
