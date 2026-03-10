import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { RegrasDistribuicaoController } from './regras-distribuicao.controller';
import { RegrasDistribuicaoService } from './regras-distribuicao.service';

@Module({
  imports: [PrismaModule],
  controllers: [RegrasDistribuicaoController],
  providers: [RegrasDistribuicaoService],
  exports: [RegrasDistribuicaoService],
})
export class RegrasDistribuicaoModule {}
