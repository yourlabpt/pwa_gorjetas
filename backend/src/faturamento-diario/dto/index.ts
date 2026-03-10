import { IsNumber, IsString, IsOptional, IsDateString } from 'class-validator';

export class CreateFaturamentoDiarioDto {
  @IsDateString()
  data: string; // YYYY-MM-DD

  @IsNumber()
  faturamento_inserido: number;

  @IsOptional()
  @IsString()
  notas?: string;
}

export class UpdateFaturamentoDiarioDto {
  @IsOptional()
  @IsNumber()
  faturamento_inserido?: number;

  @IsOptional()
  @IsString()
  notas?: string;
}

export class FaturamentoDiarioResponseDto {
  id: number;
  restID: number;
  data: Date;
  faturamento_inserido: number;
  faturamento_calculado: number;
  gorjeta_total: number;
  diferenca_percentual: number;
  notas: string | null;
  ativo: boolean;
  criadoEm: Date;
  atualizadoEm: Date;
}

export * from './save-snapshot.dto';
export * from './compute-payouts.dto';
