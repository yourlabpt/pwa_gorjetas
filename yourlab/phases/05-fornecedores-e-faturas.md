---
title: Fornecedores e faturas
weeks: 2
status: planeada
---

## Objetivo
O escritório regista faturas e notas de crédito numa lista vertical e marca-as como pagas. A lista de fornecedores e o que há para pagar deixam de estar em folhas soltas. Esforço estimado: 5–7 dias. Só arranca depois de o mock-up ser aceite.

## Features

### Diretório de fornecedores
- Requisitos: fornecedores-faturas
Lista única do grupo, com NIF, categoria habitual, forma de pagamento habitual e IBAN.
1. Migração aditiva: tabela `fornecedor`, como em `database.md`.
2. Módulo `fornecedores`. Leitura só para quem tem pelo menos uma casa; escrita e IBAN completo só para administradores. O IBAN aparece mascarado para os outros perfis, e o VISUALIZADOR nunca o vê.
3. Ligar as despesas em dinheiro da fase 04 ao fornecedor (`despesa_caixa.fornecedorID`).
4. Importar uma vez a lista de fornecedores das folhas, com o ficheiro validado pelo cliente.

### Registo de faturas e notas de crédito
- Requisitos: fornecedores-faturas
1. Migração aditiva: tabela `fatura_fornecedor`. O valor é guardado positivo, e o sinal das notas de crédito aplica-se num só sítio.
2. Módulo `faturas`: listar por casa e mês com filtros (fornecedor, categoria, pendentes), criar, editar e desativar. Avisa se o número já existir para o mesmo fornecedor. Emite um evento de auditoria em cada escrita.
3. Marcar como pagas várias faturas de uma vez, com data e forma de pagamento.
4. Marcar "aguarda nota de crédito" com uma nota.
5. Ecrã `faturas.tsx` como no mock-up: cartões por fornecedor, lista, seleção, janelas "Nova fatura" e "Marcar pagas".

### Lista de pagamentos
- Requisitos: fornecedores-faturas
Pendentes por fornecedor, com IBAN e total, e exportação em CSV feita no browser.

## Entregáveis
- Fornecedores e faturas a funcionar nas casas do piloto
- Lista de pagamentos com exportação CSV
- Total de faturas do mês igual à folha (julho: 36 676,47 €) no ensaio com dados reais
