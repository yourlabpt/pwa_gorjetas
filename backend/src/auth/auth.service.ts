import {
  BadRequestException,
  ForbiddenException,
  HttpException,
  HttpStatus,
  Injectable,
  OnModuleInit,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { UserRole } from '@prisma/client';
import * as bcrypt from 'bcryptjs';
import { Request } from 'express';
import { isAdminLike, isSuperAdmin } from './role.util';

const ROLE_MANAGER = ((UserRole as any).GERENTE ||
  (UserRole as any).GESTOR ||
  'GERENTE') as UserRole;

type LoginAttemptState = {
  failures: number;
  firstFailureAt: number;
  blockedUntil?: number;
};

@Injectable()
export class AuthService implements OnModuleInit {
  private readonly passwordHashRounds = Number(
    process.env.PASSWORD_HASH_ROUNDS || '12',
  );
  private readonly loginMaxAttempts = Number(
    process.env.AUTH_LOGIN_MAX_ATTEMPTS || '5',
  );
  private readonly loginWindowMs = Number(
    process.env.AUTH_LOGIN_WINDOW_MS || String(15 * 60 * 1000),
  );
  private readonly loginBlockMs = Number(
    process.env.AUTH_LOGIN_BLOCK_MS || String(15 * 60 * 1000),
  );
  private readonly loginFailureMinDelayMs = Number(
    process.env.AUTH_LOGIN_FAILURE_MIN_DELAY_MS || '250',
  );
  private readonly loginFailureMaxDelayMs = Number(
    process.env.AUTH_LOGIN_FAILURE_MAX_DELAY_MS || '600',
  );
  private readonly fakePasswordHash = bcrypt.hashSync(
    'invalid-password-for-constant-time-compare',
    this.passwordHashRounds,
  );
  private readonly loginAttemptsByEmail = new Map<string, LoginAttemptState>();
  private readonly loginAttemptsByIp = new Map<string, LoginAttemptState>();

  constructor(private prisma: PrismaService, private jwtService: JwtService) {}

  async onModuleInit() {
    await this.ensureSuperAdminUser();
  }

  resolveOptionalUserFromRequest(req: Request) {
    const authHeader = String(req.header('authorization') || '').trim();
    if (!authHeader.toLowerCase().startsWith('bearer ')) {
      return null;
    }

    const token = authHeader.slice(7).trim();
    if (!token) return null;

    try {
      const payload = this.jwtService.verify(token) as {
        sub?: number;
        role?: string;
      };
      return {
        userId: payload.sub,
        role: this.normalizeRoleOutput(payload.role || ''),
      };
    } catch {
      return null;
    }
  }

  async register(dto: RegisterDto, creator: any) {
    const normalizedEmail = this.normalizeEmail(dto.email);
    const requestedRole = this.normalizeRequestedRole(dto.role);
    const isPrivilegedCreator = isAdminLike(creator?.role);

    if (requestedRole === UserRole.SUPER_ADMIN) {
      throw new ForbiddenException(
        'Criação de SUPER_ADMIN é permitida apenas via bootstrap seguro',
      );
    }

    if (!isPrivilegedCreator) {
      if (
        requestedRole !== ROLE_MANAGER &&
        requestedRole !== UserRole.SUPERVISOR
      ) {
        throw new ForbiddenException(
          'Registro público permite apenas contas GERENTE ou SUPERVISOR',
        );
      }
    }

    if (requestedRole === UserRole.ADMIN && !isSuperAdmin(creator?.role)) {
      throw new ForbiddenException(
        'Somente SUPER_ADMIN pode criar contas Administrador',
      );
    }

    const existing = await this.prisma.user.findUnique({
      where: { email: normalizedEmail },
    });
    if (existing) {
      throw new BadRequestException('Email já cadastrado');
    }

    const passwordHash = await bcrypt.hash(dto.password, this.passwordHashRounds);
    const restaurantes = dto.restaurantIds || [];

    const user = await this.prisma.user.create({
      data: {
        name: dto.name.trim(),
        email: normalizedEmail,
        passwordHash,
        role: requestedRole,
        restaurantes:
          requestedRole === ROLE_MANAGER ||
          requestedRole === UserRole.SUPERVISOR
            ? restaurantes.length
              ? {
                  create: restaurantes.map((restID) => ({ restID })),
                }
              : undefined
            : undefined,
      },
      include: {
        restaurantes: true,
      },
    });

    return {
      user: this.strip(user),
    };
  }

  async login(dto: LoginDto, req: Request) {
    const normalizedEmail = this.normalizeEmail(dto.email);
    const requestIp = this.getRequestIp(req);

    this.assertNotRateLimited(normalizedEmail, requestIp);

    const user = await this.prisma.user.findUnique({
      where: { email: normalizedEmail },
      include: { restaurantes: true },
    });

    const hashToCheck = user?.passwordHash || this.fakePasswordHash;
    const isValidPassword = await bcrypt.compare(dto.password, hashToCheck);

    if (!user || !isValidPassword) {
      this.registerFailedLogin(normalizedEmail, requestIp);
      await this.randomDelayOnFailedAuth();
      throw new UnauthorizedException('Credenciais inválidas');
    }

    this.clearFailedLogins(normalizedEmail, requestIp);

    const token = this.signToken(user);
    return {
      user: this.strip(user),
      accessToken: token,
    };
  }

  async me(userPayload: any) {
    const user = await this.prisma.user.findUnique({
      where: { id: userPayload.userId },
      include: { restaurantes: true },
    });
    if (!user) throw new UnauthorizedException();
    return this.strip(user);
  }

  private signToken(user: any) {
    const restIds = (user.restaurantes || []).map((r: any) => r.restID);
    const payload = {
      sub: user.id,
      email: user.email,
      role: this.normalizeRoleOutput(user.role),
      restaurantes: restIds,
    };
    return this.jwtService.sign(payload);
  }

  private strip(user: any) {
    const { passwordHash, ...rest } = user;
    rest.role = this.normalizeRoleOutput(rest.role);
    return rest;
  }

  private normalizeEmail(email: string) {
    return email.trim().toLowerCase();
  }

  private normalizeRoleOutput(role?: string) {
    return role === 'GESTOR' ? 'GERENTE' : role;
  }

  private normalizeRequestedRole(role?: string): UserRole {
    const normalized = String(role || ROLE_MANAGER)
      .trim()
      .toUpperCase();
    if (normalized === 'GESTOR' || normalized === 'GERENTE') return ROLE_MANAGER;

    if (Object.values(UserRole).includes(normalized as UserRole)) {
      return normalized as UserRole;
    }

    throw new BadRequestException('Role inválida');
  }

  private getRequestIp(req: Request) {
    return req.ip || req.socket?.remoteAddress || 'unknown';
  }

  private assertNotRateLimited(email: string, ip: string) {
    const now = Date.now();
    this.cleanupExpiredAttempt(this.loginAttemptsByEmail, email, now);
    this.cleanupExpiredAttempt(this.loginAttemptsByIp, ip, now);

    const emailState = this.loginAttemptsByEmail.get(email);
    if (emailState?.blockedUntil && emailState.blockedUntil > now) {
      throw new HttpException(
        'Muitas tentativas de login. Tente novamente em alguns minutos.',
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const ipState = this.loginAttemptsByIp.get(ip);
    if (ipState?.blockedUntil && ipState.blockedUntil > now) {
      throw new HttpException(
        'Muitas tentativas de login. Tente novamente em alguns minutos.',
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }
  }

  private registerFailedLogin(email: string, ip: string) {
    const now = Date.now();
    this.incrementAttempt(this.loginAttemptsByEmail, email, now);
    this.incrementAttempt(this.loginAttemptsByIp, ip, now);
  }

  private clearFailedLogins(email: string, ip: string) {
    this.loginAttemptsByEmail.delete(email);
    this.loginAttemptsByIp.delete(ip);
  }

  private cleanupExpiredAttempt(
    map: Map<string, LoginAttemptState>,
    key: string,
    now: number,
  ) {
    const state = map.get(key);
    if (!state) return;

    const isWindowExpired = now - state.firstFailureAt > this.loginWindowMs;
    const isBlockExpired =
      state.blockedUntil !== undefined && now > state.blockedUntil;

    if (isWindowExpired || isBlockExpired) {
      map.delete(key);
    }
  }

  private incrementAttempt(
    map: Map<string, LoginAttemptState>,
    key: string,
    now: number,
  ) {
    const current = map.get(key);

    if (!current || now - current.firstFailureAt > this.loginWindowMs) {
      map.set(key, {
        failures: 1,
        firstFailureAt: now,
      });
      return;
    }

    const failures = current.failures + 1;
    const nextState: LoginAttemptState = {
      ...current,
      failures,
    };

    if (failures >= this.loginMaxAttempts) {
      nextState.blockedUntil = now + this.loginBlockMs;
    }

    map.set(key, nextState);
  }

  private async randomDelayOnFailedAuth() {
    const min = Math.max(0, this.loginFailureMinDelayMs);
    const max = Math.max(min, this.loginFailureMaxDelayMs);
    const delay = Math.floor(Math.random() * (max - min + 1)) + min;
    await new Promise((resolve) => setTimeout(resolve, delay));
  }

  private async ensureSuperAdminUser() {
    const superAdminEmail = this.normalizeEmail(
      process.env.SUPER_ADMIN_EMAIL || '',
    );
    const superAdminPassword = (process.env.SUPER_ADMIN_PASSWORD || '').trim();
    const superAdminName = (process.env.SUPER_ADMIN_NAME || 'Super Admin').trim();

    const existingSuperAdmin = await this.prisma.user.findFirst({
      where: { role: UserRole.SUPER_ADMIN },
      select: { id: true, email: true },
    });

    if (superAdminEmail && superAdminPassword) {
      const validPassword = this.validatePasswordStrength(superAdminPassword);
      if (!validPassword) {
        if (existingSuperAdmin) {
          console.warn(
            'SUPER_ADMIN_PASSWORD inválida no ambiente; mantendo SUPER_ADMIN existente sem bloquear inicialização.',
          );
          return;
        }
        console.error(
          'SUPER_ADMIN_PASSWORD inválida e nenhum SUPER_ADMIN encontrado. API iniciará sem bootstrap automático de SUPER_ADMIN até configuração correta do ambiente.',
        );
        return;
      }

      const passwordHash = await bcrypt.hash(
        superAdminPassword,
        this.passwordHashRounds,
      );

      try {
        await this.prisma.user.upsert({
          where: { email: superAdminEmail },
          update: {
            name: superAdminName,
            role: UserRole.SUPER_ADMIN,
            passwordHash,
          },
          create: {
            name: superAdminName,
            email: superAdminEmail,
            passwordHash,
            role: UserRole.SUPER_ADMIN,
          },
        });
      } catch (error) {
        if (existingSuperAdmin) {
          console.warn(
            'Falha ao sincronizar SUPER_ADMIN via ambiente; mantendo SUPER_ADMIN existente.',
          );
          return;
        }
        console.error(
          'Falha ao criar SUPER_ADMIN via ambiente. API iniciará sem bootstrap automático.',
          error,
        );
        return;
      }

      console.log(
        `🔐 SUPER_ADMIN sincronizado para ${superAdminEmail}. Remova SUPER_ADMIN_PASSWORD do runtime após o bootstrap, se desejar.`,
      );
      return;
    }

    if (existingSuperAdmin) return;

    if (!superAdminEmail || !superAdminPassword) {
      console.error(
        'Nenhum SUPER_ADMIN encontrado e variáveis de bootstrap ausentes. API iniciará sem bootstrap automático até configuração correta.',
      );
      return;
    }
  }

  private validatePasswordStrength(password: string) {
    if (password.length < 12 || password.length > 128) return false;
    if (!/[a-z]/.test(password)) return false;
    if (!/[A-Z]/.test(password)) return false;
    if (!/[0-9]/.test(password)) return false;
    if (!/[^A-Za-z0-9]/.test(password)) return false;
    return true;
  }
}
