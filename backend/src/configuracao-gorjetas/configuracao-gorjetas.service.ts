import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateConfiguracaoGorjetasDto,
  UpdateConfiguracaoGorjetasDto,
} from './dto/configuracao-gorjetas.dto';
import { Decimal } from 'decimal.js';

@Injectable()
export class ConfiguracaoGorjetasService {
  constructor(private prisma: PrismaService) {}

  async create(data: CreateConfiguracaoGorjetasDto) {
    // Validate based on tipo_calculo
    const tipoCalculo = data.tipo_calculo || 'percentagem';
    if (tipoCalculo === 'percentagem' && !data.percentagem) {
      throw new BadRequestException(
        'percentagem is required when tipo_calculo is "percentagem"',
      );
    }

    // Check if active config already exists for this (restID, funcao)
    const existing = await this.prisma.configuracaoGorjetas.findUnique({
      where: {
        restID_funcao: {
          restID: data.restID,
          funcao: data.funcao,
        },
      },
    });

    if (existing && existing.ativo) {
      throw new BadRequestException(
        `Active configuration already exists for function ${data.funcao} in restaurant ${data.restID}`,
      );
    }

    const createData: any = {
      restID: data.restID,
      funcao: data.funcao,
      tipo_calculo: tipoCalculo,
      ordem_calculo: data.ordem_calculo || 0,
    };

    if (data.percentagem) {
      createData.percentagem = new Decimal(data.percentagem);
    }

    return this.prisma.configuracaoGorjetas.create({
      data: createData,
    });
  }

  async findMany(restID: number) {
    return this.prisma.configuracaoGorjetas.findMany({
      where: { restID, ativo: true },
      orderBy: { funcao: 'asc' },
    });
  }

  async findOne(configID: number) {
    return this.prisma.configuracaoGorjetas.findUnique({
      where: { configID },
    });
  }

  async update(
    configID: number,
    data: UpdateConfiguracaoGorjetasDto,
  ) {
    const updateData: any = {};

    if (data.percentagem !== undefined) {
      updateData.percentagem = new Decimal(data.percentagem);
    }
    if (data.ativo !== undefined) {
      updateData.ativo = data.ativo;
    }

    return this.prisma.configuracaoGorjetas.update({
      where: { configID },
      data: updateData,
    });
  }

  async delete(configID: number) {
    const config = await this.findOne(configID);
    if (!config) {
      throw new NotFoundException('Configuration not found');
    }

    return this.prisma.configuracaoGorjetas.delete({
      where: { configID },
    });
  }
}
