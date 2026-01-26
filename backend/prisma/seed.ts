import { PrismaClient } from '@prisma/client';
import { Decimal } from 'decimal.js';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Cleanup - delete in correct order due to foreign keys
  await prisma.transacao.deleteMany({});
  await prisma.limpeza.deleteMany({});
  await prisma.distribuicaoGorjetas.deleteMany({});
  await prisma.configuracaoGorjetas.deleteMany({});
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

  // Create tip configurations
  const configs = await Promise.all([
    prisma.configuracaoGorjetas.create({
      data: {
        restID: restaurante.restID,
        funcao: 'garcom',
        percentagem: new Decimal('7.00'),
      },
    }),
    prisma.configuracaoGorjetas.create({
      data: {
        restID: restaurante.restID,
        funcao: 'cozinha',
        percentagem: new Decimal('3.00'),
      },
    }),
    prisma.configuracaoGorjetas.create({
      data: {
        restID: restaurante.restID,
        funcao: 'douglas',
        percentagem: new Decimal('1.00'),
      },
    }),
  ]);

  console.log(`✅ Created ${configs.length} tip configurations`);

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
