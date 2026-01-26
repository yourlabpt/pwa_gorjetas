import {
  IsArray,
  IsDateString,
  IsNumber,
  IsOptional,
  IsString,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

class StaffEntryDto {
  @IsNumber()
  funcID: number;

  @IsNumber()
  valor_pool: number;

  @IsNumber()
  valor_direto: number;

  @IsNumber()
  valor_pago: number;
}

class ManagerEntryDto {
  @IsNumber()
  funcID: number;

  @IsNumber()
  valor_teorico: number;

  @IsNumber()
  valor_pago: number;
}

class ChamadorEntryDto {
  @IsNumber()
  funcID: number;

  @IsNumber()
  valor_pago: number;
}

export class SaveFinanceiroSnapshotDto {
  @IsDateString()
  data: string; // YYYY-MM-DD

  @IsNumber()
  faturamento_global: number;

  @IsNumber()
  base_percentual: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => StaffEntryDto)
  staff: StaffEntryDto[];

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ManagerEntryDto)
  gestores: ManagerEntryDto[];

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ManagerEntryDto)
  supervisores: ManagerEntryDto[];

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ChamadorEntryDto)
  @IsOptional()
  chamadores?: ChamadorEntryDto[];

  @IsNumber()
  cozinha_valor: number;
}
