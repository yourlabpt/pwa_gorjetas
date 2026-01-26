import { Controller, Get, Param, Query, ParseIntPipe } from '@nestjs/common';
import { DistribuicaoGorjetasService } from './distribuicao-gorjetas.service';
import { DistribuicaoFilterDto } from './dto/distribuicao.dto';

@Controller('distribuicao-gorjetas')
export class DistribuicaoGorjetasController {
  constructor(
    private readonly distribuicaoService: DistribuicaoGorjetasService,
  ) {}

  @Get()
  async findMany(@Query() filters: DistribuicaoFilterDto) {
    return this.distribuicaoService.findMany(filters.tranID, undefined);
  }

  @Get('transacao/:tranID')
  async findByTransaction(@Param('tranID', ParseIntPipe) tranID: number) {
    return this.distribuicaoService.findByTransaction(tranID);
  }

  @Get('funcionario/:funcID')
  async findByFuncionario(
    @Param('funcID', ParseIntPipe) funcID: number,
    @Query('from') from?: string,
    @Query('to') to?: string,
    @Query('restID', ParseIntPipe) restID?: number,
  ) {
    return this.distribuicaoService.findByFuncionario(
      funcID,
      from,
      to,
      restID,
    );
  }
}
