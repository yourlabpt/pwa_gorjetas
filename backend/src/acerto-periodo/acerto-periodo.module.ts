import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { AcertoPeridoService } from './acerto-periodo.service';
import { AcertoPeridoController } from './acerto-periodo.controller';

@Module({
  imports: [PrismaModule],
  controllers: [AcertoPeridoController],
  providers: [AcertoPeridoService],
  exports: [AcertoPeridoService],
})
export class AcertoPeridoModule {}
