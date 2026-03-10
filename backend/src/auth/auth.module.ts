import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { JwtStrategy } from './jwt.strategy';

function getRequiredJwtSecret() {
  const value = process.env.JWT_SECRET;
  if (!value || value === 'change-me') {
    throw new Error(
      'JWT_SECRET inválido. Defina um segredo longo e aleatório no ambiente.',
    );
  }
  return value;
}

const jwtSecret = getRequiredJwtSecret();
const jwtIssuer = process.env.JWT_ISSUER || 'pwa-gorjetas-api';
const jwtAudience = process.env.JWT_AUDIENCE || 'pwa-gorjetas-frontend';
const jwtExpiresIn = (process.env.JWT_EXPIRES_IN || '8h') as any;

@Module({
  imports: [
    PrismaModule,
    PassportModule,
    JwtModule.register({
      secret: jwtSecret,
      signOptions: {
        expiresIn: jwtExpiresIn,
        issuer: jwtIssuer,
        audience: jwtAudience,
      },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
