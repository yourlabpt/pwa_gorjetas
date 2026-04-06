import { IsString, IsNumber, IsOptional, IsBoolean, IsArray, ValidateNested, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateTemplateDto {
  @IsString()
  label: string;

  @IsOptional()
  @IsNumber()
  ordem?: number;
}

export class UpdateTemplateDto {
  @IsOptional()
  @IsString()
  label?: string;

  @IsOptional()
  @IsNumber()
  ordem?: number;

  @IsOptional()
  @IsBoolean()
  ativo?: boolean;
}

export class FechoItemDto {
  @IsOptional()
  @IsNumber()
  id?: number; // existing item id (for updates)

  @IsOptional()
  @IsNumber()
  templateId?: number | null;

  @IsString()
  label: string;

  @IsNumber()
  @Min(0)
  valor: number;

  @IsOptional()
  @IsBoolean()
  contaNoDeposito?: boolean;
}

export class SaveFechoDto {
  @IsString()
  data: string; // YYYY-MM-DD

  @IsOptional()
  @IsNumber()
  @Min(0)
  faturamento_global?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  dinheiro_a_depositar?: number;

  @IsOptional()
  @IsString()
  notas?: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => FechoItemDto)
  itens: FechoItemDto[];
}
