import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { PayoutCalculatorService } from '../payout-calculator/payout-calculator.service';
import {
  CalculationBase,
  CalculationType,
  DayInput,
  EmployeeSplitMode,
  PaymentSource,
  PercentMode,
  RoleBreakdown,
  RoleRule,
} from '../payout-calculator/payout-calculator.types';
import {
  DailyFinanceComputation,
  EmployeePayoutLine,
  FinanceEngineComputeOptions,
} from './finance-engine.types';

@Injectable()
export class FinanceEngineService {
  constructor(
    private prisma: PrismaService,
    private payoutCalculator: PayoutCalculatorService,
  ) {}

  async computeDailyPayouts(
    restID: number,
    input: DayInput,
    options: FinanceEngineComputeOptions = {},
  ): Promise<DailyFinanceComputation> {
    const funcionarios = await this.prisma.funcionario.findMany({
      where: { restID, ativo: true },
      select: {
        funcID: true,
        name: true,
        funcao: true,
      },
      orderBy: { createdAt: 'asc' },
    });

    const regras = await this.prisma.regraDistribuicao.findMany({
      where: { restID, ativo: true },
      orderBy: { ordem: 'asc' },
    });

    const rules: RoleRule[] = [];
    for (const r of regras) {
      const splitMode = this.resolveSplitModeForRule(r as any);
      const baseRule: RoleRule = {
        id: r.id,
        role_name: r.role_name,
        calculation_type: r.calculation_type as any,
        calculation_base: (r.calculation_base as any) ?? null,
        rate: Number(r.rate),
        percent_mode: this.resolvePercentModeForRule(r as any),
        split_mode: splitMode,
        tipo_de_acerto: (r as any).tipo_de_acerto ?? undefined,
        payment_source: r.payment_source as any,
        ordem: r.ordem,
        ativo: r.ativo,
      };

      if (splitMode === EmployeeSplitMode.FULL_RATE_PER_EMPLOYEE) {
        const matchedCount = funcionarios.filter((f) =>
          this.isRoleMatch(baseRule.role_name, f.funcao),
        ).length;
        const copies = Math.max(matchedCount, 1);
        for (let i = 0; i < copies; i += 1) {
          rules.push({ ...baseRule });
        }
        continue;
      }

      rules.push(baseRule);
    }

    const staffPoolInputByFuncID = new Map<number, number>(
      (options.staff_inputs || []).map((entry) => [
        Number(entry.funcID),
        this.round2(Math.max(Number(entry.valor_pool || 0), 0)),
      ]),
    );
    const directInputByFuncID = new Map<number, number>(
      (options.staff_inputs || []).map((entry) => [
        Number(entry.funcID),
        this.round2(Math.max(Number(entry.valor_direto || 0), 0)),
      ]),
    );
    const result = this.payoutCalculator.calculate(rules, input, options);
    const recomputed = this.recomputeRoleLinesAndBuckets(
      result.role_breakdown || [],
      funcionarios,
      staffPoolInputByFuncID,
      input,
      options,
    );
    const roleBreakdown: RoleBreakdown[] = [...recomputed.role_breakdown];
    const tipPoolInitial = this.round2(
      recomputed.bucket_balances.tip_pool_initial ??
        input.valor_total_gorjetas ??
        0,
    );
    const tipPoolRemainingAfterRules = this.round2(
      Math.max(recomputed.bucket_balances.tip_pool_remaining ?? 0, 0),
    );
    const tipPoolCoveredBuckets = new Set(
      roleBreakdown
        .filter(
          (line) =>
            line.payment_pool === PaymentSource.TIP_POOL &&
            Number(line.paid_amount || 0) > 0,
        )
        .map((line) => this.toRoleBucket(line.role_name)),
    );
    const remainderFallback = this.buildKitchenBarRemainderLines(
      tipPoolRemainingAfterRules,
      tipPoolCoveredBuckets,
      funcionarios,
    );
    if (remainderFallback.lines.length) {
      roleBreakdown.push(...remainderFallback.lines);
    }

    const employeeBreakdown: EmployeePayoutLine[] = [];

    for (const roleLine of roleBreakdown) {
      const matchedEmployees = funcionarios.filter((f) =>
        this.isRoleMatch(roleLine.role_name, f.funcao),
      );
      const splitMode = roleLine.split_mode ?? EmployeeSplitMode.EQUAL_SPLIT;
      let lineTheoretical = Number(roleLine.theoretical_amount || 0);
      let linePaid = Number(roleLine.paid_amount || 0);
      let lineUnpaid = Number(roleLine.unpaid_amount || 0);

      const directValues = matchedEmployees.map(
        (emp) => directInputByFuncID.get(emp.funcID) ?? 0,
      );
      const totalDirectInput = this.round2(
        directValues.reduce((sum, value) => sum + value, 0),
      );

      if (
        splitMode === EmployeeSplitMode.DIRECT_INPUT_ONLY &&
        matchedEmployees.length > 0 &&
        totalDirectInput > 0
      ) {
        lineTheoretical = totalDirectInput;
        linePaid = totalDirectInput;
        lineUnpaid = 0;
        roleLine.base_value = totalDirectInput;
        roleLine.theoretical_amount = totalDirectInput;
        roleLine.paid_amount = totalDirectInput;
        roleLine.unpaid_amount = 0;
        roleLine.role_amount = totalDirectInput;
      }

      const canUseWeightedPoolSplit =
        splitMode === EmployeeSplitMode.PROPORTIONAL_TO_POOL_INPUT &&
        matchedEmployees.length > 0;
      const poolWeights = canUseWeightedPoolSplit
        ? matchedEmployees.map(
            (emp) => staffPoolInputByFuncID.get(emp.funcID) ?? 0,
          )
        : [];
      const canUseDirectInputSplit =
        splitMode === EmployeeSplitMode.DIRECT_INPUT_ONLY &&
        matchedEmployees.length > 0 &&
        totalDirectInput > 0;

      const theoreticalSplit = canUseDirectInputSplit
        ? this.normalizeValuesToTotal(directValues, lineTheoretical)
        : canUseWeightedPoolSplit
          ? this.splitAmountByWeights(lineTheoretical, poolWeights)
          : this.splitAmount(lineTheoretical, matchedEmployees.length || 1);
      const paidSplit = canUseDirectInputSplit
        ? this.normalizeValuesToTotal(directValues, linePaid)
        : canUseWeightedPoolSplit
          ? this.splitAmountByWeights(linePaid, poolWeights)
          : this.splitAmount(linePaid, matchedEmployees.length || 1);
      const unpaidSplit = canUseDirectInputSplit
        ? this.splitAmount(0, matchedEmployees.length || 1)
        : canUseWeightedPoolSplit
          ? this.splitAmountByWeights(lineUnpaid, poolWeights)
          : this.splitAmount(lineUnpaid, matchedEmployees.length || 1);

      if (matchedEmployees.length === 0) {
        employeeBreakdown.push({
          rule_id: roleLine.rule_id,
          role_name: roleLine.role_name,
          role_bucket: this.toRoleBucket(roleLine.role_name),
          funcID: null,
          employee_name: null,
          calculation_type: roleLine.calculation_type,
          calculation_pool: roleLine.calculation_pool,
          percent_mode: roleLine.percent_mode,
          split_mode: splitMode,
          payment_pool: roleLine.payment_pool,
          rate: roleLine.rate,
          theoretical_value: theoreticalSplit[0],
          real_paid_value: paidSplit[0],
          unpaid_value: unpaidSplit[0],
        });
        continue;
      }

      matchedEmployees.forEach((emp, idx) => {
        employeeBreakdown.push({
          rule_id: roleLine.rule_id,
          role_name: roleLine.role_name,
          role_bucket: this.toRoleBucket(roleLine.role_name),
          funcID: emp.funcID,
          employee_name: emp.name,
          calculation_type: roleLine.calculation_type,
          calculation_pool: roleLine.calculation_pool,
          percent_mode: roleLine.percent_mode,
          split_mode: splitMode,
          payment_pool: roleLine.payment_pool,
          rate: roleLine.rate,
          theoretical_value: theoreticalSplit[idx],
          real_paid_value: paidSplit[idx],
          unpaid_value: unpaidSplit[idx],
        });
      });
    }

    const totals = this.rebuildTotals(roleBreakdown);
    const finalTipPoolRemaining = this.round2(
      Math.max(tipPoolRemainingAfterRules - remainderFallback.distributed, 0),
    );
    const expectedFromPool = this.round2(
      tipPoolInitial - finalTipPoolRemaining,
    );
    const poolDelta = this.round2(totals.total_from_tip_pool - expectedFromPool);
    const errors = [
      ...result.errors.filter((msg) => !this.isInsufficientFundsError(msg)),
      ...recomputed.errors,
    ];

    if (Math.abs(poolDelta) > 0.02) {
      errors.push(
        `Inconsistência no pool de gorjetas: distribuído €${totals.total_from_tip_pool.toFixed(2)} ` +
          `vs esperado €${expectedFromPool.toFixed(2)} (delta €${poolDelta.toFixed(2)}).`,
      );
    }

    return {
      role_breakdown: roleBreakdown,
      bucket_balances: {
        tip_pool_initial: tipPoolInitial,
        tip_pool_remaining: finalTipPoolRemaining,
        financeiro_initial: this.round2(
          recomputed.bucket_balances.financeiro_initial ??
            input.faturamento_sem_gorjeta ??
            0,
        ),
        financeiro_remaining: this.round2(
          recomputed.bucket_balances.financeiro_remaining ??
            input.faturamento_sem_gorjeta ??
            0,
        ),
      },
      totals,
      errors,
      ok: errors.length === 0,
      restID,
      input,
      regras_count: rules.length,
      employee_breakdown: employeeBreakdown,
    };
  }

  private isInsufficientFundsError(message: string): boolean {
    return (
      message.includes('TIP_POOL insuficiente') ||
      message.includes('FINANCEIRO insuficiente') ||
      message.includes('Saldo insuficiente no TIP_POOL') ||
      message.includes('Saldo insuficiente no FINANCEIRO')
    );
  }

  private recomputeRoleLinesAndBuckets(
    roleBreakdown: RoleBreakdown[],
    funcionarios: Array<{ funcID: number; name: string; funcao: string }>,
    staffPoolInputByFuncID: Map<number, number>,
    input: DayInput,
    options: FinanceEngineComputeOptions,
  ): {
    role_breakdown: RoleBreakdown[];
    bucket_balances: {
      tip_pool_initial: number;
      tip_pool_remaining: number;
      financeiro_initial: number;
      financeiro_remaining: number;
    };
    errors: string[];
  } {
    const allowNegativeBalances = options.allowNegativeBalances ?? false;
    const insufficientFundsPolicy = options.insufficientFundsPolicy ?? 'SKIP';
    let tipPoolRemaining = this.round2(input.valor_total_gorjetas ?? 0);
    let financeiroRemaining = this.round2(input.faturamento_sem_gorjeta ?? 0);
    const basePercentual = this.round2(Math.max(Number(options.base_percentual || 0), 0));
    const recomputedErrors: string[] = [];

    const recomputedLines = roleBreakdown.map((original) => {
      const line: RoleBreakdown = { ...original };
      const matchedEmployees = funcionarios.filter((f) =>
        this.isRoleMatch(line.role_name, f.funcao),
      );
      const splitMode = line.split_mode ?? EmployeeSplitMode.EQUAL_SPLIT;

      let lineBaseValue = this.round2(Math.max(Number(line.base_value || 0), 0));
      let lineTheoretical = this.round2(
        Math.max(Number(line.theoretical_amount || 0), 0),
      );

      if (
        this.shouldUseInputFirstTipPoolComputation(line, splitMode) &&
        matchedEmployees.length > 0
      ) {
        const poolInputs = matchedEmployees.map(
          (emp) => staffPoolInputByFuncID.get(emp.funcID) ?? 0,
        );
        lineBaseValue = this.round2(
          poolInputs.reduce((sum, value) => sum + Math.max(Number(value || 0), 0), 0),
        );
        lineTheoretical = this.computeInputFirstTheoreticalAmount(
          poolInputs,
          line.rate,
          line.percent_mode,
          basePercentual,
        );
      }

      let linePaid = lineTheoretical;
      let lineUnpaid = 0;

      if (line.payment_pool === PaymentSource.TIP_POOL) {
        const available = tipPoolRemaining;
        if (allowNegativeBalances) {
          tipPoolRemaining = this.round2(tipPoolRemaining - lineTheoretical);
        } else if (available >= lineTheoretical) {
          tipPoolRemaining = this.round2(tipPoolRemaining - lineTheoretical);
        } else if (insufficientFundsPolicy === 'PARTIAL' && available > 0) {
          linePaid = this.round2(available);
          lineUnpaid = this.round2(lineTheoretical - linePaid);
          tipPoolRemaining = this.round2(tipPoolRemaining - linePaid);
          recomputedErrors.push(
            `TIP_POOL insuficiente para "${line.role_name}" (id=${line.rule_id}). ` +
              `Pago parcial: €${linePaid.toFixed(2)} de €${lineTheoretical.toFixed(2)}.`,
          );
        } else {
          linePaid = 0;
          lineUnpaid = lineTheoretical;
          recomputedErrors.push(
            `Saldo insuficiente no TIP_POOL para "${line.role_name}" ` +
              `(id=${line.rule_id}): disponível €${available.toFixed(2)}, ` +
              `requerido €${lineTheoretical.toFixed(2)}.`,
          );
        }
      } else if (line.payment_pool === PaymentSource.FINANCEIRO) {
        const available = financeiroRemaining;
        if (allowNegativeBalances) {
          financeiroRemaining = this.round2(financeiroRemaining - lineTheoretical);
        } else if (available >= lineTheoretical) {
          financeiroRemaining = this.round2(financeiroRemaining - lineTheoretical);
        } else if (insufficientFundsPolicy === 'PARTIAL' && available > 0) {
          linePaid = this.round2(available);
          lineUnpaid = this.round2(lineTheoretical - linePaid);
          financeiroRemaining = this.round2(financeiroRemaining - linePaid);
          recomputedErrors.push(
            `FINANCEIRO insuficiente para "${line.role_name}" (id=${line.rule_id}). ` +
              `Pago parcial: €${linePaid.toFixed(2)} de €${lineTheoretical.toFixed(2)}.`,
          );
        } else {
          linePaid = 0;
          lineUnpaid = lineTheoretical;
          recomputedErrors.push(
            `Saldo insuficiente no FINANCEIRO para "${line.role_name}" ` +
              `(id=${line.rule_id}): disponível €${available.toFixed(2)}, ` +
              `requerido €${lineTheoretical.toFixed(2)}.`,
          );
        }
      }

      line.base_value = lineBaseValue;
      line.theoretical_amount = lineTheoretical;
      line.paid_amount = linePaid;
      line.unpaid_amount = lineUnpaid;
      line.role_amount = linePaid;

      return line;
    });

    return {
      role_breakdown: recomputedLines,
      bucket_balances: {
        tip_pool_initial: this.round2(input.valor_total_gorjetas ?? 0),
        tip_pool_remaining: this.round2(tipPoolRemaining),
        financeiro_initial: this.round2(input.faturamento_sem_gorjeta ?? 0),
        financeiro_remaining: this.round2(financeiroRemaining),
      },
      errors: recomputedErrors,
    };
  }

  private shouldUseInputFirstTipPoolComputation(
    line: RoleBreakdown,
    splitMode: EmployeeSplitMode,
  ): boolean {
    return (
      splitMode === EmployeeSplitMode.PROPORTIONAL_TO_POOL_INPUT &&
      line.calculation_type === CalculationType.PERCENT &&
      line.calculation_pool === CalculationBase.VALOR_TOTAL_GORJETAS
    );
  }

  private computeInputFirstTheoreticalAmount(
    poolInputs: number[],
    rate: number,
    percentMode: PercentMode,
    basePercentual: number,
  ): number {
    const normalizedInputs = poolInputs.map((value) =>
      this.round2(Math.max(Number(value || 0), 0)),
    );

    let factor = 0;
    if (percentMode === PercentMode.BASE_PERCENT_POINTS) {
      factor = basePercentual > 0 ? rate / basePercentual : 0;
    } else {
      factor = rate / 100;
    }

    return this.round2(
      normalizedInputs.reduce((sum, value) => sum + value * factor, 0),
    );
  }

  private normalizeRole(value: string): string {
    return (value || '')
      .toLowerCase()
      .trim()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
  }

  private isRoleMatch(ruleRole: string, employeeRole: string): boolean {
    const r = this.normalizeRole(ruleRole);
    const e = this.normalizeRole(employeeRole);

    if (r === e) return true;

    const staffAliases = new Set(['staff', 'garcom', 'garcom(a)', 'garcon']);
    if (staffAliases.has(r) && staffAliases.has(e)) return true;

    const ruleBucket = this.toRoleBucket(r);
    const employeeBucket = this.toRoleBucket(e);
    const bucketAliases = new Set([
      'staff',
      'gerente',
      'supervisor',
      'cozinha',
      'chamador',
      'bar',
    ]);
    if (bucketAliases.has(ruleBucket) && ruleBucket === employeeBucket) return true;

    return false;
  }

  private toRoleBucket(roleName: string): string {
    const role = this.normalizeRole(roleName);
    if (role === 'staff' || role.includes('garcom')) return 'staff';
    if (role.includes('gestor') || role.includes('gerente')) return 'gerente';
    if (role.includes('supervisor')) return 'supervisor';
    if (role.includes('cozinha')) return 'cozinha';
    if (role === 'bar' || role.includes('bar')) return 'bar';
    if (role.includes('chamador')) return 'chamador';
    return role || 'outros';
  }

  private buildKitchenBarRemainderLines(
    tipPoolRemaining: number,
    tipPoolCoveredBuckets: Set<string>,
    funcionarios: Array<{ funcID: number; name: string; funcao: string }>,
  ): { lines: RoleBreakdown[]; distributed: number } {
    const available = this.round2(Math.max(tipPoolRemaining, 0));
    if (available <= 0) return { lines: [], distributed: 0 };

    const targets = ['cozinha', 'bar']
      .filter((bucket) => !tipPoolCoveredBuckets.has(bucket))
      .map((bucket) => ({
        bucket,
        count: funcionarios.filter((f) => this.toRoleBucket(f.funcao) === bucket)
          .length,
      }));

    if (!targets.length) return { lines: [], distributed: 0 };

    const totalCount = targets.reduce((sum, target) => sum + target.count, 0);
    const hasAnyEmployeeForTargets = totalCount > 0;

    const lines: RoleBreakdown[] = [];
    let remaining = available;
    let distributed = 0;

    targets.forEach((target, idx) => {
      const proportional = !hasAnyEmployeeForTargets
        ? idx === 0
          ? remaining
          : 0
        : idx === targets.length - 1
          ? remaining
          : this.round2((available * target.count) / totalCount);
      const amount = this.round2(Math.min(Math.max(proportional, 0), remaining));
      if (amount <= 0) return;

      distributed = this.round2(distributed + amount);
      remaining = this.round2(remaining - amount);

      lines.push({
        rule_id: -950000 - idx,
        role_name: target.bucket,
        calculation_type: CalculationType.FIXED_AMOUNT,
        calculation_pool: null,
        percent_mode: PercentMode.ABSOLUTE_PERCENT,
        split_mode: EmployeeSplitMode.EQUAL_SPLIT,
        payment_pool: PaymentSource.TIP_POOL,
        rate: amount,
        base_value: available,
        theoretical_amount: amount,
        paid_amount: amount,
        unpaid_amount: 0,
        role_amount: amount,
      });
    });

    return { lines, distributed };
  }

  private resolvePercentModeForRule(rule: {
    calculation_type: string;
    calculation_base: string | null;
    payment_source: string;
    percent_mode?: string | null;
  }): PercentMode | undefined {
    if (rule.percent_mode === PercentMode.ABSOLUTE_PERCENT) {
      return PercentMode.ABSOLUTE_PERCENT;
    }
    if (rule.percent_mode === PercentMode.BASE_PERCENT_POINTS) {
      return PercentMode.BASE_PERCENT_POINTS;
    }

    // Backward compatibility for legacy rows/clients that do not return
    // percent_mode: tip-pool percentage rules historically represented
    // percentage points over the restaurant base percentage.
    if (
      rule.calculation_type === CalculationType.PERCENT &&
      rule.calculation_base === CalculationBase.VALOR_TOTAL_GORJETAS &&
      rule.payment_source === PaymentSource.TIP_POOL
    ) {
      return PercentMode.BASE_PERCENT_POINTS;
    }

    return undefined;
  }

  private resolveSplitModeForRule(rule: {
    role_name: string;
    calculation_type: string;
    calculation_base: string | null;
    payment_source: string;
    split_mode?: string | null;
  }): EmployeeSplitMode | undefined {
    if (rule.split_mode === EmployeeSplitMode.EQUAL_SPLIT) {
      return EmployeeSplitMode.EQUAL_SPLIT;
    }
    if (rule.split_mode === EmployeeSplitMode.PROPORTIONAL_TO_POOL_INPUT) {
      return EmployeeSplitMode.PROPORTIONAL_TO_POOL_INPUT;
    }
    if (rule.split_mode === EmployeeSplitMode.DIRECT_INPUT_ONLY) {
      return EmployeeSplitMode.DIRECT_INPUT_ONLY;
    }
    if (rule.split_mode === EmployeeSplitMode.FULL_RATE_PER_EMPLOYEE) {
      return EmployeeSplitMode.FULL_RATE_PER_EMPLOYEE;
    }

    // Backward compatibility defaults:
    // - absolute external roles are effectively direct input only.
    // - legacy staff % over tip pool should keep per-employee proportional split.
    if (rule.payment_source === PaymentSource.ABSOLUTE_EXTERNAL) {
      return EmployeeSplitMode.DIRECT_INPUT_ONLY;
    }
    if (
      this.toRoleBucket(rule.role_name) === 'staff' &&
      rule.calculation_type === CalculationType.PERCENT &&
      rule.calculation_base === CalculationBase.VALOR_TOTAL_GORJETAS
    ) {
      return EmployeeSplitMode.PROPORTIONAL_TO_POOL_INPUT;
    }
    return EmployeeSplitMode.EQUAL_SPLIT;
  }

  private rebuildTotals(roleBreakdown: RoleBreakdown[]) {
    const total_theoretical = this.round2(
      roleBreakdown.reduce((sum, line) => sum + line.theoretical_amount, 0),
    );
    const total_payout = this.round2(
      roleBreakdown.reduce((sum, line) => sum + line.paid_amount, 0),
    );
    const total_unpaid = this.round2(
      roleBreakdown.reduce((sum, line) => sum + line.unpaid_amount, 0),
    );
    const total_from_tip_pool = this.round2(
      roleBreakdown
        .filter((line) => line.payment_pool === PaymentSource.TIP_POOL)
        .reduce((sum, line) => sum + line.paid_amount, 0),
    );
    const total_from_financeiro = this.round2(
      roleBreakdown
        .filter((line) => line.payment_pool === PaymentSource.FINANCEIRO)
        .reduce((sum, line) => sum + line.paid_amount, 0),
    );
    const total_external = this.round2(
      roleBreakdown
        .filter((line) => line.payment_pool === PaymentSource.ABSOLUTE_EXTERNAL)
        .reduce((sum, line) => sum + line.paid_amount, 0),
    );

    return {
      total_theoretical,
      total_payout,
      total_unpaid,
      total_from_tip_pool,
      total_from_financeiro,
      total_external,
    };
  }

  private isEffectiveRuleLine(line: RoleBreakdown): boolean {
    return (
      Math.abs(Number(line.rate || 0)) > 0 ||
      Math.abs(Number(line.theoretical_amount || 0)) > 0 ||
      Math.abs(Number(line.paid_amount || 0)) > 0 ||
      Math.abs(Number(line.unpaid_amount || 0)) > 0
    );
  }

  /**
   * Split amount with 2-decimal precision while preserving exact rounded total.
   */
  private splitAmount(total: number, parts: number): number[] {
    if (parts <= 1) return [this.round2(total)];

    const base = this.round2(total / parts);
    const split = Array(parts).fill(base) as number[];
    const allocated = this.round2(split.reduce((sum, v) => sum + v, 0));
    const delta = this.round2(total - allocated);
    split[0] = this.round2(split[0] + delta);
    return split;
  }

  /**
   * Split amount proportionally using per-employee weights.
   * Falls back to equal split when all weights are zero/invalid.
   */
  private splitAmountByWeights(total: number, weights: number[]): number[] {
    if (weights.length <= 1) return [this.round2(total)];

    const normalized = weights.map((w) => this.round2(Math.max(Number(w || 0), 0)));
    const sumWeights = this.round2(normalized.reduce((sum, w) => sum + w, 0));
    if (sumWeights <= 0) {
      return this.splitAmount(total, weights.length);
    }

    const split = normalized.map((weight) =>
      this.round2((total * weight) / sumWeights),
    );
    const allocated = this.round2(split.reduce((sum, value) => sum + value, 0));
    const delta = this.round2(total - allocated);
    const adjustIndex = normalized.findIndex((weight) => weight > 0);
    split[adjustIndex >= 0 ? adjustIndex : 0] = this.round2(
      split[adjustIndex >= 0 ? adjustIndex : 0] + delta,
    );
    return split;
  }

  /**
   * Keep provided values proportional while matching an exact rounded total.
   */
  private normalizeValuesToTotal(values: number[], total: number): number[] {
    if (values.length <= 1) return [this.round2(total)];
    const normalized = values.map((v) => this.round2(Math.max(Number(v || 0), 0)));
    const sum = this.round2(normalized.reduce((acc, val) => acc + val, 0));
    if (sum <= 0) return this.splitAmount(total, values.length);
    const scaled = normalized.map((value) => this.round2((value / sum) * total));
    const allocated = this.round2(scaled.reduce((acc, val) => acc + val, 0));
    const delta = this.round2(total - allocated);
    const adjustIndex = normalized.findIndex((value) => value > 0);
    scaled[adjustIndex >= 0 ? adjustIndex : 0] = this.round2(
      scaled[adjustIndex >= 0 ? adjustIndex : 0] + delta,
    );
    return scaled;
  }

  private round2(val: number): number {
    return Math.round(val * 100) / 100;
  }
}
