// ============================================================
// Payout Calculator — shared types
// Used by both the pure calculation function and the NestJS service.
// ============================================================

export enum CalculationType {
  PERCENT = 'PERCENT',
  FIXED_AMOUNT = 'FIXED_AMOUNT',
}

export enum CalculationBase {
  FATURAMENTO_GLOBAL = 'FATURAMENTO_GLOBAL',
  FATURAMENTO_COM_GORJETA = 'FATURAMENTO_COM_GORJETA',
  FATURAMENTO_SEM_GORJETA = 'FATURAMENTO_SEM_GORJETA',
  // In FinanceEngine, when combined with PROPORTIONAL_TO_POOL_INPUT,
  // this base can be interpreted from per-employee pool inputs (input-first).
  VALOR_TOTAL_GORJETAS = 'VALOR_TOTAL_GORJETAS',
}

export enum PaymentSource {
  TIP_POOL = 'TIP_POOL',
  FINANCEIRO = 'FINANCEIRO',
  ABSOLUTE_EXTERNAL = 'ABSOLUTE_EXTERNAL',
}

export enum PercentMode {
  ABSOLUTE_PERCENT = 'ABSOLUTE_PERCENT',
  BASE_PERCENT_POINTS = 'BASE_PERCENT_POINTS',
}

export enum EmployeeSplitMode {
  EQUAL_SPLIT = 'EQUAL_SPLIT',
  PROPORTIONAL_TO_POOL_INPUT = 'PROPORTIONAL_TO_POOL_INPUT',
  DIRECT_INPUT_ONLY = 'DIRECT_INPUT_ONLY',
  FULL_RATE_PER_EMPLOYEE = 'FULL_RATE_PER_EMPLOYEE',
}

export enum SettlementType {
  DIARIO = 'DIARIO',
  PERIODO = 'PERIODO',
}

export type InsufficientFundsPolicy = 'SKIP' | 'PARTIAL';

/** A single configured rule for a role in a restaurant. */
export interface RoleRule {
  id: number;
  role_name: string;
  calculation_type: CalculationType;
  /** Required when calculation_type = PERCENT. */
  calculation_base?: CalculationBase | null;
  /** Percentage (e.g., 1.5 means 1.5%) or absolute currency amount. */
  rate: number;
  /**
   * For PERCENT rules:
   * - ABSOLUTE_PERCENT: rate% sobre a base monetária.
   * - BASE_PERCENT_POINTS: rate pontos sobre a percentagem base do restaurante.
   */
  percent_mode?: PercentMode;
  /**
   * How this role payout is split across employees in the same role.
   */
  split_mode?: EmployeeSplitMode;
  tipo_de_acerto?: SettlementType;
  payment_source: PaymentSource;
  /** Processing order — lower values are processed first. */
  ordem: number;
  ativo?: boolean;
}

/** Daily revenue/tip bucket inputs required for calculation. */
export interface DayInput {
  /** Total gross revenue for the day. */
  faturamento_global: number;
  /** Revenue from tables/orders that included a tip. */
  faturamento_com_gorjeta: number;
  /** Revenue from tables/orders with no tip. */
  faturamento_sem_gorjeta: number;
  /** Actual tip pool money available for distribution. */
  valor_total_gorjetas: number;
}

/** Breakdown line for a single role rule. */
export interface RoleBreakdown {
  rule_id: number;
  role_name: string;
  calculation_type: CalculationType;
  /** Pool used for calculation (if calculation_type=PERCENT). */
  calculation_pool: CalculationBase | null;
  /** Percentage interpretation mode for PERCENT rules. */
  percent_mode: PercentMode;
  /** Employee-level split mode used for this role line. */
  split_mode: EmployeeSplitMode;
  /** Pool used for payment deduction. */
  payment_pool: PaymentSource;
  /** The rate as configured (% or fixed). */
  rate: number;
  /** The monetary base used to compute this rule. */
  base_value: number;
  /** Theoretical value from the rule formula before pool constraints. */
  theoretical_amount: number;
  /** Real paid value after pool-availability constraints. */
  paid_amount: number;
  /** Unpaid amount due to insufficient payment pool (if any). */
  unpaid_amount: number;

  /** Backward-compatible alias for historical consumers (equals paid_amount). */
  role_amount: number;
}

/** Bucket balance snapshot after all rules are applied. */
export interface BucketBalances {
  tip_pool_initial: number;
  tip_pool_remaining: number;
  financeiro_initial: number;
  financeiro_remaining: number;
}

/** Full result returned by calculateDailyPayouts(). */
export interface PayoutResult {
  role_breakdown: RoleBreakdown[];
  bucket_balances: BucketBalances;
  totals: {
    total_theoretical: number;
    total_payout: number;
    total_unpaid: number;
    total_from_tip_pool: number;
    total_from_financeiro: number;
    total_external: number;
  };
  /** Human-readable error messages; non-empty when ok=false. */
  errors: string[];
  ok: boolean;
}
