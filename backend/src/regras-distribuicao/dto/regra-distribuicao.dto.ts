import {
  IsString,
  IsEnum,
  IsNumber,
  IsOptional,
  IsBoolean,
  IsInt,
  Min,
  ValidateIf,
} from 'class-validator';
import { Type } from 'class-transformer';
import {
  CalculationType,
  CalculationBase,
  EmployeeSplitMode,
  PaymentSource,
  PercentMode,
  SettlementType,
} from '../../payout-calculator/payout-calculator.types';

export class CreateRegraDistribuicaoDto {
  @IsString()
  role_name: string;

  @IsEnum(CalculationType)
  calculation_type: CalculationType;

  /**
   * Required when calculation_type = PERCENT, must be null/omitted for FIXED_AMOUNT.
   */
  @ValidateIf((o) => o.calculation_type === CalculationType.PERCENT)
  @IsEnum(CalculationBase)
  calculation_base?: CalculationBase | null;

  /**
   * Percentage (e.g., 1.5 = 1.5%) or absolute currency amount.
   */
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  rate: number;

  @IsEnum(PaymentSource)
  payment_source: PaymentSource;

  @IsOptional()
  @IsEnum(PercentMode)
  percent_mode?: PercentMode;

  @IsOptional()
  @IsEnum(EmployeeSplitMode)
  split_mode?: EmployeeSplitMode;

  @IsOptional()
  @IsEnum(SettlementType)
  tipo_de_acerto?: SettlementType;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Type(() => Number)
  ordem?: number;
}

export class UpdateRegraDistribuicaoDto {
  @IsOptional()
  @IsString()
  role_name?: string;

  @IsOptional()
  @IsEnum(CalculationType)
  calculation_type?: CalculationType;

  @IsOptional()
  @IsEnum(CalculationBase)
  calculation_base?: CalculationBase | null;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  rate?: number;

  @IsOptional()
  @IsEnum(PaymentSource)
  payment_source?: PaymentSource;

  @IsOptional()
  @IsEnum(PercentMode)
  percent_mode?: PercentMode;

  @IsOptional()
  @IsEnum(EmployeeSplitMode)
  split_mode?: EmployeeSplitMode;

  @IsOptional()
  @IsEnum(SettlementType)
  tipo_de_acerto?: SettlementType;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Type(() => Number)
  ordem?: number;

  @IsOptional()
  @IsBoolean()
  ativo?: boolean;
}
