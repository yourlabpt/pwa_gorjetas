import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { AcertoFinalService } from './acerto-final.service';
import { AcertoFinalController } from './acerto-final.controller';

@Module({
  imports: [PrismaModule],
  controllers: [AcertoFinalController],
  providers: [AcertoFinalService],
  exports: [AcertoFinalService],
})
export class AcertoFinalModule {}
