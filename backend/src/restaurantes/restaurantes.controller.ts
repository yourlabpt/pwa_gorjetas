import { Controller, Get, Post, Put, Delete, Body, Param, Query, ForbiddenException } from '@nestjs/common';
import { RestaurantesService } from './restaurantes.service';
import { CreateRestauranteDto, UpdateRestauranteDto } from './dto/restaurante.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess, getAllowedRestaurantes } from '../auth/restaurant-access.util';
import { UserRole } from '@prisma/client';

@Controller('restaurantes')
export class RestaurantesController {
  constructor(private restaurantesService: RestaurantesService) {}

  @Post()
  create(@Body() data: CreateRestauranteDto, @CurrentUser() user: any) {
    if (user?.role !== UserRole.ADMIN && user?.role !== UserRole.SUPERVISOR) {
      throw new ForbiddenException('Apenas supervisor ou admin podem criar restaurante');
    }
    return this.restaurantesService.create(data);
  }

  @Get()
  findAll(@Query('ativo') ativo: string, @CurrentUser() user: any) {
    const ativoBoolean = ativo === 'true' ? true : ativo === 'false' ? false : undefined;
    const allowedRestIds = getAllowedRestaurantes(user);
    return this.restaurantesService.findAll(ativoBoolean, allowedRestIds);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser() user: any) {
    assertRestaurantAccess(user, Number(id));
    return this.restaurantesService.findOne(Number(id));
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() data: UpdateRestauranteDto, @CurrentUser() user: any) {
    if (user?.role !== UserRole.ADMIN && user?.role !== UserRole.SUPERVISOR) {
      throw new ForbiddenException('Apenas supervisor ou admin podem editar restaurante');
    }
    assertRestaurantAccess(user, Number(id));
    return this.restaurantesService.update(Number(id), data);
  }

  @Put(':id/toggle-active')
  toggleActive(@Param('id') id: string, @CurrentUser() user: any) {
    if (user?.role !== UserRole.ADMIN && user?.role !== UserRole.SUPERVISOR) {
      throw new ForbiddenException('Apenas supervisor ou admin podem editar restaurante');
    }
    assertRestaurantAccess(user, Number(id));
    return this.restaurantesService.toggleActive(Number(id));
  }

  @Delete(':id')
  delete(@Param('id') id: string, @CurrentUser() user: any) {
    if (user?.role !== UserRole.ADMIN) {
      throw new ForbiddenException('Apenas admin pode deletar restaurante');
    }
    assertRestaurantAccess(user, Number(id));
    return this.restaurantesService.delete(Number(id));
  }
}
