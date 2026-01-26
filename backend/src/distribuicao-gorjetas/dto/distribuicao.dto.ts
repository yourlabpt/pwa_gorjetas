import { IsOptional, IsDateString, IsNumber } from 'class-validator';
import { Type } from 'class-transformer';

export class DistribuicaoFilterDto {
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  tranID?: number;

  @IsOptional()
  @IsDateString()
  from?: string;

  @IsOptional()
  @IsDateString()
  to?: string;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  restID?: number;
}
