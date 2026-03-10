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
  ordem: number;
}

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];
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

export default function Relatorios() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restID, setRestID] = useSessionPageState<number | null>('restID', null);
  const [funcionarios, setFuncionarios] = useState<Record<number, FuncionarioInfo>>({});
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
      const regras = (res.data || []) as RegraDistribuicao[];
      const buckets: string[] = [];
      regras.forEach((regra) => {
        const bucket = toRoleBucket(regra.role_name);
        if (!buckets.includes(bucket)) buckets.push(bucket);
      });
      setOrderedRuleBuckets(buckets);
    } catch {
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

  const groupedEmployeeReport = useMemo(() => {
    if (snapshots.length === 0) return [];

    const agg: Record<
      number,
      {
        role: string;
        pago: number;
        direto: number;
        teorico: number;
        diasTrabalhados: number;
        name: string;
      }
    > = {};
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
        const role = employeeFromMap?.funcao
          ? toRoleBucket(employeeFromMap.funcao)
          : toRoleBucket(e.employee_funcao || e.role);
        const name = employeeFromMap?.name || e.employee_name || `Func ${e.funcID}`;

        if (!agg[e.funcID]) {
          agg[e.funcID] = {
            role,
            pago: 0,
            direto: 0,
            teorico: 0,
            diasTrabalhados: 0,
            name,
          };
        }
        agg[e.funcID].role = role;
        agg[e.funcID].name = name;
        agg[e.funcID].pago += e.valor_pago || 0;
        agg[e.funcID].direto += e.valor_direto || 0;
        agg[e.funcID].teorico += e.valor_teorico || 0;
      });
    });

    Object.entries(agg).forEach(([funcID, data]) => {
      data.diasTrabalhados = daysByEmployee.get(Number(funcID))?.size || 0;
    });

    Object.entries(funcionarios).forEach(([funcIDRaw, employee]) => {
      const funcID = Number(funcIDRaw);
      if (!agg[funcID]) {
        agg[funcID] = {
          role: toRoleBucket(employee.funcao),
          pago: 0,
          direto: 0,
          teorico: 0,
          diasTrabalhados: daysByEmployee.get(funcID)?.size || 0,
          name: employee.name,
        };
      }
    });

    const rows = Object.entries(agg).map(([funcID, data]) => ({
      funcID: Number(funcID),
      ...data,
    }));
    const bucketsInRows = Array.from(new Set(rows.map((row) => row.role)));
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
      rows: rows
        .filter((row) => row.role === bucket)
        .sort((a, b) => {
          const byName = a.name.localeCompare(b.name);
          return byName !== 0 ? byName : a.funcID - b.funcID;
        }),
    }));
  }, [funcionarios, orderedRuleBuckets, snapshots]);

  const summaryTotals = useMemo(() => {
    const totals = {
      staff: 0,
      gerente: 0,
      supervisor: 0,
      cozinha: 0,
      chamador: 0,
      faturamento: snapshots.reduce(
        (acc, curr) => acc + (curr.faturamento_inserido || 0),
        0,
      ),
    };

    snapshots.forEach((day) => {
      day.entries.forEach((entry) => {
        const bucket = toRoleBucket(entry.role);
        if (bucket === 'staff') {
          totals.staff += (entry.valor_pago || 0) + (entry.valor_direto || 0);
          return;
        }
        if (bucket === 'gerente') {
          totals.gerente += entry.valor_pago || 0;
          return;
        }
        if (bucket === 'supervisor') {
          totals.supervisor += entry.valor_pago || 0;
          return;
        }
        if (bucket === 'cozinha' || bucket === 'bar') {
          totals.cozinha += entry.valor_pago || 0;
          return;
        }
        if (bucket === 'chamador') {
          totals.chamador += entry.valor_pago || 0;
        }
      });
    });

    return totals;
  }, [snapshots]);

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
                  <span className={styles.summaryLabel}>Staff (pool + diretas)</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.staff.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Gerente</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.gerente.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Supervisor</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.supervisor.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Cozinha</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.cozinha.toFixed(2)}</strong>
                </div>
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Chamadores</span>
                  <strong className={styles.summaryValue}>€ {summaryTotals.chamador.toFixed(2)}</strong>
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
                  <p>Lista agrupada por função na mesma lógica do Financeiro Diário, mantendo as colunas atuais.</p>
                </div>
              </div>
              {groupedEmployeeReport.length === 0 ? (
                <div className={styles.info}>Nenhum dado disponível</div>
              ) : (
                groupedEmployeeReport.map((group) => (
                  <div className={styles.tableWrapper} key={group.bucket} style={{ marginTop: '14px' }}>
                    <h3 style={{ marginBottom: '8px' }}>{group.title}</h3>
                    <table className={styles.table}>
                      <thead>
                        <tr>
                          <th>Funcionário</th>
                          <th>Role</th>
                          <th>Dias trabalhados</th>
                          <th>Pago (€)</th>
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
                            <td>{row.role}</td>
                            <td>{row.diasTrabalhados}</td>
                            <td className={styles.highlight}>€ {row.pago.toFixed(2)}</td>
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
                              € {(sum(staff, 'valor_pago') + sum(staff, 'valor_direto')).toFixed(2)}
                            </strong>
                            <span className={styles.summaryMeta}>Pool: € {sum(staff, 'valor_pool').toFixed(2)}</span>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Gerente (real)</span>
                            <strong className={styles.summaryValue}>€ {sum(gerentes, 'valor_pago').toFixed(2)}</strong>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Supervisor (real)</span>
                            <strong className={styles.summaryValue}>€ {sum(supervisores, 'valor_pago').toFixed(2)}</strong>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Cozinha</span>
                            <strong className={styles.summaryValue}>€ {sum(cozinha, 'valor_pago').toFixed(2)}</strong>
                          </div>
                          <div className={styles.summaryCard}>
                            <span className={styles.summaryLabel}>Chamadores</span>
                            <strong className={styles.summaryValue}>€ {sum(chamadores, 'valor_pago').toFixed(2)}</strong>
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
                                <th>Pago (€)</th>
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
                                  <td className={styles.highlight}>€ {e.valor_pago.toFixed(2)}</td>
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
