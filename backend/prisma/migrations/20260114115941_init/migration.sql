-- DropIndex
DROP INDEX "funcionarios_restID_funcao_key";

-- CreateIndex
CREATE INDEX "funcionarios_restID_funcao_idx" ON "funcionarios"("restID", "funcao");
