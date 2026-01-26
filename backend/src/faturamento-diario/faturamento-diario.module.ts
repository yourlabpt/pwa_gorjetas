import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FaturamentoDiarioService } from './faturamento-diario.service';
import { FaturamentoDiarioController } from './faturamento-diario.controller';

@Module({
  imports: [PrismaModule],
  controllers: [FaturamentoDiarioController],
  providers: [FaturamentoDiarioService],
  exports: [FaturamentoDiarioService],
})
export class FaturamentoDiarioModule {}
