import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FaturamentoDiarioService } from './faturamento-diario.service';
import { FaturamentoDiarioController } from './faturamento-diario.controller';
import { FinanceEngineModule } from '../finance-engine/finance-engine.module';

@Module({
  imports: [PrismaModule, FinanceEngineModule],
  controllers: [FaturamentoDiarioController],
  providers: [FaturamentoDiarioService],
  exports: [FaturamentoDiarioService],
})
export class FaturamentoDiarioModule {}
