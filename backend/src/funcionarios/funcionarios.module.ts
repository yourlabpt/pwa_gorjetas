import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FuncionariosService } from './funcionarios.service';
import { FuncionariosController } from './funcionarios.controller';

@Module({
  imports: [PrismaModule],
  providers: [FuncionariosService],
  controllers: [FuncionariosController],
})
export class FuncionariosModule {}
