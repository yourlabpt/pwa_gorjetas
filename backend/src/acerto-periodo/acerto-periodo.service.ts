import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateAcertoPeridoDto,
  AcertoPeridoResponseDto,
  AcertoFuncionarioResponseDto,
} from './dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class AcertoPeridoService {
  constructor(private prisma: PrismaService) {}

  /**
   * Calcular faturamento e gorjetas de um período
   */
  private async calcularTotaisPeriodo(
    restID: number,
    dataInicio: Date,
    dataFim: Date,
  ): Promise<{
    faturamentoTotal: any;
    gorjetaTotal: any;
    transacoes: any[];
  }> {
    const inicio = new Date(dataInicio);
    inicio.setHours(0, 0, 0, 0);

    const fim = new Date(dataFim);
    fim.setHours(23, 59, 59, 999);

    const transacoes = await this.prisma.transacao.findMany({
      where: {
        restID,
        data_transacao: {
          gte: inicio,
          lte: fim,
        },
      },
      include: {
        garcom: true,
      },
    });

    let faturamentoTotal = new Prisma.Decimal(0);
    let gorjetaTotal = new Prisma.Decimal(0);

    for (const t of transacoes) {
      faturamentoTotal = faturamentoTotal.plus(t.total);
      gorjetaTotal = gorjetaTotal.plus(t.valor_gorjeta_calculada);
    }

    return { faturamentoTotal, gorjetaTotal, transacoes };
  }

  /**
   * Obter faturamento inserido para o período
   */
  private async obterFaturamentoInserido(
    restID: number,
    dataInicio: Date,
    dataFim: Date,
  ): Promise<any> {
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
    });

    let total = new Prisma.Decimal(0);
    for (const f of faturamentos) {
      total = total.plus(f.faturamento_inserido);
    }
    return total;
  }

  /**
   * Calcular valor para uma função baseado em configuração
   * Suporta múltiplas bases de cálculo incluindo distribuição avançada
   */
  private calcularValorFuncao(
    config: any,
    baseGorjeta: any,
    baseFaturamento: any,
    gorjetaRemainingContext?: { remaining: any; deductedAmount: any },
  ): {
    valorBase: any;
    percentualAplicado: any | null;
    valorAbsolutoAplicado: any | null;
    valorCalculado: any;
  } {
    let valorBase: any;
    let valorCalculado: any;
    let percentualAplicado: any | null = null;
    let valorAbsolutoAplicado: any | null = null;

    switch (config.base_calculo) {
      case 'GORJETA_TOTAL':
        valorBase = baseGorjeta;
        percentualAplicado = config.valor_percentual;
        valorCalculado = baseGorjeta.times(
          config.valor_percentual.dividedBy(100),
        );
        break;

      case 'FATURAMENTO_BASE':
        valorBase = baseFaturamento;
        percentualAplicado = config.valor_percentual;
        valorCalculado = baseFaturamento.times(
          config.valor_percentual.dividedBy(100),
        );
        break;

      case 'GORJETA_REMAINING':
        // Cozinha gets: Total Gorjeta Base - Garcom's Gorjeta - Other percentages from gorjeta
        // This is calculated after other gorjeta functions take their share
        if (gorjetaRemainingContext) {
          valorBase = gorjetaRemainingContext.remaining;
          percentualAplicado = config.valor_percentual;
          valorCalculado = gorjetaRemainingContext.remaining.times(
            config.valor_percentual.dividedBy(100),
          );
        } else {
          valorBase = new Prisma.Decimal(0);
          valorCalculado = new Prisma.Decimal(0);
        }
        break;

      case 'FATURAMENTO_EXTRA':
        // Supervisor/Gerente gets % from the 89% of faturamento (non-11% part)
        const faturamentoTotal = baseFaturamento.dividedBy(0.11); // Back-calculate total
        const faturamentoExtra = faturamentoTotal.times(0.89); // 89% of total
        valorBase = faturamentoExtra;
        percentualAplicado = config.valor_percentual;
        valorCalculado = faturamentoExtra.times(
          config.valor_percentual.dividedBy(100),
        );
        break;

      case 'ABSOLUTO':
        valorBase = config.valor_absoluto;
        valorAbsolutoAplicado = config.valor_absoluto;
        valorCalculado = config.valor_absoluto;
        break;

      default:
        throw new BadRequestException('base_calculo inválido');
    }

    return {
      valorBase,
      percentualAplicado,
      valorAbsolutoAplicado,
      valorCalculado,
    };
  }

  /**
   * Criar acerto de período
   */
  async create(
    restID: number,
    dto: CreateAcertoPeridoDto,
  ): Promise<AcertoPeridoResponseDto> {
    // Validar restaurante
    await this.prisma.restaurante.findUniqueOrThrow({
      where: { restID },
    });

    // Validar datas
    const dataInicio = new Date(dto.periodo_inicio);
    dataInicio.setHours(0, 0, 0, 0);

    const dataFim = new Date(dto.periodo_fim);
    dataFim.setHours(23, 59, 59, 999);

    if (dataInicio > dataFim) {
      throw new BadRequestException(
        'Data início não pode ser maior que data fim',
      );
    }

    // Calcular totais do período
    const { faturamentoTotal, gorjetaTotal, transacoes } =
      await this.calcularTotaisPeriodo(restID, dataInicio, dataFim);

    // Obter faturamento inserido do período
    const faturamentoInserido = await this.obterFaturamentoInserido(
      restID,
      dataInicio,
      dataFim,
    );

    // Usar faturamento inserido se fornecido, senão usar calculado
    const faturamentoParaDistribuir =
      faturamentoInserido.toNumber() > 0
        ? faturamentoInserido
        : faturamentoTotal;

    // Criar acerto_periodo
    const acertoPeriodo = await this.prisma.acertoPeriodo.create({
      data: {
        restID,
        periodo_inicio: dataInicio,
        periodo_fim: dataFim,
        tipo_periodo: dto.tipo_periodo || 'DIARIO',
        faturamento_total: faturamentoParaDistribuir,
        gorjeta_total: gorjetaTotal,
      },
    });

    // Obter configurações de acerto, ordenadas por ordem_calculo
    const configuracoes = await this.prisma.configuracaoAcerto.findMany({
      where: {
        restID,
        ativo: true,
      },
      orderBy: {
        ordem_calculo: 'asc',
      },
    });

    // Calcular base para distribuição
    const baseFaturamento = faturamentoParaDistribuir.times(0.11); // 11% do faturamento

    // Para cada configuração, criar acerto_funcionario
    const acertosFuncionarios = [];
    let gorjetaRemainingTotal = gorjetaTotal; // Track remaining gorjeta for GORJETA_REMAINING calculation

    for (const config of configuracoes) {
      // Prepare context for GORJETA_REMAINING calculation
      const gorjetaRemainingContext = {
        remaining: gorjetaRemainingTotal,
        deductedAmount: new Prisma.Decimal(0),
      };

      const { valorBase, percentualAplicado, valorAbsolutoAplicado, valorCalculado } =
        this.calcularValorFuncao(config, gorjetaTotal, baseFaturamento, gorjetaRemainingContext);

      // Update remaining gorjeta if this config uses gorjeta
      if (
        config.base_calculo === 'GORJETA_TOTAL' ||
        config.base_calculo === 'GORJETA_REMAINING'
      ) {
        gorjetaRemainingTotal = gorjetaRemainingTotal.minus(valorCalculado);
      }

      const acertoFunc = await this.prisma.acertoFuncionario.create({
        data: {
          acerto_periodo_id: acertoPeriodo.id,
          funcID: 0, // Será atualizado se necessário
          configuracao_acerto_id: config.id,
          funcao: config.funcao,
          valor_base: valorBase,
          percentual_aplicado: percentualAplicado,
          valor_absoluto_aplicado: valorAbsolutoAplicado,
          valor_calculado: valorCalculado,
          pago: false,
        },
      });

      acertosFuncionarios.push(acertoFunc);
    }

    return this.mapToResponse(acertoPeriodo, acertosFuncionarios);
  }

  /**
   * Obter acerto por ID
   */
  async findById(id: number): Promise<AcertoPeridoResponseDto> {
    const acertoPeriodo = await this.prisma.acertoPeriodo.findUnique({
      where: { id },
      include: {
        acertos_funcionarios: true,
      },
    });

    if (!acertoPeriodo) {
      throw new NotFoundException('Acerto não encontrado');
    }

    return this.mapToResponse(acertoPeriodo, acertoPeriodo.acertos_funcionarios);
  }

  /**
   * Listar acertos por período
   */
  async findByPeriod(
    restID: number,
    dataInicio?: Date,
    dataFim?: Date,
    pago?: boolean,
  ): Promise<AcertoPeridoResponseDto[]> {
    const where: any = {
      restID,
    };

    if (dataInicio || dataFim) {
      where.periodo_inicio = {};
      if (dataInicio) {
        const inicio = new Date(dataInicio);
        inicio.setHours(0, 0, 0, 0);
        where.periodo_inicio.gte = inicio;
      }
      if (dataFim) {
        const fim = new Date(dataFim);
        fim.setHours(23, 59, 59, 999);
        where.periodo_fim = { ...where.periodo_fim, lte: fim };
      }
    }

    if (pago !== undefined) {
      where.pago = pago;
    }

    const acertos = await this.prisma.acertoPeriodo.findMany({
      where,
      include: {
        acertos_funcionarios: true,
      },
      orderBy: { periodo_inicio: 'desc' },
    });

    return acertos.map((a) => this.mapToResponse(a, a.acertos_funcionarios));
  }

  /**
   * Marcar acerto como pago
   */
  async marcarComoPago(id: number): Promise<AcertoPeridoResponseDto> {
    const acertoPeriodo = await this.prisma.acertoPeriodo.findUnique({
      where: { id },
      include: {
        acertos_funcionarios: true,
      },
    });

    if (!acertoPeriodo) {
      throw new NotFoundException('Acerto não encontrado');
    }

    if (acertoPeriodo.pago) {
      throw new BadRequestException('Este acerto já foi marcado como pago');
    }

    // Atualizar acerto_periodo
    const atualizado = await this.prisma.acertoPeriodo.update({
      where: { id },
      data: {
        pago: true,
        data_pagamento: new Date(),
      },
      include: {
        acertos_funcionarios: true,
      },
    });

    // Atualizar acerto_funcionario
    await this.prisma.acertoFuncionario.updateMany({
      where: { acerto_periodo_id: id },
      data: { pago: true },
    });

    // Atualizar transações do período
    await this.prisma.transacao.updateMany({
      where: {
        restID: acertoPeriodo.restID,
        data_transacao: {
          gte: acertoPeriodo.periodo_inicio,
          lte: acertoPeriodo.periodo_fim,
        },
      },
      data: {
        pago: true,
        acerto_periodo_id: id,
      },
    });

    return this.mapToResponse(atualizado, atualizado.acertos_funcionarios);
  }

  /**
   * Mapear modelo para DTO de resposta
   */
  private mapToResponse(
    acertoPeriodo: any,
    acertosFuncionarios: any[],
  ): AcertoPeridoResponseDto {
    return {
      id: acertoPeriodo.id,
      restID: acertoPeriodo.restID,
      periodo_inicio: acertoPeriodo.periodo_inicio,
      periodo_fim: acertoPeriodo.periodo_fim,
      tipo_periodo: acertoPeriodo.tipo_periodo,
      faturamento_total: acertoPeriodo.faturamento_total.toNumber(),
      gorjeta_total: acertoPeriodo.gorjeta_total.toNumber(),
      pago: acertoPeriodo.pago,
      data_pagamento: acertoPeriodo.data_pagamento,
      acertos_funcionarios: acertosFuncionarios.map((af) => ({
        id: af.id,
        funcao: af.funcao,
        valor_base: af.valor_base.toNumber(),
        percentual_aplicado: af.percentual_aplicado
          ? af.percentual_aplicado.toNumber()
          : null,
        valor_absoluto_aplicado: af.valor_absoluto_aplicado
          ? af.valor_absoluto_aplicado.toNumber()
          : null,
        valor_calculado: af.valor_calculado.toNumber(),
        pago: af.pago,
      })),
      criadoEm: acertoPeriodo.criadoEm,
      atualizadoEm: acertoPeriodo.atualizadoEm,
    };
  }
}
