import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateFaturamentoDiarioDto,
  UpdateFaturamentoDiarioDto,
  FaturamentoDiarioResponseDto,
  SaveFinanceiroSnapshotDto,
} from './dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class FaturamentoDiarioService {
  constructor(private prisma: PrismaService) {}

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

  async saveSnapshot(
    restID: number,
    dto: SaveFinanceiroSnapshotDto,
  ): Promise<void> {
    const dataFormatada = this.normalizeDate(dto.data);

    await this.prisma.$transaction(async (tx) => {
      const existing = await tx.faturamentoDiario.findUnique({
        where: { restID_data: { restID, data: dataFormatada } },
      });

      if (existing) {
        await tx.faturamentoDiario.update({
          where: { id: existing.id },
          data: {
            faturamento_inserido: new Prisma.Decimal(dto.faturamento_global),
            faturamento_calculado: new Prisma.Decimal(dto.faturamento_global),
            diferenca_percentual: new Prisma.Decimal(0),
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
          },
        });
      }

      await tx.faturamentoDiarioDistribuicao.deleteMany({
        where: { restID, data: dataFormatada },
      });

      const rows: Prisma.FaturamentoDiarioDistribuicaoCreateManyInput[] = [];

      dto.staff.forEach((s) => {
        rows.push({
          restID,
          data: dataFormatada,
          funcID: s.funcID,
          role: 'staff',
          valor_pool: new Prisma.Decimal(s.valor_pool),
          valor_direto: new Prisma.Decimal(s.valor_direto),
          valor_teorico: null,
          valor_pago: new Prisma.Decimal(s.valor_pago),
        });
      });

      dto.gestores.forEach((g) => {
        rows.push({
          restID,
          data: dataFormatada,
          funcID: g.funcID,
          role: 'gestor',
          valor_pool: null,
          valor_direto: null,
          valor_teorico: new Prisma.Decimal(g.valor_teorico),
          valor_pago: new Prisma.Decimal(g.valor_pago),
        });
      });

      dto.supervisores.forEach((s) => {
        rows.push({
          restID,
          data: dataFormatada,
          funcID: s.funcID,
          role: 'supervisor',
          valor_pool: null,
          valor_direto: null,
          valor_teorico: new Prisma.Decimal(s.valor_teorico),
          valor_pago: new Prisma.Decimal(s.valor_pago),
        });
      });

      (dto.chamadores || []).forEach((c) => {
        rows.push({
          restID,
          data: dataFormatada,
          funcID: c.funcID,
          role: 'chamador',
          valor_pool: null,
          valor_direto: null,
          valor_teorico: null,
          valor_pago: new Prisma.Decimal(c.valor_pago),
        });
      });

      if (dto.cozinha_valor) {
        rows.push({
          restID,
          data: dataFormatada,
          funcID: null,
          role: 'cozinha',
          valor_pool: null,
          valor_direto: null,
          valor_teorico: null,
          valor_pago: new Prisma.Decimal(dto.cozinha_valor),
        });
      }

      if (rows.length) {
        await tx.faturamentoDiarioDistribuicao.createMany({ data: rows });
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

    return {
      faturamento_inserido: faturamento?.faturamento_inserido?.toNumber() ?? null,
      entries: distrib.map((d: any) => ({
        funcID: d.funcID,
        role: d.role,
        valor_pool: d.valor_pool?.toNumber() || 0,
        valor_direto: d.valor_direto?.toNumber() || 0,
        valor_teorico: d.valor_teorico?.toNumber() || 0,
        valor_pago: d.valor_pago?.toNumber() || 0,
      })),
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

    const distribByDate = distrib.reduce<Record<string, any[]>>((acc, d: any) => {
      const key = d.data.toISOString().split('T')[0];
      if (!acc[key]) acc[key] = [];
      acc[key].push(d);
      return acc;
    }, {});

    return faturamentos.map((f) => {
      const key = f.data.toISOString().split('T')[0];
      const entries = distribByDate[key] || [];
      return {
        data: key,
        faturamento_inserido: f.faturamento_inserido.toNumber(),
        entries: entries.map((d: any) => ({
          funcID: d.funcID,
          role: d.role,
          valor_pool: d.valor_pool?.toNumber() || 0,
          valor_direto: d.valor_direto?.toNumber() || 0,
          valor_teorico: d.valor_teorico?.toNumber() || 0,
          valor_pago: d.valor_pago?.toNumber() || 0,
        })),
      };
    });
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
