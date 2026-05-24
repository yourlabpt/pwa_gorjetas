import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { RegrasDistribuicaoController } from './regras-distribuicao.controller';
import { RegrasDistribuicaoService } from './regras-distribuicao.service';
import { AuditModule } from '../audit/audit.module';

@Module({
  imports: [PrismaModule, AuditModule],
  controllers: [RegrasDistribuicaoController],
  providers: [RegrasDistribuicaoService],
  exports: [RegrasDistribuicaoService],
})
export class RegrasDistribuicaoModule {}
