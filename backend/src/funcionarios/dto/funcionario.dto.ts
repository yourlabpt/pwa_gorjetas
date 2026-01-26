import { IsString, IsOptional, IsNumber, IsBoolean } from 'class-validator';

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
  restID: number;
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
  @IsBoolean()
  ativo?: boolean;
}
