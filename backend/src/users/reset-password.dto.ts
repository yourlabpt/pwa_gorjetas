import { IsString, Matches, MaxLength, MinLength } from 'class-validator';

export class ResetPasswordDto {
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
  newPassword: string;
}
