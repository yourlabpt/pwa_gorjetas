import {
  Body,
  Controller,
  Delete,
  ForbiddenException,
  Get,
  Param,
  ParseIntPipe,
  Put,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CurrentUser } from '../auth/current-user.decorator';
import { UserRole } from '@prisma/client';
import { isAdminLike, isSuperAdmin } from '../auth/role.util';
import { ResetPasswordDto } from './reset-password.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  async list(@CurrentUser() user: any) {
    if (!isAdminLike(user?.role)) {
      throw new ForbiddenException(
        'Apenas administradores podem listar usuários',
      );
    }
    return this.usersService.findAll();
  }

  @Get(':id')
  async get(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    if (!isAdminLike(user?.role)) {
      throw new ForbiddenException(
        'Apenas administradores podem visualizar usuário',
      );
    }
    return this.usersService.findOne(id);
  }

  @Put(':id/role')
  async updateRole(
    @Param('id', ParseIntPipe) id: number,
    @Body('role') role: string,
    @CurrentUser() user: any,
  ) {
    if (!isAdminLike(user?.role)) {
      throw new ForbiddenException(
        'Apenas administradores podem alterar role',
      );
    }

    if (role === UserRole.ADMIN && !isSuperAdmin(user?.role)) {
      throw new ForbiddenException(
        'Apenas SUPER_ADMIN pode promover usuários para Administrador',
      );
    }

    if (role === UserRole.SUPER_ADMIN) {
      throw new ForbiddenException(
        'Criação de SUPER_ADMIN é permitida apenas via bootstrap seguro',
      );
    }

    return this.usersService.updateRole(id, role, user);
  }

  @Put(':id/restaurantes')
  async setRestaurants(
    @Param('id', ParseIntPipe) id: number,
    @Body('restIDs') restIDs: number[],
    @CurrentUser() user: any,
  ) {
    if (!isAdminLike(user?.role)) {
      throw new ForbiddenException(
        'Apenas administradores podem definir restaurantes',
      );
    }
    return this.usersService.setRestaurants(id, restIDs || [], user);
  }

  @Put(':id/password')
  async resetPassword(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: ResetPasswordDto,
    @CurrentUser() user: any,
  ) {
    if (!isAdminLike(user?.role)) {
      throw new ForbiddenException(
        'Apenas administradores podem redefinir senha',
      );
    }
    return this.usersService.resetPassword(id, dto.newPassword, user);
  }

  @Delete(':id')
  async remove(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    if (!isAdminLike(user?.role)) {
      throw new ForbiddenException(
        'Apenas administradores podem remover usuários',
      );
    }
    return this.usersService.deleteUser(id, user);
  }
}
