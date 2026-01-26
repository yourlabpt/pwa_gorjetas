import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateFuncionarioDto, UpdateFuncionarioDto } from './dto/funcionario.dto';

@Injectable()
export class FuncionariosService {
  constructor(private prisma: PrismaService) {}

  async create(data: CreateFuncionarioDto) {
    return this.prisma.funcionario.create({
      data,
    });
  }

  async findMany(restID: number, ativo?: boolean) {
    const where: any = { restID };
    if (ativo !== undefined) {
      where.ativo = ativo;
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
    return this.prisma.funcionario.update({
      where: { funcID },
      data,
    });
  }

  async softDelete(funcID: number) {
    return this.prisma.funcionario.update({
      where: { funcID },
      data: { ativo: false },
    });
  }
}
