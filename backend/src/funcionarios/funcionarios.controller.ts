import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Query,
  ParseIntPipe,
  Req,
} from '@nestjs/common';
import { FuncionariosService } from './funcionarios.service';
import { CreateFuncionarioDto, UpdateFuncionarioDto } from './dto/funcionario.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('funcionarios')
export class FuncionariosController {
  constructor(private readonly funcionariosService: FuncionariosService) {}

  private auditContext(user: any, req: any) {
    return {
      userId: user?.userId,
      requestId: req?.requestId,
      ipAddress: req?.ipAddress,
      userAgent: req?.userAgent,
    };
  }

  @Post()
  async create(@Body() createFuncionarioDto: CreateFuncionarioDto, @CurrentUser() user: any) {
    assertRestaurantAccess(user, createFuncionarioDto.restID);
    return this.funcionariosService.create(createFuncionarioDto);
  }

  @Get()
  async findMany(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('ativo') ativo?: string,
    @Query('includeDeleted') includeDeleted?: string,
    @Query('data') data?: string,
    @CurrentUser() user?: any,
  ) {
    assertRestaurantAccess(user, restID);
    if (data) {
      // Employees that belong to that day (active on it or present in its stored rows)
      return this.funcionariosService.findForDay(restID, data);
    }
    const ativoBoolean = ativo === 'true' ? true : ativo === 'false' ? false : undefined;
    const includeDeletedBoolean = includeDeleted === 'true';
    return this.funcionariosService.findMany(restID, ativoBoolean, includeDeletedBoolean);
  }

  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const func = await this.funcionariosService.findOne(id);
    assertRestaurantAccess(user, func?.restID);
    return func;
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateFuncionarioDto: UpdateFuncionarioDto,
    @CurrentUser() user: any,
    @Req() req: any,
  ) {
    const func = await this.funcionariosService.findOne(id);
    assertRestaurantAccess(user, func?.restID);
    return this.funcionariosService.update(id, updateFuncionarioDto, this.auditContext(user, req));
  }

  @Put(':id/toggle-active')
  async toggleActive(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: any,
    @Req() req: any,
  ) {
    const func = await this.funcionariosService.findOne(id);
    assertRestaurantAccess(user, func?.restID);
    return this.funcionariosService.toggleActive(id, this.auditContext(user, req));
  }

  @Put(':id/restore')
  async restore(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const func = await this.funcionariosService.findOne(id);
    assertRestaurantAccess(user, func?.restID);
    return this.funcionariosService.restore(id);
  }

  @Delete(':id')
  async delete(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: any,
    @Req() req: any,
  ) {
    const func = await this.funcionariosService.findOne(id);
    assertRestaurantAccess(user, func?.restID);
    return this.funcionariosService.softDelete(id, this.auditContext(user, req));
  }
}
