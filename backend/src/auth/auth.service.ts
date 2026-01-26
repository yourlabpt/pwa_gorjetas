import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { UserRole } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService, private jwtService: JwtService) {}

  async register(dto: RegisterDto) {
    const existing = await this.prisma.user.findUnique({
      where: { email: dto.email.toLowerCase() },
    });
    if (existing) {
      throw new BadRequestException('Email já cadastrado');
    }

    const passwordHash = await bcrypt.hash(dto.password, 10);

    const restaurantes = dto.restaurantIds || [];

    const user = await this.prisma.user.create({
      data: {
        name: dto.name,
        email: dto.email.toLowerCase(),
        passwordHash,
        role: dto.role || UserRole.GESTOR,
        restaurantes: restaurantes.length
          ? {
              create: restaurantes.map((restID) => ({ restID })),
            }
          : undefined,
      },
      include: {
        restaurantes: true,
      },
    });

    const token = this.signToken(user);
    return {
      user: this.strip(user),
      accessToken: token,
    };
  }

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email.toLowerCase() },
      include: { restaurantes: true },
    });
    if (!user) {
      throw new UnauthorizedException('Credenciais inválidas');
    }

    const isValid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!isValid) {
      throw new UnauthorizedException('Credenciais inválidas');
    }

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
      role: user.role,
      restaurantes: restIds,
    };
    return this.jwtService.sign(payload);
  }

  private strip(user: any) {
    const { passwordHash, ...rest } = user;
    return rest;
  }
}
