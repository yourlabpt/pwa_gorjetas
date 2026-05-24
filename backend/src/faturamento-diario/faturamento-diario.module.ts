import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FaturamentoDiarioService } from './faturamento-diario.service';
import { FaturamentoDiarioController } from './faturamento-diario.controller';
import { FinanceEngineModule } from '../finance-engine/finance-engine.module';
import { AuditModule } from '../audit/audit.module';

@Module({
  imports: [PrismaModule, FinanceEngineModule, AuditModule],
  controllers: [FaturamentoDiarioController],
  providers: [FaturamentoDiarioService],
  exports: [FaturamentoDiarioService],
})
export class FaturamentoDiarioModule {}
