import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ConfiguracaoAcertoService } from './configuracao-acerto.service';
import { ConfiguracaoAcertoController } from './configuracao-acerto.controller';
import { AuditModule } from '../audit/audit.module';

@Module({
  imports: [PrismaModule, AuditModule],
  controllers: [ConfiguracaoAcertoController],
  providers: [ConfiguracaoAcertoService],
  exports: [ConfiguracaoAcertoService],
})
export class ConfiguracaoAcertoModule {}
