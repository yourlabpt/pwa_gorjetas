import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class AcertoFinalEntryDto {
  @IsInt()
  @Min(1)
  funcID: number;

  @IsString()
  bucket: string;

  @IsNumber()
  @Min(0)
  valor_sugerido: number;

  @IsNumber()
  @Min(0)
  valor_manual: number;

  @IsBoolean()
  is_manual_override: boolean;

  @IsOptional()
  @IsString()
  notas?: string;
}

export class SaveAcertoFinalDto {
  @IsDateString()
  periodo_inicio: string;

  @IsDateString()
  periodo_fim: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => AcertoFinalEntryDto)
  entries: AcertoFinalEntryDto[];
}
