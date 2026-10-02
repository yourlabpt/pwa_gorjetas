---
title: Pessoal e custos mensais
weeks: 2
status: planeada
---

## Objetivo
A folha do mês monta-se com o que a app já sabe, e só se escreve o que falta. Os custos fixos e a referência do ano anterior ficam guardados por mês. O balanço passa a incluir pessoal e segurança social. Esforço estimado: 6–8 dias. Só arranca depois de o mock-up ser aceite.

## Features

### Folha do mês automática
- Requisitos: pessoal-folha
1. Migração aditiva: tabela `folha_mensal_linha` (uma linha por funcionário, casa e mês) e `restaurante.taxa_seguranca_social` (por omissão 23,75).
2. Botão "Gerar/atualizar":
   - salário = `funcionario.salario` × dias ativos no mês (cruzando `funcionario_periodo_ativo` com o mês) ÷ dias do mês, ou regra dos 30 dias se o cliente decidir;
   - extras e feriados = soma das `despesa_caixa` com esse funcionário;
   - gorjetas por semana = a função de valor efetivo da fase 03.
3. Férias e ajustes escritos à mão. Segurança social = taxa × (salário + férias + feriados), guardada na linha.
4. "Fechar mês" grava `fechadoEm`. A partir daí "Gerar" não altera o mês, e mudar um salário em Funcionários já não mexe em meses fechados.
5. Ecrã `pessoal.tsx` com a origem de cada coluna, como no mock-up.

### Histórico de salário
- Requisitos: pessoal-folha
Mudar o salário em Funcionários pede a data a partir da qual vale. Os meses fechados guardam o seu próprio valor.

### Custos do mês e definições da casa
- Requisitos: custos-mensais
1. Migração aditiva:
   - tabela `valor_mensal` para água/gás/luz, outros custos fixos e faturação de referência de 2025;
   - em `restaurante`: `food_cost_max_pct` (por omissão 28) e `modulo_financeiro_ativo` (por omissão falso).
2. Ecrã `custos-mensais.tsx`: estimativa ou valor real, os 12 meses de 2025, e as definições (limite, taxa de segurança social, regra do cash, piloto). Só para administradores, com auditoria.

## Entregáveis
- Folha do mês gerada para as casas do piloto, com fecho de mês
- Custos fixos e referência de 2025 introduzidos
- Testes: salário proporcional, segurança social e congelamento ao fechar o mês
