import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { PayoutCalculatorModule } from '../payout-calculator/payout-calculator.module';
import { FinanceEngineService } from './finance-engine.service';

@Module({
  imports: [PrismaModule, PayoutCalculatorModule],
  providers: [FinanceEngineService],
  exports: [FinanceEngineService],
})
export class FinanceEngineModule {}
