import {
  IsString,
  IsOptional,
  IsNumber,
  IsBoolean,
  IsDateString,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreateFuncionarioDto {
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  contacto?: string;

  @IsOptional()
  @IsString()
  photo?: string;

  @IsString()
  funcao: string;

  @IsNumber()
  @Type(() => Number)
  restID: number;

  @IsOptional()
  @IsDateString()
  data_admissao?: string;

  @IsOptional()
  @IsString()
  iban?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  salario?: number;
}

export class UpdateFuncionarioDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  contacto?: string;

  @IsOptional()
  @IsString()
  photo?: string;

  @IsOptional()
  @IsString()
  funcao?: string;

  @IsOptional()
  @IsDateString()
  data_admissao?: string;

  @IsOptional()
  @IsString()
  iban?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  salario?: number;

  @IsOptional()
  @IsBoolean()
  ativo?: boolean;
}
