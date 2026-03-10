import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

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

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtSecret,
      issuer: jwtIssuer,
      audience: jwtAudience,
    });
  }

  async validate(payload: any) {
    return {
      userId: payload.sub,
      email: payload.email,
      role: payload.role,
      restaurantes: payload.restaurantes || [],
    };
  }
}
