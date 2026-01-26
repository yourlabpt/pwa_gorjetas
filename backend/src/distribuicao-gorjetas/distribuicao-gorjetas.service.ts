import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DistribuicaoGorjetasService {
  constructor(private prisma: PrismaService) {}

  async findByTransaction(tranID: number) {
    return this.prisma.distribuicaoGorjetas.findMany({
      where: { tranID },
      include: {
        funcionario: true,
        transacao: true,
      },
      orderBy: { createdAt: 'asc' },
    });
  }

  async findByFuncionario(
    funcID: number,
    from?: string,
    to?: string,
    restID?: number,
  ) {
    const where: any = { funcID };

    if (from || to) {
      where.createdAt = {};
      if (from) {
        where.createdAt.gte = new Date(from);
      }
      if (to) {
        where.createdAt.lte = new Date(to);
      }
    }

    let distributions = await this.prisma.distribuicaoGorjetas.findMany({
      where,
      include: {
        funcionario: true,
        transacao: true,
      },
      orderBy: { createdAt: 'desc' },
    });

    // Filter by restID if provided
    if (restID) {
      distributions = distributions.filter(
        (d) => d.transacao.restID === restID,
      );
    }

    return distributions;
  }

  async findMany(tranID?: number, funcID?: number) {
    const where: any = {};
    if (tranID) where.tranID = tranID;
    if (funcID) where.funcID = funcID;

    return this.prisma.distribuicaoGorjetas.findMany({
      where,
      include: {
        funcionario: true,
        transacao: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
