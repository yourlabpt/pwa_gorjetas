'use client';

import { Fragment, useCallback, useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/auditoria.module.css';

interface Restaurante {
  restID: number;
  name: string;
}

interface Funcionario {
  funcID: number;
  name: string;
}

interface AuditUser {
  id: number;
  email: string;
  name: string;
  role: string;
}

interface AuditLogRow {
  id: number;
  requestId: string;
  userId: number | null;
  user?: AuditUser | null;
  restID: number | null;
  action: string;
  entity: string;
  entityId: string;
  status: string;
  valuesBefore: Record<string, unknown> | null;
  valuesAfter: Record<string, unknown> | null;
  ipAddress: string | null;
  userAgent: string | null;
  duration: number | null;
  createdAt: string;
  errorMessage?: string | null;
}

interface AuditTrailPayload {
  total: number;
  limit: number;
  offset: number;
  data: AuditLogRow[];
}

interface ActiveSession {
  id: number;
  user: AuditUser;
  loginTime: string;
  lastActivity: string;
  ipAddress: string | null;
  userAgent: string | null;
  duration: number;
}

const ALLOWED_ROLES = ['SUPER_ADMIN'];
const ACTION_OPTIONS = [
  'CREATED',
  'UPDATED',
  'DELETED',
  'LOGIN',
  'LOGOUT',
  'VIEW',
  'COMPUTE',
  'SNAPSHOT',
  'SETTLE',
  'ROLLBACK',
  'REPLAY',
  'EXPORTED',
  'OTHER',
];
const ENTITY_OPTIONS = [
  'User',
  'Restaurante',
  'Funcionario',
  'FuncionarioRestaurante',
  'Transacao',
  'DistribuicaoGorjetas',
  'FaturamentoDiario',
  'FaturamentoDiarioDistribuicao',
  'ConfiguracaoAcerto',
  'AcertoPeriodo',
  'AcertoFuncionario',
  'AcertoFinalPeriodo',
  'AcertoFinalEntry',
  'FechoFinanceiro',
  'FechoFinanceiroTemplate',
  'FechoFinanceiroItem',
  'RegraDistribuicao',
  'FuncionarioPresencaDiaria',
  'OTHER',
];

export default function AuditoriaPage() {
  const router = useRouter();

  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [loading, setLoading] = useState(false);
  const [bootstrapping, setBootstrapping] = useState(true);
  const [error, setError] = useState('');
  const [activeTab, setActiveTab] = useState<'trail' | 'sessions'>('trail');

  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);

  const [trail, setTrail] = useState<AuditLogRow[]>([]);
  const [total, setTotal] = useState(0);
  const [expandedRowId, setExpandedRowId] = useState<number | null>(null);
  const [activeSessions, setActiveSessions] = useState<ActiveSession[]>([]);

  const [restID, setRestID] = useState('');
  const [funcionarioId, setFuncionarioId] = useState('');
  const [action, setAction] = useState('');
  const [entity, setEntity] = useState('');
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');
  const [requestIdFilter, setRequestIdFilter] = useState('');

  const restaurantMap = useMemo(
    () => new Map(restaurantes.map((r) => [r.restID, r.name])),
    [restaurantes],
  );

  const fetchFuncionarios = useCallback(async (restaurantId: number) => {
    try {
      const res = await apiClient.getFuncionarios(restaurantId, undefined, true);
      const rows = (res.data || []) as Array<{ funcID: number; name: string }>;
      setFuncionarios(
        rows.map((row) => ({
          funcID: row.funcID,
          name: row.name,
        })),
      );
    } catch {
      setFuncionarios([]);
    }
  }, []);

  const fetchTrail = useCallback(async () => {
    try {
      setLoading(true);
      setError('');

      const params: {
        restID?: number;
        entity?: string;
        entityId?: string;
        action?: string;
        from?: string;
        to?: string;
        limit?: number;
        offset?: number;
      } = {
        limit: 500,
        offset: 0,
      };

      if (restID) params.restID = Number(restID);
      if (action) params.action = action;

      if (funcionarioId) {
        params.entity = 'Funcionario';
        params.entityId = funcionarioId;
      } else if (entity) {
        params.entity = entity;
      }

      if (fromDate) params.from = new Date(`${fromDate}T00:00:00`).toISOString();
      if (toDate) params.to = new Date(`${toDate}T23:59:59.999`).toISOString();

      const res = await apiClient.getAuditTrail(params);
      const payload = (res.data || {
        total: 0,
        limit: 500,
        offset: 0,
        data: [],
      }) as AuditTrailPayload;

      const requestIdNeedle = requestIdFilter.trim().toLowerCase();
      const filteredRows = requestIdNeedle
        ? payload.data.filter((row) =>
            String(row.requestId || '').toLowerCase().includes(requestIdNeedle),
          )
        : payload.data;

      setTrail(filteredRows);
      setTotal(payload.total);
      setExpandedRowId(null);
    } catch (err: any) {
      setError(err?.response?.data?.message || 'Erro ao carregar auditoria');
      setTrail([]);
      setTotal(0);
    } finally {
      setLoading(false);
    }
  }, [action, entity, fromDate, funcionarioId, requestIdFilter, restID, toDate]);

  const fetchActiveSessions = useCallback(async () => {
    try {
      setLoading(true);
      setError('');
      const res = await apiClient.getActiveSessions();
      setActiveSessions(res.data?.sessions || []);
    } catch (err: any) {
      setError(err?.response?.data?.message || 'Erro ao carregar sessões ativas');
      setActiveSessions([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    const bootstrap = async () => {
      try {
        const token =
          typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) {
          router.replace('/login');
          return;
        }

        const meRes = await apiClient.me();
        const role = String(meRes.data?.role || '');
        if (!ALLOWED_ROLES.includes(role)) {
          router.replace('/');
          return;
        }

        const restRes = await apiClient.getRestaurantes();
        setRestaurantes((restRes.data || []) as Restaurante[]);

        setAuthorized(true);
      } catch (err: any) {
        const status = err?.response?.status;
        if (status === 401) {
          router.replace('/login');
          return;
        }
        router.replace('/');
      } finally {
        setBootstrapping(false);
      }
    };

    bootstrap();
  }, [router]);

  useEffect(() => {
    if (!authorized) return;
    if (activeTab === 'trail') {
      fetchTrail();
    } else {
      fetchActiveSessions();
    }
  }, [authorized, activeTab, fetchTrail, fetchActiveSessions]);

  useEffect(() => {
    if (!restID) {
      setFuncionarios([]);
      setFuncionarioId('');
      return;
    }
    fetchFuncionarios(Number(restID));
  }, [fetchFuncionarios, restID]);

  const handleClear = () => {
    setRestID('');
    setFuncionarioId('');
    setAction('');
    setEntity('');
    setFromDate('');
    setToDate('');
    setRequestIdFilter('');
  };

  const formatDateTime = (value: string) =>
    new Date(value).toLocaleString('pt-PT', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    });

  if (authorized === null || bootstrapping) {
    return (
      <Layout>
        <div className={styles.container}>
          <p className={styles.muted}>Verificando permissões...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.header}>
          <div>
            <h1>Auditoria de Alterações</h1>
            <p>
              Histórico completo de ações do sistema. Esta página é exclusiva para
              SUPER_ADMIN.
            </p>
          </div>
        </div>

        <div className={styles.tabs}>
          <button
            className={`${styles.tab} ${activeTab === 'trail' ? styles.active : ''}`}
            onClick={() => setActiveTab('trail')}
            type="button"
          >
            Histórico de Alterações
          </button>
          <button
            className={`${styles.tab} ${activeTab === 'sessions' ? styles.active : ''}`}
            onClick={() => setActiveTab('sessions')}
            type="button"
          >
            Sessões Ativas ({activeSessions.length})
          </button>
        </div>

        {activeTab === 'trail' && (
          <>
            <div className={styles.summaryCard}>
              <span>Registos exibidos</span>
              <strong>{trail.length}</strong>
              <small>Total no resultado bruto: {total}</small>
            </div>

            <section className={styles.filters}>
              <div className={styles.grid}>
                <label>
                  Restaurante
                  <select value={restID} onChange={(e) => setRestID(e.target.value)}>
                    <option value="">Todos</option>
                    {restaurantes.map((rest) => (
                      <option key={rest.restID} value={String(rest.restID)}>
                        {rest.name}
                      </option>
                    ))}
                  </select>
                </label>

                <label>
                  Funcionário (entidade)
                  <select
                    value={funcionarioId}
                    onChange={(e) => setFuncionarioId(e.target.value)}
                    disabled={!restID || funcionarios.length === 0}
                  >
                    <option value="">Todos</option>
                    {funcionarios.map((f) => (
                      <option key={f.funcID} value={String(f.funcID)}>
                        {f.name} (#{f.funcID})
                      </option>
                    ))}
                  </select>
                </label>

                <label>
                  Ação
                  <select value={action} onChange={(e) => setAction(e.target.value)}>
                    <option value="">Todas</option>
                    {ACTION_OPTIONS.map((item) => (
                      <option key={item} value={item}>
                        {item}
                      </option>
                    ))}
                  </select>
                </label>

                <label>
                  Entidade
                  <select
                    value={entity}
                    onChange={(e) => setEntity(e.target.value)}
                    disabled={Boolean(funcionarioId)}
                  >
                    <option value="">Todas</option>
                    {ENTITY_OPTIONS.map((item) => (
                      <option key={item} value={item}>
                        {item}
                      </option>
                    ))}
                  </select>
                </label>

                <label>
                  Data inicial
                  <input
                    type="date"
                    value={fromDate}
                    onChange={(e) => setFromDate(e.target.value)}
                  />
                </label>

                <label>
                  Data final
                  <input
                    type="date"
                    value={toDate}
                    onChange={(e) => setToDate(e.target.value)}
                  />
                </label>

                <label className={styles.span2}>
                  Request ID (contém)
                  <input
                    type="text"
                    value={requestIdFilter}
                    placeholder="Filtrar por requestId"
                    onChange={(e) => setRequestIdFilter(e.target.value)}
                  />
                </label>
              </div>

              <div className={styles.actions}>
                <button type="button" onClick={fetchTrail} disabled={loading}>
                  {loading ? 'Carregando...' : 'Aplicar filtros'}
                </button>
                <button type="button" className={styles.secondary} onClick={handleClear}>
                  Limpar filtros
                </button>
              </div>
              {!restID && (
                <p className={styles.tip}>
                  Dica: para filtrar por funcionário, selecione primeiro um restaurante.
                </p>
              )}
            </section>

            {error && <div className={styles.error}>{error}</div>}

            <section className={styles.tableWrapper}>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Data/Hora</th>
                    <th>Restaurante</th>
                    <th>Usuário</th>
                    <th>Ação</th>
                    <th>Entidade</th>
                    <th>Entity ID</th>
                    <th>Status</th>
                    <th>Duração</th>
                    <th>Request ID</th>
                    <th>Detalhes</th>
                  </tr>
                </thead>
                <tbody>
                  {trail.length === 0 ? (
                    <tr>
                      <td colSpan={10} className={styles.empty}>
                        Nenhum registo encontrado para os filtros atuais.
                      </td>
                    </tr>
                  ) : (
                    trail.map((row) => {
                      const isExpanded = expandedRowId === row.id;
                      const userDisplay = row.user
                        ? `${row.user.name} (${row.user.email})`
                        : row.userId != null
                        ? `#${row.userId}`
                        : '—';

                      return (
                        <Fragment key={row.id}>
                          <tr>
                            <td>{formatDateTime(row.createdAt)}</td>
                            <td>
                              {row.restID != null
                                ? restaurantMap.get(row.restID) || `#${row.restID}`
                                : '—'}
                            </td>
                            <td>{userDisplay}</td>
                            <td>
                              <span className={styles.badge}>{row.action}</span>
                            </td>
                            <td>{row.entity}</td>
                            <td>{row.entityId}</td>
                            <td>{row.status}</td>
                            <td>{row.duration != null ? `${row.duration} ms` : '—'}</td>
                            <td className={styles.mono}>{row.requestId}</td>
                            <td>
                              <button
                                type="button"
                                className={styles.linkBtn}
                                onClick={() => setExpandedRowId(isExpanded ? null : row.id)}
                              >
                                {isExpanded ? 'Ocultar' : 'Ver'}
                              </button>
                            </td>
                          </tr>
                          {isExpanded && (
                            <tr className={styles.detailsRow}>
                              <td colSpan={10}>
                                <div className={styles.detailsGrid}>
                                  <div>
                                    <h4>Antes</h4>
                                    <pre>
                                      {row.valuesBefore
                                        ? JSON.stringify(row.valuesBefore, null, 2)
                                        : 'null'}
                                    </pre>
                                  </div>
                                  <div>
                                    <h4>Depois</h4>
                                    <pre>
                                      {row.valuesAfter
                                        ? JSON.stringify(row.valuesAfter, null, 2)
                                        : 'null'}
                                    </pre>
                                  </div>
                                </div>
                                <div className={styles.metaLine}>
                                  <span>IP: {row.ipAddress || '—'}</span>
                                  <span>User-Agent: {row.userAgent || '—'}</span>
                                  {row.errorMessage ? (
                                    <span className={styles.errorText}>
                                      Erro: {row.errorMessage}
                                    </span>
                                  ) : null}
                                </div>
                              </td>
                            </tr>
                          )}
                        </Fragment>
                      );
                    })
                  )}
                </tbody>
              </table>
            </section>
          </>
        )}

        {activeTab === 'sessions' && (
          <section className={styles.tableWrapper}>
            {error && <div className={styles.error}>{error}</div>}
            <div className={styles.actions}>
              <button type="button" onClick={fetchActiveSessions} disabled={loading}>
                {loading ? 'Atualizando...' : 'Atualizar sessões'}
              </button>
            </div>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th>Login</th>
                  <th>Usuário</th>
                  <th>Email</th>
                  <th>Papel</th>
                  <th>Última Atividade</th>
                  <th>Duração</th>
                  <th>IP</th>
                  <th>User-Agent</th>
                </tr>
              </thead>
              <tbody>
                {activeSessions.length === 0 ? (
                  <tr>
                    <td colSpan={8} className={styles.empty}>
                      Nenhuma sessão ativa.
                    </td>
                  </tr>
                ) : (
                  activeSessions.map((session) => (
                    <tr key={session.id}>
                      <td>{formatDateTime(session.loginTime)}</td>
                      <td>{session.user.name}</td>
                      <td className={styles.mono}>{session.user.email}</td>
                      <td>
                        <span className={styles.badge}>{session.user.role}</span>
                      </td>
                      <td>{formatDateTime(session.lastActivity)}</td>
                      <td>{Math.floor(session.duration / 1000)}s</td>
                      <td className={styles.mono}>{session.ipAddress || '—'}</td>
                      <td className={styles.mono}>{session.userAgent || '—'}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </section>
        )}
      </div>
    </Layout>
  );
}
