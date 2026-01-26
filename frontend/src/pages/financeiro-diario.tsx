'use client';
import React, { useEffect, useMemo, useState } from 'react';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';

interface Restaurante {
  restID: number;
  name: string;
  percentagem_gorjeta_base: number;
  ativo: boolean;
}

interface Funcionario {
  funcID: number;
  name: string;
  funcao: string;
}

interface Configuracao {
  configID: number;
  funcao: string;
  percentagem: number;
  ativo: boolean;
}

interface GorjetaEntry {
  valor: string;
  direta: string;
}

interface ChamadorEntry {
  valor: string;
}

interface ManagerEntry {
  percentual: string;
}

interface EmployeeTotals {
  poolShare: number;
  directTip: number;
  managerShare: number;
  kitchenShare: number;
  total: number;
}

const currency = (value: number) => `€ ${value.toFixed(2)}`;
const normalizeRole = (funcao: string) => (funcao || '').toLowerCase();
const isStaffRole = (funcao: string) =>
  normalizeRole(funcao) === 'staff' || normalizeRole(funcao).includes('garcom');
const isKitchenRole = (funcao: string) => normalizeRole(funcao).includes('cozinha');
const isGestorRole = (funcao: string) => normalizeRole(funcao).includes('gestor');
const isSupervisorRole = (funcao: string) => normalizeRole(funcao).includes('supervisor');
const isManagerRole = (funcao: string) => isGestorRole(funcao) || isSupervisorRole(funcao);
const displayRole = (funcao: string) =>
  isStaffRole(funcao) ? 'Staff' : funcao || '—';

export default function FinanceiroDiario() {
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restaurantId, setRestaurantId] = useState<number | null>(null);
  const [selectedDate, setSelectedDate] = useState<string>(new Date().toISOString().split('T')[0]);
  const [faturamentoGlobal, setFaturamentoGlobal] = useState('');
  const [percentualBase, setPercentualBase] = useState<number>(11);
  const [gestorPercentual, setGestorPercentual] = useState<number>(1);
  const [supervisorPercentual, setSupervisorPercentual] = useState<number>(0.5);
  const [chamadorInputs, setChamadorInputs] = useState<Record<number, ChamadorEntry>>({});
  const [managerSplitInputs, setManagerSplitInputs] = useState<Record<number, ManagerEntry>>({});
  const [snapshotLoading, setSnapshotLoading] = useState(false);
  const [snapshotMessage, setSnapshotMessage] = useState('');
  const [snapshotLoaded, setSnapshotLoaded] = useState(false);
  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);
  const [configuracoes, setConfiguracoes] = useState<Configuracao[]>([]);
  const [gorjetaInputs, setGorjetaInputs] = useState<Record<number, GorjetaEntry>>({});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    const loadRestaurantes = async () => {
      try {
        const res = await apiClient.getRestaurantes(true);
        if (res.data?.length) {
          setRestaurantes(res.data);
          setRestaurantId(res.data[0].restID);
          const basePercent = parseFloat(String(res.data[0].percentagem_gorjeta_base)) || 11;
          setPercentualBase(basePercent);
        }
      } catch (err) {
        setError('Erro ao carregar restaurantes');
      }
    };

    loadRestaurantes();
  }, []);

  useEffect(() => {
    const loadContext = async () => {
      if (!restaurantId) return;
      try {
        setLoading(true);
        setError('');
        const [funcRes, confRes, restRes] = await Promise.all([
          apiClient.getFuncionarios(restaurantId, true),
          apiClient.getConfiguracoes(restaurantId),
          apiClient.getRestaurante(restaurantId),
        ]);

        setFuncionarios(funcRes.data || []);
        setConfiguracoes(confRes.data || []);

        const basePercent = parseFloat(String(restRes.data?.percentagem_gorjeta_base)) || 11;
        setPercentualBase(basePercent);

        setGorjetaInputs((prev) => {
          const next = { ...prev };
          (funcRes.data || []).forEach((f: Funcionario) => {
            if (!next[f.funcID]) {
              next[f.funcID] = { valor: '', direta: '' };
            }
          });
          return next;
        });

        setChamadorInputs((prev) => {
          const next = { ...prev };
          (funcRes.data || [])
            .filter((f: Funcionario) => normalizeRole(f.funcao) === 'chamador')
            .forEach((f: Funcionario) => {
              if (!next[f.funcID]) {
                next[f.funcID] = { valor: '' };
              }
            });
          return next;
        });

        setManagerSplitInputs((prev) => {
          const next = { ...prev };
          (funcRes.data || [])
            .filter((f: Funcionario) => isGestorRole(f.funcao) || isSupervisorRole(f.funcao))
            .forEach((f: Funcionario) => {
              if (!next[f.funcID]) {
                next[f.funcID] = { percentual: '' };
              }
            });
          return next;
        });
      } catch (err) {
        setError('Erro ao carregar dados do restaurante');
      } finally {
        setLoading(false);
      }
    };

    loadContext();
  }, [restaurantId]);

  const handleGorjetaChange = (funcID: number, field: keyof GorjetaEntry, value: string) => {
    setGorjetaInputs((prev) => ({
      ...prev,
      [funcID]: {
        valor: prev[funcID]?.valor || '',
        direta: prev[funcID]?.direta || '',
        [field]: value,
      },
    }));
  };

  const handleChamadorChange = (funcID: number, value: string) => {
    setChamadorInputs((prev) => ({
      ...prev,
      [funcID]: {
        valor: value,
      },
    }));
  };

  const handleManagerPercentChange = (funcID: number, value: string) => {
    setManagerSplitInputs((prev) => ({
      ...prev,
      [funcID]: {
        percentual: value,
      },
    }));
  };

  const handleSalvarFinanceiro = async () => {
    if (!restaurantId || !selectedDate) {
      setSnapshotMessage('Selecione restaurante e dia antes de salvar.');
      setTimeout(() => setSnapshotMessage(''), 2500);
      return;
    }
    try {
      setSnapshotLoading(true);
      const staffEntries = funcionarios
        .filter((f) => isStaffRole(f.funcao))
        .map((f) => {
          const entry = gorjetaInputs[f.funcID] || { valor: '0', direta: '0' };
          return {
            funcID: f.funcID,
            valor_pool: parseFloat(entry.valor) || 0,
            valor_direto: parseFloat(entry.direta) || 0,
            valor_pago: employeeTotals[f.funcID]?.total || 0,
          };
        });

      const gestorEntriesPayload = gestorPerEmployee.map((g) => ({
        funcID: g.funcionario.funcID,
        valor_teorico: g.teorico,
        valor_pago: g.real,
      }));

      const supervisorEntriesPayload = supervisorPerEmployee.map((s) => ({
        funcID: s.funcionario.funcID,
        valor_teorico: s.teorico,
        valor_pago: s.real,
      }));

      const chamadorEntriesPayload = Object.entries(chamadorInputs).map(([funcID, val]) => ({
        funcID: parseInt(funcID, 10),
        valor_pago: parseFloat(val.valor) || 0,
      }));

      const payload = {
        data: selectedDate,
        faturamento_global: parseFloat(faturamentoGlobal) || 0,
        base_percentual: basePercentNumber,
        staff: staffEntries,
        gestores: gestorEntriesPayload,
        supervisores: supervisorEntriesPayload,
        chamadores: chamadorEntriesPayload,
        cozinha_valor: kitchenPaid || 0,
      };

      await apiClient.saveFinanceiroSnapshot(restaurantId, payload);
      setSnapshotMessage('Snapshot salvo com sucesso.');
      setTimeout(() => setSnapshotMessage(''), 3000);
    } catch (err) {
      setSnapshotMessage('Erro ao salvar snapshot.');
      setTimeout(() => setSnapshotMessage(''), 3000);
    } finally {
      setSnapshotLoading(false);
    }
  };

  const calculations = useMemo(() => {
    const basePercentNumber = typeof percentualBase === 'number'
      ? percentualBase
      : parseFloat(String(percentualBase)) || 0;
    const gestorPerc = parseFloat(String(gestorPercentual)) || 0;
    const supervisorPerc = parseFloat(String(supervisorPercentual)) || 0;

    const rows = funcionarios.map((func) => {
      const entry = gorjetaInputs[func.funcID] || { valor: '', direta: '' };
      return {
        funcionario: func,
        tipValue: parseFloat(entry.valor) || 0,
        directValue: parseFloat(entry.direta) || 0,
      };
    });

    const staffRows = rows.filter((row) => isStaffRole(row.funcionario.funcao));
    const chamadorRows = funcionarios
      .filter((f) => normalizeRole(f.funcao) === 'chamador')
      .map((f) => ({
        funcionario: f,
        valor: parseFloat(chamadorInputs[f.funcID]?.valor || '0') || 0,
      }));
    const gestorRows = funcionarios.filter((f) => isGestorRole(f.funcao));
    const supervisorRows = funcionarios.filter((f) => isSupervisorRole(f.funcao));

    const tipPool = staffRows.reduce((sum, row) => sum + row.tipValue, 0);
    const directTotal = staffRows.reduce((sum, row) => sum + row.directValue, 0);
    const totalTips = tipPool;
    const chamadorTotal = chamadorRows.reduce((sum, row) => sum + row.valor, 0);

    const faturamentoNumber = parseFloat(faturamentoGlobal) || 0;
    const safeBasePercent = basePercentNumber > 0 ? basePercentNumber : 1;
    const faturamentoComGorjeta = basePercentNumber > 0 ? tipPool / (safeBasePercent / 100) : 0;
    const faturamentoSemGorjeta = Math.max(faturamentoNumber - totalTips, 0);
    const difference = faturamentoNumber - faturamentoComGorjeta;

    const configMap = new Map<string, number>();
    configuracoes.forEach((c) => {
      configMap.set(normalizeRole(c.funcao), parseFloat(String(c.percentagem)) || 0);
    });

    const roleGroups: Record<string, { employees: typeof staffRows; tipSum: number }> = {};
    staffRows.forEach((row) => {
      const roleKey = normalizeRole(row.funcionario.funcao || 'sem-funcao');
      if (!roleGroups[roleKey]) {
        roleGroups[roleKey] = { employees: [], tipSum: 0 };
      }
      roleGroups[roleKey].employees.push(row);
      roleGroups[roleKey].tipSum += row.tipValue;
    });

    const staffRoles = Object.keys(roleGroups).filter((role) => isStaffRole(role));
    const staffPercentTotal = staffRoles.reduce(
      (sum, role) => sum + (configMap.get(role) || 0),
      0,
    );

    const staffPoolPayoutRaw = basePercentNumber > 0
      ? tipPool * (staffPercentTotal / safeBasePercent)
      : 0;
    const staffPoolPayout = Math.min(staffPoolPayoutRaw, tipPool);

    const employeeTotals: Record<number, EmployeeTotals> = {};
    staffRows.forEach((row) => {
      employeeTotals[row.funcionario.funcID] = {
        poolShare: 0,
        directTip: row.directValue,
        managerShare: 0,
        kitchenShare: 0,
        total: row.directValue,
      };
    });

    staffRoles.forEach((role) => {
      const rolePercent = configMap.get(role) || 0;
      const rolePot = basePercentNumber > 0 ? tipPool * (rolePercent / safeBasePercent) : 0;
      const group = roleGroups[role];
      const weightBase = group.tipSum > 0 ? group.tipSum : group.employees.length || 1;

      group.employees.forEach((empRow) => {
        const numerator = group.tipSum > 0 ? empRow.tipValue : 1;
        const weight = weightBase > 0 ? numerator / weightBase : 0;
        const portion = rolePot * weight;
        const entry = employeeTotals[empRow.funcionario.funcID];
        entry.poolShare += portion;
        entry.total += portion;
      });
    });

    const gestorCount = gestorRows.length;
    const supervisorCount = supervisorRows.length;

    const availableForManagers = Math.max(tipPool - staffPoolPayout, 0);
    const gestorDesired = faturamentoSemGorjeta * (gestorPerc / 100) * gestorCount;
    const supervisorDesired = faturamentoSemGorjeta * (supervisorPerc / 100) * supervisorCount;
    const managerDesiredTotal = gestorDesired + supervisorDesired;
    const managerPaidTotal = managerDesiredTotal > 0
      ? Math.min(managerDesiredTotal, availableForManagers)
      : 0;
    const managerScale = managerDesiredTotal > 0 ? managerPaidTotal / managerDesiredTotal : 0;
    const gestorPaid = gestorDesired * managerScale;
    const supervisorPaid = supervisorDesired * managerScale;
    const remainingForKitchen = Math.max(availableForManagers - managerPaidTotal, 0);

    const staffTotalWithDirect = funcionarios
      .filter((f) => {
        const role = normalizeRole(f.funcao);
        return !isManagerRole(role) && !isKitchenRole(role);
      })
      .reduce((sum, f) => sum + (employeeTotals[f.funcID]?.total || 0), 0);

    const staffDirectTotal = funcionarios
      .filter((f) => {
        const role = normalizeRole(f.funcao);
        return !isManagerRole(role) && !isKitchenRole(role);
      })
      .reduce((sum, f) => sum + (employeeTotals[f.funcID]?.directTip || 0), 0);

    const splitWeights = (
      items: Funcionario[],
      defaults: Record<number, ManagerEntry>,
    ) => {
      const parsed = items.map((f) => ({
        funcID: f.funcID,
        weight: parseFloat(defaults[f.funcID]?.percentual || '0') || 0,
        funcionario: f,
      }));
      const totalWeight = parsed.reduce((sum, p) => sum + p.weight, 0);
      if (totalWeight > 0) {
        return parsed.map((p) => ({ ...p, weight: p.weight / totalWeight }));
      }
      if (parsed.length === 0) return [];
      const equal = 1 / parsed.length;
      return parsed.map((p) => ({ ...p, weight: equal }));
    };

    const gestorSplits = splitWeights(gestorRows, managerSplitInputs);
    const supervisorSplits = splitWeights(supervisorRows, managerSplitInputs);

    const gestorPerEmployee = gestorSplits.map((item) => ({
      funcionario: item.funcionario,
      teorico: gestorDesired * item.weight,
      real: gestorPaid * item.weight,
    }));

    const supervisorPerEmployee = supervisorSplits.map((item) => ({
      funcionario: item.funcionario,
      teorico: supervisorDesired * item.weight,
      real: supervisorPaid * item.weight,
    }));

    const distributedTotal =
      staffTotalWithDirect + managerPaidTotal + remainingForKitchen;
    const distributedFromPool =
      staffPoolPayout + managerPaidTotal + remainingForKitchen;

    return {
      basePercentNumber,
      tipPool,
      directTotal,
      totalTips,
      faturamentoNumber,
      faturamentoComGorjeta,
      faturamentoSemGorjeta,
      difference,
      staffPercentTotal,
      staffPoolPayout,
      gestorDesired,
      supervisorDesired,
      gestorPaid,
      supervisorPaid,
      managerPaidTotal,
      kitchenPaid: remainingForKitchen,
      employeeTotals,
      distributedTotal,
      distributedFromPool,
      staffTotalWithDirect,
      staffDirectTotal,
      chamadorTotal,
      gestorPerEmployee,
      supervisorPerEmployee,
    };
  }, [
    configuracoes,
    faturamentoGlobal,
    funcionarios,
    gorjetaInputs,
    percentualBase,
    chamadorInputs,
    gestorPercentual,
    supervisorPercentual,
  ]);

  const {
    basePercentNumber,
    tipPool,
    directTotal,
    totalTips,
    faturamentoNumber,
    faturamentoComGorjeta,
    faturamentoSemGorjeta,
    difference,
    staffPercentTotal,
    staffPoolPayout,
    gestorDesired,
    supervisorDesired,
    gestorPaid,
    supervisorPaid,
    managerPaidTotal,
    kitchenPaid,
    employeeTotals,
    distributedTotal,
    distributedFromPool,
    staffTotalWithDirect,
    staffDirectTotal,
    chamadorTotal,
    gestorPerEmployee,
    supervisorPerEmployee,
  } = calculations;

  const percentLabel = (funcao: string, configured?: number | null) => {
    if (isManagerRole(funcao) || isKitchenRole(funcao)) {
      return 'Fora do pool de gorjetas';
    }
    return configured !== undefined && configured !== null && !Number.isNaN(configured)
      ? `${configured}% de ${basePercentNumber}%`
      : '—';
  };
  const poolAfterStaff = Math.max(tipPool - staffPoolPayout, 0);
  const poolNotAllocated = Math.max(tipPool - distributedFromPool, 0);

  const loadSnapshot = async () => {
    if (!restaurantId || !selectedDate || funcionarios.length === 0) return;
    // Build defaults based on current employees to avoid stale values when switching datas
    const defaultStaffState: Record<number, GorjetaEntry> = {};
    const defaultManagerState: Record<number, ManagerEntry> = {};
    const defaultChamadorState: Record<number, ChamadorEntry> = {};

    funcionarios.forEach((f) => {
      const role = normalizeRole(f.funcao);
      if (isStaffRole(role)) {
        defaultStaffState[f.funcID] = { valor: '', direta: '' };
      }
      if (isGestorRole(role) || isSupervisorRole(role)) {
        defaultManagerState[f.funcID] = { percentual: '' };
      }
      if (role === 'chamador') {
        defaultChamadorState[f.funcID] = { valor: '' };
      }
    });

    setGorjetaInputs(defaultStaffState);
    setManagerSplitInputs(defaultManagerState);
    setChamadorInputs(defaultChamadorState);
    setFaturamentoGlobal('');

    try {
      setSnapshotLoading(true);
      setSnapshotLoaded(false);
      let data: any | null = null;
      try {
        const res = await apiClient.getFinanceiroSnapshot(restaurantId, selectedDate);
        data = res.data;
      } catch (err: any) {
        // fallback: try range endpoint in case the single-day endpoint returns 404
        try {
          const rangeRes = await apiClient.getFinanceiroSnapshotRange(
            restaurantId,
            selectedDate,
            selectedDate,
          );
          data = Array.isArray(rangeRes.data) ? rangeRes.data[0] : null;
        } catch {
          // keep data as null and handle below
        }
        if (!data) {
          throw err;
        }
      }

      if (!data) {
        setSnapshotMessage('Nenhum dado salvo para este dia ainda.');
        setTimeout(() => setSnapshotMessage(''), 3000);
        return;
      }

      if (data.faturamento_inserido !== null && data.faturamento_inserido !== undefined) {
        setFaturamentoGlobal(String(data.faturamento_inserido));
      }

      const staffEntries = data.entries?.filter((e: any) => e.role === 'staff') || [];
      const gorjetaState: Record<number, GorjetaEntry> = { ...defaultStaffState };
      staffEntries.forEach((e: any) => {
        if (e.funcID) {
          gorjetaState[e.funcID] = {
            valor: (e.valor_pool || 0).toString(),
            direta: (e.valor_direto || 0).toString(),
          };
        }
      });
      setGorjetaInputs(gorjetaState);

      const gestorEntries = data.entries?.filter((e: any) => e.role === 'gestor') || [];
      const supervisorEntries = data.entries?.filter((e: any) => e.role === 'supervisor') || [];

      const managerState: Record<number, ManagerEntry> = { ...defaultManagerState };
      gestorEntries.forEach((e: any) => {
        managerState[e.funcID] = {
          percentual: managerSplitInputs[e.funcID]?.percentual || '',
        };
      });
      supervisorEntries.forEach((e: any) => {
        if (!managerState[e.funcID]) {
          managerState[e.funcID] = { percentual: managerSplitInputs[e.funcID]?.percentual || '' };
        }
      });
      setManagerSplitInputs(managerState);

      const chamadorEntries = data.entries?.filter((e: any) => e.role === 'chamador') || [];
      const chamadorState: Record<number, ChamadorEntry> = { ...defaultChamadorState };
      chamadorEntries.forEach((e: any) => {
        if (e.funcID) {
          chamadorState[e.funcID] = { valor: (e.valor_pago || 0).toString() };
        }
      });
      setChamadorInputs(chamadorState);
      setSnapshotLoaded(true);
      setSnapshotMessage('Dados salvos carregados. Edite e salve novamente.');
      setTimeout(() => setSnapshotMessage(''), 3000);
    } catch (err) {
      // ignore load errors to avoid blocking UI, keep defaults
      setSnapshotMessage('Não foi possível carregar os dados salvos. Tente novamente.');
      setTimeout(() => setSnapshotMessage(''), 4000);
    } finally {
      setSnapshotLoading(false);
    }
  };

  useEffect(() => {
    loadSnapshot();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [restaurantId, selectedDate, funcionarios]);

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Fechamento diário</p>
            <h1>Financeiro Diário</h1>
            <p className={styles.subtitle}>
              Selecione o dia, informe o faturamento global e as gorjetas por funcionário. O
              sistema calcula o faturamento com gorjeta e distribui automaticamente entre staff,
              gestão e cozinha.
            </p>
          </div>

          <div className={styles.filters}>
            <div className={styles.selectGroup}>
              <label>Restaurante</label>
              <select
                value={restaurantId || ''}
                onChange={(e) => setRestaurantId(parseInt(e.target.value, 10) || null)}
              >
                <option value="">Selecione</option>
                {restaurantes.map((rest) => (
                  <option key={rest.restID} value={rest.restID}>
                    {rest.name}
                  </option>
                ))}
              </select>
            </div>

            <div className={styles.selectGroup}>
              <label>Dia</label>
              <input
                type="date"
                value={selectedDate}
                onChange={(e) => setSelectedDate(e.target.value)}
              />
            </div>

            <div className={styles.selectGroup}>
              <label>&nbsp;</label>
              <button
                type="button"
                className={styles.btnPrimary}
                onClick={handleSalvarFinanceiro}
                disabled={snapshotLoading || !restaurantId}
              >
                {snapshotLoading ? 'Salvando...' : 'Salvar dia'}
              </button>
            </div>
            <div className={styles.selectGroup}>
              <label>&nbsp;</label>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={loadSnapshot}
                disabled={snapshotLoading || !restaurantId}
              >
                {snapshotLoading ? 'Carregando...' : 'Carregar dados salvos'}
              </button>
              {snapshotLoaded && (
                <span className={styles.metaText}>Modo edição: dados carregados</span>
              )}
            </div>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {snapshotMessage && <div className={styles.info}>{snapshotMessage}</div>}
        {snapshotLoading && <div className={styles.info}>Carregando / salvando snapshot...</div>}
        {loading && <div className={styles.info}>Carregando dados do restaurante...</div>}

      <div className={styles.summaryGrid}>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Faturamento Global</span>
          <strong className={styles.summaryValue}>{currency(faturamentoNumber)}</strong>
        </div>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Total de Gorjetas (pool)</span>
          <strong className={styles.summaryValue}>{currency(totalTips)}</strong>
          <span className={styles.summaryMeta}>
            Pool: {currency(tipPool)} · Diretas pagas à parte: {currency(directTotal)}
          </span>
        </div>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Faturamento c/ gorjetas</span>
          <strong className={styles.summaryValue}>{currency(faturamentoComGorjeta)}</strong>
          <span className={styles.summaryMeta}>Base {basePercentNumber || 0}%</span>
        </div>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Diferença Global - c/ Gorjeta</span>
          <strong
            className={`${styles.summaryValue} ${
              difference < 0 ? styles.negative : styles.positive
            }`}
          >
            {currency(difference)}
          </strong>
        </div>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Faturamento s/ gorjeta</span>
          <strong className={styles.summaryValue}>{currency(faturamentoSemGorjeta)}</strong>
        </div>
      </div>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Entradas do dia</h2>
              <p>Inclua faturamento global e as gorjetas por funcionário.</p>
            </div>
            <span className={styles.chip}>Cálculo automático</span>
          </div>

          <div className={styles.inputRow}>
            <div className={styles.inputGroup}>
              <label>Faturamento Global (€)</label>
              <input
                type="number"
                step="0.01"
                value={faturamentoGlobal}
                onChange={(e) => setFaturamentoGlobal(e.target.value)}
                placeholder="0.00"
              />
            </div>
            <div className={styles.inputGroup}>
              <label>Percentual base da gorjeta (%)</label>
              <input
                type="number"
                step="0.1"
                value={percentualBase}
                onChange={(e) => setPercentualBase(parseFloat(e.target.value) || 0)}
              />
            </div>
            <div className={styles.inputGroup}>
              <label>Gorjetas registadas (pool)</label>
              <div className={styles.readonlyBox}>{currency(totalTips)}</div>
              <span className={styles.inlineMeta}>Apenas o pool; diretas são pagas separadamente</span>
            </div>
          </div>

          <div className={styles.tableWrapper}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Funcionário</th>
                  <th>Função</th>
                  <th>Gorjeta (pool €)</th>
                  <th>Gorjeta direta (€)</th>
                  <th>Percentual</th>
                  <th>Previsto a receber (€)</th>
                </tr>
              </thead>
              <tbody>
                {funcionarios.filter((f) => isStaffRole(f.funcao)).length === 0 && (
                  <tr>
                    <td colSpan={6} className={styles.emptyCell}>
                      Nenhum staff ativo para este restaurante.
                    </td>
                  </tr>
                )}
                {funcionarios
                  .filter((func) => isStaffRole(func.funcao))
                  .map((func) => {
                  const entry = gorjetaInputs[func.funcID] || { valor: '', direta: '' };
                  const configPercent = configuracoes.find(
                    (c) => normalizeRole(c.funcao) === normalizeRole(func.funcao),
                  )?.percentagem;
                  const totalForEmployee = employeeTotals[func.funcID]?.total || 0;

                  return (
                    <tr key={func.funcID}>
                      <td>
                        <div className={styles.nameCell}>
                          <span className={styles.avatar}>{func.name.slice(0, 1).toUpperCase()}</span>
                          <div>
                            <div className={styles.name}>{func.name}</div>
                            <div className={styles.metaText}>ID #{func.funcID}</div>
                          </div>
                        </div>
                      </td>
                      <td className={styles.muted}>{displayRole(func.funcao)}</td>
                      <td>
                        <input
                          type="number"
                          step="0.01"
                          value={entry.valor}
                          onChange={(e) => handleGorjetaChange(func.funcID, 'valor', e.target.value)}
                          className={styles.smallInput}
                          placeholder="0.00"
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          step="0.01"
                          value={entry.direta}
                          onChange={(e) => handleGorjetaChange(func.funcID, 'direta', e.target.value)}
                          className={styles.smallInput}
                          placeholder="0.00"
                        />
                      </td>
                      <td className={styles.muted}>{percentLabel(func.funcao, configPercent)}</td>
                      <td className={styles.highlight}>{currency(totalForEmployee)}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className={styles.tableWrapper} style={{ marginTop: '16px' }}>
            <h3 style={{ marginBottom: '8px' }}>Chamadores (valor fixo do faturamento global)</h3>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Funcionário</th>
                  <th>Função</th>
                  <th>Valor absoluto (€)</th>
                </tr>
              </thead>
              <tbody>
                {funcionarios.filter((f) => normalizeRole(f.funcao) === 'chamador').length === 0 && (
                  <tr>
                    <td colSpan={3} className={styles.emptyCell}>
                      Nenhum chamador configurado para este restaurante.
                    </td>
                  </tr>
                )}
                {funcionarios
                  .filter((func) => normalizeRole(func.funcao) === 'chamador')
                  .map((func) => {
                    const entry = chamadorInputs[func.funcID] || { valor: '' };
                    return (
                      <tr key={func.funcID}>
                        <td>
                          <div className={styles.nameCell}>
                            <span className={styles.avatar}>{func.name.slice(0, 1).toUpperCase()}</span>
                            <div>
                              <div className={styles.name}>{func.name}</div>
                              <div className={styles.metaText}>ID #{func.funcID}</div>
                            </div>
                          </div>
                        </td>
                        <td className={styles.muted}>{displayRole(func.funcao)}</td>
                        <td>
                          <input
                            type="number"
                            step="0.01"
                            value={entry.valor}
                            onChange={(e) => handleChamadorChange(func.funcID, e.target.value)}
                            className={styles.smallInput}
                            placeholder="0.00"
                          />
                        </td>
                      </tr>
                    );
                })}
              </tbody>
            </table>
          </div>

          <div className={styles.tableWrapper} style={{ marginTop: '16px' }}>
            <h3 style={{ marginBottom: '8px' }}>Gestores</h3>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Funcionário</th>
                  <th>% da parcela do gestor</th>
                  <th>Teórico (€)</th>
                  <th>Pago (€)</th>
                </tr>
              </thead>
              <tbody>
                {gestorPerEmployee.length === 0 && (
                  <tr>
                    <td colSpan={4} className={styles.emptyCell}>
                      Nenhum gestor configurado para este restaurante.
                    </td>
                  </tr>
                )}
                {gestorPerEmployee.map((item) => {
                  const entry = managerSplitInputs[item.funcionario.funcID] || { percentual: '' };
                  return (
                    <tr key={item.funcionario.funcID}>
                      <td>
                        <div className={styles.nameCell}>
                          <span className={styles.avatar}>{item.funcionario.name.slice(0, 1).toUpperCase()}</span>
                          <div>
                            <div className={styles.name}>{item.funcionario.name}</div>
                            <div className={styles.metaText}>ID #{item.funcionario.funcID}</div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <input
                          type="number"
                          step="0.1"
                          value={entry.percentual}
                          onChange={(e) => handleManagerPercentChange(item.funcionario.funcID, e.target.value)}
                          className={styles.smallInput}
                          placeholder="0.0"
                        />
                        <div className={styles.inlineMeta}>Divide a parcela do gestor</div>
                      </td>
                      <td className={styles.muted}>{currency(item.teorico)}</td>
                      <td className={styles.highlight}>{currency(item.real)}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          <div className={styles.tableWrapper} style={{ marginTop: '16px' }}>
            <h3 style={{ marginBottom: '8px' }}>Supervisores</h3>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Funcionário</th>
                  <th>% da parcela do supervisor</th>
                  <th>Teórico (€)</th>
                  <th>Pago (€)</th>
                </tr>
              </thead>
              <tbody>
                {supervisorPerEmployee.length === 0 && (
                  <tr>
                    <td colSpan={4} className={styles.emptyCell}>
                      Nenhum supervisor configurado para este restaurante.
                    </td>
                  </tr>
                )}
                {supervisorPerEmployee.map((item) => {
                  const entry = managerSplitInputs[item.funcionario.funcID] || { percentual: '' };
                  return (
                    <tr key={item.funcionario.funcID}>
                      <td>
                        <div className={styles.nameCell}>
                          <span className={styles.avatar}>{item.funcionario.name.slice(0, 1).toUpperCase()}</span>
                          <div>
                            <div className={styles.name}>{item.funcionario.name}</div>
                            <div className={styles.metaText}>ID #{item.funcionario.funcID}</div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <input
                          type="number"
                          step="0.1"
                          value={entry.percentual}
                          onChange={(e) => handleManagerPercentChange(item.funcionario.funcID, e.target.value)}
                          className={styles.smallInput}
                          placeholder="0.0"
                        />
                        <div className={styles.inlineMeta}>Divide a parcela do supervisor</div>
                      </td>
                      <td className={styles.muted}>{currency(item.teorico)}</td>
                      <td className={styles.highlight}>{currency(item.real)}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </section>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Distribuição das gorjetas</h2>
              <p>
                Apenas o staff (antigo garçom) recebe gorjetas do pool inicialmente. Gestor e
                supervisor recebem percentuais do faturamento sem gorjeta, mas só até o saldo do
                pool após pagar o staff. O que sobra vai para a cozinha.
              </p>
            </div>
          </div>

          <div className={styles.distributionGrid}>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Staff</div>
              <div className={styles.distributionValue}>{currency(staffTotalWithDirect)}</div>
              <div className={styles.distributionMeta}>
                Configurado: {staffPercentTotal}% de {basePercentNumber}% · Pool pago:{' '}
                {currency(staffPoolPayout)}
              </div>
              <div className={styles.distributionMeta}>
                Gorjetas diretas do staff: {currency(staffDirectTotal)}
              </div>
            </div>

            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Gestor</div>
              <div className={styles.inlineField}>
                <label>% por gestor s/ faturamento s/ gorjeta</label>
                <input
                  type="number"
                  step="0.1"
                  value={gestorPercentual}
                  onChange={(e) => setGestorPercentual(parseFloat(e.target.value) || 0)}
                />
              </div>
              <div className={styles.distributionValue}>{currency(gestorPaid)}</div>
              <div className={styles.distributionMeta}>
                Teórico: {currency(gestorDesired)} · Pago (limite pelo pool): {currency(gestorPaid)}
              </div>
            </div>

            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Supervisor</div>
              <div className={styles.inlineField}>
                <label>% por supervisor s/ faturamento s/ gorjeta</label>
                <input
                  type="number"
                  step="0.1"
                  value={supervisorPercentual}
                  onChange={(e) => setSupervisorPercentual(parseFloat(e.target.value) || 0)}
                />
              </div>
              <div className={styles.distributionValue}>{currency(supervisorPaid)}</div>
              <div className={styles.distributionMeta}>
                Teórico: {currency(supervisorDesired)} · Pago (limite pelo pool): {currency(supervisorPaid)}
              </div>
            </div>

            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Cozinha</div>
              <div className={styles.distributionValue}>{currency(kitchenPaid)}</div>
              <div className={styles.distributionMeta}>
                Recebe o que sobra do pool após staff, gestor e supervisor.
              </div>
            </div>

            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Pool não distribuído</div>
              <div className={styles.distributionValue}>
                {currency(poolNotAllocated)}
              </div>
              <div className={styles.distributionMeta}>
                Vem apenas das gorjetas do dia. Não inclui valores diretos.
              </div>
            </div>

            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Chamadores (faturamento global)</div>
              <div className={styles.distributionValue}>{currency(chamadorTotal)}</div>
              <div className={styles.distributionMeta}>
                Valores absolutos definidos por funcionário. Fora do pool de gorjetas.
              </div>
            </div>
          </div>

          <div className={styles.notice}>
            <div>
              <strong>Saldo do pool após staff:</strong> {currency(poolAfterStaff)}
              {' · '}
              <strong>Gestor + Supervisor (real):</strong> {currency(managerPaidTotal)}
              {' · '}
              <strong>Cozinha (real):</strong> {currency(kitchenPaid)}
              {' · '}
              <strong>Pool não distribuído:</strong> {currency(poolNotAllocated)}
            </div>
          </div>
        </section>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Resumo operacional</h2>
              <p>Use estes números para validar o fechamento do dia.</p>
            </div>
          </div>
          <div className={styles.summaryGridSmall}>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Total distribuído</span>
              <strong className={styles.summaryValue}>{currency(distributedTotal)}</strong>
              <span className={styles.summaryMeta}>
                Pool distribuído: {currency(distributedFromPool)} · Diretas pagas: {currency(directTotal)}
              </span>
            </div>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Pago ao staff</span>
              <strong className={styles.summaryValue}>{currency(staffTotalWithDirect)}</strong>
              <span className={styles.summaryMeta}>
                Saldo remanescente do pool: {currency(poolNotAllocated)}
              </span>
            </div>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Gestão (gestor + supervisor)</span>
              <strong className={styles.summaryValue}>{currency(managerPaidTotal)}</strong>
              <span className={styles.summaryMeta}>
                Teórico: {currency(gestorDesired + supervisorDesired)} · Pago limitado ao pool
              </span>
            </div>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Chamadores (faturamento global)</span>
              <strong className={styles.summaryValue}>{currency(chamadorTotal)}</strong>
              <span className={styles.summaryMeta}>
                Não faz parte do pool de gorjetas
              </span>
            </div>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Cozinha</span>
              <strong className={styles.summaryValue}>{currency(kitchenPaid)}</strong>
              <span className={styles.summaryMeta}>Recebe o restante do pool após gestão</span>
            </div>
          </div>
        </section>
      </div>
    </Layout>
  );
}
