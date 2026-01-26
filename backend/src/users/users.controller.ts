import { Body, Controller, Get, Param, ParseIntPipe, Put } from '@nestjs/common';
import { UsersService } from './users.service';
import { CurrentUser } from '../auth/current-user.decorator';
import { UserRole } from '@prisma/client';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  async list(@CurrentUser() user: any) {
    if (user?.role !== UserRole.ADMIN) {
      throw new Error('Apenas admin pode listar usuários');
    }
    return this.usersService.findAll();
  }

  @Get(':id')
  async get(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    if (user?.role !== UserRole.ADMIN) {
      throw new Error('Apenas admin pode visualizar usuário');
    }
    return this.usersService.findOne(id);
  }

  @Put(':id/role')
  async updateRole(
    @Param('id', ParseIntPipe) id: number,
    @Body('role') role: UserRole,
    @CurrentUser() user: any,
  ) {
    if (user?.role !== UserRole.ADMIN) {
      throw new Error('Apenas admin pode alterar role');
    }
    return this.usersService.updateRole(id, role);
  }

  @Put(':id/restaurantes')
  async setRestaurants(
    @Param('id', ParseIntPipe) id: number,
    @Body('restIDs') restIDs: number[],
    @CurrentUser() user: any,
  ) {
    if (user?.role !== UserRole.ADMIN) {
      throw new Error('Apenas admin pode definir restaurantes');
    }
    return this.usersService.setRestaurants(id, restIDs || []);
  }
}
