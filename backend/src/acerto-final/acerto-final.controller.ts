import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Body,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import { AcertoFinalService } from './acerto-final.service';
import { SaveAcertoFinalDto } from './dto/save-acerto-final.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('acerto-final')
export class AcertoFinalController {
  constructor(private readonly acertoFinalService: AcertoFinalService) {}

  @Post('save')
  async save(
    @Query('restID', ParseIntPipe) restID: number,
    @Body() dto: SaveAcertoFinalDto,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.acertoFinalService.save(restID, dto);
  }

  @Get()
  async findByPeriod(
    @Query('restID', ParseIntPipe) restID: number,
    @Query('from') from: string,
    @Query('to') to: string,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    return this.acertoFinalService.findByPeriod(restID, from, to);
  }

  @Delete(':id')
  async delete(
    @Param('id', ParseIntPipe) id: number,
    @Query('restID', ParseIntPipe) restID: number,
    @CurrentUser() user: any,
  ) {
    assertRestaurantAccess(user, restID);
    await this.acertoFinalService.delete(id, restID);
    return { message: 'Acerto Final eliminado com sucesso' };
  }
}
