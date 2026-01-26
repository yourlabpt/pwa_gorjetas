import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ConfiguracaoGorjetasService } from './configuracao-gorjetas.service';
import { ConfiguracaoGorjetasController } from './configuracao-gorjetas.controller';

@Module({
  imports: [PrismaModule],
  providers: [ConfiguracaoGorjetasService],
  controllers: [ConfiguracaoGorjetasController],
})
export class ConfiguracaoGorjetasModule {}
