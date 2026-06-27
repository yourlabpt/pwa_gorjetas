-- Add employee_name and employee_funcao to faturamento_diario_distribuicao
ALTER TABLE "faturamento_diario_distribuicao"
  ADD COLUMN IF NOT EXISTS "employee_name"   TEXT,
  ADD COLUMN IF NOT EXISTS "employee_funcao" TEXT;

-- Backfill from funcionarios (includes soft-deleted employees)
UPDATE "faturamento_diario_distribuicao" d
SET
  "employee_name"   = f."name",
  "employee_funcao" = f."funcao"
FROM "funcionarios" f
WHERE d."funcID" = f."funcID"
  AND d."employee_name" IS NULL;

-- Add employee_name and employee_funcao to acerto_final_entry
ALTER TABLE "acerto_final_entry"
  ADD COLUMN IF NOT EXISTS "employee_name"   TEXT,
  ADD COLUMN IF NOT EXISTS "employee_funcao" TEXT;

-- Backfill from funcionarios (includes soft-deleted employees)
UPDATE "acerto_final_entry" e
SET
  "employee_name"   = f."name",
  "employee_funcao" = f."funcao"
FROM "funcionarios" f
WHERE e."funcID" = f."funcID"
  AND e."employee_name" IS NULL;
