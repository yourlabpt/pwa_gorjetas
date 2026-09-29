import { FinanceEngineService } from './finance-engine.service';
import {
  CalculationBase,
  CalculationType,
  EmployeeSplitMode,
  PaymentSource,
  PercentMode,
} from '../payout-calculator/payout-calculator.types';

describe('FinanceEngineService', () => {
  const baseRuleRow = {
    id: 1,
    role_name: 'chefe de turno',
    calculation_type: CalculationType.PERCENT,
    calculation_base: CalculationBase.VALOR_TOTAL_GORJETAS,
    rate: 10,
    percent_mode: PercentMode.BASE_PERCENT_POINTS,
    split_mode: EmployeeSplitMode.PROPORTIONAL_TO_POOL_INPUT,
    payment_source: PaymentSource.TIP_POOL,
    ordem: 1,
    ativo: true,
  };

  const baselinePayoutResult = {
    role_breakdown: [
      {
        rule_id: 1,
        role_name: 'chefe de turno',
        calculation_type: CalculationType.PERCENT,
        calculation_pool: CalculationBase.VALOR_TOTAL_GORJETAS,
        percent_mode: PercentMode.BASE_PERCENT_POINTS,
        split_mode: EmployeeSplitMode.PROPORTIONAL_TO_POOL_INPUT,
        payment_pool: PaymentSource.TIP_POOL,
        rate: 10,
        base_value: 700,
        theoretical_amount: 560,
        paid_amount: 560,
        unpaid_amount: 0,
        role_amount: 560,
      },
    ],
    bucket_balances: {
      tip_pool_initial: 700,
      tip_pool_remaining: 140,
      financeiro_initial: 1300,
      financeiro_remaining: 1300,
    },
    totals: {
      total_theoretical: 560,
      total_payout: 560,
      total_unpaid: 0,
      total_from_tip_pool: 560,
      total_from_financeiro: 0,
      total_external: 0,
    },
    errors: [],
    ok: true,
  };

  function makeService() {
    const prisma = {
      funcionario: {
        findMany: jest.fn().mockResolvedValue([
          { funcID: 1, name: 'Carlos', funcao: 'chefe de turno' },
        ]),
      },
      regraDistribuicao: {
        findMany: jest.fn().mockResolvedValue([baseRuleRow]),
      },
    } as any;

    const payoutCalculator = {
      calculate: jest.fn().mockReturnValue(baselinePayoutResult),
    } as any;

    const funcionarios = {
      findForDay: jest.fn().mockResolvedValue([
        { funcID: 1, name: 'Carlos', funcao: 'chefe de turno' },
      ]),
    } as any;

    const service = new FinanceEngineService(prisma, payoutCalculator, funcionarios);
    return { service, prisma, payoutCalculator, funcionarios };
  }

  const dayInput = {
    faturamento_global: 7000,
    faturamento_com_gorjeta: 5600,
    faturamento_sem_gorjeta: 1300,
    valor_total_gorjetas: 700,
  };

  it('loads the participants of the computed day, not the current ativo flag', async () => {
    const { service, funcionarios, prisma } = makeService();
    const data = new Date('2026-01-15T00:00:00Z');

    await service.computeDailyPayouts(10, dayInput, { base_percentual: 12.5, data });

    expect(funcionarios.findForDay).toHaveBeenCalledWith(10, data);
    expect(prisma.funcionario.findMany).not.toHaveBeenCalled();
  });

  it('ignores staff inputs of employees that do not belong to the day', async () => {
    const { service } = makeService();

    const result = await service.computeDailyPayouts(10, dayInput, {
      base_percentual: 12.5,
      insufficientFundsPolicy: 'PARTIAL',
      staff_inputs: [
        { funcID: 1, valor_pool: 200, valor_direto: 0 },
        { funcID: 99, valor_pool: 500, valor_direto: 50 }, // not a participant
      ],
    });

    expect(result.employee_breakdown.map((e) => e.funcID)).toEqual([1]);
    expect(result.role_breakdown[0].base_value).toBe(200);
    expect(result.role_breakdown[0].theoretical_amount).toBe(160);
    expect(result.totals.total_from_tip_pool).toBe(160);
  });

  it('uses employee input as base for PROPORTIONAL + VALOR_TOTAL_GORJETAS (zero input => zero payout)', async () => {
    const { service } = makeService();

    const result = await service.computeDailyPayouts(
      10,
      {
        faturamento_global: 7000,
        faturamento_com_gorjeta: 5600,
        faturamento_sem_gorjeta: 1300,
        valor_total_gorjetas: 700,
      },
      {
        base_percentual: 12.5,
        insufficientFundsPolicy: 'PARTIAL',
        staff_inputs: [{ funcID: 1, valor_pool: 0, valor_direto: 0 }],
      },
    );

    expect(result.role_breakdown[0].base_value).toBe(0);
    expect(result.role_breakdown[0].theoretical_amount).toBe(0);
    expect(result.role_breakdown[0].paid_amount).toBe(0);
    expect(result.employee_breakdown[0].theoretical_value).toBe(0);
    expect(result.employee_breakdown[0].real_paid_value).toBe(0);
    expect(result.bucket_balances.tip_pool_remaining).toBe(700);
    expect(result.totals.total_from_tip_pool).toBe(0);
  });

  it('computes payout from employee input for BASE_PERCENT_POINTS', async () => {
    const { service } = makeService();

    const result = await service.computeDailyPayouts(
      10,
      {
        faturamento_global: 7000,
        faturamento_com_gorjeta: 5600,
        faturamento_sem_gorjeta: 1300,
        valor_total_gorjetas: 700,
      },
      {
        base_percentual: 12.5,
        insufficientFundsPolicy: 'PARTIAL',
        staff_inputs: [{ funcID: 1, valor_pool: 200, valor_direto: 0 }],
      },
    );

    // 200 * (10 / 12.5) = 160
    expect(result.role_breakdown[0].base_value).toBe(200);
    expect(result.role_breakdown[0].theoretical_amount).toBe(160);
    expect(result.role_breakdown[0].paid_amount).toBe(160);
    expect(result.employee_breakdown[0].real_paid_value).toBe(160);
    expect(result.bucket_balances.tip_pool_remaining).toBe(540);
    expect(result.totals.total_from_tip_pool).toBe(160);
  });
});
