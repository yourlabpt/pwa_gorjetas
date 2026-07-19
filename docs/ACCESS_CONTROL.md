# Controlo de Acesso por Página

Cada página do frontend verifica o papel do utilizador via `GET /auth/me` e redireciona quem não tiver permissão para `/` (ou `/login` se não houver token). As constantes partilhadas estão em [`frontend/src/lib/roles.ts`](../frontend/src/lib/roles.ts).

No backend, mutações de utilizadores `VISUALIZADOR` são bloqueadas globalmente pelo `WriteAccessGuard` (exceto login, logout e `POST /faturamento-diario/compute`).

## Papéis disponíveis

| Papel | Descrição |
|---|---|
| `SUPER_ADMIN` | Super administrador — controla contas ADMIN e gestão global de segurança |
| `ADMIN` | Administrador — acesso total |
| `SUPERVISOR` | Supervisor — acesso operacional e de configuração |
| `GERENTE` | Gerente — acesso ao dia-a-dia do restaurante |
| `VISUALIZADOR` | Visualizador — leitura global (todos os restaurantes), sem alterações |

## Mapeamento de acesso por página

| Página | Caminho | Papéis permitidos |
|---|---|---|
| Início | `/` | Operacionais + `VISUALIZADOR` |
| Financeiro Diário | `/financeiro-diario` | Operacionais + `VISUALIZADOR` (UI read-only) |
| Acerto Final | `/acerto-final` | Operacionais + `VISUALIZADOR` (UI read-only) |
| Funcionários | `/funcionarios` | Operacionais + `VISUALIZADOR` (UI read-only) |
| Relatórios | `/relatorios` | Operacionais + `VISUALIZADOR` |
| Configuração | `/configuracao` | Operacionais + `VISUALIZADOR` |
| Configuração de Acerto | `/configuracao/acerto` | Operacionais + `VISUALIZADOR` (UI read-only) |
| Restaurantes | `/restaurantes` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `VISUALIZADOR` (UI read-only) |
| Usuários | `/usuarios` | `SUPER_ADMIN`, `ADMIN` |
| Auditoria | `/auditoria` | `SUPER_ADMIN` |

> **Login** (`/login`) é público.
> **Registo** (`/register`) é público para criar contas `GERENTE`/`SUPERVISOR`.
> Criação de `ADMIN` continua restrita a `SUPER_ADMIN`.
> Criação de `VISUALIZADOR` é feita por `ADMIN`/`SUPER_ADMIN` em `/usuarios`.

## VISUALIZADOR — enforcement

| Camada | Comportamento |
|---|---|
| API (`WriteAccessGuard`) | Bloqueia POST/PUT/PATCH/DELETE; permite GET e compute |
| Restaurantes | Leitura global via `hasGlobalReadAccess()` |
| UI | Banner read-only + botões de mutação ocultos/desativados |

## Como alterar o acesso a uma página

Edite [`frontend/src/lib/roles.ts`](../frontend/src/lib/roles.ts) ou o array usado na página:

```typescript
import { OPERATIONAL_ROLES } from '../lib/roles';

if (!OPERATIONAL_ROLES.includes(role)) {
  router.replace('/');
  return;
}
```
