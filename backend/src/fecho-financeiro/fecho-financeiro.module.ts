import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FechoFinanceiroService } from './fecho-financeiro.service';
import { FechoFinanceiroController } from './fecho-financeiro.controller';

@Module({
  imports: [PrismaModule],
  controllers: [FechoFinanceiroController],
  providers: [FechoFinanceiroService],
  exports: [FechoFinanceiroService],
})
export class FechoFinanceiroModule {}
