## O crescimento face a 2025 deve ser calculado sobre 2025 (33,41%) e não sobre 2026 (25,04%)?
- Para: cliente
- Estado: aberta

Separador FECHOS, célula "AUMENTO PORCENTAGEM". A folha divide a diferença (55 027,16 €) pela faturação de 2026 (219 743,19 €) e mostra 25,04%. Sobre a faturação de julho 2025 (164 716,03 €), o crescimento é 33,41%. O título "DIFERENÇA 2025-2026" também está invertido: o valor é 2026 − 2025. O mock-up usa 33,41%.

## Nos dias 14, 15 e 17 de julho, qual é o valor certo das despesas em dinheiro?
- Para: cliente
- Estado: aberta

O total da coluna DESPESAS é 24 723,03 €. A especificação por baixo soma 24 896,89 € (fornecedores 22 891,04 € + ordenados em dinheiro 857,32 € + outros 1 148,53 €). A diferença de 173,86 € está toda nestes três dias:

| Dia | Coluna DESPESAS | Especificação | Soma do texto INFORMAÇÕES |
|---|---|---|---|
| 14 | 1 426,98 € | 1 426,06 € | 1 426,98 € |
| 15 | 694,12 € | 859,96 € | 672,17 € |
| 17 | 251,86 € | 260,80 € | 260,66 € |

- **Dia 14:** o valor de fornecedores foi escrito como 1 226,80 € em vez de 1 227,72 €.
- **Dias 15 e 17:** os três números são todos diferentes.

Além disso, cada separador usa um valor diferente para as mesmas despesas:
- o cash do mês (41 928,52 €) usa a coluna DESPESAS;
- o food cost e as "Outras despesas" do separador CONTROLE usam a especificação.

Na app cada despesa é escrita uma só vez, por isso estes desvios deixam de existir.

## Táxis, ferramentas, filtros e papel contam como food cost?
- Para: cliente
- Estado: aberta

Tudo o que está na coluna "FORNECED." e no separador FATURAS entra no food cost. Em julho isso inclui:
- táxi 50,60 € e ferramentas 27,86 € (dia 28);
- ferramentas 2,30 € (dia 29);
- filtros 15,38 € (dia 27);
- as faturas da Neutral Paper, 785,39 € (papel e descartáveis).

Sem estes valores, o food cost de julho passa de 59 567,51 € (30,35%) para 58 685,98 € (29,90%).

Também não é claro onde entram lavandaria, canalizador e pagamentos a pessoas: no dia 6 aparecem misturados com compras a fornecedores.

Precisamos da regra: o que conta como food cost (só comida e bebida?) e o que vai para "Outras despesas".

## Os pagamentos a pessoas em dinheiro são "salários extras" ou "outras despesas"?
- Para: cliente
- Estado: aberta

Hoje há pagamentos a pessoas em colunas diferentes:
- **Em "ORD. CASH":** 600,00 € no dia 2, 200,00 € no dia 21 e 57,32 € ("1 dia de trabalho") no dia 24.
- **Em "OUTROS":** outro pagamento de 100,00 € a uma pessoa, também no dia 2.
- **Dia 6:** há um pagamento de 50,00 € a uma pessoa e não é claro em que coluna entra.

Na app, um salário extra fica ligado ao funcionário e aparece na folha do mês dele. Pagamentos a pessoas que não são funcionários ficam em "Outros". Confirmar esta regra.

## A folha salarial e a segurança social entram no balanço? Com que taxa e base?
- Para: cliente
- Estado: aberta

No separador CONTROLE, a "Folha Salarial" não tem valor e a "Segurança Social" está a 0,00 €. Por isso o "Balanço Positivo" de julho (121 348,79 €) está acima do real.

Na app, a folha monta-se com o salário de cada funcionário, e a segurança social calcula-se com a taxa patronal geral de 23,75% sobre salários, férias e feriados. Confirmar:
- a taxa;
- se os extras pagos em dinheiro e as gorjetas entram na base;
- se há funcionários com taxa diferente.

## O limite de 28% de food cost é sobre a faturação com IVA ou sem IVA?
- Para: cliente
- Estado: aberta

A linha "Faturamento C IVA" (196 281,15 €) é a faturação total menos as gorjetas (219 743,19 € − 23 462,04 €). Ainda tem IVA. O limite de 28% aplica-se a esse valor.

Na reunião ficou decidido retirar a linha "sem IVA" por estar errada. Confirmar se o food cost continua a ser medido sobre a faturação com IVA e sem gorjetas, como na folha. A alternativa é medir sobre a faturação sem IVA, a prática habitual no setor, e nesse caso o food cost fica mais alto.

Confirmar também se os valores das faturas de fornecedores são registados com IVA.

## Os 9 000 € de água, gás e luz são uma estimativa fixa?
- Para: cliente
- Estado: aberta

Separador CONTROLE: "Água / Gás / Luz (Base)" tem 9 000 € fixos.

Na app propõe-se uma estimativa por casa e por mês, substituída pelo valor real quando chegam as faturas. Confirmar:
- se o valor é igual todos os meses;
- se é igual em todas as casas;
- se as faturas destes serviços devem ser registadas nas Faturas (categoria "Outro").

## Podem enviar uma cópia real da folha, com os valores de cada dia?
- Para: cliente
- Estado: aberta

Na cópia recebida, o Total (7 088,49 €), o Multibanco (4 938,44 €) e a Gorjeta (756,84 €) são iguais nos 31 dias: parece a média repetida.

Para validar as fórmulas precisamos de uma cópia real com os valores de cada dia. Como combinado, pode vir em ZIP e sem partilha, idealmente de 2 a 3 casas e de 2 meses.

## Os blocos de percentagens e o separador PORCENTAGENS ANO são para manter?
- Para: cliente
- Estado: aberta

Estes blocos estão vazios ou dão erro:
- **"DESPESAS MÊS":** fornecedores transferência/cash, ordenados transferência/cash, comissões cash e feriados estão todos a 0,00 €.
- **"PORCENTAGEM VENDAS/DESPESAS" e "PORCENTAGEM DE ORDENADOS":** mostram 0,00%, e o bloco de julho diz "JUNHO".
- **Separador PORCENTAGENS ANO:** dá #DIV/0! em todos os meses.

Na app estes valores são calculados sozinhos (ecrã Anual). Precisamos de saber:
- se querem manter estas linhas;
- o que são as "comissões cash";
- de onde vêm os "ordenados por transferência" (do processamento salarial?).

## Em que mês conta uma fatura, e a data passa a ser obrigatória?
- Para: cliente
- Estado: aberta

O separador FATURAS só tem valor e número, sem data. Na app cada fatura tem data. Confirmar se o mês conta pela data da fatura ou pela data em que a fatura chegou.

## Como corrigir três registos duvidosos nas faturas de julho?
- Para: cliente
- Estado: aberta

- **Aviludo:** a fatura de 1 237,07 € tem o número "63,21", que parece um valor.
- **Pinheiro:** há 100,74 € sem número e com a nota "falta nota de crédito". Está somado como fatura. É uma fatura ou o valor da nota de crédito em falta?
- **Cas Carne:** tem a nota "falta nota de crédito" sem valor. De quanto é?

Na app propõe-se marcar estas faturas como "aguarda nota de crédito" até ela chegar.

## Existe uma lista única de fornecedores para todas as casas?
- Para: cliente
- Estado: aberta

O separador LIST. PAG. FORNECEDORES tem o título "Standardlicious – fornecedores de junho 2026" e o total a pagar está a 0,00 €. Tem 19 fornecedores com IBAN, mas faltam 10 dos 15 fornecedores com faturas em julho (por exemplo Aviludo, Geltejo e Pinheiro).

Precisamos de saber:
- se a lista é por casa ou do grupo;
- quem mantém os IBAN atualizados;
- quem vai poder vê-los na app (proposta: só administradores).

## Os chamadores trabalharam nos dias 25, 26 e 29 de julho?
- Para: cliente
- Estado: aberta

A coluna CHAMADOR está vazia nesses três dias; nos outros dias de julho vai de 103 € a 259 €. Na app o valor vem da distribuição do dia. Precisamos de saber se um dia vazio quer dizer "sem chamador" ou "esquecido".

## A data do depósito do dinheiro deve ser registada?
- Para: cliente
- Estado: aberta

Na coluna INFORMAÇÕES, todos os dias dizem "Depósito feito dia" sem a data, e o dia 31 não tem nada.

Na app propõe-se registar a data e o valor depositado. Confirmar se o valor depositado é sempre igual ao cash do dia.

## A média diária divide pelos dias do mês ou pelos dias em que a casa abriu?
- Para: cliente
- Estado: aberta

Hoje a média diária de 2026 é 219 743,19 € ÷ 31 dias = 7 088,49 €. Se a casa fechar algum dia, dividir pelos dias do mês baixa a média.

## Na folha por funcionário, o que são "Férias" e como se contam as semanas?
- Para: cliente
- Estado: aberta

O separador Funcionários está vazio. Tem as colunas ORDENADO, FÉRIAS, FERIADO, GORJETA e EXTRA, e as gorjetas da semana 1 à semana 4 (S1 a S4). Precisamos de saber:
- se "Férias" é o subsídio de férias (pago uma vez por ano) ou a parte mensal (1/12);
- se "Feriado" é o valor pago por trabalhar num feriado;
- como se definem as semanas: julho tem 31 dias e cinco semanas incompletas;
- como se calcula o salário de quem entra ou sai a meio do mês: por dias de calendário ou pela regra dos 30 dias.

## Quem fornece a faturação de 2025 de cada casa, mês a mês?
- Para: cliente
- Estado: aberta

A comparação com o ano anterior usa o total de julho 2025 (164 716,03 €). A app só tem dados desde janeiro 2026, por isso precisamos dos 12 meses de 2025 de cada casa. São introduzidos uma única vez.

## Uma compra paga em dinheiro que também tem fatura conta duas vezes no food cost?
- Para: cliente
- Estado: aberta

O food cost soma as faturas e os fornecedores pagos em dinheiro. Se um fornecedor pago em dinheiro também entrega fatura, e essa fatura entra no separador FATURAS, o valor conta duas vezes. Por exemplo, o talho aparece nas despesas em dinheiro e tem IBAN na lista de fornecedores. Isto acontece?

## A faturação total do dia é o valor do talão Z do POS?
- Para: cliente
- Estado: aberta

Na app, a faturação do fecho diário passa a ser a única fonte para o painel. Confirmar de onde vem o valor: talão Z, relatório do POS ou outra fonte.

## Um dia sem gorjetas guardadas deve bloquear o acerto ou só avisar?
- Para: cliente
- Estado: aberta

No mock-up, o acerto mostra os dias em falta a vermelho. Antes de guardar, pede um motivo. A alternativa é não deixar guardar enquanto houver dias em falta.

## Quem vê o quê na nova app?
- Para: cliente
- Estado: aberta

O mock-up do ecrã Utilizadores tem uma matriz de acessos proposta. Por exemplo: salários, IBAN, balanço e comparativo só para administradores, e gerentes só nas suas casas. Validar na reunião do mock-up.

## Quais são as 3 casas do piloto?
- Para: cliente
- Estado: aberta

Ficou combinado testar primeiro em 3 casas mais tranquilas. O mock-up usa Ferrary, Casa Ribeira e Casa Alfama só como exemplo.

## Que indicadores querem ver no painel e no comparativo?
- Para: cliente
- Estado: aberta

O mock-up propõe:
- faturação;
- crescimento face a 2025;
- média diária;
- food cost face ao limite de 28%;
- peso do pessoal;
- balanço;
- dias por preencher.

A lista final define-se com quem conhece o negócio.
