import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { DistribuicaoGorjetasService } from './distribuicao-gorjetas.service';
import { DistribuicaoGorjetasController } from './distribuicao-gorjetas.controller';

@Module({
  imports: [PrismaModule],
  providers: [DistribuicaoGorjetasService],
  controllers: [DistribuicaoGorjetasController],
})
export class DistribuicaoGorjetasModule {}
