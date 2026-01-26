import { IsDateString, IsOptional, IsString } from 'class-validator';

export class CreateAcertoPeridoDto {
  @IsDateString()
  periodo_inicio: string; // YYYY-MM-DD

  @IsDateString()
  periodo_fim: string; // YYYY-MM-DD

  @IsOptional()
  @IsString()
  tipo_periodo?: string; // "DIARIO" | "SEMANAL"
}

export class AcertoFuncionarioResponseDto {
  id: number;
  funcao: string;
  valor_base: number;
  percentual_aplicado: number | null;
  valor_absoluto_aplicado: number | null;
  valor_calculado: number;
  pago: boolean;
}

export class AcertoPeridoResponseDto {
  id: number;
  restID: number;
  periodo_inicio: Date;
  periodo_fim: Date;
  tipo_periodo: string;
  faturamento_total: number;
  gorjeta_total: number;
  pago: boolean;
  data_pagamento: Date | null;
  acertos_funcionarios: AcertoFuncionarioResponseDto[];
  criadoEm: Date;
  atualizadoEm: Date;
}
