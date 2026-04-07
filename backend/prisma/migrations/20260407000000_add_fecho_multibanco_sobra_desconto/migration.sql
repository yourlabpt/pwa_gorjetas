-- AlterTable: add valor_multibanco, sobra_especie, sobra_conta_no_deposito to fecho_financeiro
ALTER TABLE "fecho_financeiro" ADD COLUMN "valor_multibanco" DECIMAL(12,2);
ALTER TABLE "fecho_financeiro" ADD COLUMN "sobra_especie" DECIMAL(12,2);
ALTER TABLE "fecho_financeiro" ADD COLUMN "sobra_conta_no_deposito" BOOLEAN DEFAULT false;

-- AlterTable: add desconto to faturamento_diario_distribuicao
ALTER TABLE "faturamento_diario_distribuicao" ADD COLUMN "desconto" DECIMAL(12,2);
