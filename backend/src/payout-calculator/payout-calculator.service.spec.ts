import { calculateDailyPayouts } from './payout-calculator.service';
import {
  CalculationBase,
  CalculationType,
  DayInput,
  PaymentSource,
  PercentMode,
  RoleRule,
} from './payout-calculator.types';

// ─── Shared fixtures ─────────────────────────────────────────────────────────

/** A typical restaurant day: €10 000 gross, €8 000 with tips, €2 000 without.
 *  Tip pool = 11% of €8 000 = €880. */
const BASE_DAY: DayInput = {
  faturamento_global: 10_000,
  faturamento_com_gorjeta: 8_000,
  faturamento_sem_gorjeta: 2_000,
  valor_total_gorjetas: 880,
};

function rule(overrides: Partial<RoleRule> & Pick<RoleRule, 'role_name' | 'calculation_type' | 'rate' | 'payment_source'>): RoleRule {
  return {
    id: 1,
    calculation_base: null,
    ordem: 0,
    ativo: true,
    ...overrides,
  };
}

// ─── Tests ───────────────────────────────────────────────────────────────────

describe('calculateDailyPayouts', () => {
  // ── 1 ──────────────────────────────────────────────────────────────────────
  it('Staff paid from TIP_POOL as % of tip pool', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'staff',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.VALOR_TOTAL_GORJETAS,
        rate: 50, // 50% of €880 = €440
        percent_mode: PercentMode.ABSOLUTE_PERCENT,
        payment_source: PaymentSource.TIP_POOL,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(true);
    expect(result.errors).toHaveLength(0);
    expect(result.role_breakdown[0].theoretical_amount).toBe(440);
    expect(result.role_breakdown[0].paid_amount).toBe(440);
    expect(result.role_breakdown[0].unpaid_amount).toBe(0);
    expect(result.role_breakdown[0].base_value).toBe(880);
    expect(result.bucket_balances.tip_pool_remaining).toBe(440);
    expect(result.totals.total_from_tip_pool).toBe(440);
  });

  it('Staff paid using BASE_PERCENT_POINTS over tip pool base percentage', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'staff',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.VALOR_TOTAL_GORJETAS,
        rate: 5.5, // 5.5 pts of 11% base = 50% of tip pool
        percent_mode: PercentMode.BASE_PERCENT_POINTS,
        payment_source: PaymentSource.TIP_POOL,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY, { base_percentual: 11 });

    expect(result.ok).toBe(true);
    expect(result.errors).toHaveLength(0);
    expect(result.role_breakdown[0].percent_mode).toBe(
      PercentMode.BASE_PERCENT_POINTS,
    );
    expect(result.role_breakdown[0].theoretical_amount).toBe(440);
    expect(result.role_breakdown[0].paid_amount).toBe(440);
    expect(result.bucket_balances.tip_pool_remaining).toBe(440);
  });

  it('Legacy tip-pool % rule without percent_mode defaults to BASE_PERCENT_POINTS', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'staff',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.VALOR_TOTAL_GORJETAS,
        rate: 5.5,
        payment_source: PaymentSource.TIP_POOL,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY, { base_percentual: 11 });

    expect(result.ok).toBe(true);
    expect(result.role_breakdown[0].percent_mode).toBe(
      PercentMode.BASE_PERCENT_POINTS,
    );
    expect(result.role_breakdown[0].paid_amount).toBe(440);
  });

  // ── 2 ──────────────────────────────────────────────────────────────────────
  it('Sub-gerente paid as % of faturamento_com_gorjeta, from TIP_POOL', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'sub-gerente',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.FATURAMENTO_COM_GORJETA,
        rate: 1, // 1% of €8 000 = €80
        payment_source: PaymentSource.TIP_POOL,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(true);
    expect(result.role_breakdown[0].theoretical_amount).toBe(80);
    expect(result.role_breakdown[0].paid_amount).toBe(80);
    expect(result.role_breakdown[0].base_value).toBe(8_000);
    expect(result.bucket_balances.tip_pool_remaining).toBeCloseTo(800, 2);
    expect(result.totals.total_from_tip_pool).toBe(80);
  });

  // ── 3 ──────────────────────────────────────────────────────────────────────
  it('Gerente paid as 1% of faturamento_global, from TIP_POOL remainder', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'staff',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.VALOR_TOTAL_GORJETAS,
        rate: 50, // pays €440 first
        percent_mode: PercentMode.ABSOLUTE_PERCENT,
        payment_source: PaymentSource.TIP_POOL,
        ordem: 1,
      }),
      rule({
        id: 2,
        role_name: 'gerente',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.FATURAMENTO_GLOBAL,
        rate: 1, // 1% of €10 000 = €100
        payment_source: PaymentSource.TIP_POOL,
        ordem: 2,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(true);
    const gerenteLine = result.role_breakdown.find((r) => r.role_name === 'gerente')!;
    expect(gerenteLine.theoretical_amount).toBe(100);
    expect(gerenteLine.paid_amount).toBe(100);
    // Tip pool started at 880, staff took 440, gerente takes 100 → 340 left
    expect(result.bucket_balances.tip_pool_remaining).toBe(340);
    expect(result.totals.total_from_tip_pool).toBe(540);
  });

  // ── 4 ──────────────────────────────────────────────────────────────────────
  it('Chamador paid fixed amount from ABSOLUTE_EXTERNAL — no bucket deduction', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'chamador',
        calculation_type: CalculationType.FIXED_AMOUNT,
        rate: 50,
        payment_source: PaymentSource.ABSOLUTE_EXTERNAL,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(true);
    expect(result.role_breakdown[0].theoretical_amount).toBe(50);
    expect(result.role_breakdown[0].paid_amount).toBe(50);
    expect(result.totals.total_external).toBe(50);
    // Buckets must NOT be touched
    expect(result.bucket_balances.tip_pool_remaining).toBe(BASE_DAY.valor_total_gorjetas);
    expect(result.bucket_balances.financeiro_remaining).toBe(BASE_DAY.faturamento_sem_gorjeta);
  });

  // ── 5 ──────────────────────────────────────────────────────────────────────
  it('Error case: TIP_POOL insufficient — rule is skipped and error recorded', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'staff',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.VALOR_TOTAL_GORJETAS,
        rate: 200, // 200% of €880 = €1 760 — exceeds pool
        percent_mode: PercentMode.ABSOLUTE_PERCENT,
        payment_source: PaymentSource.TIP_POOL,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(false);
    expect(result.errors).toHaveLength(1);
    expect(result.errors[0]).toMatch(/TIP_POOL/);
    expect(result.role_breakdown).toHaveLength(1);
    expect(result.role_breakdown[0].paid_amount).toBe(0);
    expect(result.role_breakdown[0].unpaid_amount).toBe(1760);
    // Bucket must be unchanged
    expect(result.bucket_balances.tip_pool_remaining).toBe(880);
  });

  // ── 6 ──────────────────────────────────────────────────────────────────────
  it('Error case: FINANCEIRO insufficient — rule is skipped and error recorded', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'operacional',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.FATURAMENTO_GLOBAL,
        rate: 50, // 50% of €10 000 = €5 000, FINANCEIRO only has €2 000
        payment_source: PaymentSource.FINANCEIRO,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(false);
    expect(result.errors).toHaveLength(1);
    expect(result.errors[0]).toMatch(/FINANCEIRO/);
    expect(result.role_breakdown).toHaveLength(1);
    expect(result.role_breakdown[0].paid_amount).toBe(0);
    expect(result.role_breakdown[0].unpaid_amount).toBe(5000);
    expect(result.bucket_balances.financeiro_remaining).toBe(2_000);
  });

  // ── 7 ──────────────────────────────────────────────────────────────────────
  it('allowNegativeBalances skips the check and processes the rule anyway', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'opEx',
        calculation_type: CalculationType.PERCENT,
        calculation_base: CalculationBase.FATURAMENTO_GLOBAL,
        rate: 50, // would overdraw FINANCEIRO
        payment_source: PaymentSource.FINANCEIRO,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY, {
      allowNegativeBalances: true,
    });

    expect(result.ok).toBe(true);
    expect(result.role_breakdown).toHaveLength(1);
    expect(result.bucket_balances.financeiro_remaining).toBe(2_000 - 5_000); // -3000
  });

  // ── 8 ──────────────────────────────────────────────────────────────────────
  it('PERCENT rule without calculation_base records error and skips', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'broken',
        calculation_type: CalculationType.PERCENT,
        calculation_base: null, // missing — should error
        rate: 10,
        payment_source: PaymentSource.TIP_POOL,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(false);
    expect(result.errors[0]).toMatch(/calculation_base/);
    expect(result.role_breakdown).toHaveLength(0);
  });

  // ── 9 ──────────────────────────────────────────────────────────────────────
  it('Inactive rules are ignored', () => {
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'inactive_role',
        calculation_type: CalculationType.FIXED_AMOUNT,
        rate: 999,
        payment_source: PaymentSource.TIP_POOL,
        ativo: false,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(true);
    expect(result.role_breakdown).toHaveLength(0);
  });

  // ── 10 ─────────────────────────────────────────────────────────────────────
  it('Rules are processed in ordem order', () => {
    // Pool=880; rule A (ordem=2) wants 500, rule B (ordem=1) wants 500
    // B runs first → takes 500 → pool=380; A then tries 500 → fails
    const rules: RoleRule[] = [
      rule({
        id: 1,
        role_name: 'A',
        calculation_type: CalculationType.FIXED_AMOUNT,
        rate: 500,
        payment_source: PaymentSource.TIP_POOL,
        ordem: 2,
      }),
      rule({
        id: 2,
        role_name: 'B',
        calculation_type: CalculationType.FIXED_AMOUNT,
        rate: 500,
        payment_source: PaymentSource.TIP_POOL,
        ordem: 1,
      }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(false);
    expect(result.role_breakdown).toHaveLength(2);
    expect(result.role_breakdown[0].role_name).toBe('B'); // B ran first
    expect(result.role_breakdown[0].paid_amount).toBe(500);
    expect(result.role_breakdown[1].role_name).toBe('A');
    expect(result.role_breakdown[1].paid_amount).toBe(0);
    expect(result.errors[0]).toMatch(/A/);
  });

  // ── 11 ─────────────────────────────────────────────────────────────────────
  it('Mixed sources: TIP_POOL + FINANCEIRO + ABSOLUTE_EXTERNAL totals are correct', () => {
    const rules: RoleRule[] = [
      rule({ id: 1, role_name: 'staff',     calculation_type: CalculationType.FIXED_AMOUNT, rate: 200, payment_source: PaymentSource.TIP_POOL }),
      rule({ id: 2, role_name: 'manager',   calculation_type: CalculationType.FIXED_AMOUNT, rate: 100, payment_source: PaymentSource.FINANCEIRO }),
      rule({ id: 3, role_name: 'chamador',  calculation_type: CalculationType.FIXED_AMOUNT, rate: 50,  payment_source: PaymentSource.ABSOLUTE_EXTERNAL }),
    ];

    const result = calculateDailyPayouts(rules, BASE_DAY);

    expect(result.ok).toBe(true);
    expect(result.totals.total_from_tip_pool).toBe(200);
    expect(result.totals.total_from_financeiro).toBe(100);
    expect(result.totals.total_external).toBe(50);
    expect(result.totals.total_payout).toBe(350);
    expect(result.bucket_balances.tip_pool_remaining).toBe(680);
    expect(result.bucket_balances.financeiro_remaining).toBe(1_900);
  });
});
