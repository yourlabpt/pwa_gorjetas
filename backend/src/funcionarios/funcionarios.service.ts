import { BadRequestException, Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { AuditAction, AuditEntity } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CreateFuncionarioDto, UpdateFuncionarioDto } from './dto/funcionario.dto';

export interface StatusChangeContext {
  userId?: number;
  requestId?: string;
  ipAddress?: string;
  userAgent?: string;
}

@Injectable()
export class FuncionariosService {
  constructor(
    private prisma: PrismaService,
    private eventEmitter: EventEmitter2,
  ) {}

  private sanitizePayload(
    data: CreateFuncionarioDto | UpdateFuncionarioDto,
  ): Record<string, unknown> {
    const payload: Record<string, unknown> = { ...data };

    if ('data_admissao' in data) {
      payload.data_admissao =
        data.data_admissao === null
          ? null
          : data.data_admissao
            ? new Date(`${data.data_admissao}T00:00:00Z`)
            : undefined;
    }

    if ('iban' in data) {
      payload.iban =
        data.iban === null
          ? null
          : data.iban?.trim()
            ? data.iban.trim()
            : undefined;
    }

    if ('salario' in data) {
      payload.salario = data.salario ?? undefined;
    }

    return payload;
  }

  /** Lisbon calendar day as a UTC-midnight Date (matches @db.Date columns). */
  private todayLisbon(): Date {
    const ymd = new Intl.DateTimeFormat('en-CA', { timeZone: 'Europe/Lisbon' }).format(new Date());
    return new Date(`${ymd}T00:00:00Z`);
  }

  private normalizeDay(data: Date | string): Date {
    const d = typeof data === 'string' ? new Date(`${data}T00:00:00Z`) : new Date(data);
    d.setUTCHours(0, 0, 0, 0);
    return d;
  }

  /** Nested write that opens (activate) or closes (deactivate) the activity period. */
  private periodoChange(ativo: boolean) {
    const hoje = this.todayLisbon();
    return ativo
      ? { create: { inicio: hoje } }
      : { updateMany: { where: { fim: null }, data: { fim: hoje } } };
  }

  private emitStatusAudit(
    action: AuditAction,
    before: { funcID: number; restID: number | null; ativo: boolean; deletedAt: Date | null },
    after: { ativo: boolean; deletedAt: Date | null },
    context?: StatusChangeContext,
  ) {
    this.eventEmitter.emit('audit.action', {
      requestId: context?.requestId,
      userId: context?.userId,
      restID: before.restID ?? undefined,
      action,
      entity: AuditEntity.Funcionario,
      entityId: before.funcID.toString(),
      status: 'SUCCESS',
      valuesBefore: { ativo: before.ativo, deletedAt: before.deletedAt },
      valuesAfter: { ativo: after.ativo, deletedAt: after.deletedAt },
      ipAddress: context?.ipAddress,
      userAgent: context?.userAgent,
    });
  }

  async create(data: CreateFuncionarioDto) {
    const payload = this.sanitizePayload(data);
    const hoje = this.todayLisbon();
    const admissao = payload.data_admissao instanceof Date ? payload.data_admissao : null;
    const inicio = admissao && admissao < hoje ? admissao : hoje;
    return this.prisma.funcionario.create({
      data: { ...payload, periodos: { create: { inicio } } } as any,
    });
  }

  async findMany(restID: number, ativo?: boolean, includeDeleted = false) {
    const where: any = { restID };
    if (ativo !== undefined) {
      where.ativo = ativo;
    }
    if (!includeDeleted) {
      where.deletedAt = null;
    }

    return this.prisma.funcionario.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Employees that belong to a given day: active on that day (activity periods)
   * or already present in that day's stored financial/presence rows.
   * Includes inactive and soft-deleted employees on purpose: history must be kept.
   */
  async findForDay(restID: number, data: Date | string) {
    const dia = this.normalizeDay(data);
    return this.prisma.funcionario.findMany({
      where: {
        OR: [
          {
            restID,
            periodos: {
              some: { inicio: { lte: dia }, OR: [{ fim: null }, { fim: { gte: dia } }] },
            },
          },
          { faturamento_distribuicoes: { some: { restID, data: dia } } },
          { presencas: { some: { restID, data: dia } } },
        ],
      },
      orderBy: { createdAt: 'asc' },
    });
  }

  async findOne(funcID: number) {
    return this.prisma.funcionario.findUnique({
      where: { funcID },
    });
  }

  async update(funcID: number, data: UpdateFuncionarioDto, context?: StatusChangeContext) {
    const funcionario = await this.findOne(funcID);
    if (funcionario?.deletedAt) {
      throw new BadRequestException('Funcionário eliminado não pode ser editado sem restauro prévio');
    }

    const payload = this.sanitizePayload(data);
    const statusChanged =
      funcionario != null && data.ativo !== undefined && data.ativo !== funcionario.ativo;
    if (statusChanged) {
      payload.periodos = this.periodoChange(data.ativo!);
    }

    const updated = await this.prisma.funcionario.update({
      where: { funcID },
      data: payload as any,
    });
    if (statusChanged) {
      this.emitStatusAudit(AuditAction.UPDATED, funcionario!, updated, context);
    }
    return updated;
  }

  async toggleActive(funcID: number, context?: StatusChangeContext) {
    const funcionario = await this.findOne(funcID);
    if (!funcionario) {
      throw new Error('Funcionário não encontrado');
    }
    if (funcionario.deletedAt) {
      throw new BadRequestException('Funcionário eliminado não pode ser ativado/desativado');
    }

    const ativo = !funcionario.ativo;
    const updated = await this.prisma.funcionario.update({
      where: { funcID },
      data: { ativo, periodos: this.periodoChange(ativo) },
    });
    this.emitStatusAudit(AuditAction.UPDATED, funcionario, updated, context);
    return updated;
  }

  async softDelete(funcID: number, context?: StatusChangeContext) {
    const funcionario = await this.findOne(funcID);
    if (!funcionario) {
      throw new Error('Funcionário não encontrado');
    }
    if (funcionario.deletedAt) {
      throw new BadRequestException('Funcionário já eliminado');
    }

    const updated = await this.prisma.funcionario.update({
      where: { funcID },
      data: {
        ativo: false,
        deletedAt: new Date(),
        periodos: this.periodoChange(false),
      },
    });
    this.emitStatusAudit(AuditAction.DELETED, funcionario, updated, context);
    return updated;
  }

  async restore(funcID: number) {
    const funcionario = await this.findOne(funcID);
    if (!funcionario) {
      throw new Error('Funcionário não encontrado');
    }
    if (!funcionario.deletedAt) {
      throw new BadRequestException('Funcionário não está eliminado');
    }

    return this.prisma.funcionario.update({
      where: { funcID },
      data: {
        deletedAt: null,
        deleteReason: null,
        ativo: false,
      },
    });
  }
}
