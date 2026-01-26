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
import { ConfiguracaoGorjetasService } from './configuracao-gorjetas.service';
import {
  CreateConfiguracaoGorjetasDto,
  UpdateConfiguracaoGorjetasDto,
} from './dto/configuracao-gorjetas.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('configuracao-gorjetas')
export class ConfiguracaoGorjetasController {
  constructor(
    private readonly configuracaoService: ConfiguracaoGorjetasService,
  ) {}

  @Post()
  async create(
    @Body() createConfiguracaoDto: CreateConfiguracaoGorjetasDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, createConfiguracaoDto.restID);
    return this.configuracaoService.create(createConfiguracaoDto);
  }

  @Get()
  async findMany(@Query('restID', ParseIntPipe) restID: number, @CurrentUser() user: any) {
    assertRestaurantAccess(user, restID);
    return this.configuracaoService.findMany(restID);
  }

  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const rec = await this.configuracaoService.findOne(id);
    assertRestaurantAccess(user, rec?.restID);
    return rec;
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateConfiguracaoDto: UpdateConfiguracaoGorjetasDto,
    @CurrentUser() user: any,
  ) {
    const rec = await this.configuracaoService.findOne(id);
    assertRestaurantAccess(user, rec?.restID);
    return this.configuracaoService.update(id, updateConfiguracaoDto);
  }

  @Delete(':id')
  async delete(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const rec = await this.configuracaoService.findOne(id);
    assertRestaurantAccess(user, rec?.restID);
    return this.configuracaoService.delete(id);
  }
}
