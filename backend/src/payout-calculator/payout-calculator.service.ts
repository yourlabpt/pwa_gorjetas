import { Injectable } from '@nestjs/common';
import {
  CalculationBase,
  CalculationType,
  DayInput,
  EmployeeSplitMode,
  InsufficientFundsPolicy,
  PaymentSource,
  PercentMode,
  PayoutResult,
  RoleBreakdown,
  RoleRule,
} from './payout-calculator.types';

// ─── Helper ──────────────────────────────────────────────────────────────────

function round2(val: number): number {
  return Math.round(val * 100) / 100;
}

// ─── Pure calculation function ────────────────────────────────────────────────

/**
 * Pure, deterministic, idempotent function that computes daily role payouts
 * given a list of role rules and the day's financial buckets.
 *
 * Rules are processed in ascending `ordem` order.
 * Each rule either deducts from TIP_POOL, FINANCEIRO, or is external.
 * When allowNegativeBalances=false (default) any rule that would overdraw
 * its bucket is skipped and an error is recorded.
 *
 * @param rules    Active role rules for the restaurant.
 * @param dayInput Daily revenue/tip bucket values.
 * @param options  Extra flags (allowNegativeBalances).
 */
export function calculateDailyPayouts(
  rules: RoleRule[],
  dayInput: DayInput,
  options: {
    allowNegativeBalances?: boolean;
    insufficientFundsPolicy?: InsufficientFundsPolicy;
    base_percentual?: number;
  } = {},
): PayoutResult {
  const { allowNegativeBalances = false } = options;
  const insufficientFundsPolicy = options.insufficientFundsPolicy ?? 'SKIP';
  const errors: string[] = [];

  // Work only with active rules, sorted by processing order.
  const sortedRules = [...rules]
    .filter((r) => r.ativo !== false)
    .sort((a, b) => a.ordem - b.ordem);

  let tipPoolRemaining = dayInput.valor_total_gorjetas;
  let financeiroRemaining = dayInput.faturamento_sem_gorjeta;
  const roleBreakdown: RoleBreakdown[] = [];

  for (const rule of sortedRules) {
    // ── Validate rule ──────────────────────────────────────────────────────
    if (
      rule.calculation_type === CalculationType.PERCENT &&
      !rule.calculation_base
    ) {
      errors.push(
        `Regra "${rule.role_name}" (id=${rule.id}): ` +
          `calculation_base é obrigatório quando calculation_type=PERCENT.`,
      );
      continue;
    }

    // ── Resolve base monetary value ────────────────────────────────────────
    let baseValue = 0;

    if (rule.calculation_type === CalculationType.PERCENT) {
      switch (rule.calculation_base!) {
        case CalculationBase.FATURAMENTO_GLOBAL:
          baseValue = dayInput.faturamento_global;
          break;
        case CalculationBase.FATURAMENTO_COM_GORJETA:
          baseValue = dayInput.faturamento_com_gorjeta;
          break;
        case CalculationBase.FATURAMENTO_SEM_GORJETA:
          baseValue = dayInput.faturamento_sem_gorjeta;
          break;
        case CalculationBase.VALOR_TOTAL_GORJETAS:
          baseValue = dayInput.valor_total_gorjetas;
          break;
      }
    }

    // ── Compute payout ─────────────────────────────────────────────────────
    let roleAmount: number;

    const percentMode =
      rule.percent_mode ??
      (rule.calculation_base === CalculationBase.VALOR_TOTAL_GORJETAS
        ? PercentMode.BASE_PERCENT_POINTS
        : PercentMode.ABSOLUTE_PERCENT);
    const splitMode = rule.split_mode ?? EmployeeSplitMode.EQUAL_SPLIT;

    if (rule.calculation_type === CalculationType.PERCENT) {
      if (percentMode === PercentMode.BASE_PERCENT_POINTS) {
        const basePercentual = Number(options.base_percentual || 0);
        if (basePercentual <= 0) {
          errors.push(
            `Regra "${rule.role_name}" (id=${rule.id}): base_percentual do restaurante é obrigatório ` +
              `quando percent_mode=BASE_PERCENT_POINTS.`,
          );
          continue;
        }
        roleAmount = round2(baseValue * (rule.rate / basePercentual));
      } else {
        roleAmount = round2(baseValue * (rule.rate / 100));
      }
    } else {
      // FIXED_AMOUNT: rate IS the amount
      roleAmount = round2(rule.rate);
      baseValue = roleAmount;
    }

    // ── Apply to payment source bucket ─────────────────────────────────────
    const theoreticalAmount = roleAmount;
    let paidAmount = theoreticalAmount;
    let unpaidAmount = 0;

    if (rule.payment_source === PaymentSource.TIP_POOL) {
      const available = tipPoolRemaining;
      if (allowNegativeBalances) {
        tipPoolRemaining = tipPoolRemaining - theoreticalAmount;
      } else if (available >= theoreticalAmount) {
        tipPoolRemaining = tipPoolRemaining - theoreticalAmount;
      } else if (insufficientFundsPolicy === 'PARTIAL' && available > 0) {
        paidAmount = round2(available);
        unpaidAmount = round2(theoreticalAmount - paidAmount);
        tipPoolRemaining = round2(tipPoolRemaining - paidAmount);
        errors.push(
          `TIP_POOL insuficiente para "${rule.role_name}" (id=${rule.id}). ` +
            `Pago parcial: €${paidAmount.toFixed(2)} de €${theoreticalAmount.toFixed(2)}.`,
        );
      } else {
        paidAmount = 0;
        unpaidAmount = theoreticalAmount;
        errors.push(
          `Saldo insuficiente no TIP_POOL para "${rule.role_name}" ` +
            `(id=${rule.id}): disponível €${available.toFixed(2)}, ` +
            `requerido €${theoreticalAmount.toFixed(2)}.`,
        );
      }
    } else if (rule.payment_source === PaymentSource.FINANCEIRO) {
      const available = financeiroRemaining;
      if (allowNegativeBalances) {
        financeiroRemaining = financeiroRemaining - theoreticalAmount;
      } else if (available >= theoreticalAmount) {
        financeiroRemaining = financeiroRemaining - theoreticalAmount;
      } else if (insufficientFundsPolicy === 'PARTIAL' && available > 0) {
        paidAmount = round2(available);
        unpaidAmount = round2(theoreticalAmount - paidAmount);
        financeiroRemaining = round2(financeiroRemaining - paidAmount);
        errors.push(
          `FINANCEIRO insuficiente para "${rule.role_name}" (id=${rule.id}). ` +
            `Pago parcial: €${paidAmount.toFixed(2)} de €${theoreticalAmount.toFixed(2)}.`,
        );
      } else {
        paidAmount = 0;
        unpaidAmount = theoreticalAmount;
        errors.push(
          `Saldo insuficiente no FINANCEIRO para "${rule.role_name}" ` +
            `(id=${rule.id}): disponível €${available.toFixed(2)}, ` +
            `requerido €${theoreticalAmount.toFixed(2)}.`,
        );
      }
    }
    // ABSOLUTE_EXTERNAL: no bucket deduction. Always paid in full.

    roleBreakdown.push({
      rule_id: rule.id,
      role_name: rule.role_name,
      calculation_type: rule.calculation_type,
      calculation_pool: rule.calculation_base ?? null,
      percent_mode: percentMode,
      split_mode: splitMode,
      payment_pool: rule.payment_source,
      rate: rule.rate,
      base_value: baseValue,
      theoretical_amount: theoreticalAmount,
      paid_amount: paidAmount,
      unpaid_amount: unpaidAmount,
      role_amount: paidAmount,
    });
  }

  const totalTheoretical = round2(
    roleBreakdown.reduce((sum, r) => sum + r.theoretical_amount, 0),
  );
  const totalPaid = round2(
    roleBreakdown.reduce((sum, r) => sum + r.paid_amount, 0),
  );
  const totalUnpaid = round2(
    roleBreakdown.reduce((sum, r) => sum + r.unpaid_amount, 0),
  );

  const totalFromTipPool = round2(
    roleBreakdown
      .filter((r) => r.payment_pool === PaymentSource.TIP_POOL)
      .reduce((sum, r) => sum + r.paid_amount, 0),
  );
  const totalFromFinanceiro = round2(
    roleBreakdown
      .filter((r) => r.payment_pool === PaymentSource.FINANCEIRO)
      .reduce((sum, r) => sum + r.paid_amount, 0),
  );
  const totalExternal = round2(
    roleBreakdown
      .filter((r) => r.payment_pool === PaymentSource.ABSOLUTE_EXTERNAL)
      .reduce((sum, r) => sum + r.paid_amount, 0),
  );

  return {
    role_breakdown: roleBreakdown,
    bucket_balances: {
      tip_pool_initial: dayInput.valor_total_gorjetas,
      tip_pool_remaining: round2(tipPoolRemaining),
      financeiro_initial: dayInput.faturamento_sem_gorjeta,
      financeiro_remaining: round2(financeiroRemaining),
    },
    totals: {
      total_theoretical: totalTheoretical,
      total_payout: totalPaid,
      total_unpaid: totalUnpaid,
      total_from_tip_pool: totalFromTipPool,
      total_from_financeiro: totalFromFinanceiro,
      total_external: totalExternal,
    },
    errors,
    ok: errors.length === 0,
  };
}

// ─── NestJS injectable service wrapper ───────────────────────────────────────

@Injectable()
export class PayoutCalculatorService {
  calculate(
    rules: RoleRule[],
    dayInput: DayInput,
    options: {
      allowNegativeBalances?: boolean;
      insufficientFundsPolicy?: InsufficientFundsPolicy;
      base_percentual?: number;
    } = {},
  ): PayoutResult {
    return calculateDailyPayouts(rules, dayInput, options);
  }
}
