# Quick Start: Gorjeta Distribution System

## How to Use

### Step 1: Create a Restaurant
1. Go to **Restaurantes** page
2. Click **+ Novo Restaurante**
3. Fill in restaurant details:
   - **Nome** (required)
   - **Endereço** (optional)
   - **Contacto** (optional)
   - **Percentagem Base** (default: 11%)
4. Click **Criar**

### Step 2: Configure Tip Distribution
After creating a restaurant, you'll see the configuration wizard:

1. **Add Functions:** Configure which roles receive tips
   - Enter role name (e.g., "garcom", "cozinha", "douglas")
   - Enter percentage for that role
   - The total should equal 11% (or your base percentage)

2. **Edit/Remove:** Adjust configurations as needed
   - Click input to change percentage
   - Click "Remover" to delete a function
   - Click "+ Adicionar Função" to add more roles

3. **Confirm:** Click **Confirmar e Criar** when done
   - Or click **Configurar Depois** to skip and configure later

### Step 3: Register Employees
1. Go to **Funcionários** page
2. For each role configured above, create at least one employee
   - Must have the same role name as configured
   - Example: if you configured "garcom", create employees with "garcom" role

### Step 4: Register Transactions
1. Go to **Transações** → **Nova Transação**
2. Select restaurant (configured values appear automatically)
3. Enter:
   - **Data da Transação** (date of transaction)
   - **Valor da Gorjeta** (tip amount received)
4. **Distribuição:** Verify pre-filled percentages
   - Can be adjusted for special cases
5. Select **Garçom** (waiter who received tip)
6. Optionally enter **MB WAY** value
7. Click **Criar Transação**

### Step 5: View Configuration
1. Go to **Configuração de Distribuição** page
2. View all configured functions for active restaurant
3. **Edit:** Change percentages on the fly
4. **Adicionar Função:** Add new role
5. **Remover:** Delete a role

## Understanding the Calculations

### Example
- Restaurant base percentage: **11%**
- Tip received: **€11.00**
- Table total: €100.00 (€100 × 11% = €11 tip)

**Distribution (if configured as: garcom 7%, cozinha 3%, douglas 1%):**
- Garçom: €11 × (7% / 11%) = **€7.00**
- Cozinha: €11 × (3% / 11%) = **€3.00**
- Douglas: €11 × (1% / 11%) = **€1.00**
- **Total: €11.00** ✓

## Common Tasks

### Change Tip Distribution for a Restaurant
1. Go to **Configuração de Distribuição**
2. Edit percentages directly in the table
3. Changes apply to future transactions immediately

### Add a New Role
1. Go to **Configuração de Distribuição**
2. Click **+ Adicionar Nova Função**
3. Enter role name and percentage
4. Click **Adicionar**
5. Create employee with this role in **Funcionários** page

### Remove a Role
1. Go to **Configuração de Distribuição**
2. Find the role in the table
3. Click **Remover** button
4. Confirm removal

### Override Distribution for Special Case
When registering a transaction:
1. Edit percentages in the **Distribuição de Gorjeta por Função** section
2. The preview will recalculate with your custom values
3. This doesn't change the restaurant configuration
4. Next transaction will use default configuration again

## Tips

✅ **Do:**
- Keep total percentages at 100% of tip (usually 11%)
- Ensure you have active employees for each configured role
- Review configuration before creating transactions

❌ **Don't:**
- Delete a role if employees have active transactions
- Create roles with no corresponding employees
- Let total percentage differ significantly from base unless intentional

## Troubleshooting

**"Nenhuma função configurada"** (No functions configured)
- Go to **Configuração de Distribuição**
- Click **+ Adicionar Nova Função**
- Add at least one function

**"Missing active employee(s)"**
- Go to **Funcionários**
- Create employee with the exact role name from configuration
- Ensure employee status is "Ativo"

**Transactions not calculating correctly**
- Check: Do configured functions have corresponding active employees?
- Verify: Does total percentage match restaurant base percentage?
- Review: Are all employee role names exactly matching configuration?

## Support

For issues or questions, consult:
1. Check **Como funciona** section on configuration page
2. Review this guide
3. Verify employee and configuration setup
4. Check browser console for error messages
