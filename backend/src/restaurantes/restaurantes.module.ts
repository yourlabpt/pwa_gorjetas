import { Module } from '@nestjs/common';
import { RestaurantesController } from './restaurantes.controller';
import { RestaurantesService } from './restaurantes.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [RestaurantesController],
  providers: [RestaurantesService],
})
export class RestaurantesModule {}
