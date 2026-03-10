'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';
import { useSessionPageState } from '../hooks/useSessionPageState';

interface Restaurante {
  restID: number;
  name: string;
  endereco?: string;
  contacto?: string;
  percentagem_gorjeta_base: number;
  ativo: boolean;
}

type CalculationType = 'PERCENT' | 'FIXED_AMOUNT';
type CalculationBase =
  | 'FATURAMENTO_GLOBAL'
  | 'FATURAMENTO_COM_GORJETA'
  | 'FATURAMENTO_SEM_GORJETA'
  | 'VALOR_TOTAL_GORJETAS';
type PaymentSource = 'TIP_POOL' | 'FINANCEIRO' | 'ABSOLUTE_EXTERNAL';
type PercentMode = 'ABSOLUTE_PERCENT' | 'BASE_PERCENT_POINTS';
type EmployeeSplitMode =
  | 'EQUAL_SPLIT'
  | 'PROPORTIONAL_TO_POOL_INPUT'
  | 'DIRECT_INPUT_ONLY'
  | 'FULL_RATE_PER_EMPLOYEE';
type SettlementType = 'DIARIO' | 'PERIODO';

interface RegraDistribuicao {
  id: number;
  restID: number;
  role_name: string;
  calculation_type: CalculationType;
  calculation_base: CalculationBase | null;
  rate: number;
  percent_mode: PercentMode;
  split_mode?: EmployeeSplitMode;
  tipo_de_acerto?: SettlementType;
  payment_source: PaymentSource;
  ordem: number;
  ativo: boolean;
}

interface RegraFormState {
  role_name: string;
  calculation_type: CalculationType;
  calculation_base: CalculationBase;
  rate: string;
  percent_mode: PercentMode;
  split_mode: EmployeeSplitMode;
  tipo_de_acerto: SettlementType;
  payment_source: PaymentSource;
  ordem: string;
}

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR'];

const DEFAULT_REGRA_FORM: RegraFormState = {
  role_name: '',
  calculation_type: 'PERCENT',
  calculation_base: 'VALOR_TOTAL_GORJETAS',
  rate: '',
  percent_mode: 'BASE_PERCENT_POINTS',
  split_mode: 'EQUAL_SPLIT',
  tipo_de_acerto: 'DIARIO',
  payment_source: 'TIP_POOL',
  ordem: '10',
};

const CALCULATION_TYPE_OPTIONS: Array<{ value: CalculationType; label: string }> = [
  { value: 'PERCENT', label: 'Percentagem' },
  { value: 'FIXED_AMOUNT', label: 'Valor fixo' },
];

const CALCULATION_BASE_OPTIONS: Array<{ value: CalculationBase; label: string }> = [
  { value: 'VALOR_TOTAL_GORJETAS', label: 'Gorjetas percentuais (input do pool)' },
  { value: 'FATURAMENTO_GLOBAL', label: 'Faturamento global' },
  { value: 'FATURAMENTO_COM_GORJETA', label: 'Faturamento gorjetado' },
  {
    value: 'FATURAMENTO_SEM_GORJETA',
    label: 'Faturamento liquido (global - gorjetas percentuais)',
  },
];

const PAYMENT_SOURCE_OPTIONS: Array<{ value: PaymentSource; label: string }> = [
  { value: 'TIP_POOL', label: 'Pool de gorjetas percentuais' },
  { value: 'FINANCEIRO', label: 'Pool financeiro (faturamento liquido)' },
  { value: 'ABSOLUTE_EXTERNAL', label: 'Externo (fora do faturamento)' },
];

const PERCENT_MODE_OPTIONS: Array<{ value: PercentMode; label: string }> = [
  { value: 'BASE_PERCENT_POINTS', label: 'Pontos da % base' },
  { value: 'ABSOLUTE_PERCENT', label: '% absoluto da base (€)' },
];

const SPLIT_MODE_OPTIONS: Array<{ value: EmployeeSplitMode; label: string }> = [
  { value: 'EQUAL_SPLIT', label: 'Igual por colaborador' },
  { value: 'PROPORTIONAL_TO_POOL_INPUT', label: 'Proporcional ao input do pool' },
  { value: 'DIRECT_INPUT_ONLY', label: 'Apenas valores diretos' },
  {
    value: 'FULL_RATE_PER_EMPLOYEE',
    label: 'Percentual completo por colaborador',
  },
];

const SETTLEMENT_TYPE_OPTIONS: Array<{ value: SettlementType; label: string }> = [
  { value: 'DIARIO', label: 'Diario' },
  { value: 'PERIODO', label: 'Periodo' },
];

const normalizeRole = (value: string) =>
  (value || '')
    .toLowerCase()
    .trim()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');

const formatTipoCalculo = (value: CalculationType) =>
  value === 'PERCENT' ? 'Percentagem' : 'Valor fixo';

const formatBaseCalculo = (value: CalculationBase | null) => {
  if (!value) return 'Nao aplicavel';
  const found = CALCULATION_BASE_OPTIONS.find((opt) => opt.value === value);
  return found?.label || value;
};

const formatFontePagamento = (value: PaymentSource) => {
  const found = PAYMENT_SOURCE_OPTIONS.find((opt) => opt.value === value);
  return found?.label || value;
};

const formatModoPercentual = (value: PercentMode) => {
  const found = PERCENT_MODE_OPTIONS.find((opt) => opt.value === value);
  return found?.label || value;
};

const formatModoDivisao = (value: EmployeeSplitMode) => {
  const found = SPLIT_MODE_OPTIONS.find((opt) => opt.value === value);
  return found?.label || value;
};

const formatTipoAcerto = (value: SettlementType) => {
  const found = SETTLEMENT_TYPE_OPTIONS.find((opt) => opt.value === value);
  return found?.label || value;
};

export default function Restaurantes() {
  const router = useRouter();

  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [regrasMap, setRegrasMap] = useState<Record<number, RegraDistribuicao[]>>({});
  const [knownRoles, setKnownRoles] = useState<string[]>([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [expandedRestaurant, setExpandedRestaurant] = useSessionPageState<number | null>(
    'expandedRestaurant',
    null,
  );

  const [showAddRegra, setShowAddRegra] = useState<number | null>(null);
  const [editingRegra, setEditingRegra] = useState<{
    restID: number;
    regraID: number;
  } | null>(null);
  const [regraForm, setRegraForm] = useState<RegraFormState>(DEFAULT_REGRA_FORM);

  const [formData, setFormData] = useState({
    name: '',
    endereco: '',
    contacto: '',
    percentagem_gorjeta_base: '11.00',
  });

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token =
          typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) {
          router.replace('/login');
          return;
        }

        const res = await apiClient.me();
        const role: string = res.data?.role || '';
        if (!ALLOWED_ROLES.includes(role)) {
          router.replace('/');
          return;
        }

        setAuthorized(true);
        await fetchRestaurantes();
      } catch {
        router.replace('/login');
      }
    };

    checkAuth();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const fetchRestaurantes = async () => {
    try {
      setLoading(true);
      setError('');

      const response = await apiClient.getRestaurantes();
      const listaRestaurantes: Restaurante[] = response.data || [];
      setRestaurantes(listaRestaurantes);
      if (
        expandedRestaurant != null &&
        !listaRestaurantes.some((rest) => rest.restID === expandedRestaurant)
      ) {
        setExpandedRestaurant(null);
      }

      const roleMap = new Map<string, string>();
      const regrasEntries = await Promise.all(
        listaRestaurantes.map(async (rest) => {
          try {
            const regrasRes = await apiClient.getRegrasDistribuicao(rest.restID, true);
            const regras = (regrasRes.data || []) as RegraDistribuicao[];
            regras.forEach((regra) => {
              const key = normalizeRole(regra.role_name);
              if (key && !roleMap.has(key)) {
                roleMap.set(key, regra.role_name);
              }
            });
            return [rest.restID, regras] as const;
          } catch {
            return [rest.restID, [] as RegraDistribuicao[]] as const;
          }
        }),
      );

      const nextRegrasMap: Record<number, RegraDistribuicao[]> = {};
      regrasEntries.forEach(([restID, regras]) => {
        nextRegrasMap[restID] = regras;
      });

      setRegrasMap(nextRegrasMap);
      setKnownRoles(
        Array.from(roleMap.values()).sort((a, b) => a.localeCompare(b, 'pt-PT')),
      );
    } catch (err) {
      setError('Erro ao carregar restaurantes.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const loadRegras = async (restID: number) => {
    try {
      const res = await apiClient.getRegrasDistribuicao(restID, true);
      const regras = (res.data || []) as RegraDistribuicao[];
      setRegrasMap((prev) => ({ ...prev, [restID]: regras }));

      const roleMap = new Map<string, string>();
      Object.values({ ...regrasMap, [restID]: regras })
        .flat()
        .forEach((regra) => {
          const key = normalizeRole(regra.role_name);
          if (key && !roleMap.has(key)) {
            roleMap.set(key, regra.role_name);
          }
        });
      setKnownRoles(
        Array.from(roleMap.values()).sort((a, b) => a.localeCompare(b, 'pt-PT')),
      );
    } catch (err) {
      console.error('Erro ao carregar regras:', err);
    }
  };

  const resetForm = () => {
    setFormData({
      name: '',
      endereco: '',
      contacto: '',
      percentagem_gorjeta_base: '11.00',
    });
  };

  const resetRegraForm = () => {
    setRegraForm(DEFAULT_REGRA_FORM);
  };

  const openCreateForm = () => {
    if (showForm && !editingId) {
      setShowForm(false);
      resetForm();
      return;
    }
    setEditingId(null);
    resetForm();
    setShowForm(true);
  };

  const handleEditRestaurante = (rest: Restaurante) => {
    setEditingId(rest.restID);
    setFormData({
      name: rest.name,
      endereco: rest.endereco || '',
      contacto: rest.contacto || '',
      percentagem_gorjeta_base: parseFloat(String(rest.percentagem_gorjeta_base)).toFixed(2),
    });
    setShowForm(true);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleCancelForm = () => {
    setShowForm(false);
    setEditingId(null);
    resetForm();
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingId) return;

    try {
      await apiClient.updateRestaurante(editingId, {
        name: formData.name,
        endereco: formData.endereco || undefined,
        contacto: formData.contacto || undefined,
        percentagem_gorjeta_base: parseFloat(formData.percentagem_gorjeta_base),
      });

      setSuccess('Restaurante atualizado com sucesso.');
      setTimeout(() => setSuccess(''), 3000);
      handleCancelForm();
      await fetchRestaurantes();
    } catch (err) {
      setError('Erro ao atualizar restaurante.');
      console.error(err);
    }
  };

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      setError('');
      await apiClient.createRestaurante({
        name: formData.name,
        endereco: formData.endereco || undefined,
        contacto: formData.contacto || undefined,
        percentagem_gorjeta_base: parseFloat(formData.percentagem_gorjeta_base),
      });

      setSuccess('Restaurante criado com sucesso. Configure as regras abaixo.');
      setTimeout(() => setSuccess(''), 3000);
      handleCancelForm();
      await fetchRestaurantes();
    } catch (err: any) {
      setError(err.response?.data?.message || 'Erro ao criar restaurante.');
      console.error(err);
    }
  };

  const handleToggleActive = async (restID: number) => {
    try {
      await apiClient.toggleRestauranteActive(restID);
      setSuccess('Restaurante atualizado com sucesso.');
      setTimeout(() => setSuccess(''), 3000);
      await fetchRestaurantes();
    } catch (err) {
      setError('Erro ao atualizar restaurante.');
      console.error(err);
    }
  };

  const openCreateRegraEditor = (restID: number) => {
    setEditingRegra(null);
    resetRegraForm();
    setShowAddRegra(restID);
  };

  const openEditRegraEditor = (restID: number, regra: RegraDistribuicao) => {
    setEditingRegra({ restID, regraID: regra.id });
    setRegraForm({
      role_name: regra.role_name,
      calculation_type: regra.calculation_type,
      calculation_base: regra.calculation_base || 'VALOR_TOTAL_GORJETAS',
      rate: String(regra.rate),
      percent_mode:
        regra.percent_mode ||
        (regra.calculation_base === 'VALOR_TOTAL_GORJETAS'
          ? 'BASE_PERCENT_POINTS'
          : 'ABSOLUTE_PERCENT'),
      split_mode:
        regra.split_mode ||
        (regra.payment_source === 'ABSOLUTE_EXTERNAL'
          ? 'DIRECT_INPUT_ONLY'
          : normalizeRole(regra.role_name) === 'staff' ||
              normalizeRole(regra.role_name).includes('garcom')
            ? 'PROPORTIONAL_TO_POOL_INPUT'
            : 'EQUAL_SPLIT'),
      tipo_de_acerto: regra.tipo_de_acerto || 'DIARIO',
      payment_source: regra.payment_source,
      ordem: String(regra.ordem),
    });
    setShowAddRegra(restID);
  };

  const closeRegraEditor = () => {
    setShowAddRegra(null);
    setEditingRegra(null);
    resetRegraForm();
  };

  const handleSaveRegra = async (restID: number) => {
    try {
      const roleName = regraForm.role_name.trim();
      const rate = parseFloat(regraForm.rate);
      const ordem = parseInt(regraForm.ordem, 10);

      if (!roleName) {
        setError('Informe a funcao da regra.');
        return;
      }
      if (Number.isNaN(rate)) {
        setError('Informe um valor valido para a taxa.');
        return;
      }

      const payload: any = {
        role_name: roleName,
        calculation_type: regraForm.calculation_type,
        payment_source: regraForm.payment_source,
        rate,
        ordem: Number.isNaN(ordem) ? 0 : ordem,
        split_mode: regraForm.split_mode,
        tipo_de_acerto: regraForm.tipo_de_acerto,
      };

      if (regraForm.calculation_type === 'PERCENT') {
        payload.calculation_base = regraForm.calculation_base;
        payload.percent_mode = regraForm.percent_mode;
      } else {
        payload.calculation_base = null;
        payload.percent_mode = 'ABSOLUTE_PERCENT';
      }

      const isEditingThisRestaurant =
        editingRegra?.restID === restID && editingRegra?.regraID != null;

      if (isEditingThisRestaurant) {
        await apiClient.updateRegraDistribuicao(editingRegra!.regraID, restID, payload);
        setSuccess('Regra atualizada com sucesso.');
      } else {
        await apiClient.createRegraDistribuicao(restID, payload);
        setSuccess('Regra criada com sucesso.');
      }

      setTimeout(() => setSuccess(''), 3000);
      closeRegraEditor();
      await loadRegras(restID);
    } catch (err: any) {
      const backendMessage = err?.response?.data?.message;
      const parsedMessage = Array.isArray(backendMessage)
        ? backendMessage.join(' | ')
        : backendMessage;
      setError(parsedMessage || err?.message || 'Erro ao guardar regra.');
    }
  };

  const handleDeleteRegra = async (id: number, restID: number) => {
    if (!confirm('Remover esta regra?')) return;

    try {
      await apiClient.deleteRegraDistribuicao(id, restID);
      if (editingRegra?.regraID === id) {
        closeRegraEditor();
      }
      setSuccess('Regra removida.');
      setTimeout(() => setSuccess(''), 3000);
      await loadRegras(restID);
    } catch {
      setError('Erro ao remover regra.');
    }
  };

  const handleToggleRegraAtiva = async (regra: RegraDistribuicao, restID: number) => {
    try {
      await apiClient.updateRegraDistribuicao(regra.id, restID, {
        ativo: !regra.ativo,
      });
      setSuccess(regra.ativo ? 'Regra inativada.' : 'Regra ativada.');
      setTimeout(() => setSuccess(''), 3000);
      await loadRegras(restID);
    } catch {
      setError('Erro ao atualizar estado da regra.');
    }
  };

  if (authorized === null) {
    return (
      <Layout>
        <div className={styles.container}>
          <p className={styles.muted}>Verificando permissoes...</p>
        </div>
      </Layout>
    );
  }

  if (loading) {
    return (
      <Layout>
        <div className={styles.container}>
          <p className={styles.muted}>Carregando restaurantes...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Administracao</p>
            <h1 style={{ marginBottom: 0 }}>Restaurantes</h1>
            <p className={styles.subtitle}>
              Configuracao unificada por regras de distribuicao.
            </p>
          </div>
          <div className={styles.filters} style={{ alignItems: 'flex-end' }}>
            <button onClick={openCreateForm} className={styles.btnPrimary}>
              {showForm && !editingId ? 'Fechar formulario' : 'Novo restaurante'}
            </button>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {success && <div className={styles.info}>{success}</div>}

        {showForm && (
          <div className={styles.section} style={{ marginBottom: '20px' }}>
            <div className={styles.sectionHeader}>
              <div>
                <h2>{editingId ? 'Editar restaurante' : 'Novo restaurante'}</h2>
                <p>
                  {editingId
                    ? 'Altere os dados basicos do restaurante.'
                    : 'Crie o restaurante e depois configure as regras.'}
                </p>
              </div>
              <button onClick={handleCancelForm} className={styles.btnSecondary}>
                Cancelar
              </button>
            </div>

            <form onSubmit={editingId ? handleSubmit : handleCreate}>
              <div className={styles.inputRow}>
                <div className={styles.inputGroup}>
                  <label>Nome *</label>
                  <input
                    type="text"
                    required
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    placeholder="Ex: Restaurante Central"
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Endereco</label>
                  <input
                    type="text"
                    value={formData.endereco}
                    onChange={(e) => setFormData({ ...formData, endereco: e.target.value })}
                    placeholder="Rua, numero, cidade"
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Contacto</label>
                  <input
                    type="text"
                    value={formData.contacto}
                    onChange={(e) => setFormData({ ...formData, contacto: e.target.value })}
                    placeholder="Telefone ou email"
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Percentagem base (%)</label>
                  <input
                    type="number"
                    step="0.01"
                    required
                    value={formData.percentagem_gorjeta_base}
                    onChange={(e) =>
                      setFormData({ ...formData, percentagem_gorjeta_base: e.target.value })
                    }
                  />
                  <span className={styles.inlineMeta}>
                    Percentual total da gorjeta a distribuir
                  </span>
                </div>
              </div>

              <div
                className={styles.filters}
                style={{ marginTop: '20px', paddingTop: '16px', borderTop: '1px solid #e5e7eb' }}
              >
                <button type="submit" className={styles.btnSuccess}>
                  {editingId ? 'Atualizar restaurante' : 'Criar restaurante'}
                </button>
                <button type="button" onClick={handleCancelForm} className={styles.btnSecondary}>
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        )}

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Restaurantes ({restaurantes.length})</h2>
              <p>Expanda um restaurante para gerir as regras de distribuicao.</p>
            </div>
          </div>

          {restaurantes.length === 0 ? (
            <p className={styles.muted}>Nenhum restaurante cadastrado ainda.</p>
          ) : (
            <div>
              {restaurantes.map((rest) => {
                const isExpanded = expandedRestaurant === rest.restID;
                const regras = regrasMap[rest.restID] || [];
                const regrasAtivas = regras.filter((r) => r.ativo).length;
                const isRuleEditorOpen = showAddRegra === rest.restID;
                const isEditingRuleForRest =
                  editingRegra?.restID === rest.restID && editingRegra?.regraID != null;

                return (
                  <div
                    key={rest.restID}
                    className={rest.ativo ? styles.restaurantCard : styles.restaurantCardInactive}
                  >
                    <div className={styles.restaurantCardHeader}>
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div
                          style={{
                            display: 'flex',
                            alignItems: 'center',
                            gap: '10px',
                            flexWrap: 'wrap',
                          }}
                        >
                          <h3 style={{ margin: 0, fontSize: '18px', color: '#0f172a' }}>
                            {rest.name}
                          </h3>
                          <span
                            className={styles.chip}
                            style={{
                              background: rest.ativo ? '#dcfce7' : '#fef2f2',
                              color: rest.ativo ? '#166534' : '#991b1b',
                            }}
                          >
                            {rest.ativo ? 'Ativo' : 'Inativo'}
                          </span>
                        </div>

                        <div className={styles.restaurantCardMeta}>
                          <div className={styles.restaurantCardMetaItem}>
                            <span className={styles.restaurantCardMetaLabel}>Percentagem base</span>
                            <span className={styles.restaurantCardMetaValue}>
                              {parseFloat(String(rest.percentagem_gorjeta_base)).toFixed(2)}%
                            </span>
                          </div>
                          <div className={styles.restaurantCardMetaItem}>
                            <span className={styles.restaurantCardMetaLabel}>Endereco</span>
                            <span className={styles.restaurantCardMetaValue}>{rest.endereco || '-'}</span>
                          </div>
                          <div className={styles.restaurantCardMetaItem}>
                            <span className={styles.restaurantCardMetaLabel}>Contacto</span>
                            <span className={styles.restaurantCardMetaValue}>{rest.contacto || '-'}</span>
                          </div>
                          <div className={styles.restaurantCardMetaItem}>
                            <span className={styles.restaurantCardMetaLabel}>Regras</span>
                            <span className={styles.restaurantCardMetaValue}>
                              {regrasAtivas} ativas · {regras.length} total
                            </span>
                          </div>
                        </div>
                      </div>

                      <div className={styles.restaurantCardActions}>
                        <button
                          onClick={() => handleEditRestaurante(rest)}
                          className={styles.btnInfo}
                        >
                          Editar dados
                        </button>
                        <button
                          onClick={() => handleToggleActive(rest.restID)}
                          className={rest.ativo ? styles.btnWarning : styles.btnActivate}
                        >
                          {rest.ativo ? 'Desativar' : 'Ativar'}
                        </button>
                        <button
                          onClick={() => {
                            if (isExpanded) {
                              setExpandedRestaurant(null);
                              closeRegraEditor();
                            } else {
                              setExpandedRestaurant(rest.restID);
                              loadRegras(rest.restID);
                            }
                          }}
                          className={styles.btnPrimary}
                          style={{ fontSize: '13px', padding: '10px 14px' }}
                        >
                          {isExpanded ? 'Fechar' : 'Configurar regras'}
                        </button>
                      </div>
                    </div>

                    {isExpanded && (
                      <div className={styles.restaurantCardBody}>
                        <div className={styles.sectionHeader} style={{ marginBottom: '16px' }}>
                          <div>
                            <h4 style={{ margin: 0, fontSize: '15px', color: '#0f172a' }}>
                              Regras de distribuicao
                            </h4>
                            <p className={styles.metaText} style={{ marginTop: '4px' }}>
                              Configure cálculo, base de cálculo, fonte de pagamento e divisão por função.
                            </p>
                            <div
                              style={{
                                marginTop: '8px',
                                padding: '10px 12px',
                                borderRadius: '8px',
                                border: '1px solid #dbeafe',
                                background: '#eff6ff',
                                color: '#1e3a8a',
                                fontSize: '12px',
                                lineHeight: 1.45,
                                maxWidth: '760px',
                              }}
                            >
                              <strong>Guia rápido (conceitos financeiros)</strong>
                              <br />
                              <strong>Gorjetas percentuais:</strong> valores da taxa base do restaurante (ex: 12,5%) incluídos na conta.
                              <br />
                              <strong>Gorjetas diretas:</strong> valores dados diretamente ao colaborador, fora do pool percentual.
                              <br />
                              <strong>Valores externos:</strong> pagamentos fora do faturamento do restaurante.
                              <br />
                              <strong>Bases de cálculo:</strong> Faturamento Global (total do dia), Faturamento Gorjetado
                              (parte do faturamento que gerou gorjetas), Faturamento Líquido (Global - Gorjetas Percentuais)
                              e Gorjetas Percentuais (input do pool por colaborador).
                              <br />
                              <strong>Não gorjetado (conceito):</strong> Global - Gorjetado (valor informativo para clientes
                              que pedem a retirada da gorjeta da conta).
                              <br />
                              <strong>Regra importante:</strong> ao usar <em>Gorjetas percentuais (input do pool)</em> +
                              <em> Divisão proporcional ao input</em>, o cálculo é por colaborador (input-first): cada um recebe
                              sobre o próprio input do dia; sem input, recebe 0 nessa regra.
                              <br />
                              <strong>Fonte de pagamento:</strong> define de qual caixa o valor sai (TIP_POOL, FINANCEIRO ou EXTERNO).
                              <br />
                              <strong>Tipo de acerto:</strong> <em>Diario</em> indica que a função já recebe no dia a dia e entra como
                              recebido no Acerto Final; <em>Periodo</em> indica fechamento no fim do período.
                            </div>
                          </div>
                          <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                            <button
                              onClick={() => {
                                if (isRuleEditorOpen && !isEditingRuleForRest) {
                                  closeRegraEditor();
                                } else {
                                  openCreateRegraEditor(rest.restID);
                                }
                              }}
                              className={styles.btnPrimary}
                              style={{ fontSize: '13px', padding: '8px 14px' }}
                            >
                              {isRuleEditorOpen && !isEditingRuleForRest
                                ? 'Cancelar'
                                : 'Nova regra'}
                            </button>
                          </div>
                        </div>

                        {isRuleEditorOpen && (
                          <div
                            style={{
                              background: '#f8fafc',
                              border: '1px solid #e2e8f0',
                              borderRadius: '8px',
                              padding: '16px',
                              marginBottom: '16px',
                            }}
                          >
                            <h5 style={{ margin: '0 0 12px', fontSize: '14px' }}>
                              {isEditingRuleForRest ? 'Editar regra' : 'Nova regra'}
                            </h5>

                            <datalist id="known-roles-regras">
                              {knownRoles.map((r) => (
                                <option key={r} value={r} />
                              ))}
                            </datalist>

                            <div className={styles.ruleEditorGrid}>
                              <div>
                                <label
                                  style={{
                                    fontSize: '12px',
                                    fontWeight: 600,
                                    color: '#374151',
                                    display: 'block',
                                    marginBottom: '4px',
                                  }}
                                >
                                  Funcao *
                                </label>
                                <input
                                  type="text"
                                  list="known-roles-regras"
                                  placeholder="Ex: staff"
                                  value={regraForm.role_name}
                                  onChange={(e) =>
                                    setRegraForm({ ...regraForm, role_name: e.target.value })
                                  }
                                  style={{
                                    width: '100%',
                                    padding: '6px 8px',
                                    border: '1px solid #d1d5db',
                                    borderRadius: '6px',
                                    fontSize: '13px',
                                    boxSizing: 'border-box',
                                  }}
                                />
                              </div>

                              <div>
                                <label
                                  style={{
                                    fontSize: '12px',
                                    fontWeight: 600,
                                    color: '#374151',
                                    display: 'block',
                                    marginBottom: '4px',
                                  }}
                                >
                                  Tipo de calculo
                                </label>
                                <select
                                  value={regraForm.calculation_type}
                                  onChange={(e) =>
                                    setRegraForm({
                                      ...regraForm,
                                      calculation_type: e.target.value as CalculationType,
                                    })
                                  }
                                  style={{
                                    width: '100%',
                                    padding: '6px 8px',
                                    border: '1px solid #d1d5db',
                                    borderRadius: '6px',
                                    fontSize: '13px',
                                  }}
                                >
                                  {CALCULATION_TYPE_OPTIONS.map((opt) => (
                                    <option key={opt.value} value={opt.value}>
                                      {opt.label}
                                    </option>
                                  ))}
                                </select>
                              </div>

                              {regraForm.calculation_type === 'PERCENT' && (
                                <div>
                                  <label
                                    style={{
                                      fontSize: '12px',
                                      fontWeight: 600,
                                      color: '#374151',
                                      display: 'block',
                                      marginBottom: '4px',
                                    }}
                                  >
                                    Base de calculo
                                  </label>
                                  <select
                                    value={regraForm.calculation_base}
                                    onChange={(e) =>
                                      setRegraForm({
                                        ...regraForm,
                                        calculation_base: e.target.value as CalculationBase,
                                      })
                                    }
                                    style={{
                                      width: '100%',
                                      padding: '6px 8px',
                                      border: '1px solid #d1d5db',
                                      borderRadius: '6px',
                                      fontSize: '13px',
                                    }}
                                  >
                                    {CALCULATION_BASE_OPTIONS.map((opt) => (
                                      <option key={opt.value} value={opt.value}>
                                        {opt.label}
                                      </option>
                                    ))}
                                  </select>
                                </div>
                              )}

                              {regraForm.calculation_type === 'PERCENT' && (
                                <div>
                                  <label
                                    style={{
                                      fontSize: '12px',
                                      fontWeight: 600,
                                      color: '#374151',
                                      display: 'block',
                                      marginBottom: '4px',
                                    }}
                                  >
                                    Interpretação da %
                                  </label>
                                  <select
                                    value={regraForm.percent_mode}
                                    onChange={(e) =>
                                      setRegraForm({
                                        ...regraForm,
                                        percent_mode: e.target.value as PercentMode,
                                      })
                                    }
                                    style={{
                                      width: '100%',
                                      padding: '6px 8px',
                                      border: '1px solid #d1d5db',
                                      borderRadius: '6px',
                                      fontSize: '13px',
                                    }}
                                  >
                                    {PERCENT_MODE_OPTIONS.map((opt) => (
                                      <option key={opt.value} value={opt.value}>
                                        {opt.label}
                                      </option>
                                    ))}
                                  </select>
                                </div>
                              )}

                              <div>
                                <label
                                  style={{
                                    fontSize: '12px',
                                    fontWeight: 600,
                                    color: '#374151',
                                    display: 'block',
                                    marginBottom: '4px',
                                  }}
                                >
                                  {regraForm.calculation_type === 'PERCENT'
                                    ? regraForm.percent_mode === 'BASE_PERCENT_POINTS'
                                      ? 'Pontos da base (%) *'
                                      : 'Taxa (%) *'
                                    : 'Valor fixo (EUR) *'}
                                </label>
                                <input
                                  type="number"
                                  step="0.01"
                                  placeholder="0.00"
                                  value={regraForm.rate}
                                  onChange={(e) =>
                                    setRegraForm({ ...regraForm, rate: e.target.value })
                                  }
                                  style={{
                                    width: '100%',
                                    padding: '6px 8px',
                                    border: '1px solid #d1d5db',
                                    borderRadius: '6px',
                                    fontSize: '13px',
                                    boxSizing: 'border-box',
                                  }}
                                />
                              </div>

                              <div>
                                <label
                                  style={{
                                    fontSize: '12px',
                                    fontWeight: 600,
                                    color: '#374151',
                                    display: 'block',
                                    marginBottom: '4px',
                                  }}
                                >
                                  Fonte de pagamento
                                </label>
                                <select
                                  value={regraForm.payment_source}
                                  onChange={(e) =>
                                    setRegraForm({
                                      ...regraForm,
                                      payment_source: e.target.value as PaymentSource,
                                      split_mode:
                                        e.target.value === 'ABSOLUTE_EXTERNAL'
                                          ? 'DIRECT_INPUT_ONLY'
                                          : regraForm.split_mode === 'DIRECT_INPUT_ONLY'
                                            ? 'EQUAL_SPLIT'
                                            : regraForm.split_mode,
                                    })
                                  }
                                  style={{
                                    width: '100%',
                                    padding: '6px 8px',
                                    border: '1px solid #d1d5db',
                                    borderRadius: '6px',
                                    fontSize: '13px',
                                  }}
                                >
                                  {PAYMENT_SOURCE_OPTIONS.map((opt) => (
                                    <option key={opt.value} value={opt.value}>
                                      {opt.label}
                                    </option>
                                  ))}
                                </select>
                              </div>

                              <div>
                                <label
                                  style={{
                                    fontSize: '12px',
                                    fontWeight: 600,
                                    color: '#374151',
                                    display: 'block',
                                    marginBottom: '4px',
                                  }}
                                >
                                  Divisão por colaborador
                                </label>
                                <select
                                  value={regraForm.split_mode}
                                  onChange={(e) =>
                                    setRegraForm({
                                      ...regraForm,
                                      split_mode: e.target.value as EmployeeSplitMode,
                                    })
                                  }
                                  style={{
                                    width: '100%',
                                    padding: '6px 8px',
                                    border: '1px solid #d1d5db',
                                    borderRadius: '6px',
                                    fontSize: '13px',
                                  }}
                                >
                                  {SPLIT_MODE_OPTIONS.map((opt) => (
                                    <option key={opt.value} value={opt.value}>
                                      {opt.label}
                                    </option>
                                  ))}
                                </select>
                                <span className={styles.inlineMeta}>
                                  Igual: divide por todos da função. Proporcional: usa input do pool por colaborador
                                  (na base de gorjetas percentuais, calcula por colaborador e soma o total da regra).
                                  Direto: usa apenas o campo Direta/Absoluta. Percentual completo: aplica a taxa
                                  inteira para cada colaborador da função.
                                </span>
                              </div>

                              <div>
                                <label
                                  style={{
                                    fontSize: '12px',
                                    fontWeight: 600,
                                    color: '#374151',
                                    display: 'block',
                                    marginBottom: '4px',
                                  }}
                                >
                                  Tipo de acerto
                                </label>
                                <select
                                  value={regraForm.tipo_de_acerto}
                                  onChange={(e) =>
                                    setRegraForm({
                                      ...regraForm,
                                      tipo_de_acerto: e.target.value as SettlementType,
                                    })
                                  }
                                  style={{
                                    width: '100%',
                                    padding: '6px 8px',
                                    border: '1px solid #d1d5db',
                                    borderRadius: '6px',
                                    fontSize: '13px',
                                  }}
                                >
                                  {SETTLEMENT_TYPE_OPTIONS.map((opt) => (
                                    <option key={opt.value} value={opt.value}>
                                      {opt.label}
                                    </option>
                                  ))}
                                </select>
                                <span className={styles.inlineMeta}>
                                  Diario: considerado como recebido no Acerto Final. Periodo: acertado no fechamento do período.
                                </span>
                              </div>

                              <div>
                                <label
                                  style={{
                                    fontSize: '12px',
                                    fontWeight: 600,
                                    color: '#374151',
                                    display: 'block',
                                    marginBottom: '4px',
                                  }}
                                >
                                  Ordem
                                </label>
                                <input
                                  type="number"
                                  value={regraForm.ordem}
                                  onChange={(e) =>
                                    setRegraForm({ ...regraForm, ordem: e.target.value })
                                  }
                                  style={{
                                    width: '100%',
                                    padding: '6px 8px',
                                    border: '1px solid #d1d5db',
                                    borderRadius: '6px',
                                    fontSize: '13px',
                                    boxSizing: 'border-box',
                                  }}
                                />
                              </div>
                            </div>

                            <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                              <button
                                onClick={() => handleSaveRegra(rest.restID)}
                                className={styles.btnSuccess}
                                style={{ fontSize: '13px', padding: '8px 16px' }}
                                type="button"
                              >
                                {isEditingRuleForRest ? 'Atualizar regra' : 'Criar regra'}
                              </button>
                              <button
                                onClick={closeRegraEditor}
                                className={styles.btnSecondary}
                                style={{ fontSize: '13px', padding: '8px 16px' }}
                                type="button"
                              >
                                Cancelar
                              </button>
                            </div>
                          </div>
                        )}

                        {regras.length === 0 ? (
                          <p className={styles.muted} style={{ fontStyle: 'italic' }}>
                            Nenhuma regra configurada para este restaurante.
                          </p>
                        ) : (
                          <div className={styles.tableWrapper}>
                            <table className={styles.configTable}>
                              <thead>
                                <tr>
                                  <th>Funcao</th>
                                  <th>Tipo</th>
                                  <th>Base</th>
                                  <th>Modo %</th>
                                  <th>Divisão</th>
                                  <th>Acerto</th>
                                  <th>Taxa</th>
                                  <th>Fonte</th>
                                  <th>Ordem</th>
                                  <th>Estado</th>
                                  <th>Acoes</th>
                                </tr>
                              </thead>
                              <tbody>
                                {[...regras]
                                  .sort((a, b) => a.ordem - b.ordem)
                                  .map((r) => (
                                    <tr key={r.id} style={{ opacity: r.ativo ? 1 : 0.55 }}>
                                      <td style={{ fontWeight: 600 }}>{r.role_name}</td>
                                      <td>{formatTipoCalculo(r.calculation_type)}</td>
                                      <td className={styles.metaText}>
                                        {r.calculation_type === 'PERCENT'
                                          ? formatBaseCalculo(r.calculation_base)
                                          : 'Nao aplicavel'}
                                      </td>
                                      <td className={styles.metaText}>
                                        {r.calculation_type === 'PERCENT'
                                          ? formatModoPercentual(r.percent_mode || 'ABSOLUTE_PERCENT')
                                          : 'Nao aplicavel'}
                                      </td>
                                      <td className={styles.metaText}>
                                        {formatModoDivisao(r.split_mode || 'EQUAL_SPLIT')}
                                      </td>
                                      <td className={styles.metaText}>
                                        {formatTipoAcerto(r.tipo_de_acerto || 'DIARIO')}
                                      </td>
                                      <td>
                                        {r.calculation_type === 'PERCENT'
                                          ? r.percent_mode === 'BASE_PERCENT_POINTS'
                                            ? `${Number(r.rate).toFixed(2)} pts`
                                            : `${Number(r.rate).toFixed(2)}%`
                                          : `EUR ${Number(r.rate).toFixed(2)}`}
                                      </td>
                                      <td className={styles.metaText}>
                                        {formatFontePagamento(r.payment_source)}
                                      </td>
                                      <td>{r.ordem}</td>
                                      <td>
                                        <span
                                          className={styles.chip}
                                          style={{
                                            background: r.ativo ? '#dcfce7' : '#f3f4f6',
                                            color: r.ativo ? '#166534' : '#6b7280',
                                          }}
                                        >
                                          {r.ativo ? 'Ativa' : 'Inativa'}
                                        </span>
                                      </td>
                                      <td>
                                        <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
                                          <button
                                            onClick={() => openEditRegraEditor(rest.restID, r)}
                                            className={styles.btnInfo}
                                            style={{ padding: '4px 8px', fontSize: '12px' }}
                                            type="button"
                                          >
                                            Editar
                                          </button>
                                          <button
                                            onClick={() => handleToggleRegraAtiva(r, rest.restID)}
                                            className={styles.btnSecondary}
                                            style={{ padding: '4px 8px', fontSize: '12px' }}
                                            type="button"
                                          >
                                            {r.ativo ? 'Inativar' : 'Ativar'}
                                          </button>
                                          <button
                                            onClick={() => handleDeleteRegra(r.id, rest.restID)}
                                            className={styles.btnDanger}
                                            style={{ padding: '4px 8px', fontSize: '12px' }}
                                            type="button"
                                          >
                                            Remover
                                          </button>
                                        </div>
                                      </td>
                                    </tr>
                                  ))}
                              </tbody>
                            </table>
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}
