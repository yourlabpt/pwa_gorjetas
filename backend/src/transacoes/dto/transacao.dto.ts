import {
  IsString,
  IsNumber,
  IsOptional,
  Min,
  IsDateString,
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreateTransacaoDto {
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  total: number;

  @Type(() => Number)
  @IsNumber()
  @Min(0)
  valor_gorjeta_calculada: number;

  @Type(() => Number)
  @IsNumber()
  funcID_garcom: number;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  @Min(0)
  mbway?: number;

  @Type(() => Number)
  @IsNumber()
  restID: number;

  @IsDateString()
  data_transacao: string; // ISO date string (YYYY-MM-DD)
}

export class TransacaoFilterDto {
  @Type(() => Number)
  @IsNumber()
  restID: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  funcID?: number;

  @IsOptional()
  @IsDateString()
  from?: string;

  @IsOptional()
  @IsDateString()
  to?: string;
}
