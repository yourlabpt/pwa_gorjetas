import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ConfiguracaoAcertoService } from './configuracao-acerto.service';
import { ConfiguracaoAcertoController } from './configuracao-acerto.controller';

@Module({
  imports: [PrismaModule],
  controllers: [ConfiguracaoAcertoController],
  providers: [ConfiguracaoAcertoService],
  exports: [ConfiguracaoAcertoService],
})
export class ConfiguracaoAcertoModule {}
