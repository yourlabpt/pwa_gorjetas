import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateFuncionarioDto, UpdateFuncionarioDto } from './dto/funcionario.dto';

@Injectable()
export class FuncionariosService {
  constructor(private prisma: PrismaService) {}

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

  async create(data: CreateFuncionarioDto) {
    return this.prisma.funcionario.create({
      data: this.sanitizePayload(data) as any,
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

  async findOne(funcID: number) {
    return this.prisma.funcionario.findUnique({
      where: { funcID },
    });
  }

  async update(funcID: number, data: UpdateFuncionarioDto) {
    const funcionario = await this.findOne(funcID);
    if (funcionario?.deletedAt) {
      throw new BadRequestException('Funcionário eliminado não pode ser editado sem restauro prévio');
    }

    return this.prisma.funcionario.update({
      where: { funcID },
      data: this.sanitizePayload(data) as any,
    });
  }

  async toggleActive(funcID: number) {
    const funcionario = await this.findOne(funcID);
    if (!funcionario) {
      throw new Error('Funcionário não encontrado');
    }
    if (funcionario.deletedAt) {
      throw new BadRequestException('Funcionário eliminado não pode ser ativado/desativado');
    }

    return this.prisma.funcionario.update({
      where: { funcID },
      data: { ativo: !funcionario.ativo },
    });
  }

  async softDelete(funcID: number) {
    const funcionario = await this.findOne(funcID);
    if (!funcionario) {
      throw new Error('Funcionário não encontrado');
    }
    if (funcionario.deletedAt) {
      throw new BadRequestException('Funcionário já eliminado');
    }

    return this.prisma.funcionario.update({
      where: { funcID },
      data: {
        ativo: false,
        deletedAt: new Date(),
      },
    });
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
