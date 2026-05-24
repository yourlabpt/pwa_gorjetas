import { Module } from '@nestjs/common';
import { AuditService } from './audit.service';
import { AuditEventListener } from './audit.listener';
import { AuditController } from './audit.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [AuditController],
  providers: [AuditService, AuditEventListener],
  exports: [AuditService], // Export for use in other modules
})
export class AuditModule {}
