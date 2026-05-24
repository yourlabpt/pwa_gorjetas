---
name: gorjetas-business-regression-guard
description: 'Use when implementing, reviewing, or deploying features in PWA Gorjetas. Enforces business invariants, complete auditability (who/when/what), safe migrations, and anti-regression checks before and after changes.'
argument-hint: 'Request + affected modules + expected business outcome'
user-invocable: true
disable-model-invocation: false
---

# Gorjetas Business Regression Guard

Workflow para reduzir regressao funcional e regressao de negocio no projeto de gorjetas.

## When to Use
- Mudancas em calculos financeiros, distribuicao de gorjetas, acertos diarios/periodo, fecho financeiro.
- Mudancas de autenticacao/autorizacao, auditoria, rastreabilidade ou responsabilizacao de usuarios.
- Alteracoes de schema Prisma, migracoes, deploy em Docker, backup/restore.
- Qualquer request com risco de quebrar comportamento ja validado com o negocio.

## Business Outcomes
- Preservar comportamento esperado pelo negocio para pagamento, conferencia e auditoria.
- Garantir rastreabilidade completa: quem fez, quando fez, o que mudou, antes/depois.
- Evitar regressao de regras ja acordadas (especialmente em producao).

## Core Invariants (Do Not Break)
1. Nenhuma mudanca pode eliminar rastreabilidade de usuario em acoes criticas.
2. Eventos de login/logout e mutacoes relevantes devem ser auditaveis.
3. Filtros por restaurante nao podem regredir em backend nem frontend.
4. Logica financeira ja definida e funcional nao pode ser alterada sem validacao explicita de negocio.
5. Alteracoes financeiras devem manter consistencia de totais e arredondamento.
6. Mudancas de schema devem ser migradas com seguranca e sem perda de dados.
7. Deploy deve ser precedido de backup valido e acompanhado de verificacao de saude.

## Procedure
1. Reframe da request em valor de negocio.
- Escreva o resultado esperado em linguagem de operacao: "o que o gestor/super admin consegue provar ou executar apos a mudanca".
- Liste impacto por perfil: SUPER_ADMIN, ADMIN, GERENTE, SUPERVISOR.
- Para sessoes ativas: SUPER_ADMIN e ADMIN podem visualizar usuarios ativos globais.

2. Mapear superficie tecnica.
- Identifique modulos de backend, frontend, Prisma schema, migrations, Docker compose e envs afetados.
- Trace fluxo atual: entrada -> validacao -> regra -> persistencia -> auditoria -> resposta/UI.

3. Definir risco e criticidade.
- Classifique em: baixo, medio, alto.
- Alto risco quando envolve: calculo financeiro, autorizacao, auditoria, migracao ou deploy produtivo.

4. Aplicar delta minimo seguro.
- Fazer a menor mudanca necessaria para atender o comportamento alvo.
- Evitar refatoracao ampla em paralelo a fix funcional.

5. Forcar contexto incremental por request.
- A cada novo pedido, anexar no raciocinio:
  - Decisoes de negocio ja definidas
  - Comportamentos proibidos (nao desejados)
  - Incidentes/regressoes anteriores relevantes
- Se houver conflito com decisao antiga, destacar explicitamente e pedir confirmacao antes de alterar.

6. Validar antes de deploy.
- Checar erros de compilacao/lint nos arquivos tocados.
- Validar fluxos criticos afetados (ex.: login/logout audit, consulta de auditoria, filtros por restaurante).
- Confirmar migracao e integridade de dados no ambiente alvo.

7. Deploy com seguranca (se aplicavel).
- Nivel obrigatorio: estrito.
- Garantir backup recente e restauravel.
- Aplicar migration de forma explicita e verificar saude dos containers.
- Confirmar endpoints/rotas principais apos subir.
- Validar funcionalmente fluxos criticos de negocio apos deploy.

8. Fechamento com evidencia.
- Registrar o que foi alterado, o que foi validado e riscos residuais.
- Declarar claramente o que NAO foi validado (se houver).

## Decision Branches
- Se faltar clareza de regra de negocio:
  - Nao assumir; fazer pergunta objetiva de aceite antes de codar.
- Se migracao tocar dados historicos:
  - Exigir backup + plano de rollback antes de aplicar.
- Se houver divergencia entre comportamento atual e regra desejada:
  - Priorizar regra de negocio mais recente confirmada e documentar impacto.

## Quality Gate (Definition of Done)
- Resultado de negocio descrito e atendido.
- Invariantes criticos preservados.
- Auditoria e atribuicao de usuario funcionando quando aplicavel.
- Mudanca sem erros de compilacao nos arquivos tocados.
- Em caso de deploy: backup, migration e health-check concluídos.

## Suggested Prompts
- /gorjetas-business-regression-guard "Completar trilha de auditoria com login/logout e usuario responsavel"
- /gorjetas-business-regression-guard "Alterar regra de distribuicao sem regressao de calculo diario"
- /gorjetas-business-regression-guard "Aplicar migration em producao com backup e validacao pos-deploy"
