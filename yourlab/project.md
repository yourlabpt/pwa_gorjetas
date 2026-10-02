---
name: Gestao Financeira Restauração
client: Grupo Ferreira
type: resgate
stage: requirements
---

## Propósito
A app nasceu para distribuir gorjetas nos restaurantes do Grupo Ferreira. Passa a ser a ferramenta financeira do grupo: substitui a folha de cálculo que cada casa preenche todos os meses (fecho de caixa, despesas, faturas de fornecedores, food cost, pessoal, balanço). Serve os gerentes no dia a dia, o escritório no registo e pagamento de faturas, e os donos na leitura do desempenho de cada casa.

## Contexto
- A app está em produção num droplet DigitalOcean (Docker: Postgres 16, app NestJS + Next.js num só contentor, Caddy ou túnel Cloudflare). Tem dados reais desde janeiro 2026 e cerca de 15 casas.
- **Código:** backend NestJS + Prisma em `backend/` (27 migrações, todo o dinheiro em `Decimal`). Frontend Next.js 14 (pages router) em `frontend/`, só com axios como dependência, sem biblioteca de gráficos.
- **Já existe:**
  - Distribuição diária de gorjetas por regras (`finance-engine.service.ts`).
  - Fecho de caixa simples (`fecho_financeiro`, com linhas de texto livre).
  - Acerto de gorjetas por período (cálculo no frontend).
  - Períodos de atividade dos funcionários.
  - Auditoria de parte das ações.
- **Não existe:** fornecedores, faturas, despesas por categoria, folha salarial, food cost, comparação entre casas nem com o ano anterior.
- **Pedido** (reunião de 21 set 2026): pôr a folha de cálculo dentro da app, fácil de lançar, ver e tirar relatórios. Também uma vista por funcionário com vários dias, para deixar de perder 60–70 € em dias por guardar.
- **Forma de trabalho combinada:**
  - Analisar a folha e iterar mock-ups antes de fixar orçamento.
  - Ambiente de testes separado.
  - Piloto em 3 casas tranquilas, sem pôr em risco os dados atuais.
- O mock-up v1 está em `mockup/`. As dúvidas encontradas na folha estão em `questions.md`. As fases 03 a 08 só arrancam depois de o mock-up ser aceite.
- Regra n.º 1 do projeto: nunca apagar dados. As migrações são só aditivas, e as releases seguem `docs/procedures/SANDBOX_AND_DEPLOY.md`.

## Riscos
- **Registo público:** `POST /auth/register` é público e aceita `restaurantIds`. Qualquer pessoa pode criar uma conta de supervisor com acesso às casas que escolher. Tem de ser fechado antes de entrarem IBAN e salários.
- **Dumps no git:** há dumps da base de dados de produção guardados no repositório (`backups/`, ficheiro `100.104.251.1`). É um problema de RGPD, e a decisão (deixar de seguir os ficheiros ou reescrever o histórico) é do dono.
- **Backups:**
  - O cron aponta para um contentor com outro nome, por isso pode não estar a correr.
  - Não há cópia fora do droplet.
- **Monitorização:** não há endpoint de saúde, rastreio de erros, alertas de disponibilidade nem rotação de logs.
- **Eliminação em cascata:** `DELETE /restaurantes/:id` apaga em cascata todo o histórico financeiro da casa.
- **Ambiente:** Node 18 está fora de suporte. Uma migração falhada não para o arranque (`MIGRATE_STRICT=false`).
- **Regra do cash:** muda de "total − multibanco − todas as linhas" para "total − multibanco − despesas". Se for aplicada a dias antigos, muda números já fechados.
- **Duas faturações:** a faturação existe em dois sítios (`faturamento_diario.faturamento_inserido` e `fecho_financeiro.faturamento_global`), que podem divergir.
- **Dados de teste:** a cópia da folha recebida está anonimizada (valores iguais todos os dias), por isso as fórmulas ainda não foram validadas com dados reais.

## Assunções
- O food cost mede-se sobre a faturação com IVA e sem gorjetas, com limite de 28%, como na folha, até o cliente decidir o contrário.
- A segurança social é 23,75% da folha (salários, férias e feriados).
- O salário de quem entra ou sai a meio do mês é proporcional aos dias de calendário, até o contabilista confirmar a regra dos 30 dias.
- Os dias guardados antes da regra nova do cash mantêm o cálculo antigo.
- Os fornecedores são do grupo (uma lista para todas as casas). Só administradores veem o IBAN completo.
- O volume de dados novo é pequeno (cerca de 100 mil linhas por ano) e não obriga a mudar o plano do droplet.
- A manutenção atual é de 95 €/mês. Com os módulos novos estima-se mais 50% de carga: 120 €/mês durante o piloto e 145 €/mês depois, com a infraestrutura nova cobrada à parte.
