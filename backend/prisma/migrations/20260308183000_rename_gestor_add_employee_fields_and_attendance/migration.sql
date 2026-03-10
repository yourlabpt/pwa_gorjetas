-- Rename role enum value from GESTOR to GERENTE (safe/idempotent)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_enum e
    JOIN pg_type t ON t.oid = e.enumtypid
    WHERE t.typname = 'UserRole'
      AND e.enumlabel = 'GESTOR'
  )
  AND NOT EXISTS (
    SELECT 1
    FROM pg_enum e
    JOIN pg_type t ON t.oid = e.enumtypid
    WHERE t.typname = 'UserRole'
      AND e.enumlabel = 'GERENTE'
  ) THEN
    ALTER TYPE "UserRole" RENAME VALUE 'GESTOR' TO 'GERENTE';
  END IF;
END $$;

ALTER TABLE "users"
  ALTER COLUMN "role" SET DEFAULT 'GERENTE';

-- Add optional employee fields
ALTER TABLE "funcionarios"
  ADD COLUMN IF NOT EXISTS "data_admissao" DATE,
  ADD COLUMN IF NOT EXISTS "iban" TEXT,
  ADD COLUMN IF NOT EXISTS "salario" DECIMAL(12,2);

-- Attendance by employee/day
CREATE TABLE IF NOT EXISTS "funcionario_presenca_diaria" (
  "id" SERIAL NOT NULL,
  "restID" INTEGER NOT NULL,
  "data" DATE NOT NULL,
  "funcID" INTEGER NOT NULL,
  "presente" BOOLEAN NOT NULL DEFAULT false,
  "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "atualizadoEm" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "funcionario_presenca_diaria_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "funcionario_presenca_diaria_restID_data_funcID_key"
  ON "funcionario_presenca_diaria"("restID", "data", "funcID");

CREATE INDEX IF NOT EXISTS "funcionario_presenca_diaria_restID_data_idx"
  ON "funcionario_presenca_diaria"("restID", "data");

CREATE INDEX IF NOT EXISTS "funcionario_presenca_diaria_funcID_idx"
  ON "funcionario_presenca_diaria"("funcID");

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'funcionario_presenca_diaria_restID_fkey'
  ) THEN
    ALTER TABLE "funcionario_presenca_diaria"
      ADD CONSTRAINT "funcionario_presenca_diaria_restID_fkey"
      FOREIGN KEY ("restID") REFERENCES "restaurantes"("restID")
      ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'funcionario_presenca_diaria_funcID_fkey'
  ) THEN
    ALTER TABLE "funcionario_presenca_diaria"
      ADD CONSTRAINT "funcionario_presenca_diaria_funcID_fkey"
      FOREIGN KEY ("funcID") REFERENCES "funcionarios"("funcID")
      ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;

-- Normalize legacy text role names in business tables
UPDATE "funcionarios"
SET "funcao" = regexp_replace("funcao", 'gestor', 'gerente', 'gi')
WHERE "funcao" ~* 'gestor';

UPDATE "regras_distribuicao"
SET "role_name" = regexp_replace("role_name", 'gestor', 'gerente', 'gi')
WHERE "role_name" ~* 'gestor';

UPDATE "faturamento_diario_distribuicao"
SET "role" = regexp_replace("role", 'gestor', 'gerente', 'gi')
WHERE "role" ~* 'gestor';

UPDATE "configuracao_acerto"
SET "funcao" = regexp_replace("funcao", 'gestor', 'gerente', 'gi')
WHERE "funcao" ~* 'gestor';

UPDATE "acerto_funcionario"
SET "funcao" = regexp_replace("funcao", 'gestor', 'gerente', 'gi')
WHERE "funcao" ~* 'gestor';
