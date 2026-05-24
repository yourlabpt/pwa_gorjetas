import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FinanceEngineModule } from '../finance-engine/finance-engine.module';
import { TransacoesService } from './transacoes.service';
import { TransacoesController } from './transacoes.controller';
import { AuditModule } from '../audit/audit.module';

@Module({
  imports: [PrismaModule, FinanceEngineModule, AuditModule],
  providers: [TransacoesService],
  controllers: [TransacoesController],
})
export class TransacoesModule {}
