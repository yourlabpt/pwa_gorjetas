import { Module } from '@nestjs/common';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { PrismaModule } from './prisma/prisma.module';
import { RestaurantesModule } from './restaurantes/restaurantes.module';
import { FuncionariosModule } from './funcionarios/funcionarios.module';
import { TransacoesModule } from './transacoes/transacoes.module';
import { DistribuicaoGorjetasModule } from './distribuicao-gorjetas/distribuicao-gorjetas.module';
import { RelatoriosModule } from './relatorios/relatorios.module';
import { FaturamentoDiarioModule } from './faturamento-diario/faturamento-diario.module';
import { ConfiguracaoAcertoModule } from './configuracao-acerto/configuracao-acerto.module';
import { AcertoPeridoModule } from './acerto-periodo/acerto-periodo.module';
import { AuthModule } from './auth/auth.module';
import { APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { JwtAuthGuard } from './auth/jwt-auth.guard';
import { RestaurantAccessGuard } from './auth/restaurant-access.guard';
import { UsersModule } from './users/users.module';
import { FechoFinanceiroModule } from './fecho-financeiro/fecho-financeiro.module';
import { PayoutCalculatorModule } from './payout-calculator/payout-calculator.module';
import { RegrasDistribuicaoModule } from './regras-distribuicao/regras-distribuicao.module';
import { FinanceEngineModule } from './finance-engine/finance-engine.module';
import { AcertoFinalModule } from './acerto-final/acerto-final.module';
import { AuditModule } from './audit/audit.module';
import { AuditRequestInterceptor } from './common/interceptors/audit-request.interceptor';
import { SessionsModule } from './sessions/sessions.module';

@Module({
  imports: [
    EventEmitterModule.forRoot(),
    PrismaModule,
    AuditModule,
    AuthModule,
    UsersModule,
      SessionsModule,
    RestaurantesModule,
    FuncionariosModule,
    TransacoesModule,
    DistribuicaoGorjetasModule,
    RelatoriosModule,
    FaturamentoDiarioModule,
    ConfiguracaoAcertoModule,
    AcertoPeridoModule,
    FechoFinanceiroModule,
    PayoutCalculatorModule,
    RegrasDistribuicaoModule,
    FinanceEngineModule,
    AcertoFinalModule,
  ],
  controllers: [],
  providers: [
    {
      provide: APP_GUARD,
      useClass: JwtAuthGuard,
    },
    {
      provide: APP_GUARD,
      useClass: RestaurantAccessGuard,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: AuditRequestInterceptor,
    },
  ],
})
export class AppModule {}
