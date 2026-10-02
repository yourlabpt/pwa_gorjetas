---
title: Acerto por funcionário
weeks: 1
status: planeada
---

## Objetivo
O gerente vê todos os dias de cada funcionário numa tabela e não fecha um período sem saber que faltam dias. Esforço estimado: 3–5 dias. É a primeira entrega útil: só junta duas colunas nulas ao esquema e parte do trabalho já está feito (paginador de dias, faixa da semana e dias em falta, ainda por publicar). Só arranca depois de o mock-up ser aceite.

## Features

### Tabela funcionário × dia
- Requisitos: acerto-funcionario
Matriz com os dias do período em colunas e os funcionários em linhas, dias em falta a vermelho, folgas a cinzento.
1. Publicar o trabalho já feito em `frontend/src/components/DayPager.tsx` e `frontend/src/lib/dates.ts`, com as alterações a `financeiro-diario.tsx` e `acerto-final.tsx`, depois de revisto e ensaiado.
2. Passar a fórmula do valor efetivo por dia (hoje em `acerto-final.tsx`: pago + direto − desconto; só direto para os papéis externos) para uma função no backend, com teste. A folha do mês (fase 06) vai usar a mesma. Ao guardar um dia, gravar também `payment_source` (coluna nova e nula) em cada linha de distribuição, para que uma mudança de regras não altere meses passados.
3. Criar `GET /acerto-final/matriz?restID&inicio&fim` com os valores por funcionário e dia, as folgas (presença) e os dias sem distribuição guardada. Usa `faturamento_diario`, `faturamento_diario_distribuicao` e `funcionario_presenca_diaria`.
4. Desenhar a matriz em `acerto-final.tsx` como no mock-up: coluna do nome fixa, a célula abre o dia, o nome abre a vista do funcionário.

### Períodos e filtros
- Requisitos: acerto-funcionario
Semana, 15 dias, 30 dias, mês ou datas à escolha, com setas ‹ ›, filtro por função e por funcionário.
1. Juntar os presets de 15 e 30 dias a `presetPeriod` em `lib/dates.ts`, com o teste em `dates.check.ts`. `shiftPeriod` já trata qualquer comprimento.
2. Filtrar por função e por funcionário no frontend, sem pedidos novos.

### Aviso de dias em falta
- Requisitos: acerto-funcionario
1. Mostrar um aviso com a lista dos dias em falta e a ligação para cada um.
2. Ao guardar com dias em falta, pedir confirmação e motivo, ou bloquear (conforme a resposta do cliente). O motivo fica numa coluna nova e nula, `acerto_final_periodo.motivo_dias_em_falta`.

### Vista de um funcionário
- Requisitos: acerto-funcionario
Página nova `acerto-funcionario` com os dias de uma pessoa, totais, exportar CSV e imprimir.

## Entregáveis
- Tabela funcionário × dia publicada nas casas do piloto
- Presets de 15 e 30 dias e filtros
- Aviso e confirmação de dias em falta
- Testes da função de valor efetivo
