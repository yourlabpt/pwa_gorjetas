import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsInt,
  IsNumber,
  IsOptional,
  IsIn,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

class StaffEntryDto {
  @IsNumber()
  @Min(0)
  funcID: number;

  @IsNumber()
  @Min(0)
  valor_pool: number;

  @IsNumber()
  @Min(0)
  valor_direto: number;

  @IsNumber()
  @Min(0)
  valor_pago: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  desconto?: number;
}

class PresencaEntryDto {
  @IsInt()
  @Min(1)
  @Type(() => Number)
  funcID: number;

  @Type(() => Boolean)
  @IsBoolean()
  presente: boolean;
}

export class SaveFinanceiroSnapshotDto {
  @IsDateString()
  data: string; // YYYY-MM-DD

  @IsNumber()
  @Min(0)
  faturamento_global: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  base_percentual?: number;

  // ── New revenue/tip buckets (optional for backward compat) ──────────────
  @IsOptional()
  @IsNumber()
  @Min(0)
  faturamento_com_gorjeta?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  faturamento_sem_gorjeta?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  valor_total_gorjetas?: number;
  // ────────────────────────────────────────────────────────────────────────

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => StaffEntryDto)
  staff?: StaffEntryDto[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PresencaEntryDto)
  presencas?: PresencaEntryDto[];

  /**
   * Staff direct tips that should also consume TIP_POOL before fallback
   * distribution (legacy-compatible behavior used in financeiro-diario).
   */
  @IsOptional()
  @IsNumber()
  @Min(0)
  staff_direct_tip_pool_total?: number;

  /**
   * Behavior when payment pool is insufficient:
   * - SKIP: pay zero and keep unpaid amount.
   * - PARTIAL: pay available balance and keep remaining as unpaid.
   */
  @IsOptional()
  @IsIn(['SKIP', 'PARTIAL'])
  insufficientFundsPolicy?: 'SKIP' | 'PARTIAL';
}
