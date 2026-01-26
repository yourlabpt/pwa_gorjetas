# Restaurantes (Restaurants) Management

## Overview

A new **Restaurantes** module has been added to both backend and frontend to allow managing restaurants in your system.

## Backend API

### Endpoints

#### Create Restaurant
```bash
POST /restaurantes
Content-Type: application/json

{
  "name": "Restaurant Name",
  "endereco": "Address (optional)",
  "contacto": "Contact (optional)",
  "percentagem_gorjeta_base": 10.5
}
```

**Response:**
```json
{
  "restID": 1,
  "name": "Restaurant Name",
  "endereco": "Address",
  "contacto": "Contact",
  "percentagem_gorjeta_base": "10.50",
  "ativo": true,
  "createdAt": "2026-01-16T11:53:33.000Z",
  "updatedAt": "2026-01-16T11:53:33.000Z"
}
```

#### Get All Restaurants
```bash
GET /restaurantes
GET /restaurantes?ativo=true    # Only active
GET /restaurantes?ativo=false   # Only inactive
```

#### Get Single Restaurant
```bash
GET /restaurantes/:id
```

#### Update Restaurant
```bash
PUT /restaurantes/:id
Content-Type: application/json

{
  "name": "New Name",
  "endereco": "New Address",
  "contacto": "New Contact",
  "percentagem_gorjeta_base": 12.0,
  "ativo": true
}
```

#### Toggle Restaurant Active Status
```bash
PUT /restaurantes/:id/toggle-active
```

Toggles the `ativo` field between true and false.

## Frontend

### Restaurant Management Page

A new page `/restaurantes` has been added to the frontend with:

- **List of all restaurants** with details (ID, name, address, contact, base tip %, status)
- **Create Restaurant form** with fields:
  - Name (required)
  - Address (optional)
  - Contact (optional)
  - Base Tip Percentage (defaults to 10%)
- **Activate/Deactivate button** for each restaurant
- **Visual status indicator** (green for active, red for inactive)

### Navigation

The Restaurantes link has been added to the main navigation menu.

## How to Use

### Via API (cURL Example)

```bash
# Create a restaurant
curl -X POST http://localhost:3001/restaurantes \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Meu Restaurante",
    "endereco": "Rua Principal, 123, Lisboa",
    "contacto": "+351 21 123 4567",
    "percentagem_gorjeta_base": 12.5
  }'

# List all restaurants
curl http://localhost:3001/restaurantes

# Get specific restaurant
curl http://localhost:3001/restaurantes/1

# Toggle active status
curl -X PUT http://localhost:3001/restaurantes/1/toggle-active
```

### Via Frontend UI

1. Navigate to **Restaurantes** in the menu
2. Click **+ Novo Restaurante**
3. Fill in the form (name is required)
4. Click **Criar**
5. Use the **Desativar/Ativar** button to toggle status

## Notes

- The `restID` is auto-generated and returned in responses
- All restaurants are `ativo: true` by default
- The base tip percentage is used as a default when calculating tips
- Future employees must be linked to an existing restaurant via `restID`

## Next Steps (Phase 2+)

In future phases:
- Add user roles and permissions for restaurant management
- Allow gestor (manager) role to see only their assigned restaurants
- Add restaurant-specific settings and configurations
- Implement multi-restaurant dashboards and analytics
