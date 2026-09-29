import { FuncionariosService } from './funcionarios.service';

describe('FuncionariosService activity periods', () => {
  const hoje = new Date(
    `${new Intl.DateTimeFormat('en-CA', { timeZone: 'Europe/Lisbon' }).format(new Date())}T00:00:00Z`,
  );
  const base = { funcID: 7, restID: 1, name: 'Ana', funcao: 'staff', deletedAt: null };

  function makeService(current: Partial<typeof base> & { ativo: boolean; deletedAt?: Date | null }) {
    const funcionario = { ...base, ...current };
    const prisma = {
      funcionario: {
        findUnique: jest.fn().mockResolvedValue(funcionario),
        findMany: jest.fn().mockResolvedValue([]),
        update: jest.fn().mockImplementation(async ({ data }) => ({ ...funcionario, ...data })),
        create: jest.fn().mockImplementation(async ({ data }) => data),
      },
    } as any;
    const eventEmitter = { emit: jest.fn() } as any;
    return { service: new FuncionariosService(prisma, eventEmitter), prisma, eventEmitter };
  }

  it('deactivating closes the open period on today and audits it', async () => {
    const { service, prisma, eventEmitter } = makeService({ ativo: true });
    await service.toggleActive(7, { userId: 3 });
    expect(prisma.funcionario.update).toHaveBeenCalledWith({
      where: { funcID: 7 },
      data: { ativo: false, periodos: { updateMany: { where: { fim: null }, data: { fim: hoje } } } },
    });
    expect(eventEmitter.emit).toHaveBeenCalledWith(
      'audit.action',
      expect.objectContaining({ entity: 'Funcionario', entityId: '7', userId: 3 }),
    );
  });

  it('activating opens a new period starting today', async () => {
    const { service, prisma } = makeService({ ativo: false });
    await service.toggleActive(7);
    expect(prisma.funcionario.update.mock.calls[0][0].data).toEqual({
      ativo: true,
      periodos: { create: { inicio: hoje } },
    });
  });

  it('update without a status change does not touch periods', async () => {
    const { service, prisma, eventEmitter } = makeService({ ativo: true });
    await service.update(7, { name: 'Ana Maria', ativo: true });
    expect(prisma.funcionario.update.mock.calls[0][0].data.periodos).toBeUndefined();
    expect(eventEmitter.emit).not.toHaveBeenCalled();
  });

  it('update flipping ativo closes the period', async () => {
    const { service, prisma } = makeService({ ativo: true });
    await service.update(7, { ativo: false });
    expect(prisma.funcionario.update.mock.calls[0][0].data.periodos).toEqual({
      updateMany: { where: { fim: null }, data: { fim: hoje } },
    });
  });

  it('soft delete closes the period', async () => {
    const { service, prisma } = makeService({ ativo: true });
    await service.softDelete(7);
    const data = prisma.funcionario.update.mock.calls[0][0].data;
    expect(data.ativo).toBe(false);
    expect(data.deletedAt).toBeInstanceOf(Date);
    expect(data.periodos).toEqual({ updateMany: { where: { fim: null }, data: { fim: hoje } } });
  });

  it('create opens a period at admission date when it is in the past', async () => {
    const { service, prisma } = makeService({ ativo: true });
    await service.create({ name: 'Novo', funcao: 'staff', restID: 1, data_admissao: '2020-01-01' });
    expect(prisma.funcionario.create.mock.calls[0][0].data.periodos).toEqual({
      create: { inicio: new Date('2020-01-01T00:00:00Z') },
    });
  });

  it('findForDay asks for employees active on the day or stored in it', async () => {
    const { service, prisma } = makeService({ ativo: true });
    await service.findForDay(1, '2026-03-10');
    const dia = new Date('2026-03-10T00:00:00Z');
    expect(prisma.funcionario.findMany).toHaveBeenCalledWith({
      where: {
        OR: [
          { restID: 1, periodos: { some: { inicio: { lte: dia }, OR: [{ fim: null }, { fim: { gte: dia } }] } } },
          { faturamento_distribuicoes: { some: { restID: 1, data: dia } } },
          { presencas: { some: { restID: 1, data: dia } } },
        ],
      },
      orderBy: { createdAt: 'asc' },
    });
  });
});
