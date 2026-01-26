import { Module } from '@nestjs/common';
import { PrismaModule } from './prisma/prisma.module';
import { RestaurantesModule } from './restaurantes/restaurantes.module';
import { FuncionariosModule } from './funcionarios/funcionarios.module';
import { ConfiguracaoGorjetasModule } from './configuracao-gorjetas/configuracao-gorjetas.module';
import { TransacoesModule } from './transacoes/transacoes.module';
import { DistribuicaoGorjetasModule } from './distribuicao-gorjetas/distribuicao-gorjetas.module';
import { RelatoriosModule } from './relatorios/relatorios.module';
import { TipCalculatorModule } from './tip-calculator/tip-calculator.module';
import { FaturamentoDiarioModule } from './faturamento-diario/faturamento-diario.module';
import { ConfiguracaoAcertoModule } from './configuracao-acerto/configuracao-acerto.module';
import { AcertoPeridoModule } from './acerto-periodo/acerto-periodo.module';
import { AuthModule } from './auth/auth.module';
import { APP_GUARD } from '@nestjs/core';
import { JwtAuthGuard } from './auth/jwt-auth.guard';
import { RestaurantAccessGuard } from './auth/restaurant-access.guard';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    PrismaModule,
    AuthModule,
    UsersModule,
    RestaurantesModule,
    FuncionariosModule,
    ConfiguracaoGorjetasModule,
    TransacoesModule,
    DistribuicaoGorjetasModule,
    RelatoriosModule,
    TipCalculatorModule,
    FaturamentoDiarioModule,
    ConfiguracaoAcertoModule,
    AcertoPeridoModule,
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
  ],
})
export class AppModule {}
