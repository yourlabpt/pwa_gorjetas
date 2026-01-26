import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { TipCalculatorModule } from '../tip-calculator/tip-calculator.module';
import { TransacoesService } from './transacoes.service';
import { TransacoesController } from './transacoes.controller';

@Module({
  imports: [PrismaModule, TipCalculatorModule],
  providers: [TransacoesService],
  controllers: [TransacoesController],
})
export class TransacoesModule {}
