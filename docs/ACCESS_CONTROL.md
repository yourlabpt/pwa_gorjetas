# Controlo de Acesso por Página

Cada página do frontend define a constante `ALLOWED_ROLES` no topo do ficheiro, listando os papéis que têm permissão de acesso. Utilizadores sem o papel correto são redirecionados para `/` (ou `/login` se não houver token).

## Papéis disponíveis

| Papel | Descrição |
|---|---|
| `SUPER_ADMIN` | Super administrador — controla contas ADMIN e gestão global de segurança |
| `ADMIN` | Administrador — acesso total |
| `SUPERVISOR` | Supervisor — acesso operacional e de configuração |
| `GERENTE` | Gerente — acesso ao dia-a-dia do restaurante |

## Mapeamento de acesso por página

| Página | Caminho | `ALLOWED_ROLES` |
|---|---|---|
| Início | `/` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `GERENTE` |
| Financeiro Diário | `/financeiro-diario` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `GERENTE` |
| Funcionários | `/funcionarios` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `GERENTE` |
| Relatórios | `/relatorios` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `GERENTE` |
| Configuração | `/configuracao` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `GERENTE` |
| Configuração de Acerto | `/configuracao/acerto` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `GERENTE` |
| Configuração de Gorjetas | `/configuracao-gorjetas` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR`, `GERENTE` |
| Restaurantes | `/restaurantes` | `SUPER_ADMIN`, `ADMIN`, `SUPERVISOR` |
| Usuários | `/usuarios` | `SUPER_ADMIN`, `ADMIN` |

> **Login** (`/login`) é público.
> **Registo** (`/register`) é público para criar contas `GERENTE`/`SUPERVISOR`.
> Criação de `ADMIN` continua restrita a `SUPER_ADMIN`.

## Como alterar o acesso a uma página

Abra o ficheiro da página e edite o array `ALLOWED_ROLES` no início do componente:

```typescript
// Exemplo: restringir /relatorios apenas a ADMIN e SUPERVISOR
const ALLOWED_ROLES = ['ADMIN', 'SUPERVISOR'];
```

A lógica de verificação é sempre a mesma: ao montar a página, é feita uma chamada a `GET /auth/me` para obter o papel do utilizador autenticado. Se o papel não constar em `ALLOWED_ROLES`, o utilizador é redirecionado.
