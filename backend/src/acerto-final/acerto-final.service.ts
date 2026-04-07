import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SaveAcertoFinalDto } from './dto/save-acerto-final.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class AcertoFinalService {
  constructor(private prisma: PrismaService) {}

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

  async save(restID: number, dto: SaveAcertoFinalDto) {
    const inicio = this.normalizeDate(dto.periodo_inicio);
    const fim = this.normalizeDate(dto.periodo_fim);

    await this.prisma.restaurante.findUniqueOrThrow({
      where: { restID },
    });

    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.acertoFinalPeriodo.findUnique({
        where: {
          restID_periodo_inicio_periodo_fim: {
            restID,
            periodo_inicio: inicio,
            periodo_fim: fim,
          },
        },
      });

      let periodoId: number;

      if (existing) {
        periodoId = existing.id;
        await tx.acertoFinalEntry.deleteMany({
          where: { acerto_final_periodo_id: periodoId },
        });
      } else {
        const created = await tx.acertoFinalPeriodo.create({
          data: {
            restID,
            periodo_inicio: inicio,
            periodo_fim: fim,
          },
        });
        periodoId = created.id;
      }

      if (dto.entries.length > 0) {
        await tx.acertoFinalEntry.createMany({
          data: dto.entries.map((entry) => ({
            acerto_final_periodo_id: periodoId,
            funcID: entry.funcID,
            bucket: entry.bucket,
            valor_sugerido: new Prisma.Decimal(entry.valor_sugerido),
            valor_manual: new Prisma.Decimal(entry.valor_manual),
            is_manual_override: entry.is_manual_override,
            notas: entry.notas || null,
          })),
        });
      }

      return this.findByIdInternal(tx, periodoId);
    });
  }

  async findByPeriod(restID: number, from: string, to: string) {
    const inicio = this.normalizeDate(from);
    const fim = this.normalizeDate(to);

    const record = await this.prisma.acertoFinalPeriodo.findUnique({
      where: {
        restID_periodo_inicio_periodo_fim: {
          restID,
          periodo_inicio: inicio,
          periodo_fim: fim,
        },
      },
      include: {
        entries: {
          orderBy: { funcID: 'asc' },
        },
      },
    });

    if (!record) return null;
    return this.mapToResponse(record);
  }

  async delete(id: number, restID: number) {
    const record = await this.prisma.acertoFinalPeriodo.findFirst({
      where: { id, restID },
    });

    if (!record) {
      throw new NotFoundException('Acerto Final não encontrado');
    }

    await this.prisma.acertoFinalPeriodo.delete({
      where: { id },
    });
  }

  private async findByIdInternal(tx: any, id: number) {
    const record = await tx.acertoFinalPeriodo.findUnique({
      where: { id },
      include: {
        entries: {
          orderBy: { funcID: 'asc' },
        },
      },
    });
    return record ? this.mapToResponse(record) : null;
  }

  private mapToResponse(record: any) {
    return {
      id: record.id,
      restID: record.restID,
      periodo_inicio: record.periodo_inicio,
      periodo_fim: record.periodo_fim,
      criadoEm: record.criadoEm,
      atualizadoEm: record.atualizadoEm,
      entries: (record.entries || []).map((e: any) => ({
        id: e.id,
        funcID: e.funcID,
        bucket: e.bucket,
        valor_sugerido: e.valor_sugerido?.toNumber?.() ?? Number(e.valor_sugerido),
        valor_manual: e.valor_manual?.toNumber?.() ?? Number(e.valor_manual),
        is_manual_override: e.is_manual_override,
        notas: e.notas,
      })),
    };
  }
}
