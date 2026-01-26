import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import { TransacoesService } from './transacoes.service';
import { CreateTransacaoDto, TransacaoFilterDto } from './dto/transacao.dto';

@Controller('transacoes')
export class TransacoesController {
  constructor(private readonly transacoesService: TransacoesService) {}

  @Post()
  async create(@Body() createTransacaoDto: CreateTransacaoDto) {
    return this.transacoesService.create(createTransacaoDto);
  }

  @Get()
  async findMany(@Query() filters: TransacaoFilterDto) {
    return this.transacoesService.findMany(
      filters.restID,
      filters.funcID,
      filters.from,
      filters.to,
    );
  }

  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.transacoesService.findOne(id);
  }
}
