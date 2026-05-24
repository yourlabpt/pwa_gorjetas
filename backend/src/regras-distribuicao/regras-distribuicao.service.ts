import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateRegraDistribuicaoDto,
  UpdateRegraDistribuicaoDto,
} from './dto/regra-distribuicao.dto';
import {
  CalculationBase,
  CalculationType,
  EmployeeSplitMode,
  PaymentSource,
  PercentMode,
  SettlementType,
} from '../payout-calculator/payout-calculator.types';
import { Decimal } from 'decimal.js';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { AuditAction, AuditEntity } from '@prisma/client';

@Injectable()
export class RegrasDistribuicaoService {
  constructor(
    private prisma: PrismaService,
    private eventEmitter: EventEmitter2,
  ) {}

  private normalizeRoleName(roleName: string): string {
    return (roleName || '')
      .trim()
      .toLowerCase();
  }

  async findAll(restID: number, apenasAtivos?: boolean) {
    return this.prisma.regraDistribuicao.findMany({
      where: {
        restID,
        ...(apenasAtivos ? { ativo: true } : {}),
      },
      orderBy: [{ ordem: 'asc' }, { criadoEm: 'asc' }],
    });
  }

  async findOne(id: number, restID: number) {
    const regra = await this.prisma.regraDistribuicao.findFirst({
      where: { id, restID },
    });
    if (!regra) throw new NotFoundException(`Regra ${id} não encontrada.`);
    return regra;
  }

  async create(restID: number, dto: CreateRegraDistribuicaoDto) {
    this.validateRule(dto.calculation_type, dto.calculation_base);
    const percentMode = this.resolvePercentMode(
      dto.calculation_type,
      dto.calculation_base ?? null,
      dto.percent_mode,
    );
    const splitMode = this.resolveSplitMode(
      dto.role_name,
      dto.calculation_type,
      dto.calculation_base ?? null,
      dto.payment_source,
      dto.split_mode,
    );
    const tipoDeAcerto = this.resolveTipoAcerto(dto.tipo_de_acerto);

    const created = await this.prisma.regraDistribuicao.create({
      data: {
        restID,
        role_name: this.normalizeRoleName(dto.role_name),
        calculation_type: dto.calculation_type,
        calculation_base: dto.calculation_base ?? null,
        rate: new Decimal(dto.rate),
        percent_mode: percentMode,
        split_mode: splitMode,
        tipo_de_acerto: tipoDeAcerto,
        payment_source: dto.payment_source,
        ordem: dto.ordem ?? 0,
      } as any,
    });

    this.eventEmitter.emit('audit.action', {
      requestId: (global as any).requestId,
      userId: (global as any).userId,
      restID,
      action: AuditAction.CREATED,
      entity: AuditEntity.RegraDistribuicao,
      entityId: created.id.toString(),
      status: 'SUCCESS',
      valuesAfter: created,
      ipAddress: (global as any).ipAddress,
      userAgent: (global as any).userAgent,
      duration: (global as any).requestDuration,
    });

    return created;
  }

  async update(id: number, restID: number, dto: UpdateRegraDistribuicaoDto) {
    const existing = await this.findOne(id, restID); // ensure ownership

    const nextCalculationType =
      dto.calculation_type ?? (existing.calculation_type as any);
    const nextCalculationBase =
      dto.calculation_base !== undefined
        ? dto.calculation_base
        : (existing.calculation_base as any);
    this.validateRule(nextCalculationType, nextCalculationBase);
    const nextPercentMode = this.resolvePercentMode(
      nextCalculationType,
      nextCalculationBase,
      dto.percent_mode !== undefined
        ? dto.percent_mode
        : ((existing as any).percent_mode as any),
    );
    const nextPaymentSource =
      dto.payment_source ?? (existing.payment_source as any);
    const nextRoleName = dto.role_name ?? existing.role_name;
    const nextSplitMode = this.resolveSplitMode(
      nextRoleName,
      nextCalculationType,
      nextCalculationBase,
      nextPaymentSource,
      dto.split_mode !== undefined
        ? dto.split_mode
        : ((existing as any).split_mode as any),
    );
    const nextTipoDeAcerto = this.resolveTipoAcerto(
      dto.tipo_de_acerto !== undefined
        ? dto.tipo_de_acerto
        : ((existing as any).tipo_de_acerto as any),
    );

    const updateData: any = {};
    if (dto.role_name !== undefined)
      updateData.role_name = this.normalizeRoleName(dto.role_name);
    if (dto.calculation_type !== undefined)
      updateData.calculation_type = dto.calculation_type;
    if (dto.calculation_base !== undefined)
      updateData.calculation_base = dto.calculation_base;
    if (dto.rate !== undefined) updateData.rate = new Decimal(dto.rate);
    if (
      dto.percent_mode !== undefined ||
      dto.calculation_type !== undefined ||
      dto.calculation_base !== undefined
    ) {
      updateData.percent_mode = nextPercentMode;
    }
    if (
      dto.split_mode !== undefined ||
      dto.calculation_type !== undefined ||
      dto.calculation_base !== undefined ||
      dto.payment_source !== undefined ||
      dto.role_name !== undefined
    ) {
      updateData.split_mode = nextSplitMode;
    }
    if (dto.tipo_de_acerto !== undefined) {
      updateData.tipo_de_acerto = nextTipoDeAcerto;
    }
    if (dto.payment_source !== undefined)
      updateData.payment_source = dto.payment_source;
    if (dto.ordem !== undefined) updateData.ordem = dto.ordem;
    if (dto.ativo !== undefined) updateData.ativo = dto.ativo;

    const updated = await this.prisma.regraDistribuicao.update({
      where: { id },
      data: updateData,
    });

    this.eventEmitter.emit('audit.action', {
      requestId: (global as any).requestId,
      userId: (global as any).userId,
      restID,
      action: AuditAction.UPDATED,
      entity: AuditEntity.RegraDistribuicao,
      entityId: id.toString(),
      status: 'SUCCESS',
      valuesBefore: existing,
      valuesAfter: updated,
      ipAddress: (global as any).ipAddress,
      userAgent: (global as any).userAgent,
      duration: (global as any).requestDuration,
    });

    return updated;
  }

  async delete(id: number, restID: number) {
    const existing = await this.findOne(id, restID);
    const deleted = await this.prisma.regraDistribuicao.delete({ where: { id } });

    this.eventEmitter.emit('audit.action', {
      requestId: (global as any).requestId,
      userId: (global as any).userId,
      restID,
      action: AuditAction.DELETED,
      entity: AuditEntity.RegraDistribuicao,
      entityId: id.toString(),
      status: 'SUCCESS',
      valuesBefore: existing,
      valuesAfter: deleted,
      ipAddress: (global as any).ipAddress,
      userAgent: (global as any).userAgent,
      duration: (global as any).requestDuration,
    });

    return deleted;
  }

  private validateRule(
    calculationType: CalculationType,
    calculationBase: any,
  ) {
    if (
      calculationType === CalculationType.PERCENT &&
      !calculationBase
    ) {
      throw new BadRequestException(
        'calculation_base é obrigatório quando calculation_type é PERCENT.',
      );
    }

    if (
      calculationType === CalculationType.FIXED_AMOUNT &&
      calculationBase != null
    ) {
      throw new BadRequestException(
        'calculation_base deve ser null quando calculation_type é FIXED_AMOUNT.',
      );
    }
  }

  private resolvePercentMode(
    calculationType: CalculationType,
    calculationBase: CalculationBase | null,
    requested?: PercentMode,
  ): PercentMode {
    if (calculationType !== CalculationType.PERCENT) {
      return PercentMode.ABSOLUTE_PERCENT;
    }
    if (requested) return requested;
    if (calculationBase === CalculationBase.VALOR_TOTAL_GORJETAS) {
      return PercentMode.BASE_PERCENT_POINTS;
    }
    return PercentMode.ABSOLUTE_PERCENT;
  }

  private resolveSplitMode(
    _roleName: string,
    _calculationType: CalculationType,
    _calculationBase: CalculationBase | null,
    paymentSource: PaymentSource,
    requested?: EmployeeSplitMode,
  ): EmployeeSplitMode {
    if (requested) return requested;

    if (paymentSource === PaymentSource.ABSOLUTE_EXTERNAL) {
      return EmployeeSplitMode.DIRECT_INPUT_ONLY;
    }

    return EmployeeSplitMode.EQUAL_SPLIT;
  }

  private resolveTipoAcerto(requested?: SettlementType | null): SettlementType {
    if (requested === SettlementType.PERIODO) return SettlementType.PERIODO;
    return SettlementType.DIARIO;
  }

}
