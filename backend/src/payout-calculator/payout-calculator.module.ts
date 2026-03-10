import { Module } from '@nestjs/common';
import { PayoutCalculatorService } from './payout-calculator.service';

@Module({
  providers: [PayoutCalculatorService],
  exports: [PayoutCalculatorService],
})
export class PayoutCalculatorModule {}
