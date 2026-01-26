import { IsNumber, IsString, IsOptional, IsBoolean, IsIn } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateConfiguracaoGorjetasDto {
  @IsNumber()
  restID: number;

  @IsString()
  funcao: string;

  @IsOptional()
  @IsIn(['percentagem', 'remainder'])
  tipo_calculo?: string; // Default: 'percentagem'

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  percentagem?: number; // Required if tipo_calculo = 'percentagem'

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  ordem_calculo?: number; // Default: 0
}

export class UpdateConfiguracaoGorjetasDto {
  @IsOptional()
  @IsIn(['percentagem', 'remainder'])
  tipo_calculo?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  percentagem?: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  ordem_calculo?: number;

  @IsOptional()
  @IsBoolean()
  ativo?: boolean;
}
