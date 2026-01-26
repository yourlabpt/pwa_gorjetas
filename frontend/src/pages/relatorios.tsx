'use client';

import { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';

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
  valor_pool: number;
  valor_direto: number;
  valor_teorico: number;
  valor_pago: number;
}

interface SnapshotDay {
  data: string;
  faturamento_inserido: number | null;
  entries: SnapshotEntry[];
}

interface Restaurante {
  restID: number;
  name: string;
  percentagem_gorjeta_base: number;
}

export default function Relatorios() {
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restID, setRestID] = useState<number | null>(null);
  const [funcionarios, setFuncionarios] = useState<Record<number, string>>({});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');
  const [snapshots, setSnapshots] = useState<SnapshotDay[]>([]);

  useEffect(() => {
    loadRestaurant();
  }, []);

  useEffect(() => {
    if (restID) {
      fetchFuncionarios();
      fetchSnapshots();
    }
  }, [restID, fromDate, toDate]);

  const loadRestaurant = async () => {
    try {
      const response = await apiClient.getRestaurantes(true);
      if (response.data && response.data.length > 0) {
        setRestaurantes(response.data);
        setRestID(response.data[0].restID);
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
      const map: Record<number, string> = {};
      res.data?.forEach((f: any) => {
        map[f.funcID] = f.name;
      });
      setFuncionarios(map);
    } catch (err) {
      // ignore for now
    }
  };

  const fetchSnapshots = async () => {
    if (!restID) return;
    try {
      setLoading(true);
      setError('');

      const from = fromDate || new Date().toISOString().split('T')[0];
      const to = toDate || fromDate || from;
      const snaps = await apiClient.getFinanceiroSnapshotRange(restID, from, to);
      setSnapshots(snaps.data || []);
    } catch (err) {
      setError('Erro ao carregar snapshots');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleFilter = (e: React.FormEvent) => {
    e.preventDefault();
    fetchSnapshots();
  };

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
              <button type="button" className={styles.btnPrimary} onClick={fetchSnapshots} disabled={!restID || loading}>
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
                  fetchSnapshots();
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
                {(() => {
                  const allEntries = snapshots.flatMap((d) => d.entries);
                  const sum = (role: string) =>
                    allEntries
                      .filter((e) => e.role === role)
                      .reduce((acc, curr) => acc + (curr.valor_pago || 0) + (curr.valor_direto || 0), 0);
                  const staffTotal = sum('staff');
                  const gestorTotal = sum('gestor');
                  const supervisorTotal = sum('supervisor');
                  const cozinhaTotal = sum('cozinha');
                  const chamadorTotal = sum('chamador');
                  const faturamentoTotal = snapshots.reduce(
                    (acc, curr) => acc + (curr.faturamento_inserido || 0),
                    0,
                  );
                  return (
                    <>
                      <div className={styles.summaryCard}>
                        <span className={styles.summaryLabel}>Staff (pool + diretas)</span>
                        <strong className={styles.summaryValue}>€ {staffTotal.toFixed(2)}</strong>
                      </div>
                      <div className={styles.summaryCard}>
                        <span className={styles.summaryLabel}>Gestor</span>
                        <strong className={styles.summaryValue}>€ {gestorTotal.toFixed(2)}</strong>
                      </div>
                      <div className={styles.summaryCard}>
                        <span className={styles.summaryLabel}>Supervisor</span>
                        <strong className={styles.summaryValue}>€ {supervisorTotal.toFixed(2)}</strong>
                      </div>
                      <div className={styles.summaryCard}>
                        <span className={styles.summaryLabel}>Cozinha</span>
                        <strong className={styles.summaryValue}>€ {cozinhaTotal.toFixed(2)}</strong>
                      </div>
                      <div className={styles.summaryCard}>
                        <span className={styles.summaryLabel}>Chamadores</span>
                        <strong className={styles.summaryValue}>€ {chamadorTotal.toFixed(2)}</strong>
                      </div>
                      <div className={styles.summaryCard}>
                        <span className={styles.summaryLabel}>Faturamento (salvo)</span>
                        <strong className={styles.summaryValue}>€ {faturamentoTotal.toFixed(2)}</strong>
                      </div>
                    </>
                  );
                })()}
              </div>
            )}

            <section className={styles.section}>
              <div className={styles.sectionHeader}>
                <div>
                  <h2>Distribuição por Funcionário (período)</h2>
                  <p>Somatório das gorjetas pagas (pool + diretas) e pagamentos de gestor/supervisor.</p>
                </div>
              </div>

              <div className={styles.tableWrapper}>
                <table className={styles.table}>
                  <thead>
                    <tr>
                      <th>Funcionário</th>
                      <th>Role</th>
                      <th>Pago (€)</th>
                      <th>Direto (€)</th>
                      <th>Teórico (€)</th>
                    </tr>
                  </thead>
                  <tbody>
                    {(() => {
                      const agg: Record<
                        number,
                        { role: string; pago: number; direto: number; teorico: number }
                      > = {};
                      snapshots.forEach((day) => {
                        day.entries.forEach((e) => {
                          if (!e.funcID) return;
                          if (!agg[e.funcID]) {
                            agg[e.funcID] = { role: e.role, pago: 0, direto: 0, teorico: 0 };
                          }
                          agg[e.funcID].role = e.role;
                          agg[e.funcID].pago += e.valor_pago || 0;
                          agg[e.funcID].direto += e.valor_direto || 0;
                          agg[e.funcID].teorico += e.valor_teorico || 0;
                        });
                      });

                      const rows = Object.entries(agg);
                      if (rows.length === 0) {
                        return (
                          <tr>
                            <td colSpan={5} className={styles.emptyCell}>
                              Nenhum dado disponível
                            </td>
                          </tr>
                        );
                      }

                      return rows.map(([funcID, data]) => (
                        <tr key={funcID}>
                          <td>
                            <div className={styles.nameCell}>
                              <span className={styles.avatar}>
                                {(funcionarios[Number(funcID)] || '?').slice(0, 1).toUpperCase()}
                              </span>
                              <div>
                                <div className={styles.name}>{funcionarios[Number(funcID)] || `Func ${funcID}`}</div>
                                <div className={styles.metaText}>ID #{funcID}</div>
                              </div>
                            </div>
                          </td>
                          <td>{data.role}</td>
                          <td className={styles.highlight}>€ {data.pago.toFixed(2)}</td>
                          <td>€ {data.direto.toFixed(2)}</td>
                          <td>€ {data.teorico.toFixed(2)}</td>
                        </tr>
                      ));
                    })()}
                  </tbody>
                </table>
              </div>
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
                    const staff = day.entries.filter((e) => e.role === 'staff');
                    const gestores = day.entries.filter((e) => e.role === 'gestor');
                    const supervisores = day.entries.filter((e) => e.role === 'supervisor');
                    const chamadores = day.entries.filter((e) => e.role === 'chamador');
                    const cozinha = day.entries.filter((e) => e.role === 'cozinha');

                    const sum = (arr: SnapshotEntry[], field: keyof SnapshotEntry) =>
                      arr.reduce((acc, curr) => acc + (curr[field] as number), 0);

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
                            <span className={styles.summaryLabel}>Gestor (real)</span>
                            <strong className={styles.summaryValue}>€ {sum(gestores, 'valor_pago').toFixed(2)}</strong>
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
                                <th>Func ID</th>
                                <th>Pool (€)</th>
                                <th>Direto (€)</th>
                                <th>Teórico (€)</th>
                                <th>Pago (€)</th>
                              </tr>
                            </thead>
                            <tbody>
                              {day.entries.map((e, idx) => (
                                <tr key={`${day.data}-${idx}`}>
                                  <td>{e.role}</td>
                                  <td>{e.funcID || '—'}</td>
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
