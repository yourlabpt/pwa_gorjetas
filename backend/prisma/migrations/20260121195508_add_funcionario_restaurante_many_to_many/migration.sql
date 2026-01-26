-- DropForeignKey
ALTER TABLE "funcionarios" DROP CONSTRAINT "funcionarios_restID_fkey";

-- AlterTable
ALTER TABLE "funcionarios" ALTER COLUMN "restID" DROP NOT NULL;

-- CreateTable
CREATE TABLE "funcionario_restaurante" (
    "id" SERIAL NOT NULL,
    "funcID" INTEGER NOT NULL,
    "restID" INTEGER NOT NULL,
    "funcao" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "funcionario_restaurante_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "funcionario_restaurante_funcID_idx" ON "funcionario_restaurante"("funcID");

-- CreateIndex
CREATE INDEX "funcionario_restaurante_restID_idx" ON "funcionario_restaurante"("restID");

-- CreateIndex
CREATE UNIQUE INDEX "funcionario_restaurante_funcID_restID_key" ON "funcionario_restaurante"("funcID", "restID");

-- AddForeignKey
ALTER TABLE "funcionarios" ADD CONSTRAINT "funcionarios_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "funcionario_restaurante" ADD CONSTRAINT "funcionario_restaurante_funcID_fkey" FOREIGN KEY ("funcID") REFERENCES "funcionarios"("funcID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "funcionario_restaurante" ADD CONSTRAINT "funcionario_restaurante_restID_fkey" FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID") ON DELETE CASCADE ON UPDATE CASCADE;
