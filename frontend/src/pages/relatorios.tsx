'use client';

import { useState, useEffect, useMemo } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';
import { useSessionPageState } from '../hooks/useSessionPageState';

interface FuncionarioReport {
  funcID: number;
  name: string;
  total_gorjeta: number;
  breakdown: Record<string, number>;
  count_transacoes: number;
  total_mbway: number;
}

interface ResumoReport {
  total_gorjeta: number;
  count_transacoes: number;
  breakdown_by_type: Record<string, number>;
}

interface FaturamentoReport {
  base_percentage: number;
  total_gorjeta: number;
  total_faturamento: number;
  count_transacoes: number;
}

interface SnapshotEntry {
  funcID: number | null;
  role: string;
  employee_name?: string | null;
  employee_funcao?: string | null;
  valor_pool: number;
  valor_direto: number;
  valor_teorico: number;
  valor_pago: number;
  valor_nao_pago?: number;
}

interface SnapshotPresencaEntry {
  funcID: number;
  presente: boolean;
}

interface SnapshotDay {
  data: string;
  faturamento_inserido: number | null;
  presencas?: SnapshotPresencaEntry[];
  entries: SnapshotEntry[];
}

interface Restaurante {
  restID: number;
  name: string;
  percentagem_gorjeta_base: number;
}

interface FuncionarioInfo {
  name: string;
  funcao: string;
}

interface RegraDistribuicao {
  role_name: string;
  tipo_de_acerto?: 'DIARIO' | 'PERIODO';
  ordem: number;
  ativo?: boolean;
}

type SettlementModeSummary = 'DIARIO' | 'PERIODO' | 'MISTO';

interface BucketConfig {
  bucket: string;
  settlementMode: SettlementModeSummary;
  dailyShare: number;
}

interface GroupedEmployeeRow {
  funcID: number;
  bucket: string;
  settlementMode: SettlementModeSummary;
  name: string;
  diasTrabalhados: number;
  efetivo: number;
  teorico: number;
  naoPago: number;
  pagoBruto: number;
  direto: number;
  jaRecebidoDiario: number;
  aReceberPeriodo: number;
}

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];
const round2 = (value: number) => Math.round(value * 100) / 100;
const normalizeRole = (funcao: string) =>
  (funcao || '')
    .toLowerCase()
    .trim()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');
const toRoleBucket = (roleName: string) => {
  const role = normalizeRole(roleName);
  if (role === 'staff' || role.includes('garcom')) return 'staff';
  if (role.includes('gestor') || role.includes('gerente')) return 'gerente';
  if (role.includes('supervisor')) return 'supervisor';
  if (role.includes('cozinha')) return 'cozinha';
  if (role === 'bar' || role.includes('bar')) return 'bar';
  if (role.includes('chamador')) return 'chamador';
  return role || 'outros';
};

const toNumberSafe = (value: any): number => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
};

const getEffectiveSnapshotValue = (entry: SnapshotEntry) => {
  const bucket = toRoleBucket(entry.employee_funcao || entry.role);
  const paid = round2(Math.max(toNumberSafe(entry.valor_pago), 0));
  const direct = round2(Math.max(toNumberSafe(entry.valor_direto), 0));

  if (bucket === 'staff') return round2(paid + direct);
  if (bucket === 'chamador') return round2(direct > 0 ? direct : paid);
  return paid;
};

export default function Relatorios() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restID, setRestID] = useSessionPageState<number | null>('restID', null);
  const [funcionarios, setFuncionarios] = useState<Record<number, FuncionarioInfo>>({});
  const [regras, setRegras] = useState<RegraDistribuicao[]>([]);
  const [orderedRuleBuckets, setOrderedRuleBuckets] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [fromDate, setFromDate] = useSessionPageState<string>('fromDate', '');
  const [toDate, setToDate] = useSessionPageState<string>('toDate', '');
  const [snapshots, setSnapshots] = useState<SnapshotDay[]>([]);

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) { router.replace('/login'); return; }
        const res = await apiClient.me();
        const role: string = res.data?.role || '';
        if (!ALLOWED_ROLES.includes(role)) { router.replace('/'); return; }
        setAuthorized(true);
        loadRestaurant();
      } catch {
        router.replace('/login');
      }
    };
    checkAuth();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (!restID) return;
    fetchFuncionarios();
    fetchRegrasDistribuicao();
  }, [restID]);

  useEffect(() => {
    if (!restID) return;
    fetchSnapshots();
  }, [restID, fromDate, toDate]);

  const loadRestaurant = async () => {
    try {
      const response = await apiClient.getRestaurantes(true);
      if (response.data && response.data.length > 0) {
        setRestaurantes(response.data);
        const hasPersistedRestaurant =
          restID != null &&
          response.data.some((rest: Restaurante) => rest.restID === restID);
        setRestID(hasPersistedRestaurant ? restID : response.data[0].restID);
      } else {
        setError('Nenhum restaurante ativo encontrado.');
      }
    } catch (err) {
      setError('Erro ao carregar restaurantes');
      console.error(err);
    }
  };

  const fetchFuncionarios = async () => {
    if (!restID) return;
    try {
      const res = await apiClient.getFuncionarios(restID, true);
      const map: Record<number, FuncionarioInfo> = {};
      res.data?.forEach((f: any) => {
        map[f.funcID] = {
          name: f.name,
          funcao: f.funcao,
        };
      });
      setFuncionarios(map);
    } catch (err) {
      // ignore for now
    }
  };

  const fetchRegrasDistribuicao = async () => {
    if (!restID) return;
    try {
      const res = await apiClient.getRegrasDistribuicao(restID);
      const regras = ((res.data || []) as RegraDistribuicao[]).filter(
        (regra) => regra.ativo !== false,
      );
      setRegras(regras);
      const buckets: string[] = [];
      regras.forEach((regra) => {
        const bucket = toRoleBucket(regra.role_name);
        if (!buckets.includes(bucket)) buckets.push(bucket);
      });
      setOrderedRuleBuckets(buckets);
    } catch {
      setRegras([]);
      setOrderedRuleBuckets([]);
    }
  };

  const bucketTitle = (bucket: string) => {
    if (bucket === 'supervisor') return 'Gestores';
    if (bucket === 'chamador') return 'Chamadores';
    if (bucket === 'gerente') return 'Gerentes';
    if (bucket === 'staff') return 'Staff';
    if (bucket === 'cozinha') return 'Cozinha';
    if (bucket === 'bar') return 'Bar';
    return bucket
      .split('_')
      .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
      .join(' ');
  };

  const defaultBucketOrder = [
    'supervisor',
    'chamador',
    'gerente',
    'staff',
    'cozinha',
    'bar',
  ];

  const bucketConfigs = useMemo(() => {
    const orderedRules = [...regras].sort((a, b) => a.ordem - b.ordem);
    const grouped = new Map<string, RegraDistribuicao[]>();

    orderedRules.forEach((rule) => {
      const bucket = toRoleBucket(rule.role_name);
      if (!grouped.has(bucket)) grouped.set(bucket, []);
      grouped.get(bucket)!.push(rule);
    });

    const configByBucket = new Map<string, BucketConfig>();

    grouped.forEach((rulesInBucket, bucket) => {
      const dailyRules = rulesInBucket.filter(
        (rule) => (rule.tipo_de_acerto || 'DIARIO') !== 'PERIODO',
      ).length;
      const periodRules = rulesInBucket.length - dailyRules;
      const totalRules = rulesInBucket.length;

      const dailyShare = totalRules > 0 ? round2(dailyRules / totalRules) : 1;

      let settlementMode: SettlementModeSummary = 'DIARIO';
      if (dailyRules > 0 && periodRules > 0) settlementMode = 'MISTO';
      else if (periodRules > 0) settlementMode = 'PERIODO';

      configByBucket.set(bucket, {
        bucket,
        settlementMode,
        dailyShare,
      });
    });

    return configByBucket;
  }, [regras]);

  const groupedEmployeeReport = useMemo(() => {
    if (snapshots.length === 0) return [];

    const agg: Record<number, GroupedEmployeeRow> = {};
    const daysByEmployee = new Map<number, Set<string>>();

    snapshots.forEach((day) => {
      (day.presencas || []).forEach((presenca) => {
        if (!presenca.presente) return;
        if (!daysByEmployee.has(presenca.funcID)) {
          daysByEmployee.set(presenca.funcID, new Set<string>());
        }
        daysByEmployee.get(presenca.funcID)!.add(day.data);
      });
    });

    snapshots.forEach((day) => {
      day.entries.forEach((e) => {
        if (e.funcID == null) return;
        const employeeFromMap = funcionarios[e.funcID];
        const bucket = employeeFromMap?.funcao
          ? toRoleBucket(employeeFromMap.funcao)
          : toRoleBucket(e.employee_funcao || e.role);
        const config = bucketConfigs.get(bucket);
        const name = employeeFromMap?.name || e.employee_name || `Func ${e.funcID}`;

        if (!agg[e.funcID]) {
          agg[e.funcID] = {
            funcID: e.funcID,
            bucket,
            settlementMode: config?.settlementMode || 'DIARIO',
            efetivo: 0,
            pagoBruto: 0,
            direto: 0,
            teorico: 0,
            naoPago: 0,
            jaRecebidoDiario: 0,
            aReceberPeriodo: 0,
            diasTrabalhados: 0,
            name,
          };
        }
        agg[e.funcID].bucket = bucket;
        agg[e.funcID].settlementMode = config?.settlementMode || agg[e.funcID].settlementMode;
        agg[e.funcID].name = name;
        agg[e.funcID].efetivo = round2(
          agg[e.funcID].efetivo + getEffectiveSnapshotValue(e),
        );
        agg[e.funcID].pagoBruto = round2(
          agg[e.funcID].pagoBruto + toNumberSafe(e.valor_pago),
        );
        agg[e.funcID].direto = round2(
          agg[e.funcID].direto + toNumberSafe(e.valor_direto),
        );
        agg[e.funcID].teorico = round2(
          agg[e.funcID].teorico + toNumberSafe(e.valor_teorico),
        );
        agg[e.funcID].naoPago = round2(
          agg[e.funcID].naoPago + toNumberSafe(e.valor_nao_pago),
        );
      });
    });

    Object.entries(agg).forEach(([funcID, row]) => {
      row.diasTrabalhados = daysByEmployee.get(Number(funcID))?.size || 0;
      const config = bucketConfigs.get(row.bucket);
      const dailyShare = config?.dailyShare ?? 1;
      row.settlementMode = config?.settlementMode || row.settlementMode;
      row.jaRecebidoDiario =
        row.settlementMode === 'PERIODO'
          ? 0
          : round2(row.efetivo * dailyShare);
      row.aReceberPeriodo = round2(Math.max(row.efetivo - row.jaRecebidoDiario, 0));
    });

    Object.entries(funcionarios).forEach(([funcIDRaw, employee]) => {
      const funcID = Number(funcIDRaw);
      if (!agg[funcID]) {
        const bucket = toRoleBucket(employee.funcao);
        const config = bucketConfigs.get(bucket);
        agg[funcID] = {
          funcID,
          bucket,
          settlementMode: config?.settlementMode || 'DIARIO',
          efetivo: 0,
          pagoBruto: 0,
          direto: 0,
          teorico: 0,
          naoPago: 0,
          jaRecebidoDiario: 0,
          aReceberPeriodo: 0,
          diasTrabalhados: daysByEmployee.get(funcID)?.size || 0,
          name: employee.name,
        };
      }
    });

    const rows = Object.values(agg);
    const bucketsInRows = Array.from(new Set(rows.map((row) => row.bucket)));
    const orderedBuckets = [
      ...orderedRuleBuckets.filter((bucket) => bucketsInRows.includes(bucket)),
      ...defaultBucketOrder.filter(
        (bucket) =>
          bucketsInRows.includes(bucket) && !orderedRuleBuckets.includes(bucket),
      ),
      ...bucketsInRows
        .filter(
          (bucket) =>
            !orderedRuleBuckets.includes(bucket) &&
            !defaultBucketOrder.includes(bucket),
        )
        .sort((a, b) => a.localeCompare(b)),
    ];

    return orderedBuckets.map((bucket) => ({
      bucket,
      title: bucketTitle(bucket),
      settlementMode: bucketConfigs.get(bucket)?.settlementMode || 'DIARIO',
      rows: rows
        .filter((row) => row.bucket === bucket)
        .sort((a, b) => {
          const byName = a.name.localeCompare(b.name);
          return byName !== 0 ? byName : a.funcID - b.funcID;
        }),
    }));
  }, [bucketConfigs, funcionarios, orderedRuleBuckets, snapshots]);

  const summaryTotals = useMemo(() => {
    const totals = {
      staff: 0,
      gerente: 0,
      supervisor: 0,
      cozinha: 0,
      chamador: 0,
      efetivo: 0,
      teorico: 0,
      naoPago: 0,
      jaRecebidoDiario: 0,
      aReceberPeriodo: 0,
      faturamento: snapshots.reduce(
        (acc, curr) => acc + (curr.faturamento_inserido || 0),
        0,
      ),
    };

    groupedEmployeeReport.forEach((group) => {
      group.rows.forEach((row) => {
        totals.efetivo = round2(totals.efetivo + row.efetivo);
        totals.teorico = round2(totals.teorico + row.teorico);
        totals.naoPago = round2(totals.naoPago + row.naoPago);
        totals.jaRecebidoDiario = round2(
          totals.jaRecebidoDiario + row.jaRecebidoDiario,
        );
        totals.aReceberPeriodo = round2(
          totals.aReceberPeriodo + row.aReceberPeriodo,
        );

        if (row.bucket === 'staff') {
          totals.staff = round2(totals.staff + row.efetivo);
          return;
        }
        if (row.bucket === 'gerente') {
          totals.gerente = round2(totals.gerente + row.efetivo);
          return;
        }
        if (row.bucket === 'supervisor') {
          totals.supervisor = round2(totals.supervisor + row.efetivo);
          return;
        }
        if (row.bucket === 'cozinha' || row.bucket === 'bar') {
          totals.cozinha = round2(totals.cozinha + row.efetivo);
          return;
        }
        if (row.bucket === 'chamador') {
          totals.chamador = round2(totals.chamador + row.efetivo);
        }
      });
    });

    return totals;
  }, [groupedEmployeeReport, snapshots]);

  const fetchSnapshots = async (nextFromDate?: string, nextToDate?: string) => {
    if (!restID) return;
    try {
      setLoading(true);
      setError('');

      const effectiveFrom = nextFromDate ?? fromDate;
      const effectiveTo = nextToDate ?? toDate;
      const from = effectiveFrom || new Date().toISOString().split('T')[0];
      const to = effectiveTo || effectiveFrom || from;
      const snaps = await apiClient.getFinanceiroSnapshotRange(restID, from, to);
      setSnapshots(snaps.data || []);
    } catch (err) {
      setError('Erro ao carregar snapshots');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (authorized === null) return <Layout><div className={styles.container}><p className={styles.muted}>Verificando permissões…</p></div></Layout>;

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Relatórios</p>
            <h1>Visão Geral</h1>
            <p className={styles.subtitle}>
              Consulte os totais de gorjetas, faturamento estimado e a distribuição por funcionário em
              um intervalo de datas. Visual pensado no Financeiro Diário para manter a consistência.
            </p>
          </div>

          <div className={styles.filters}>
            <div className={styles.selectGroup}>
              <label>Restaurante</label>
              <select
                value={restID || ''}
                onChange={(e) => setRestID(parseInt(e.target.value, 10) || null)}
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
              <label>De</label>
              <input
                type="date"
                value={fromDate}
                onChange={(e) => setFromDate(e.target.value)}
              />
            </div>
            <div className={styles.selectGroup}>
              <label>Até</label>
              <input
                type="date"
                value={toDate}
                onChange={(e) => setToDate(e.target.value)}
              />
            </div>
            <div className={styles.selectGroup}>
              <label>&nbsp;</label>
              <button
                type="button"
                className={styles.btnPrimary}
                onClick={() => fetchSnapshots()}
                disabled={!restID || loading}
              >
                {loading ? 'Carregando...' : 'Aplicar'}
              </button>
            </div>
            <div className={styles.selectGroup}>
              <label>&nbsp;</label>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={() => {
                  setFromDate('');
                  setToDate('');
                  fetchSnapshots('', '');
                }}
              >
                Limpar
              </button>
            </div>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}

        {loading ? (
          <div className={styles.info}>Carregando relatórios...</div>
        ) : (
          <>
            {/* Summary across snapshots */}
            {snapshots.length > 0 && (
              <div className={styles.summaryGrid}>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Staff (efetivo)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.staff.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Gerente (efetivo)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.gerente.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Supervisor (efetivo)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.supervisor.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Cozinha (efetivo)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.cozinha.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Chamadores (efetivo)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.chamador.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Já recebido (diário)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.jaRecebidoDiario.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>A receber (período)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.aReceberPeriodo.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Total não pago</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.naoPago.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Faturamento (salvo)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.faturamento.toFixed(2)}</strong>
                </div>
              </div>
            )}

            <section className={styles.section}>
              <div className={styles.sectionHeader}>
                <div>
                  <h2>Distribuição por Funcionário (período)</h2>
                  <p>Lista agrupada por função com valor efetivo, valor teórico, já recebido no diário e o que fica para acerto por período.</p>
                </div>
              </div>
              {groupedEmployeeReport.length === 0 ? (
                <div className={styles.info}>Nenhum dado disponível</div>
              ) : (
                groupedEmployeeReport.map((group) => (
                  <div className={styles.tableWrapper} key={group.bucket} style={{ marginTop: '14px' }}>
                    <h3 style={{ marginBottom: '8px' }}>{group.title}</h3>
                    <p className={styles.metaText} style={{ marginBottom: '8px' }}>
                      Tipo de acerto predominante: <strong>{group.settlementMode}</strong>
                    </p>
                    <table className={styles.table}>
                      <thead>
                        <tr>
                          <th>Funcionário</th>
                          <th>Role</th>
                          <th>Acerto</th>
                          <th>Dias trabalhados</th>
                          <th>Efetivo (€)</th>
                          <th>Já recebido diário (€)</th>
                          <th>A receber período (€)</th>
                          <th>Não pago (€)</th>
                          <th>Direto (€)</th>
                          <th>Teórico (€)</th>
                        </tr>
                      </thead>
                      <tbody>
                        {group.rows.map((row) => (
                          <tr key={row.funcID}>
                            <td>
                              <div className={styles.nameCell}>
                                <span className={styles.avatar}>
                                  {row.name.slice(0, 1).toUpperCase()}
                                </span>
                                <div>
                                  <div className={styles.name}>{row.name}</div>
                                  <div className={styles.metaText}>ID #{row.funcID}</div>
                                </div>
                              </div>
                            </td>
                            <td>{row.bucket}</td>
                            <td>{row.settlementMode}</td>
                            <td>{row.diasTrabalhados}</td>
                            <td className={styles.highlight}>€ {row.efetivo.toFixed(2)}</td>
                            <td>€ {row.jaRecebidoDiario.toFixed(2)}</td>
                            <td>€ {row.aReceberPeriodo.toFixed(2)}</td>
                            <td>€ {row.naoPago.toFixed(2)}</td>
                            <td>€ {row.direto.toFixed(2)}</td>
                            <td>€ {row.teorico.toFixed(2)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                ))
              )}
            </section>

            <section className={styles.section}>
              <div className={styles.sectionHeader}>
                <div>
                  <h2>Fechamento por dia (snapshots)</h2>
                  <p>Mostra o que foi salvo no Financeiro Diário para cada dia.</p>
                </div>
              </div>

              {snapshots.length === 0 ? (
                <div className={styles.info}>Nenhum snapshot encontrado no período.</div>
              ) : (
                <div className={styles.transactionsList}>
                  {snapshots.map((day) => {
                    const dateLabel = new Date(day.data).toLocaleDateString('pt-BR');
                    const staff = day.entries.filter((e) => toRoleBucket(e.role) === 'staff');
                    const gerentes = day.entries.filter((e) => toRoleBucket(e.role) === 'gerente');
                    const supervisores = day.entries.filter((e) => toRoleBucket(e.role) === 'supervisor');
                    const chamadores = day.entries.filter((e) => toRoleBucket(e.role) === 'chamador');
                    const cozinha = day.entries.filter((e) => {
                      const bucket = toRoleBucket(e.role);
                      return bucket === 'cozinha' || bucket === 'bar';
                    });

                    const sum = (arr: SnapshotEntry[], field: keyof SnapshotEntry) =>
                      arr.reduce((acc, curr) => acc + (curr[field] as number), 0);
                    const sumEffective = (arr: SnapshotEntry[]) =>
                      arr.reduce((acc, curr) => acc + getEffectiveSnapshotValue(curr), 0);
                    const dayBuckets = Array.from(
                      new Set(day.entries.map((entry) => toRoleBucket(entry.role))),
                    );
                    const dayOrderedBuckets = [
                      ...orderedRuleBuckets.filter((bucket) => dayBuckets.includes(bucket)),
                      ...defaultBucketOrder.filter(
                        (bucket) =>
                          dayBuckets.includes(bucket) &&
                          !orderedRuleBuckets.includes(bucket),
                      ),
                      ...dayBuckets
                        .filter(
                          (bucket) =>
                            !orderedRuleBuckets.includes(bucket) &&
                            !defaultBucketOrder.includes(bucket),
                        )
                        .sort((a, b) => a.localeCompare(b)),
                    ];
                    const sortedEntries = [...day.entries].sort((a, b) => {
                      const bucketA = toRoleBucket(a.role);
                      const bucketB = toRoleBucket(b.role);
                      const idxA = dayOrderedBuckets.indexOf(bucketA);
                      const idxB = dayOrderedBuckets.indexOf(bucketB);
                      if (idxA !== idxB) return idxA - idxB;

                      const nameA =
                        (a.funcID != null ? funcionarios[a.funcID]?.name : null) ||
                        a.employee_name ||
                        '';
                      const nameB =
                        (b.funcID != null ? funcionarios[b.funcID]?.name : null) ||
                        b.employee_name ||
                        '';
                      return nameA.localeCompare(nameB);
                    });

                    return (
                      <div key={day.data} className={styles.card}>
                        <div className={styles.cardHeader}>
                          <h3>{dateLabel}</h3>
                          <span className={styles.badge}>
                            Faturamento: {day.faturamento_inserido !== null ? `€ ${day.faturamento_inserido?.toFixed(2)}` : '—'}
                          </span>
                        </div>

                        <div className={styles.summaryGridSmall}>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Staff (pool + diretas)</span>
                            <strong className={styles.summaryValue}>
                              € {sumEffective(staff).toFixed(2)}
                            </strong>
                            <span className={styles.summaryMeta}>Pool: € {sum(staff, 'valor_pool').toFixed(2)}</span>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Gerente (efetivo)</span>
                            <strong className={styles.summaryValue}>€ {sumEffective(gerentes).toFixed(2)}</strong>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Supervisor (efetivo)</span>
                            <strong className={styles.summaryValue}>€ {sumEffective(supervisores).toFixed(2)}</strong>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Cozinha (efetivo)</span>
                            <strong className={styles.summaryValue}>€ {sumEffective(cozinha).toFixed(2)}</strong>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Chamadores</span>
                            <strong className={styles.summaryValue}>€ {sumEffective(chamadores).toFixed(2)}</strong>
                            <span className={styles.summaryMeta}>Fora do pool</span>
                          </div>
                        </div>

                        <div className={styles.tableWrapper} style={{ marginTop: '12px' }}>
                          <table className={styles.table}>
                            <thead>
                              <tr>
                                <th>Role</th>
                                <th>Nome</th>
                                <th>Pool (€)</th>
                                <th>Direto (€)</th>
                                <th>Teórico (€)</th>
                                <th>Efetivo (€)</th>
                              </tr>
                            </thead>
                            <tbody>
                              {sortedEntries.map((e, idx) => (
                                <tr key={`${day.data}-${idx}`}>
                                  <td>{toRoleBucket(e.role)}</td>
                                  <td>
                                    {e.funcID != null
                                      ? funcionarios[Number(e.funcID)]?.name ||
                                        e.employee_name ||
                                        `ID ${e.funcID}`
                                      : e.employee_name || '—'}
                                  </td>
                                  <td>€ {e.valor_pool.toFixed(2)}</td>
                                  <td>€ {e.valor_direto.toFixed(2)}</td>
                                  <td>€ {e.valor_teorico.toFixed(2)}</td>
                                  <td className={styles.highlight}>
                                    € {getEffectiveSnapshotValue(e).toFixed(2)}
                                  </td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </section>
          </>
        )}
      </div>
    </Layout>
  );
}
