---
title: Fecho de caixa e despesas
weeks: 3
status: planeada
---

## Objetivo
O fecho diário substitui o separador FECHOS. Cada despesa em dinheiro é escrita uma vez, com categoria, fornecedor ou funcionário, e o cash é calculado e guardado pela app com a regra nova. Esforço estimado: 8–11 dias. Só arranca depois de o mock-up ser aceite.

## Features

### Despesas em dinheiro com categoria
- Requisitos: despesas-caixa
Tabela nova, gravada linha a linha, em vez das linhas de texto livre do fecho.
1. Migração aditiva: tabela `despesa_caixa` e enum `CategoriaDespesa`, como em `database.md`. A chave estrangeira usa `onDelete: Restrict`. Juntar os valores novos a `AuditEntity`.
2. Módulo NestJS `despesas-caixa`: listar por casa e dia, criar, editar e desativar uma linha. Exige `restID` (padrão de `fecho-financeiro.service.ts`) e emite um evento de auditoria em cada escrita.
3. Ainda não existem fornecedores (fase 05): nesta fase guarda-se o nome em texto e o `fornecedorID` fica nulo. A ligação faz-se na fase 05.
4. As linhas antigas de `fecho_financeiro_item` não mudam e aparecem como "não classificado".

### Regra nova do cash, por casa
- Requisitos: fecho-caixa
Cash = faturação total − multibanco − despesas em dinheiro. Gorjetas e chamadores deixam de ser descontados.
1. Migração aditiva: `fecho_financeiro.regra_calculo` (inteiro, nulo = regra antiga), `fecho_financeiro.deposito_data` (data, nula) e `restaurante.regra_cash_desde` (data, nula).
2. Passar o cálculo do cash para o backend (`fecho-financeiro.service.ts`) e guardar o resultado em `sobra_especie`. Os dias com `regra_calculo` nulo nunca são recalculados.
3. Para a regra antiga, ler o multibanco da coluna e, quando não existir (antes de abril 2026), da linha com "multibanco" no nome.
4. Testes com os números de julho da folha: 2 jul dá cash 949,91 €; 1 jul dá 970,34 €.

### Fecho diário v2 no ecrã
- Requisitos: fecho-caixa
1. Tirar o fecho de dentro de `financeiro-diario.tsx` (2 776 linhas) para um componente `FechoCaixa.tsx` com separadores Fecho de caixa / Gorjetas do dia.
2. Gorjetas e chamadores preenchidos a partir da distribuição do dia (só leitura). Faturação do fecho pré-preenchida com a do dia, mostrando a diferença se forem diferentes.
3. Janela "Nova despesa": a categoria muda os campos pedidos, como no mock-up.
4. Registar a data e o valor do depósito.

### Casa no menu
- Requisitos: plataforma-operacao
Um seletor de casa no menu, em vez de um por página (hoje cada página guarda a sua em `useSessionPageState`).

## Entregáveis
- Tabela de despesas em dinheiro e janela "Nova despesa"
- Regra nova do cash ligada só nas casas do piloto, com o histórico intacto
- Fecho diário v2 publicado nas casas do piloto
- Testes do cash com os números da folha
