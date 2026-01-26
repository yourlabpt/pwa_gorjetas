import {
  Controller,
  Get,
  Post,
  Put,
  Param,
  Body,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import { AcertoPeridoService } from './acerto-periodo.service';
import { CreateAcertoPeridoDto } from './dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('acerto-periodo')
export class AcertoPeridoController {
  constructor(private readonly acertoPeridoService: AcertoPeridoService) {}

  @Post()
  async create(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: CreateAcertoPeridoDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.acertoPeridoService.create(restID, dto);
  }

  @Get()
  async findByPeriod(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('dataInicio') dataInicio?: string,
    @Query('dataFim') dataFim?: string,
    @Query('pago') pago?: string,
    @CurrentUser() user?: any,
  ) {
    assertRestaurantAccess(user, restID);
    const pagoBool = pago === 'true' ? true : pago === 'false' ? false : undefined;
    return this.acertoPeridoService.findByPeriod(
      restID,
      dataInicio ? new Date(dataInicio) : undefined,
      dataFim ? new Date(dataFim) : undefined,
      pagoBool,
    );
  }

  @Get(':id')
  async findById(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const rec = await this.acertoPeridoService.findById(id);
    assertRestaurantAccess(user, rec?.restID);
    return rec;
  }

  @Put(':id/marcar-pago')
  async marcarComoPago(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: any) {
    const rec = await this.acertoPeridoService.findById(id);
    assertRestaurantAccess(user, rec?.restID);
    return this.acertoPeridoService.marcarComoPago(id);
  }
}
