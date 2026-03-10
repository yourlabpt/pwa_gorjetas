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
import { FechoFinanceiroService } from './fecho-financeiro.service';
import { CreateTemplateDto, UpdateTemplateDto, SaveFechoDto } from './dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('fecho-financeiro')
export class FechoFinanceiroController {
  constructor(private readonly service: FechoFinanceiroService) {}

  // ─── Templates ───────────────────────────────────────────────────────────

  @Get('templates')
  async getTemplates(
    @Query('restID', ParseIntPipe) restID: number,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.service.getTemplates(restID);
  }

  @Post('templates')
  async createTemplate(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: CreateTemplateDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.service.createTemplate(restID, dto);
  }

  @Put('templates/:id')
  async updateTemplate(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: UpdateTemplateDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.service.updateTemplate(id, restID, dto);
  }

  @Delete('templates/:id')
  async deleteTemplate(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.service.deleteTemplate(id, restID);
  }

  // ─── Fecho Diário ────────────────────────────────────────────────────────

  @Get()
  async getFecho(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('data') data: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.service.getFecho(restID, data);
  }

  @Post()
  async saveFecho(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: SaveFechoDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.service.saveFecho(restID, dto);
  }

  @Get('range')
  async getFechoRange(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('from') from: string,
    @Query('to') to: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.service.getFechoRange(restID, from, to);
  }
}
