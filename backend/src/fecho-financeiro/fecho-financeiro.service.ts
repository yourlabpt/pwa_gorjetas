import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateTemplateDto, UpdateTemplateDto, SaveFechoDto } from './dto';

@Injectable()
export class FechoFinanceiroService {
  constructor(private prisma: PrismaService) {}

  private normalizeDate(input: string | Date): Date {
    const d = new Date(`${typeof input === 'string' ? input : input.toISOString().slice(0, 10)}T00:00:00Z`);
    return d;
  }

  // ─── Templates ───────────────────────────────────────────────────────────

  async getTemplates(restID: number) {
    return this.prisma.fechoFinanceiroTemplate.findMany({
      where: { restID, ativo: true },
      orderBy: [{ ordem: 'asc' }, { criadoEm: 'asc' }],
    });
  }

  async createTemplate(restID: number, dto: CreateTemplateDto) {
    return this.prisma.fechoFinanceiroTemplate.create({
      data: {
        restID,
        label: dto.label.trim(),
        ordem: dto.ordem ?? 0,
      },
    });
  }

  async updateTemplate(id: number, restID: number, dto: UpdateTemplateDto) {
    const existing = await this.prisma.fechoFinanceiroTemplate.findFirst({
      where: { id, restID },
    });
    if (!existing) throw new NotFoundException('Template não encontrado');

    return this.prisma.fechoFinanceiroTemplate.update({
      where: { id },
      data: {
        ...(dto.label !== undefined && { label: dto.label.trim() }),
        ...(dto.ordem !== undefined && { ordem: dto.ordem }),
        ...(dto.ativo !== undefined && { ativo: dto.ativo }),
      },
    });
  }

  async deleteTemplate(id: number, restID: number) {
    const existing = await this.prisma.fechoFinanceiroTemplate.findFirst({
      where: { id, restID },
    });
    if (!existing) throw new NotFoundException('Template não encontrado');

    await this.prisma.fechoFinanceiroTemplate.update({
      where: { id },
      data: { ativo: false },
    });
    return { message: 'Template removido' };
  }

  // ─── Fecho Diário ────────────────────────────────────────────────────────

  /**
   * Get fecho for a given date.
   * If no fecho exists yet, returns a "virtual" empty fecho with items
   * pre-populated from the restaurant's templates (value = 0).
   */
  async getFecho(restID: number, dataStr: string) {
    const data = this.normalizeDate(dataStr);

    const existing = await this.prisma.fechoFinanceiro.findUnique({
      where: { restID_data: { restID, data } },
      include: { itens: { orderBy: { criadoEm: 'asc' } } },
    });

    if (existing) {
      return this.toResponse(existing);
    }

    // Build virtual fecho from templates (not saved to DB yet)
    const templates = await this.getTemplates(restID);
    return {
      id: null,
      restID,
      data: data.toISOString().slice(0, 10),
      faturamento_global: 0,
      dinheiro_a_depositar: 0,
      valor_multibanco: null,
      sobra_especie: null,
      sobra_conta_no_deposito: false,
      notas: null,
      itens: templates.map((t) => ({
        id: null,
        templateId: t.id,
        label: t.label,
        valor: 0,
        contaNoDeposito: false,
      })),
    };
  }

  /**
   * Upsert a fecho for the given date. Replaces all items.
   */
  async saveFecho(restID: number, dto: SaveFechoDto) {
    const data = this.normalizeDate(dto.data);

    const fecho = await this.prisma.fechoFinanceiro.upsert({
      where: { restID_data: { restID, data } },
      update: {
        faturamento_global: dto.faturamento_global ?? 0,
        dinheiro_a_depositar: dto.dinheiro_a_depositar ?? 0,
        valor_multibanco: dto.valor_multibanco ?? null,
        sobra_especie: dto.sobra_especie ?? null,
        sobra_conta_no_deposito: dto.sobra_conta_no_deposito ?? false,
        notas: dto.notas ?? null,
      },
      create: {
        restID,
        data,
        faturamento_global: dto.faturamento_global ?? 0,
        dinheiro_a_depositar: dto.dinheiro_a_depositar ?? 0,
        valor_multibanco: dto.valor_multibanco ?? null,
        sobra_especie: dto.sobra_especie ?? null,
        sobra_conta_no_deposito: dto.sobra_conta_no_deposito ?? false,
        notas: dto.notas ?? null,
      },
    });

    // Replace all items
    await this.prisma.fechoFinanceiroItem.deleteMany({ where: { fecID: fecho.id } });

    if (dto.itens && dto.itens.length > 0) {
      await this.prisma.fechoFinanceiroItem.createMany({
        data: dto.itens.map((item) => ({
          fecID: fecho.id,
          templateId: item.templateId ?? null,
          label: item.label.trim(),
          valor: item.valor,
          contaNoDeposito: item.contaNoDeposito ?? false,
        })),
      });
    }

    // Return fully populated fecho
    const result = await this.prisma.fechoFinanceiro.findUnique({
      where: { id: fecho.id },
      include: { itens: { orderBy: { criadoEm: 'asc' } } },
    });

    return this.toResponse(result!);
  }

  /**
   * Get fechos for a date range (for reports).
   */
  async getFechoRange(restID: number, from: string, to: string) {
    const fechos = await this.prisma.fechoFinanceiro.findMany({
      where: {
        restID,
        data: {
          gte: this.normalizeDate(from),
          lte: this.normalizeDate(to),
        },
      },
      include: { itens: { orderBy: { criadoEm: 'asc' } } },
      orderBy: { data: 'asc' },
    });
    return fechos.map((f) => this.toResponse(f));
  }

  private toResponse(fecho: any) {
    return {
      id: fecho.id,
      restID: fecho.restID,
      data: fecho.data instanceof Date ? fecho.data.toISOString().slice(0, 10) : fecho.data,
      faturamento_global: parseFloat(fecho.faturamento_global?.toString() ?? '0'),
      dinheiro_a_depositar: parseFloat(fecho.dinheiro_a_depositar?.toString() ?? '0'),
      valor_multibanco: fecho.valor_multibanco != null ? parseFloat(fecho.valor_multibanco.toString()) : null,
      sobra_especie: fecho.sobra_especie != null ? parseFloat(fecho.sobra_especie.toString()) : null,
      sobra_conta_no_deposito: fecho.sobra_conta_no_deposito ?? false,
      notas: fecho.notas ?? null,
      itens: (fecho.itens ?? []).map((item: any) => ({
        id: item.id,
        templateId: item.templateId ?? null,
        label: item.label,
        valor: parseFloat(item.valor?.toString() ?? '0'),
        contaNoDeposito: Boolean(item.contaNoDeposito),
      })),
    };
  }
}
