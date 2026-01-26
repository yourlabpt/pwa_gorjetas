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
} from '@nestjs/common';
import { FuncionariosService } from './funcionarios.service';
import { CreateFuncionarioDto, UpdateFuncionarioDto } from './dto/funcionario.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('funcionarios')
export class FuncionariosController {
  constructor(private readonly funcionariosService: FuncionariosService) {}

  @Post()
  async create(@Body() createFuncionarioDto: CreateFuncionarioDto, @CurrentUser() user: any) {
    assertRestaurantAccess(user, createFuncionarioDto.restID);
    return this.funcionariosService.create(createFuncionarioDto);
  }

  @Get()
  async findMany(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('ativo') ativo?: string,
    @CurrentUser() user?: any,
  ) {
    assertRestaurantAccess(user, restID);
    const ativoBoolean = ativo === 'true' ? true : ativo === 'false' ? false : undefined;
    return this.funcionariosService.findMany(restID, ativoBoolean);
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
  ) {
    const func = await this.funcionariosService.findOne(id);
    assertRestaurantAccess(user, func?.restID);
    return this.funcionariosService.update(id, updateFuncionarioDto);
  }

  @Delete(':id')
  async delete(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const func = await this.funcionariosService.findOne(id);
    assertRestaurantAccess(user, func?.restID);
    return this.funcionariosService.softDelete(id);
  }
}
