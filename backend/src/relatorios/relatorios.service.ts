import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Decimal } from 'decimal.js';

@Injectable()
export class RelatoriosService {
  constructor(private prisma: PrismaService) {}

  /**
   * Get totals by employee with breakdown by type
   */
  async getFuncionariosReport(
    restID: number,
    from?: string,
    to?: string,
  ) {
    const where: any = { transacao: { restID } };

    if (from || to) {
      where.transacao = where.transacao || {};
      where.transacao.createdAt = {};
      if (from) {
        where.transacao.createdAt.gte = new Date(from);
      }
      if (to) {
        where.transacao.createdAt.lte = new Date(to);
      }
    }

    const distributions = await this.prisma.distribuicaoGorjetas.findMany({
      where,
      include: {
        funcionario: true,
        transacao: true,
      },
    });
    const presencas = await this.prisma.$queryRaw<
      Array<{ funcID: number; data: Date; presente: boolean }>
    >`
      SELECT "funcID", "data", "presente"
      FROM "funcionario_presenca_diaria"
      WHERE "restID" = ${restID}
    `;
    const filteredPresencas = presencas.filter((presenca) => {
      if (!presenca.presente) return false;
      if (from && presenca.data < new Date(from)) return false;
      if (to && presenca.data > new Date(to)) return false;
      return true;
    });
    const diasTrabalhados = new Map<number, Set<string>>();
    filteredPresencas.forEach((presenca) => {
      if (!diasTrabalhados.has(presenca.funcID)) {
        diasTrabalhados.set(presenca.funcID, new Set<string>());
      }
      diasTrabalhados
        .get(presenca.funcID)!
        .add(presenca.data.toISOString().split('T')[0]);
    });

    // Group by employee
    const reportMap: Map<
      number,
      {
        funcID: number;
        name: string;
        total_gorjeta: Decimal;
        breakdown: Map<string, Decimal>;
        count_transacoes: Set<number>;
        total_mbway: Decimal;
      }
    > = new Map();

    for (const dist of distributions) {
      const funcID = dist.funcID;
      if (!reportMap.has(funcID)) {
        reportMap.set(funcID, {
          funcID,
          name: dist.funcionario.name,
          total_gorjeta: new Decimal(0),
          breakdown: new Map(),
          count_transacoes: new Set<number>(),
          total_mbway: new Decimal(0),
        });
      }

      const entry = reportMap.get(funcID);
      if (entry) {
        entry.total_gorjeta = entry.total_gorjeta.plus(dist.valor_calculado);

        const tipo = dist.tipo_distribuicao;
        const current = entry.breakdown.get(tipo) || new Decimal(0);
        entry.breakdown.set(tipo, current.plus(dist.valor_calculado));

        // Track unique transactions for count
        if (!entry.count_transacoes.has(dist.tranID)) {
          entry.count_transacoes.add(dist.tranID);
        }

        // Add MB WAY totals (only for garcom)
        if (dist.tipo_distribuicao === 'garcom') {
          entry.total_mbway = entry.total_mbway.plus(dist.transacao.mbway);
        }
      }
    }

    // Convert to array and format
    const report = Array.from(reportMap.values())
      .map((entry) => ({
        funcID: entry.funcID,
        name: entry.name,
        total_gorjeta: entry.total_gorjeta.toNumber(),
        breakdown: Object.fromEntries(
          Array.from(entry.breakdown.entries()).map(([k, v]) => [
            k,
            v.toNumber(),
          ]),
        ),
        count_transacoes: entry.count_transacoes.size,
        total_mbway: entry.total_mbway.toNumber(),
        days_worked: diasTrabalhados.get(entry.funcID)?.size || 0,
      }))
      .sort((a, b) => b.total_gorjeta - a.total_gorjeta);

    return report;
  }

  /**
   * Get overall summary with totals by distribution type
   */
  async getResumoReport(restID: number, from?: string, to?: string) {
    const where: any = { transacao: { restID } };

    if (from || to) {
      where.transacao = where.transacao || {};
      where.transacao.createdAt = {};
      if (from) {
        where.transacao.createdAt.gte = new Date(from);
      }
      if (to) {
        where.transacao.createdAt.lte = new Date(to);
      }
    }

    const distributions = await this.prisma.distribuicaoGorjetas.findMany({
      where,
      include: { transacao: true },
    });

    let totalGorjeta = new Decimal(0);
    const breakdownByType: Map<string, Decimal> = new Map();
    let countTransacoes = 0;
    const uniqueTransacoes = new Set<number>();

    for (const dist of distributions) {
      totalGorjeta = totalGorjeta.plus(dist.valor_calculado);

      const tipo = dist.tipo_distribuicao;
      const current = breakdownByType.get(tipo) || new Decimal(0);
      breakdownByType.set(tipo, current.plus(dist.valor_calculado));

      uniqueTransacoes.add(dist.tranID);
    }

    countTransacoes = uniqueTransacoes.size;

    return {
      total_gorjeta: totalGorjeta.toNumber(),
      count_transacoes: countTransacoes,
      breakdown_by_type: Object.fromEntries(
        Array.from(breakdownByType.entries()).map(([k, v]) => [
          k,
          v.toNumber(),
        ]),
      ),
    };
  }

  /**
   * Calculate reverse billing (faturamento)
   * faturamento = total_gorjeta / (base_percent / 100)
   */
  async getFaturamentoReport(restID: number, from?: string, to?: string) {
    const restaurante = await this.prisma.restaurante.findUnique({
      where: { restID },
    });

    if (!restaurante) {
      return { error: `Restaurant ${restID} not found` };
    }

    const basePercent = restaurante.percentagem_gorjeta_base;

    const where: any = { restID };

    if (from || to) {
      where.createdAt = {};
      if (from) {
        where.createdAt.gte = new Date(from);
      }
      if (to) {
        where.createdAt.lte = new Date(to);
      }
    }

    const transacoes = await this.prisma.transacao.findMany({
      where,
    });

    let totalGorjeta = new Decimal(0);
    let totalFaturamento = new Decimal(0);

    for (const trans of transacoes) {
      totalGorjeta = totalGorjeta.plus(trans.valor_gorjeta_calculada);
      const faturamento = new Decimal(trans.valor_gorjeta_calculada)
        .times(100)
        .dividedBy(basePercent);
      totalFaturamento = totalFaturamento.plus(faturamento);
    }

    return {
      base_percentage: basePercent.toNumber(),
      total_gorjeta: totalGorjeta.toNumber(),
      total_faturamento: totalFaturamento.toDecimalPlaces(2).toNumber(),
      count_transacoes: transacoes.length,
    };
  }
}
