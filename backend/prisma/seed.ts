import { PrismaClient } from '@prisma/client';
import { Decimal } from 'decimal.js';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Cleanup - delete in correct order due to foreign keys
  await prisma.distribuicaoGorjetas.deleteMany({});
  await prisma.transacao.deleteMany({});
  await prisma.regraDistribuicao.deleteMany({});
  await prisma.limpezaRecord.deleteMany({});
  await prisma.limpeza.deleteMany({});
  await prisma.funcionarioRestaurante.deleteMany({});
  await prisma.funcionario.deleteMany({});
  await prisma.restaurante.deleteMany({});

  // Create restaurant
  const restaurante = await prisma.restaurante.create({
    data: {
      name: 'Restaurante Test',
      endereco: 'Rua da Teste, 123, Lisboa',
      contacto: '+351 21 123 4567',
      percentagem_gorjeta_base: new Decimal('11.00'),
    },
  });

  console.log('✅ Created restaurant:', restaurante.name);

  // Create employees
  const funcionarios = await Promise.all([
    prisma.funcionario.create({
      data: {
        name: 'João Silva',
        contacto: '912345678',
        funcao: 'garcom',
        restID: restaurante.restID,
      },
    }),
    prisma.funcionario.create({
      data: {
        name: 'Maria Santos',
        contacto: '912345679',
        funcao: 'garcom',
        restID: restaurante.restID,
      },
    }),
    prisma.funcionario.create({
      data: {
        name: 'Chef Nunes',
        contacto: '912345680',
        funcao: 'cozinha',
        restID: restaurante.restID,
      },
    }),
    prisma.funcionario.create({
      data: {
        name: 'Douglas Silva',
        contacto: '912345681',
        funcao: 'douglas',
        restID: restaurante.restID,
      },
    }),
  ]);

  console.log(`✅ Created ${funcionarios.length} employees`);

  // Create centralized payout rules
  const regras = await Promise.all([
    prisma.regraDistribuicao.create({
      data: {
        restID: restaurante.restID,
        role_name: 'garcom',
        calculation_type: 'PERCENT',
        calculation_base: 'VALOR_TOTAL_GORJETAS',
        rate: new Decimal('7.00'),
        percent_mode: 'BASE_PERCENT_POINTS',
        split_mode: 'PROPORTIONAL_TO_POOL_INPUT',
        payment_source: 'TIP_POOL',
        ordem: 1,
        ativo: true,
      },
    }),
    prisma.regraDistribuicao.create({
      data: {
        restID: restaurante.restID,
        role_name: 'cozinha',
        calculation_type: 'PERCENT',
        calculation_base: 'VALOR_TOTAL_GORJETAS',
        rate: new Decimal('3.00'),
        percent_mode: 'BASE_PERCENT_POINTS',
        split_mode: 'EQUAL_SPLIT',
        payment_source: 'TIP_POOL',
        ordem: 2,
        ativo: true,
      },
    }),
    prisma.regraDistribuicao.create({
      data: {
        restID: restaurante.restID,
        role_name: 'douglas',
        calculation_type: 'PERCENT',
        calculation_base: 'VALOR_TOTAL_GORJETAS',
        rate: new Decimal('1.00'),
        percent_mode: 'BASE_PERCENT_POINTS',
        split_mode: 'EQUAL_SPLIT',
        payment_source: 'TIP_POOL',
        ordem: 3,
        ativo: true,
      },
    }),
  ]);

  console.log(`✅ Created ${regras.length} payout rules`);

  console.log('🎉 Seeding completed!');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
