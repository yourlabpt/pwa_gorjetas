-- Ensure legacy databases also support the new split mode used by the UI:
-- "Percentual completo por colaborador" => FULL_RATE_PER_EMPLOYEE
ALTER TYPE "EmployeeSplitMode"
  ADD VALUE IF NOT EXISTS 'FULL_RATE_PER_EMPLOYEE';
