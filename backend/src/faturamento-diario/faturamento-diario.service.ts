import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateFaturamentoDiarioDto,
  UpdateFaturamentoDiarioDto,
  FaturamentoDiarioResponseDto,
  SaveFinanceiroSnapshotDto,
  ComputePayoutsDto,
} from './dto';
import { Prisma } from '@prisma/client';
import { FinanceEngineService } from '../finance-engine/finance-engine.service';
import { DailyFinanceComputation } from '../finance-engine/finance-engine.types';

@Injectable()
export class FaturamentoDiarioService {
  constructor(
    private prisma: PrismaService,
    private financeEngine: FinanceEngineService,
  ) {}

  /**
   * Normalize date-only strings to UTC midnight to avoid timezone drift.
   */
  private normalizeDate(dateInput: string | Date): Date {
    if (dateInput instanceof Date) {
      const d = new Date(dateInput);
      d.setUTCHours(0, 0, 0, 0);
      return d;
    }
    const d = new Date(`${dateInput}T00:00:00Z`);
    d.setUTCHours(0, 0, 0, 0);
    return d;
  }

  private normalizeRole(value: string): string {
    return (value || '')
      .toLowerCase()
      .trim()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
  }

  private isStaffRole(funcao: string): boolean {
    const role = this.normalizeRole(funcao);
    return role === 'staff' || role.includes('garcom');
  }

  private toRoleBucket(roleName: string): string {
    const role = this.normalizeRole(roleName);
    if (role === 'staff' || role.includes('garcom')) return 'staff';
    if (role.includes('gestor') || role.includes('gerente')) return 'gerente';
    if (role.includes('supervisor') || role.includes('chefe') || role.includes('turno')) return 'supervisor';
    if (role.includes('cozinha')) return 'cozinha';
    if (role === 'bar' || role.includes('bar')) return 'bar';
    if (role.includes('chamador')) return 'chamador';
    return role || 'outros';
  }

  private buildStaffInputsFromDistrib(
    funcionariosAtivos: Array<{ funcID: number; name: string; funcao: string }>,
    distribRows: Array<{
      funcID: number | null;
      valor_pool: Prisma.Decimal | null;
      valor_direto: Prisma.Decimal | null;
    }>,
  ): Array<{ funcID: number; valor_pool: number; valor_direto: number }> {
    const map = new Map<number, { valor_pool: number; valor_direto: number }>();

    distribRows.forEach((row) => {
      if (row.funcID == null) return;
      const prev = map.get(row.funcID) || { valor_pool: 0, valor_direto: 0 };
      const pool =
        row.valor_pool == null ? prev.valor_pool : Number(row.valor_pool.toNumber());
      const direto =
        row.valor_direto == null
          ? prev.valor_direto
          : Number(row.valor_direto.toNumber());
      map.set(row.funcID, {
        valor_pool: Math.max(pool || 0, 0),
        valor_direto: Math.max(direto || 0, 0),
      });
    });

    return funcionariosAtivos.map((func) => ({
      funcID: func.funcID,
      valor_pool: map.get(func.funcID)?.valor_pool || 0,
      valor_direto: map.get(func.funcID)?.valor_direto || 0,
    }));
  }

  private async buildRecomputedEntriesForDay(
    restID: number,
    dataFormatada: Date,
    faturamento: any | null,
    distribRows: Array<{
      funcID: number | null;
      role: string;
      valor_pool: Prisma.Decimal | null;
      valor_direto: Prisma.Decimal | null;
      valor_teorico: Prisma.Decimal | null;
      valor_pago: Prisma.Decimal;
      desconto?: Prisma.Decimal | null;
    }>,
  ) {
    if (!faturamento && distribRows.length === 0) {
      return [];
    }

    const funcionariosAtivos = await this.prisma.funcionario.findMany({
      where: { restID, ativo: true },
      select: {
        funcID: true,
        name: true,
        funcao: true,
      },
      orderBy: { createdAt: 'asc' },
    });
    const restaurante = await this.prisma.restaurante.findUnique({
      where: { restID },
      select: { percentagem_gorjeta_base: true },
    });
    const basePercentual = Number(restaurante?.percentagem_gorjeta_base || 0);

    const staffInputs = this.buildStaffInputsFromDistrib(
      funcionariosAtivos,
      distribRows,
    );
    const staffInputByFuncID = new Map(
      staffInputs.map((entry) => [entry.funcID, entry]),
    );
    const staffDirectTipPoolTotal = funcionariosAtivos.reduce((sum, func) => {
      const input = staffInputByFuncID.get(func.funcID);
      return sum + (input?.valor_direto || 0);
    }, 0);
    const valorTotalGorjetas =
      faturamento?.valor_total_gorjetas?.toNumber() ??
      staffInputs.reduce((sum, entry) => sum + (entry.valor_pool || 0), 0);
    const faturamentoGlobal = faturamento?.faturamento_inserido?.toNumber() ?? 0;
    const faturamentoComGorjeta =
      faturamento?.faturamento_com_gorjeta?.toNumber() ?? faturamentoGlobal;
    const faturamentoSemGorjeta =
      faturamento?.faturamento_sem_gorjeta?.toNumber() ??
      Math.max(faturamentoGlobal - valorTotalGorjetas, 0);

    const computation = await this.financeEngine.computeDailyPayouts(
      restID,
      {
        faturamento_global: faturamentoGlobal,
        faturamento_com_gorjeta: faturamentoComGorjeta,
        faturamento_sem_gorjeta: faturamentoSemGorjeta,
        valor_total_gorjetas: valorTotalGorjetas,
      },
      {
        insufficientFundsPolicy: 'PARTIAL',
        data: dataFormatada,
        staff_direct_tip_pool_total: staffDirectTipPoolTotal,
        base_percentual: basePercentual,
        staff_inputs: staffInputs,
      },
    );

    const legacyInputByFuncID = new Map(
      staffInputs.map((entry) => [entry.funcID, entry]),
    );
    const employeeMetaByFuncID = new Map(
      funcionariosAtivos.map((f) => [f.funcID, { name: f.name, funcao: f.funcao }]),
    );

    const aggregate = new Map<
      string,
      {
        funcID: number | null;
        role: string;
        employee_name: string | null;
        employee_funcao: string | null;
        valor_pool: number;
        valor_direto: number;
        valor_teorico: number;
        valor_pago: number;
        desconto: number;
        fromComputation: boolean;
      }
    >();
    const aggregateKeyByFuncID = new Map<number, string>();

    computation.employee_breakdown.forEach((entry) => {
      const existingKey =
        entry.funcID != null ? aggregateKeyByFuncID.get(entry.funcID) : undefined;
      const key = existingKey || `${entry.funcID ?? 'null'}::${entry.role_bucket}`;
      const staffInput =
        entry.funcID != null ? legacyInputByFuncID.get(entry.funcID) : undefined;
      const employeeMeta =
        entry.funcID != null ? employeeMetaByFuncID.get(entry.funcID) : undefined;

      if (!aggregate.has(key)) {
        aggregate.set(key, {
          funcID: entry.funcID,
          role: entry.role_bucket,
          employee_name: entry.employee_name || employeeMeta?.name || null,
          employee_funcao: employeeMeta?.funcao || null,
          valor_pool: staffInput?.valor_pool || 0,
          valor_direto: staffInput?.valor_direto || 0,
          valor_teorico: 0,
          valor_pago: 0,
          desconto: 0,
          fromComputation: true,
        });
      }

      const current = aggregate.get(key)!;
      current.valor_teorico += entry.theoretical_value || 0;
      current.valor_pago += entry.real_paid_value || 0;
      if (entry.funcID != null) {
        aggregateKeyByFuncID.set(entry.funcID, key);
      }
    });

    distribRows.forEach((row) => {
      const rowFuncID = row.funcID != null ? Number(row.funcID) : null;
      const employeeMeta =
        rowFuncID != null ? employeeMetaByFuncID.get(rowFuncID) : undefined;
      const roleBucket = this.toRoleBucket(row.role || employeeMeta?.funcao || '');
      const fallbackRole = roleBucket || this.normalizeRole(row.role || '') || 'outros';
      const existingKey =
        rowFuncID != null ? aggregateKeyByFuncID.get(rowFuncID) : undefined;
      const key = existingKey || `${rowFuncID ?? 'null'}::${fallbackRole}`;

      if (!aggregate.has(key)) {
        aggregate.set(key, {
          funcID: rowFuncID,
          role: fallbackRole,
          employee_name: employeeMeta?.name || null,
          employee_funcao: employeeMeta?.funcao || null,
          valor_pool: 0,
          valor_direto: 0,
          valor_teorico: 0,
          valor_pago: 0,
          desconto: 0,
          fromComputation: false,
        });
      }

      const current = aggregate.get(key)!;
      const storedPool =
        row.valor_pool != null ? Number(row.valor_pool.toNumber()) : null;
      const storedDirect =
        row.valor_direto != null ? Number(row.valor_direto.toNumber()) : null;
      const storedPaid = Number(row.valor_pago.toNumber());
      const storedDesconto =
        row.desconto != null ? Number(row.desconto.toNumber()) : 0;
      const hasStoredInput = (storedPool || 0) > 0 || (storedDirect || 0) > 0;
      const shouldApplyStoredAmounts =
        !current.fromComputation || hasStoredInput || storedPaid > 0;

      if (storedPool != null) current.valor_pool = storedPool;
      if (storedDirect != null) current.valor_direto = storedDirect;
      current.desconto = storedDesconto;
      if (row.valor_teorico != null && shouldApplyStoredAmounts) {
        current.valor_teorico = Number(row.valor_teorico.toNumber());
      }
      if (shouldApplyStoredAmounts) {
        current.valor_pago = storedPaid;
      }
      if (rowFuncID != null) {
        aggregateKeyByFuncID.set(rowFuncID, key);
      }
    });

    return Array.from(aggregate.values()).map((entry) => ({
      funcID: entry.funcID,
      role: entry.role,
      employee_name: entry.employee_name,
      employee_funcao: entry.employee_funcao,
      valor_pool: entry.valor_pool || 0,
      valor_direto: entry.valor_direto || 0,
      valor_teorico: entry.valor_teorico || 0,
      valor_pago: entry.valor_pago || 0,
      desconto: entry.desconto || 0,
      valor_nao_pago: Math.max((entry.valor_teorico || 0) - (entry.valor_pago || 0), 0),
    }));
  }

  /**
   * Calcular o faturamento total do dia somando todas as transações
   */
  private async calcularFaturamentoDodia(
    restID: number,
    data: Date,
  ): Promise<{ faturamento: any; gorjetas: any }> {
    const transacoes = await this.prisma.transacao.findMany({
      where: {
        restID,
        data_transacao: {
          gte: new Date(data.getFullYear(), data.getMonth(), data.getDate()),
          lte: new Date(
            data.getFullYear(),
            data.getMonth(),
            data.getDate() + 1,
          ),
        },
      },
    });

    let faturamento = new Prisma.Decimal(0);
    let gorjetas = new Prisma.Decimal(0);

    for (const t of transacoes) {
      faturamento = faturamento.plus(t.total);
      gorjetas = gorjetas.plus(t.valor_gorjeta_calculada);
    }

    return { faturamento, gorjetas };
  }

  /**
   * Calcula a diferença percentual entre inserido e calculado
   */
  private calcularDiferenca(
    faturamentoInserido: any,
    faturamentoCalculado: any,
  ): any {
    if (faturamentoCalculado.equals(0)) {
      return new Prisma.Decimal(0);
    }

    const diferenca = faturamentoInserido
      .minus(faturamentoCalculado)
      .dividedBy(faturamentoCalculado)
      .times(100);

    return diferenca;
  }

  /**
   * Criar faturamento diário
   */
  async create(
    restID: number,
    dto: CreateFaturamentoDiarioDto,
  ): Promise<FaturamentoDiarioResponseDto> {
    // Validar se restaurante existe
    await this.prisma.restaurante.findUniqueOrThrow({
      where: { restID },
    });

    // Verificar se já existe faturamento para este dia
    const dataFormatada = new Date(dto.data);
    dataFormatada.setHours(0, 0, 0, 0);

    const existente = await this.prisma.faturamentoDiario.findUnique({
      where: {
        restID_data: {
          restID,
          data: dataFormatada,
        },
      },
    });

    if (existente) {
      throw new BadRequestException(
        `Faturamento já existe para ${dataFormatada.toDateString()}`,
      );
    }

    // Calcular faturamento do dia
    const { faturamento: faturamentoCalculado, gorjetas } =
      await this.calcularFaturamentoDodia(restID, dataFormatada);

    // Calcular diferença
    const diferenca = this.calcularDiferenca(
      new Prisma.Decimal(dto.faturamento_inserido),
      faturamentoCalculado,
    );

    // Criar registro
    const faturamento = await this.prisma.faturamentoDiario.create({
      data: {
        restID,
        data: dataFormatada,
        faturamento_inserido: new Prisma.Decimal(
          dto.faturamento_inserido,
        ),
        faturamento_calculado: faturamentoCalculado,
        diferenca_percentual: diferenca,
        notas: dto.notas || null,
      },
    });

    return this.mapToResponse(faturamento, gorjetas);
  }

  /**
   * Obter faturamento de um dia específico
   */
  async findByDate(
    restID: number,
    data: Date,
  ): Promise<FaturamentoDiarioResponseDto> {
    const dataFormatada = new Date(data);
    dataFormatada.setHours(0, 0, 0, 0);

    const faturamento = await this.prisma.faturamentoDiario.findUnique({
      where: {
        restID_data: {
          restID,
          data: dataFormatada,
        },
      },
    });

    if (!faturamento) {
      throw new NotFoundException(
        `Faturamento não encontrado para ${dataFormatada.toDateString()}`,
      );
    }

    // Obter gorjetas do dia para resposta
    const { gorjetas } = await this.calcularFaturamentoDodia(
      restID,
      dataFormatada,
    );

    return this.mapToResponse(faturamento, gorjetas);
  }

  /**
   * Listar faturamentos por período
   */
  async findByPeriod(
    restID: number,
    dataInicio: Date,
    dataFim: Date,
  ): Promise<FaturamentoDiarioResponseDto[]> {
    const inicio = new Date(dataInicio);
    inicio.setHours(0, 0, 0, 0);

    const fim = new Date(dataFim);
    fim.setHours(23, 59, 59, 999);

    const faturamentos = await this.prisma.faturamentoDiario.findMany({
      where: {
        restID,
        data: {
          gte: inicio,
          lte: fim,
        },
        ativo: true,
      },
      orderBy: { data: 'desc' },
    });

    // Obter gorjetas para cada dia
    const result = await Promise.all(
      faturamentos.map(async (f) => {
        const { gorjetas } = await this.calcularFaturamentoDodia(
          restID,
          f.data,
        );
        return this.mapToResponse(f, gorjetas);
      }),
    );

    return result;
  }

  /**
   * Atualizar faturamento diário
   */
  async update(
    id: number,
    restID: number,
    dto: UpdateFaturamentoDiarioDto,
  ): Promise<FaturamentoDiarioResponseDto> {
    // Validar se existe
    const faturamento = await this.prisma.faturamentoDiario.findFirst({
      where: { id, restID },
    });

    if (!faturamento) {
      throw new NotFoundException('Faturamento não encontrado');
    }

    // Recalcular diferença se faturamento inserido foi alterado
    let diferenca = faturamento.diferenca_percentual;
    if (
      dto.faturamento_inserido !== undefined &&
      dto.faturamento_inserido !== faturamento.faturamento_inserido.toNumber()
    ) {
      diferenca = this.calcularDiferenca(
        new Prisma.Decimal(dto.faturamento_inserido),
        faturamento.faturamento_calculado,
      );
    }

    // Atualizar
    const atualizado = await this.prisma.faturamentoDiario.update({
      where: { id },
      data: {
        faturamento_inserido:
          dto.faturamento_inserido !== undefined
            ? new Prisma.Decimal(dto.faturamento_inserido)
            : undefined,
        diferenca_percentual: diferenca,
        notas: dto.notas !== undefined ? dto.notas : undefined,
      },
    });

    const { gorjetas } = await this.calcularFaturamentoDodia(
      restID,
      atualizado.data,
    );

    return this.mapToResponse(atualizado, gorjetas);
  }

  /**
   * Deletar (soft delete) faturamento
   */
  async delete(id: number, restID: number): Promise<void> {
    const faturamento = await this.prisma.faturamentoDiario.findFirst({
      where: { id, restID },
    });

    if (!faturamento) {
      throw new NotFoundException('Faturamento não encontrado');
    }

    await this.prisma.faturamentoDiario.update({
      where: { id },
      data: { ativo: false },
    });
  }

  /**
   * Server-side daily payout calculation.
   * Uses the centralized FinanceEngineService against the supplied day's
   * financial buckets. Does NOT persist anything.
   */
  async computePayouts(
    restID: number,
    dto: ComputePayoutsDto,
  ): Promise<DailyFinanceComputation> {
    return this.financeEngine.computeDailyPayouts(
      restID,
      {
        faturamento_global: dto.faturamento_global,
        faturamento_com_gorjeta:
          dto.faturamento_com_gorjeta ?? dto.faturamento_global,
        faturamento_sem_gorjeta:
          dto.faturamento_sem_gorjeta ??
          Math.max(dto.faturamento_global - dto.valor_total_gorjetas, 0),
        valor_total_gorjetas: dto.valor_total_gorjetas,
      },
      {
        allowNegativeBalances: dto.allowNegativeBalances ?? false,
        insufficientFundsPolicy: dto.insufficientFundsPolicy ?? 'PARTIAL',
        data: dto.data,
        staff_direct_tip_pool_total: dto.staff_direct_tip_pool_total ?? 0,
        base_percentual: dto.base_percentual,
        staff_inputs: (dto.staff || []).map((entry) => ({
          funcID: entry.funcID,
          valor_pool: entry.valor_pool ?? 0,
          valor_direto: entry.valor_direto ?? 0,
        })),
      },
    );
  }

  async saveSnapshot(
    restID: number,
    dto: SaveFinanceiroSnapshotDto,
  ): Promise<void> {
    const dataFormatada = this.normalizeDate(dto.data);
    const computation = await this.financeEngine.computeDailyPayouts(
      restID,
      {
        faturamento_global: dto.faturamento_global,
        faturamento_com_gorjeta:
          dto.faturamento_com_gorjeta ?? dto.faturamento_global,
        faturamento_sem_gorjeta:
          dto.faturamento_sem_gorjeta ??
          Math.max(
            dto.faturamento_global - (dto.valor_total_gorjetas ?? 0),
            0,
          ),
        valor_total_gorjetas: dto.valor_total_gorjetas ?? 0,
      },
      {
        insufficientFundsPolicy: dto.insufficientFundsPolicy ?? 'PARTIAL',
        data: dataFormatada,
        staff_direct_tip_pool_total: dto.staff_direct_tip_pool_total ?? 0,
        base_percentual: dto.base_percentual,
        staff_inputs: (dto.staff || []).map((entry) => ({
          funcID: entry.funcID,
          valor_pool: entry.valor_pool ?? 0,
          valor_direto: entry.valor_direto ?? 0,
        })),
      },
    );

    await this.prisma.$transaction(async (tx) => {
      const existing = await tx.faturamentoDiario.findUnique({
        where: { restID_data: { restID, data: dataFormatada } },
      });

      const buckets = {
        ...(dto.faturamento_com_gorjeta != null && { faturamento_com_gorjeta: new Prisma.Decimal(dto.faturamento_com_gorjeta) }),
        ...(dto.faturamento_sem_gorjeta != null && { faturamento_sem_gorjeta: new Prisma.Decimal(dto.faturamento_sem_gorjeta) }),
        ...(dto.valor_total_gorjetas != null && { valor_total_gorjetas: new Prisma.Decimal(dto.valor_total_gorjetas) }),
      };

      if (existing) {
        await tx.faturamentoDiario.update({
          where: { id: existing.id },
          data: {
            faturamento_inserido: new Prisma.Decimal(dto.faturamento_global),
            faturamento_calculado: new Prisma.Decimal(dto.faturamento_global),
            diferenca_percentual: new Prisma.Decimal(0),
            ...buckets,
          },
        });
      } else {
        await tx.faturamentoDiario.create({
          data: {
            restID,
            data: dataFormatada,
            faturamento_inserido: new Prisma.Decimal(dto.faturamento_global),
            faturamento_calculado: new Prisma.Decimal(dto.faturamento_global),
            diferenca_percentual: new Prisma.Decimal(0),
            ...buckets,
          },
        });
      }

      await tx.faturamentoDiarioDistribuicao.deleteMany({
        where: { restID, data: dataFormatada },
      });

      const rows: Prisma.FaturamentoDiarioDistribuicaoCreateManyInput[] = [];

      if ((computation.role_breakdown || []).length === 0) {
        throw new BadRequestException(
          'Nenhuma distribuição calculada para este restaurante neste dia. Configure regras de distribuição ou valide os dados do dia antes de salvar o snapshot.',
        );
      }

      const legacyStaffByFuncID = new Map(
        (dto.staff || []).map((s) => [
          s.funcID,
          {
            valor_pool: s.valor_pool || 0,
            valor_direto: s.valor_direto || 0,
            valor_pago: s.valor_pago || 0,
            desconto: s.desconto ?? 0,
          },
        ]),
      );
      const staffFuncIDs = Array.from(legacyStaffByFuncID.keys());
      const employeeMetaRows =
        staffFuncIDs.length > 0
          ? await tx.funcionario.findMany({
              where: {
                restID,
                funcID: { in: staffFuncIDs },
              },
              select: {
                funcID: true,
                funcao: true,
              },
            })
          : [];
      const employeeRoleByFuncID = new Map(
        employeeMetaRows.map((row) => [row.funcID, row.funcao]),
      );

      const aggregate = new Map<
        string,
        {
          funcID: number | null;
          role: string;
          valor_pool: number | null;
          valor_direto: number | null;
          valor_teorico: number;
          valor_pago: number;
          desconto: number | null;
          fromComputation: boolean;
        }
      >();
      const aggregateKeyByFuncID = new Map<number, string>();

      computation.employee_breakdown.forEach((entry) => {
        const existingKey =
          entry.funcID != null ? aggregateKeyByFuncID.get(entry.funcID) : undefined;
        const key = existingKey || `${entry.funcID ?? 'null'}::${entry.role_bucket}`;
        const staffLegacy =
          entry.funcID != null
            ? legacyStaffByFuncID.get(entry.funcID)
            : undefined;

        if (!aggregate.has(key)) {
          aggregate.set(key, {
            funcID: entry.funcID,
            role: entry.role_bucket,
            valor_pool: staffLegacy?.valor_pool ?? null,
            valor_direto: staffLegacy?.valor_direto ?? null,
            valor_teorico: 0,
            valor_pago: 0,
            desconto: staffLegacy?.desconto ?? null,
            fromComputation: true,
          });
        }

        const current = aggregate.get(key)!;
        current.valor_teorico += entry.theoretical_value;
        current.valor_pago += entry.real_paid_value;
        if (entry.funcID != null) {
          aggregateKeyByFuncID.set(entry.funcID, key);
        }
      });

      (dto.staff || []).forEach((staffEntry) => {
        const roleFromEmployee = this.toRoleBucket(
          employeeRoleByFuncID.get(staffEntry.funcID) || '',
        );
        const fallbackRole = roleFromEmployee || 'outros';
        const existingKey = aggregateKeyByFuncID.get(staffEntry.funcID);
        const key = existingKey || `${staffEntry.funcID}::${fallbackRole}`;

        if (!aggregate.has(key)) {
          aggregate.set(key, {
            funcID: staffEntry.funcID,
            role: fallbackRole,
            valor_pool: null,
            valor_direto: null,
            valor_teorico: 0,
            valor_pago: 0,
            desconto: null,
            fromComputation: false,
          });
        }

        const current = aggregate.get(key)!;
        const pool = staffEntry.valor_pool ?? 0;
        const direto = staffEntry.valor_direto ?? 0;
        const paid = staffEntry.valor_pago ?? 0;
        const hasExplicitInput = pool > 0 || direto > 0;
        const shouldApplyManualPaid =
          !current.fromComputation || hasExplicitInput || paid > 0;

        current.valor_pool = staffEntry.valor_pool ?? current.valor_pool ?? 0;
        current.valor_direto = staffEntry.valor_direto ?? current.valor_direto ?? 0;
        current.desconto = staffEntry.desconto ?? current.desconto ?? 0;
        if (shouldApplyManualPaid) {
          current.valor_pago = staffEntry.valor_pago ?? current.valor_pago;
        }
        aggregateKeyByFuncID.set(staffEntry.funcID, key);
      });

      aggregate.forEach((entry) => {
        rows.push({
          restID,
          data: dataFormatada,
          funcID: entry.funcID,
          role: entry.role,
          valor_pool:
            entry.valor_pool == null
              ? null
              : new Prisma.Decimal(entry.valor_pool),
          valor_direto:
            entry.valor_direto == null
              ? null
              : new Prisma.Decimal(entry.valor_direto),
          valor_teorico: new Prisma.Decimal(entry.valor_teorico),
          valor_pago: new Prisma.Decimal(entry.valor_pago),
          desconto:
            entry.desconto == null
              ? null
              : new Prisma.Decimal(entry.desconto),
        });
      });

      if (rows.length) {
        await tx.faturamentoDiarioDistribuicao.createMany({ data: rows });
      }

      if (dto.presencas) {
        const deduped = new Map<number, boolean>();
        dto.presencas.forEach((entry) => {
          if (!Number.isFinite(Number(entry.funcID))) return;
          deduped.set(Number(entry.funcID), Boolean(entry.presente));
        });

        await tx.$executeRaw`
          DELETE FROM "funcionario_presenca_diaria"
          WHERE "restID" = ${restID}
            AND "data" = ${dataFormatada}
        `;

        for (const [funcID, presente] of deduped.entries()) {
          await tx.$executeRaw`
            INSERT INTO "funcionario_presenca_diaria"
              ("restID", "data", "funcID", "presente", "criadoEm", "atualizadoEm")
            VALUES
              (${restID}, ${dataFormatada}, ${funcID}, ${presente}, NOW(), NOW())
          `;
        }
      }
    });
  }

  async getSnapshot(restID: number, data: Date) {
    const dataFormatada = this.normalizeDate(data);

    const faturamento = await this.prisma.faturamentoDiario.findUnique({
      where: { restID_data: { restID, data: dataFormatada } },
    });

    const distrib = await this.prisma.faturamentoDiarioDistribuicao.findMany({
      where: { restID, data: dataFormatada },
    });
    const presencas = await this.prisma.$queryRaw<
      Array<{ funcID: number; presente: boolean }>
    >`
      SELECT "funcID", "presente"
      FROM "funcionario_presenca_diaria"
      WHERE "restID" = ${restID}
        AND "data" = ${dataFormatada}
    `;

    const recomputedEntries = await this.buildRecomputedEntriesForDay(
      restID,
      dataFormatada,
      faturamento,
      distrib as any,
    );

    return {
      faturamento_inserido: faturamento?.faturamento_inserido?.toNumber() ?? null,
      faturamento_com_gorjeta: faturamento?.faturamento_com_gorjeta?.toNumber() ?? null,
      faturamento_sem_gorjeta: faturamento?.faturamento_sem_gorjeta?.toNumber() ?? null,
      valor_total_gorjetas: faturamento?.valor_total_gorjetas?.toNumber() ?? null,
      presencas,
      entries: recomputedEntries,
    };
  }

  async getSnapshotRange(restID: number, from: Date, to: Date) {
    const inicio = this.normalizeDate(from);
    const fim = this.normalizeDate(to);
    fim.setUTCHours(23, 59, 59, 999);

    const faturamentos = await this.prisma.faturamentoDiario.findMany({
      where: {
        restID,
        data: {
          gte: inicio,
          lte: fim,
        },
        ativo: true,
      },
      orderBy: { data: 'desc' },
    });

    const distrib = await this.prisma.faturamentoDiarioDistribuicao.findMany({
      where: {
        restID,
        data: {
          gte: inicio,
          lte: fim,
        },
      },
    });
    const presencas = await this.prisma.$queryRaw<
      Array<{ data: Date; funcID: number; presente: boolean }>
    >`
      SELECT "data", "funcID", "presente"
      FROM "funcionario_presenca_diaria"
      WHERE "restID" = ${restID}
        AND "data" >= ${inicio}
        AND "data" <= ${fim}
    `;

    const distribByDate = distrib.reduce<Record<string, any[]>>((acc, d: any) => {
      const key = d.data.toISOString().split('T')[0];
      if (!acc[key]) acc[key] = [];
      acc[key].push(d);
      return acc;
    }, {});
    const presencasByDate = presencas.reduce<Record<string, any[]>>((acc, p) => {
      const key = p.data.toISOString().split('T')[0];
      if (!acc[key]) acc[key] = [];
      acc[key].push({
        funcID: p.funcID,
        presente: Boolean(p.presente),
      });
      return acc;
    }, {});

    const result = await Promise.all(faturamentos.map(async (f) => {
      const key = f.data.toISOString().split('T')[0];
      const storedEntries = distribByDate[key] || [];
      const dayPresencas = presencasByDate[key] || [];
      const recomputedEntries = await this.buildRecomputedEntriesForDay(
        restID,
        f.data,
        f,
        storedEntries,
      );
      return {
        data: key,
        faturamento_inserido: f.faturamento_inserido.toNumber(),
        faturamento_com_gorjeta: f.faturamento_com_gorjeta?.toNumber() ?? null,
        faturamento_sem_gorjeta: f.faturamento_sem_gorjeta?.toNumber() ?? null,
        valor_total_gorjetas: f.valor_total_gorjetas?.toNumber() ?? null,
        presencas: dayPresencas,
        entries: recomputedEntries,
      };
    }));

    return result;
  }

  /**
   * Mapear modelo para DTO de resposta
   */
  private mapToResponse(
    faturamento: any,
    gorjetas: Prisma.Decimal,
  ): FaturamentoDiarioResponseDto {
    return {
      id: faturamento.id,
      restID: faturamento.restID,
      data: faturamento.data,
      faturamento_inserido: faturamento.faturamento_inserido.toNumber(),
      faturamento_calculado: faturamento.faturamento_calculado.toNumber(),
      gorjeta_total: gorjetas.toNumber(),
      diferenca_percentual: faturamento.diferenca_percentual.toNumber(),
      notas: faturamento.notas,
      ativo: faturamento.ativo,
      criadoEm: faturamento.criadoEm,
      atualizadoEm: faturamento.atualizadoEm,
    };
  }
}
