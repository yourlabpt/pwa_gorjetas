import { IsString, IsOptional, IsNumber } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateRestauranteDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  endereco?: string;

  @IsOptional()
  @IsString()
  contacto?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  percentagem_gorjeta_base?: number;
}

export class UpdateRestauranteDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  endereco?: string;

  @IsOptional()
  @IsString()
  contacto?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  percentagem_gorjeta_base?: number;

  @IsOptional()
  ativo?: boolean;
}
