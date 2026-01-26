import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TipCalculatorService } from '../tip-calculator/tip-calculator.service';
import { CreateTransacaoDto } from './dto/transacao.dto';
import { Decimal } from 'decimal.js';

@Injectable()
export class TransacoesService {
  constructor(
    private prisma: PrismaService,
    private tipCalculator: TipCalculatorService,
  ) {}

  async create(data: CreateTransacaoDto) {
    // Validate garçom exists in restaurant
    await this.tipCalculator.validateGarcom(data.funcID_garcom, data.restID);

    // Use provided valor_gorjeta_calculada (already calculated on frontend)
    const valorGorjeta = new Decimal(data.valor_gorjeta_calculada);

    // Generate distribution payloads based on the provided gorjeta value
    const calculationResult =
      await this.tipCalculator.generateDistributionsForGorjeta(
        data.restID,
        valorGorjeta,
      );

    // Create transaction and distributions atomically
    const transacao = await this.prisma.$transaction(async (tx) => {
      // Create transaction
      const newTransacao = await tx.transacao.create({
        data: {
          total: new Decimal(data.total),
          valor_gorjeta_calculada: valorGorjeta,
          percentagem_aplicada: calculationResult.base_percentage,
          mbway: new Decimal(data.mbway || 0),
          funcID_garcom: data.funcID_garcom,
          restID: data.restID,
          data_transacao: new Date(data.data_transacao),
        },
      });

      // Create distribution records
      for (const dist of calculationResult.distributions) {
        await tx.distribuicaoGorjetas.create({
          data: {
            tranID: newTransacao.tranID,
            funcID: dist.funcID,
            tipo_distribuicao: dist.funcao,
            percentagem_aplicada: dist.percentagem_aplicada,
            valor_calculado: dist.valor_calculado,
          },
        });
      }

      return newTransacao;
    });

    // Fetch full transaction with distributions
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
        // Set to end of day for 'to' date
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
}
