import { Controller, Get, Query } from '@nestjs/common';
import { RelatoriosService } from './relatorios.service';
import { RelatorioFilterDto } from './dto/relatorio.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { assertRestaurantAccess } from '../auth/restaurant-access.util';

@Controller('relatorios')
export class RelatoriosController {
  constructor(private readonly relatoriosService: RelatoriosService) {}

  @Get('funcionarios')
  async getFuncionariosReport(@Query() filters: RelatorioFilterDto, @CurrentUser() user: any) {
    assertRestaurantAccess(user, filters.restID);
    return this.relatoriosService.getFuncionariosReport(
      filters.restID,
      filters.from,
      filters.to,
    );
  }

  @Get('resumo')
  async getResumoReport(@Query() filters: RelatorioFilterDto, @CurrentUser() user: any) {
    assertRestaurantAccess(user, filters.restID);
    return this.relatoriosService.getResumoReport(
      filters.restID,
      filters.from,
      filters.to,
    );
  }

  @Get('faturamento')
  async getFaturamentoReport(@Query() filters: RelatorioFilterDto, @CurrentUser() user: any) {
    assertRestaurantAccess(user, filters.restID);
    return this.relatoriosService.getFaturamentoReport(
      filters.restID,
      filters.from,
      filters.to,
    );
  }
}
