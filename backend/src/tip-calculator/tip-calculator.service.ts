import { Injectable, BadRequestException } from '@nestjs/common';
import { Decimal } from 'decimal.js';
import { PrismaService } from '../prisma/prisma.service';

export interface DistributionPayload {
  funcao: string;
  funcID: number;
  percentagem_aplicada: Decimal;
  valor_calculado: Decimal;
}

@Injectable()
export class TipCalculatorService {
  constructor(private prisma: PrismaService) {}

  /**
   * Generate distribution payloads for a given gorjeta amount
   * Supports two calculation types:
   * - "percentagem": Direct percentage of gorjeta (e.g., 40% of gorjeta)
   * - "remainder": Gets what's left after other roles (e.g., Cozinha = 100% - Garcom% - outros%)
   */
  async generateDistributionsForGorjeta(
    restID: number,
    valorGorjeta: Decimal,
  ): Promise<{
    base_percentage: Decimal;
    distributions: DistributionPayload[];
  }> {
    // Fetch restaurant base percentage
    const restaurante = await this.prisma.restaurante.findUnique({
      where: { restID },
    });

    if (!restaurante) {
      throw new BadRequestException(`Restaurant ${restID} not found`);
    }

    // Fetch all active configs ordered by calculation priority
    const configs = await this.prisma.configuracaoGorjetas.findMany({
      where: {
        restID,
        ativo: true,
      },
      orderBy: { ordem_calculo: 'asc' },
    });

    if (configs.length === 0) {
      throw new BadRequestException(
        `No tip configurations found for restaurant ${restID}`,
      );
    }

    // Validate and fetch employees
    const missingFuncoes: string[] = [];
    const distributions: DistributionPayload[] = [];
    let totalPercentageUsed = new Decimal(0);

    // First pass: calculate direct percentages
    for (const config of configs) {
      if (config.tipo_calculo !== 'percentagem') {
        continue; // Skip remainder calculations for now
      }

      // Fetch employee for this function
      const funcionario = await this.prisma.funcionario.findFirst({
        where: {
          restID,
          funcao: config.funcao,
          ativo: true,
        },
      });

      if (!funcionario) {
        missingFuncoes.push(config.funcao);
        continue;
      }

      // Calculate distribution amount as percentage of total gorjeta
      const valor_calculado = new Decimal(valorGorjeta)
        .times(config.percentagem)
        .dividedBy(100)
        .toDecimalPlaces(2);

      totalPercentageUsed = totalPercentageUsed.plus(config.percentagem);

      distributions.push({
        funcao: config.funcao,
        funcID: funcionario.funcID,
        percentagem_aplicada: new Decimal(config.percentagem),
        valor_calculado,
      });
    }

    // Second pass: calculate remainder distributions
    const remainderPercentage = new Decimal(100).minus(totalPercentageUsed);

    for (const config of configs) {
      if (config.tipo_calculo !== 'remainder') {
        continue; // Only process remainder calculations
      }

      // Fetch employee for this function
      const funcionario = await this.prisma.funcionario.findFirst({
        where: {
          restID,
          funcao: config.funcao,
          ativo: true,
        },
      });

      if (!funcionario) {
        missingFuncoes.push(config.funcao);
        continue;
      }

      // Calculate distribution as remainder percentage
      const valor_calculado = new Decimal(valorGorjeta)
        .times(remainderPercentage)
        .dividedBy(100)
        .toDecimalPlaces(2);

      distributions.push({
        funcao: config.funcao,
        funcID: funcionario.funcID,
        percentagem_aplicada: remainderPercentage,
        valor_calculado,
      });
    }

    if (missingFuncoes.length > 0) {
      throw new BadRequestException(
        `Missing active employee(s) for function(s): ${missingFuncoes.join(', ')}`,
      );
    }

    return {
      base_percentage: restaurante.percentagem_gorjeta_base,
      distributions,
    };
  }

  /**
   * Calculate total tip and generate distribution payloads
   * Validates that all required configs and employees exist
   */
  async calculateAndGenerateDistributions(
    restID: number,
    total: Decimal,
  ): Promise<{
    total_tip: Decimal;
    base_percentage: Decimal;
    distributions: DistributionPayload[];
  }> {
    // Fetch restaurant base percentage
    const restaurante = await this.prisma.restaurante.findUnique({
      where: { restID },
    });

    if (!restaurante) {
      throw new BadRequestException(`Restaurant ${restID} not found`);
    }

    // Calculate total tip
    const total_tip = new Decimal(total)
      .times(restaurante.percentagem_gorjeta_base)
      .dividedBy(100)
      .toDecimalPlaces(2);

    // Fetch all active configs for this restaurant
    const configs = await this.prisma.configuracaoGorjetas.findMany({
      where: {
        restID,
        ativo: true,
      },
    });

    if (configs.length === 0) {
      throw new BadRequestException(
        `No tip configurations found for restaurant ${restID}`,
      );
    }

    // Validate and fetch employees
    const missingFuncoes: string[] = [];
    const distributions: DistributionPayload[] = [];

    for (const config of configs) {
      // Fetch employee for this function
      const funcionario = await this.prisma.funcionario.findFirst({
        where: {
          restID,
          funcao: config.funcao,
          ativo: true,
        },
      });

      if (!funcionario) {
        missingFuncoes.push(config.funcao);
        continue;
      }

      // Calculate distribution amount
      const valor_calculado = new Decimal(total_tip)
        .times(config.percentagem)
        .dividedBy(restaurante.percentagem_gorjeta_base)
        .toDecimalPlaces(2);

      distributions.push({
        funcao: config.funcao,
        funcID: funcionario.funcID,
        percentagem_aplicada: new Decimal(config.percentagem),
        valor_calculado,
      });
    }

    if (missingFuncoes.length > 0) {
      throw new BadRequestException(
        `Missing active employee(s) for function(s): ${missingFuncoes.join(', ')}`,
      );
    }

    return {
      total_tip,
      base_percentage: restaurante.percentagem_gorjeta_base,
      distributions,
    };
  }

  /**
   * Validate that Garçom (waiter) exists
   */
  async validateGarcom(funcID: number, restID: number): Promise<boolean> {
    const funcionario = await this.prisma.funcionario.findUnique({
      where: { funcID },
    });

    if (!funcionario || funcionario.restID !== restID) {
      throw new BadRequestException(
        `Waiter ${funcID} not found in restaurant ${restID}`,
      );
    }

    return true;
  }
}
