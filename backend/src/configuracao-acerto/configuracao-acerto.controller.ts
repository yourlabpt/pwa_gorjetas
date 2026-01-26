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
import { ConfiguracaoAcertoService } from './configuracao-acerto.service';
import {
  CreateConfiguracaoAcertoDto,
  UpdateConfiguracaoAcertoDto,
} from './dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('configuracao-acerto')
export class ConfiguracaoAcertoController {
  constructor(
    private readonly configuracaoAcertoService: ConfiguracaoAcertoService,
  ) {}

  @Post()
  async create(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: CreateConfiguracaoAcertoDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.configuracaoAcertoService.create(restID, dto);
  }

  @Get()
  async findByRestaurante(@Query('restID', ParseIntPipe) restID: number, @CurrentUser() user: any) {
    assertRestaurantAccess(user, restID);
    return this.configuracaoAcertoService.findByRestaurante(restID);
  }

  @Get(':id')
  async findById(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const record = await this.configuracaoAcertoService.findById(id);
    assertRestaurantAccess(user, record?.restID);
    return record;
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateConfiguracaoAcertoDto,
    @CurrentUser() user: any,
  ) {
    const record = await this.configuracaoAcertoService.findById(id);
    assertRestaurantAccess(user, record?.restID);
    return this.configuracaoAcertoService.update(id, dto);
  }

  @Delete(':id')
  async delete(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const record = await this.configuracaoAcertoService.findById(id);
    assertRestaurantAccess(user, record?.restID);
    await this.configuracaoAcertoService.delete(id);
    return { message: 'Configuração deletada com sucesso' };
  }
}
