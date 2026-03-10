CREATE TYPE "EmployeeSplitMode" AS ENUM (
  'EQUAL_SPLIT',
  'PROPORTIONAL_TO_POOL_INPUT',
  'DIRECT_INPUT_ONLY',
  'FULL_RATE_PER_EMPLOYEE'
);

ALTER TABLE "regras_distribuicao"
  ADD COLUMN "split_mode" "EmployeeSplitMode" NOT NULL DEFAULT 'EQUAL_SPLIT';

-- Legacy compatibility:
-- 1) Staff tip-pool percentage rules should split by individual input.
UPDATE "regras_distribuicao"
SET "split_mode" = 'PROPORTIONAL_TO_POOL_INPUT'
WHERE "calculation_type" = 'PERCENT'::"CalculationType"
  AND "calculation_base" = 'VALOR_TOTAL_GORJETAS'::"CalculationBase"
  AND (
    LOWER("role_name") = 'staff'
    OR LOWER("role_name") LIKE '%garcom%'
  );

-- 2) External absolute payments are direct-input driven.
UPDATE "regras_distribuicao"
SET "split_mode" = 'DIRECT_INPUT_ONLY'
WHERE "payment_source" = 'ABSOLUTE_EXTERNAL'::"PaymentSource";
