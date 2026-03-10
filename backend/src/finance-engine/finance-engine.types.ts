import {
  CalculationBase,
  CalculationType,
  DayInput,
  EmployeeSplitMode,
  InsufficientFundsPolicy,
  PaymentSource,
  PercentMode,
  PayoutResult,
} from '../payout-calculator/payout-calculator.types';

export interface EmployeePayoutLine {
  rule_id: number;
  role_name: string;
  role_bucket: string;
  funcID: number | null;
  employee_name: string | null;
  calculation_type: CalculationType;
  calculation_pool: CalculationBase | null;
  percent_mode: PercentMode;
  split_mode: EmployeeSplitMode;
  payment_pool: PaymentSource;
  rate: number;
  theoretical_value: number;
  real_paid_value: number;
  unpaid_value: number;
}

export interface DailyFinanceComputation extends PayoutResult {
  restID: number;
  input: DayInput;
  regras_count: number;
  employee_breakdown: EmployeePayoutLine[];
}

export interface FinanceEngineComputeOptions {
  allowNegativeBalances?: boolean;
  insufficientFundsPolicy?: InsufficientFundsPolicy;
  data?: Date | string;
  /** Legacy compatibility field; no TIP_POOL deduction is applied from this. */
  staff_direct_tip_pool_total?: number;
  base_percentual?: number;
  staff_inputs?: Array<{
    funcID: number;
    valor_pool?: number;
    valor_direto?: number;
  }>;
}
