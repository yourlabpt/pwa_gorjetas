import {
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

class ComputeStaffInputDto {
  @IsInt()
  @Min(1)
  @Type(() => Number)
  funcID: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  valor_pool?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  valor_direto?: number;
}

/**
 * Input DTO for the server-side daily payout calculation endpoint.
 * Accepts the day's financial buckets and optionally a date string
 * (used for context only, not persisted here).
 */
export class ComputePayoutsDto {
  /** Global revenue for the day (all transactions). */
  @IsNumber()
  @Min(0)
  faturamento_global: number;

  /**
   * Revenue including all tips (faturamento_global by default if omitted).
   * Can be derived as: valor_total_gorjetas / (base_percent / 100)
   */
  @IsOptional()
  @IsNumber()
  @Min(0)
  faturamento_com_gorjeta?: number;

  /**
   * Revenue after tips have been stripped out.
   * Can be derived as: faturamento_global - valor_total_gorjetas
   */
  @IsOptional()
  @IsNumber()
  @Min(0)
  faturamento_sem_gorjeta?: number;

  /** Total tip pool collected on this day. */
  @IsNumber()
  @Min(0)
  valor_total_gorjetas: number;

  /** Base tip percentage configured for the restaurant (e.g. 11). */
  @IsOptional()
  @IsNumber()
  @Min(0)
  base_percentual?: number;

  /** Optional: ISO date (YYYY-MM-DD) for informational purposes. */
  @IsOptional()
  @IsString()
  data?: string;

  /** When true, rules that would overdraw their bucket are still applied. */
  @IsOptional()
  @Type(() => Boolean)
  @IsBoolean()
  allowNegativeBalances?: boolean;

  /**
   * Behavior when payment pool is insufficient:
   * - SKIP: pay zero and keep unpaid amount.
   * - PARTIAL: pay available balance and keep remaining as unpaid.
   */
  @IsOptional()
  @IsIn(['SKIP', 'PARTIAL'])
  insufficientFundsPolicy?: 'SKIP' | 'PARTIAL';

  /**
   * Legacy compatibility field. Staff direct tips are tracked separately
   * and are not deducted from TIP_POOL in the centralized engine.
   */
  @IsOptional()
  @IsNumber()
  @Min(0)
  staff_direct_tip_pool_total?: number;

  /**
   * Per-employee inputs from frontend used to split STAFF payout
   * proportionally to each employee's produced pool value.
   */
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ComputeStaffInputDto)
  staff?: ComputeStaffInputDto[];
}
