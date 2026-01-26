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
import { FaturamentoDiarioService } from './faturamento-diario.service';
import {
  CreateFaturamentoDiarioDto,
  UpdateFaturamentoDiarioDto,
  SaveFinanceiroSnapshotDto,
} from './dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('faturamento-diario')
export class FaturamentoDiarioController {
  constructor(
    private readonly faturamentoDiarioService: FaturamentoDiarioService,
  ) {}

  @Post()
  async create(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: CreateFaturamentoDiarioDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.faturamentoDiarioService.create(restID, dto);
  }

  @Get(':id')
  async findById(@Param('id', ParseIntPipe) id: number) {
    // Nota: este endpoint requer restID para validação
    // Será ajustado com query param
    return { message: 'Use query params' };
  }

  @Get()
  async findByDate(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('data') data: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.faturamentoDiarioService.findByDate(
      restID,
      new Date(data),
    );
  }

  @Get('periodo/list')
  async findByPeriod(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('dataInicio') dataInicio: string,
    @Query('dataFim') dataFim: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.faturamentoDiarioService.findByPeriod(
      restID,
      new Date(dataInicio),
      new Date(dataFim),
    );
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: UpdateFaturamentoDiarioDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.faturamentoDiarioService.update(id, restID, dto);
  }

  @Post('snapshot')
  async saveSnapshot(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: SaveFinanceiroSnapshotDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    await this.faturamentoDiarioService.saveSnapshot(restID, dto);
    return { message: 'Snapshot salvo com sucesso' };
  }

  @Get('snapshot')
  async getSnapshot(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('data') data: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.faturamentoDiarioService.getSnapshot(restID, new Date(data));
  }

  @Get('snapshot/range')
  async getSnapshotRange(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('from') from: string,
    @Query('to') to: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.faturamentoDiarioService.getSnapshotRange(restID, new Date(from), new Date(to || from));
  }

  @Delete(':id')
  async delete(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    await this.faturamentoDiarioService.delete(id, restID);
    return { message: 'Faturamento deletado com sucesso' };
  }
}
