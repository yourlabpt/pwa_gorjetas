import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateRestauranteDto, UpdateRestauranteDto } from './dto/restaurante.dto';
import { Decimal } from 'decimal.js';

@Injectable()
export class RestaurantesService {
  constructor(private prisma: PrismaService) {}

  async create(data: CreateRestauranteDto) {
    const percentagem = data.percentagem_gorjeta_base
      ? new Decimal(data.percentagem_gorjeta_base)
      : new Decimal('10.00');

    // Create restaurant and default rules atomically
    return this.prisma.$transaction(async (tx) => {
      const restaurante = await tx.restaurante.create({
        data: {
          name: data.name,
          endereco: data.endereco,
          contacto: data.contacto,
          percentagem_gorjeta_base: percentagem,
        },
      });

      const defaultConfigs = [
        {
          funcao: 'garcom',
          percentagem: new Decimal('7.00'),
          split_mode: 'PROPORTIONAL_TO_POOL_INPUT',
        },
        {
          funcao: 'cozinha',
          percentagem: new Decimal('3.00'),
          split_mode: 'EQUAL_SPLIT',
        },
        {
          funcao: 'supervisor',
          percentagem: new Decimal('1.00'),
          split_mode: 'EQUAL_SPLIT',
        },
      ];

      for (const [idx, config] of defaultConfigs.entries()) {
        await tx.regraDistribuicao.create({
          data: {
            restID: restaurante.restID,
            role_name: config.funcao,
            calculation_type: 'PERCENT' as any,
            calculation_base: 'VALOR_TOTAL_GORJETAS' as any,
            rate: config.percentagem,
            percent_mode: 'BASE_PERCENT_POINTS' as any,
            split_mode: config.split_mode as any,
            payment_source: 'TIP_POOL' as any,
            ordem: idx + 1,
            ativo: true,
          } as any,
        });
      }

      return restaurante;
    });
  }

  async findAll(ativo?: boolean, allowedRestIds?: number[]) {
    const where: any = {};
    if (ativo !== undefined) where.ativo = ativo;
    if (allowedRestIds && allowedRestIds.length > 0) {
      where.restID = { in: allowedRestIds };
    }
    return this.prisma.restaurante.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(restID: number) {
    return this.prisma.restaurante.findUnique({
      where: { restID },
    });
  }

  async update(restID: number, data: UpdateRestauranteDto) {
    const updateData: any = {
      name: data.name,
      endereco: data.endereco,
      contacto: data.contacto,
      ativo: data.ativo,
    };

    if (data.percentagem_gorjeta_base !== undefined) {
      updateData.percentagem_gorjeta_base = new Decimal(data.percentagem_gorjeta_base);
    }

    // Remove undefined values
    Object.keys(updateData).forEach(
      (key) => updateData[key] === undefined && delete updateData[key],
    );

    return this.prisma.restaurante.update({
      where: { restID },
      data: updateData,
    });
  }

  async toggleActive(restID: number) {
    const restaurante = await this.findOne(restID);
    if (!restaurante) {
      throw new Error('Restaurante não encontrado');
    }

    return this.prisma.restaurante.update({
      where: { restID },
      data: { ativo: !restaurante.ativo },
    });
  }

  async delete(restID: number) {
    const restaurante = await this.findOne(restID);
    if (!restaurante) {
      throw new Error('Restaurante não encontrado');
    }

    // Cascade delete in the correct order to respect foreign key constraints
    return this.prisma.$transaction(async (tx) => {
      // 1. Delete all limpeza_records for funcionarios in this restaurant
      const funcionarios = await tx.funcionario.findMany({
        where: { restID },
        select: { funcID: true },
      });

      const funcIDs = funcionarios.map((f: { funcID: number }) => f.funcID);

      if (funcIDs.length > 0) {
        // Delete limpeza records for these funcionarios
        await tx.limpezaRecord.deleteMany({
          where: { funcID: { in: funcIDs } },
        });

        // Delete distribuicoes for transacoes in this restaurant (cascades are not always reliable)
        await tx.distribuicaoGorjetas.deleteMany({
          where: { 
            transacao: { restID }
          },
        });

        // Delete all transacoes for this restaurant (they reference these funcionarios)
        await tx.transacao.deleteMany({
          where: { restID },
        });
      }

      // 2. Delete all limpeza products for this restaurant
      await tx.limpeza.deleteMany({
        where: { restID },
      });

      // 3. Delete all funcionarios for this restaurant
      await tx.funcionario.deleteMany({
        where: { restID },
      });

      // 4. Delete all configurations for this restaurant
      await tx.regraDistribuicao.deleteMany({
        where: { restID },
      });

      // 5. Finally, delete the restaurant
      return tx.restaurante.delete({
        where: { restID },
      });
    });
  }
}
