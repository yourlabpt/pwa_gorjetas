import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateConfiguracaoAcertoDto,
  UpdateConfiguracaoAcertoDto,
  ConfiguracaoAcertoResponseDto,
} from './dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class ConfiguracaoAcertoService {
  constructor(private prisma: PrismaService) {}

  private normalizeFuncaoLabel(funcao: string): string {
    return (funcao || '').trim().replace(/gestor/gi, 'Gerente');
  }

  /**
   * Criar configuração de acerto para uma função
   */
  async create(
    restID: number,
    dto: CreateConfiguracaoAcertoDto,
  ): Promise<ConfiguracaoAcertoResponseDto> {
    const funcaoNormalizada = this.normalizeFuncaoLabel(dto.funcao);
    // Validar se restaurante existe
    await this.prisma.restaurante.findUniqueOrThrow({
      where: { restID },
    });

    // Validar se já existe configuração para esta função
    const existente = await this.prisma.configuracaoAcerto.findUnique({
      where: {
        restID_funcao: {
          restID,
          funcao: funcaoNormalizada,
        },
      },
    });

    if (existente && existente.ativo) {
      throw new BadRequestException(
        `Já existe configuração para a função: ${funcaoNormalizada}`,
      );
    }

    // Validar base_calculo
    const basesValidas = ['GORJETA_TOTAL', 'FATURAMENTO_BASE', 'ABSOLUTO', 'GORJETA_REMAINING', 'FATURAMENTO_EXTRA'];
    if (!basesValidas.includes(dto.base_calculo)) {
      throw new BadRequestException('base_calculo inválido');
    }

    // Validar valores
    if (
      dto.base_calculo === 'ABSOLUTO' &&
      (dto.valor_absoluto === undefined || dto.valor_absoluto === null)
    ) {
      throw new BadRequestException(
        'valor_absoluto é obrigatório quando base_calculo é ABSOLUTO',
      );
    }

    if (
      dto.base_calculo !== 'ABSOLUTO' &&
      (dto.valor_percentual === undefined || dto.valor_percentual === null)
    ) {
      throw new BadRequestException(
        'valor_percentual é obrigatório quando base_calculo não é ABSOLUTO',
      );
    }

    // Se percentual, validar faixa
    if (
      dto.valor_percentual !== undefined &&
      (dto.valor_percentual < 0 || dto.valor_percentual > 100)
    ) {
      throw new BadRequestException('valor_percentual deve estar entre 0 e 100');
    }

    // Se absoluto, validar positivo
    if (
      dto.valor_absoluto !== undefined &&
      dto.valor_absoluto < 0
    ) {
      throw new BadRequestException('valor_absoluto deve ser positivo');
    }

    const config = await this.prisma.configuracaoAcerto.create({
      data: {
        restID,
        funcao: funcaoNormalizada,
        base_calculo: dto.base_calculo,
        valor_percentual:
          dto.valor_percentual !== undefined
            ? new Prisma.Decimal(dto.valor_percentual)
            : null,
        valor_absoluto:
          dto.valor_absoluto !== undefined
            ? new Prisma.Decimal(dto.valor_absoluto)
            : null,
        ordem_calculo: dto.ordem_calculo !== undefined ? dto.ordem_calculo : 999,
      },
    });

    return this.mapToResponse(config);
  }

  /**
   * Listar configurações de acerto por restaurante
   */
  async findByRestaurante(restID: number): Promise<ConfiguracaoAcertoResponseDto[]> {
    await this.prisma.restaurante.findUniqueOrThrow({
      where: { restID },
    });

    const configs = await this.prisma.configuracaoAcerto.findMany({
      where: {
        restID,
        ativo: true,
      },
      orderBy: { funcao: 'asc' },
    });

    return configs.map((c) => this.mapToResponse(c));
  }

  /**
   * Obter configuração específica
   */
  async findById(id: number): Promise<ConfiguracaoAcertoResponseDto> {
    const config = await this.prisma.configuracaoAcerto.findUnique({
      where: { id },
    });

    if (!config) {
      throw new NotFoundException('Configuração não encontrada');
    }

    return this.mapToResponse(config);
  }

  /**
   * Atualizar configuração de acerto
   */
  async update(
    id: number,
    dto: UpdateConfiguracaoAcertoDto,
  ): Promise<ConfiguracaoAcertoResponseDto> {
    const config = await this.prisma.configuracaoAcerto.findUnique({
      where: { id },
    });

    if (!config) {
      throw new NotFoundException('Configuração não encontrada');
    }

    // Validar valores se alterados
    if (dto.base_calculo !== undefined) {
      const basesValidas = ['GORJETA_TOTAL', 'FATURAMENTO_BASE', 'ABSOLUTO', 'GORJETA_REMAINING', 'FATURAMENTO_EXTRA'];
      if (!basesValidas.includes(dto.base_calculo)) {
        throw new BadRequestException('base_calculo inválido');
      }
    }

    if (
      dto.valor_percentual !== undefined &&
      (dto.valor_percentual < 0 || dto.valor_percentual > 100)
    ) {
      throw new BadRequestException('valor_percentual deve estar entre 0 e 100');
    }

    if (dto.valor_absoluto !== undefined && dto.valor_absoluto < 0) {
      throw new BadRequestException('valor_absoluto deve ser positivo');
    }

    const atualizado = await this.prisma.configuracaoAcerto.update({
      where: { id },
      data: {
        base_calculo: dto.base_calculo,
        valor_percentual:
          dto.valor_percentual !== undefined
            ? new Prisma.Decimal(dto.valor_percentual)
            : undefined,
        valor_absoluto:
          dto.valor_absoluto !== undefined
            ? new Prisma.Decimal(dto.valor_absoluto)
            : undefined,
        ordem_calculo: dto.ordem_calculo !== undefined ? dto.ordem_calculo : undefined,
      },
    });

    return this.mapToResponse(atualizado);
  }

  /**
   * Deletar (soft delete) configuração
   */
  async delete(id: number): Promise<void> {
    const config = await this.prisma.configuracaoAcerto.findUnique({
      where: { id },
    });

    if (!config) {
      throw new NotFoundException('Configuração não encontrada');
    }

    await this.prisma.configuracaoAcerto.update({
      where: { id },
      data: { ativo: false },
    });
  }

  /**
   * Mapear modelo para DTO de resposta
   */
  private mapToResponse(config: any): ConfiguracaoAcertoResponseDto {
    return {
      id: config.id,
      restID: config.restID,
      funcao: config.funcao,
      base_calculo: config.base_calculo,
      valor_percentual: config.valor_percentual
        ? config.valor_percentual.toNumber()
        : null,
      valor_absoluto: config.valor_absoluto
        ? config.valor_absoluto.toNumber()
        : null,
      ordem_calculo: config.ordem_calculo,
      ativo: config.ativo,
      criadoEm: config.criadoEm,
      atualizadoEm: config.atualizadoEm,
    };
  }
}
