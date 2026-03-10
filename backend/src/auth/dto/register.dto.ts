import {
  IsArray,
  IsEmail,
  IsIn,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  MinLength,
} from 'class-validator';
import { UserRole } from '@prisma/client';

export class RegisterDto {
  @IsString()
  name: string;

  @IsEmail()
  @MaxLength(254)
  email: string;

  @IsString()
  @MinLength(12)
  @MaxLength(128)
  @Matches(/[a-z]/, {
    message: 'Senha deve conter pelo menos uma letra minúscula',
  })
  @Matches(/[A-Z]/, {
    message: 'Senha deve conter pelo menos uma letra maiúscula',
  })
  @Matches(/[0-9]/, {
    message: 'Senha deve conter pelo menos um número',
  })
  @Matches(/[^A-Za-z0-9]/, {
    message: 'Senha deve conter pelo menos um caractere especial',
  })
  password: string;

  @IsOptional()
  @IsIn(['GERENTE', UserRole.SUPERVISOR, UserRole.ADMIN, UserRole.SUPER_ADMIN])
  role?: string;

  @IsOptional()
  @IsArray()
  restaurantIds?: number[];
}
