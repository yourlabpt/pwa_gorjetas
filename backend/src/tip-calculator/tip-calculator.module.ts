import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { TipCalculatorService } from './tip-calculator.service';

@Module({
  imports: [PrismaModule],
  providers: [TipCalculatorService],
  exports: [TipCalculatorService],
})
export class TipCalculatorModule {}
