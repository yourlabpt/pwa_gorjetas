/*
  Warnings:

  - You are about to drop the column `nome` on the `transacoes` table. All the data in the column will be lost.
  - Added the required column `data_transacao` to the `transacoes` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "transacoes" DROP COLUMN "nome",
ADD COLUMN     "data_transacao" TIMESTAMP(3) NOT NULL;
