import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  ParseIntPipe,
  ForbiddenException,
} from '@nestjs/common';
import { RegrasDistribuicaoService } from './regras-distribuicao.service';
import {
  CreateRegraDistribuicaoDto,
  UpdateRegraDistribuicaoDto,
} from './dto/regra-distribuicao.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';
import { canManageRestaurants } from '../auth/role.util';

@Controller('regras-distribuicao')
export class RegrasDistribuicaoController {
  constructor(private svc: RegrasDistribuicaoService) {}

  /** List all rules for a restaurant (active only by default). */
  @Get()
  findAll(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('todos') todos: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    const apenasAtivos = todos !== 'true';
    return this.svc.findAll(restID, apenasAtivos);
  }

  /** Get a single rule. */
  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.svc.findOne(id, restID);
  }

  /** Create a new rule. ADMIN and SUPERVISOR only. */
  @Post()
  create(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: CreateRegraDistribuicaoDto,
    @CurrentUser() user: any,
  ) {
    if (!canManageRestaurants(user?.role)) {
      throw new ForbiddenException(
        'Apenas supervisor, admin ou super admin podem gerir regras.',
      );
    }
    assertRestaurantAccess(user, restID);
    return this.svc.create(restID, dto);
  }

  /** Update an existing rule. ADMIN and SUPERVISOR only. */
  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: UpdateRegraDistribuicaoDto,
    @CurrentUser() user: any,
  ) {
    if (!canManageRestaurants(user?.role)) {
      throw new ForbiddenException(
        'Apenas supervisor, admin ou super admin podem editar regras.',
      );
    }
    assertRestaurantAccess(user, restID);
    return this.svc.update(id, restID, dto);
  }

  /** Delete a rule. ADMIN and SUPERVISOR only. */
  @Delete(':id')
  delete(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @CurrentUser() user: any,
  ) {
    if (!canManageRestaurants(user?.role)) {
      throw new ForbiddenException(
        'Apenas supervisor, admin ou super admin podem remover regras.',
      );
    }
    assertRestaurantAccess(user, restID);
    return this.svc.delete(id, restID);
  }

}
