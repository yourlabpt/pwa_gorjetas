import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateTransacaoDto } from './dto/transacao.dto';
import { Decimal } from 'decimal.js';
import { FinanceEngineService } from '../finance-engine/finance-engine.service';
import { PaymentSource } from '../payout-calculator/payout-calculator.types';

@Injectable()
export class TransacoesService {
  constructor(
    private prisma: PrismaService,
    private financeEngine: FinanceEngineService,
  ) {}

  async create(data: CreateTransacaoDto) {
    await this.validateGarcom(data.funcID_garcom, data.restID);

    const valorGorjeta = new Decimal(data.valor_gorjeta_calculada);
    const total = new Decimal(data.total);

    const restaurante = await this.prisma.restaurante.findUnique({
      where: { restID: data.restID },
      select: { percentagem_gorjeta_base: true },
    });

    if (!restaurante) {
      throw new BadRequestException(`Restaurant ${data.restID} not found`);
    }

    const computation = await this.financeEngine.computeDailyPayouts(
      data.restID,
      {
        faturamento_global: total.toNumber(),
        faturamento_com_gorjeta: total.toNumber(),
        faturamento_sem_gorjeta: Math.max(
          total.minus(valorGorjeta).toNumber(),
          0,
        ),
        valor_total_gorjetas: valorGorjeta.toNumber(),
      },
      {
        insufficientFundsPolicy: 'PARTIAL',
        base_percentual: Number(restaurante.percentagem_gorjeta_base),
      },
    );

    const distributions = computation.employee_breakdown.filter(
      (line) =>
        line.funcID != null &&
        line.real_paid_value > 0 &&
        line.payment_pool === PaymentSource.TIP_POOL,
    );

    if (distributions.length === 0) {
      throw new BadRequestException(
        `No active TIP_POOL rules with matched employees found for restaurant ${data.restID}`,
      );
    }

    const transacao = await this.prisma.$transaction(async (tx) => {
      const newTransacao = await tx.transacao.create({
        data: {
          total,
          valor_gorjeta_calculada: valorGorjeta,
          percentagem_aplicada: restaurante.percentagem_gorjeta_base,
          mbway: new Decimal(data.mbway || 0),
          funcID_garcom: data.funcID_garcom,
          restID: data.restID,
          data_transacao: new Date(data.data_transacao),
        },
      });

      for (const dist of distributions) {
        await tx.distribuicaoGorjetas.create({
          data: {
            tranID: newTransacao.tranID,
            funcID: dist.funcID!,
            tipo_distribuicao: dist.role_bucket,
            percentagem_aplicada: new Decimal(dist.rate),
            valor_calculado: new Decimal(dist.real_paid_value),
          },
        });
      }

      return newTransacao;
    });

    return this.findOneWithDistributions(transacao.tranID);
  }

  async findMany(
    restID: number,
    funcID?: number,
    from?: string,
    to?: string,
  ) {
    const where: any = { restID };

    if (funcID) {
      where.funcID_garcom = funcID;
    }

    if (from || to) {
      where.data_transacao = {};
      if (from) {
        where.data_transacao.gte = new Date(from);
      }
      if (to) {
        const toDate = new Date(to);
        toDate.setHours(23, 59, 59, 999);
        where.data_transacao.lte = toDate;
      }
    }

    return this.prisma.transacao.findMany({
      where,
      include: {
        garcom: true,
        distribuicoes: {
          include: {
            funcionario: true,
          },
        },
      },
      orderBy: { data_transacao: 'desc' },
    });
  }

  async findOne(tranID: number) {
    return this.prisma.transacao.findUnique({
      where: { tranID },
      include: {
        garcom: true,
        distribuicoes: {
          include: {
            funcionario: true,
          },
        },
      },
    });
  }

  private async findOneWithDistributions(tranID: number) {
    return this.prisma.transacao.findUnique({
      where: { tranID },
      include: {
        garcom: true,
        distribuicoes: {
          include: {
            funcionario: true,
          },
        },
      },
    });
  }

  private async validateGarcom(funcID: number, restID: number): Promise<void> {
    const funcionario = await this.prisma.funcionario.findUnique({
      where: { funcID },
    });

    if (!funcionario || funcionario.restID !== restID) {
      throw new BadRequestException(
        `Waiter ${funcID} not found in restaurant ${restID}`,
      );
    }
  }
}
