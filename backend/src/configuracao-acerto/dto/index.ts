import { IsString, IsNumber, IsOptional, Min, Max } from 'class-validator';

export class CreateConfiguracaoAcertoDto {
  @IsString()
  funcao: string; // "Garçom", "Cozinha", "Supervisor", "Gestor", etc.

  @IsString()
  base_calculo: string; // "GORJETA_TOTAL" | "FATURAMENTO_BASE" | "ABSOLUTO" | "GORJETA_REMAINING" | "FATURAMENTO_EXTRA"

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  valor_percentual?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  valor_absoluto?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  ordem_calculo?: number; // Processing order (lower = sooner)
}

export class UpdateConfiguracaoAcertoDto {
  @IsOptional()
  @IsString()
  base_calculo?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  valor_percentual?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  valor_absoluto?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  ordem_calculo?: number;
}

export class ConfiguracaoAcertoResponseDto {
  id: number;
  restID: number;
  funcao: string;
  base_calculo: string;
  valor_percentual: number | null;
  valor_absoluto: number | null;
  ordem_calculo: number;
  ativo: boolean;
  criadoEm: Date;
  atualizadoEm: Date;
}
