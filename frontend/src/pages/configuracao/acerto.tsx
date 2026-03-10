import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../../components/Layout';
import { apiClient } from '../../lib/api';
import styles from '../../styles/financeiro-diario.module.css';
import { useSessionPageState } from '../../hooks/useSessionPageState';

interface ConfiguracaoAcerto {
  id: number;
  restID: number;
  funcao: string;
  base_calculo: string;
  valor_percentual: number | null;
  valor_absoluto: number | null;
  ativo: boolean;
}

interface Restaurante {
  restID: number;
  name: string;
}

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];

const baseCalculoLabel: Record<string, string> = {
  GORJETA_TOTAL: 'Percentual das gorjetas totais',
  FATURAMENTO_BASE: 'Percentual do faturamento base (11%)',
  ABSOLUTO: 'Valor fixo (R$)',
};

const normalizeError = (err: any, fallback: string) => {
  const message = err?.response?.data?.message;
  if (Array.isArray(message)) return message.join(', ');
  return message || fallback;
};

export default function ConfiguracaoAcertoPage() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [selectedRestID, setSelectedRestID] = useSessionPageState<number | null>(
    'acerto_selected_restID',
    null,
  );
  const [configuracoes, setConfiguracoes] = useState<ConfiguracaoAcerto[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);

  const [formData, setFormData] = useState({
    funcao: '',
    base_calculo: 'GORJETA_TOTAL',
    valor_percentual: '',
    valor_absoluto: '',
  });

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) {
          router.replace('/login');
          return;
        }

        const meRes = await apiClient.me();
        const role: string = meRes.data?.role || '';
        if (!ALLOWED_ROLES.includes(role)) {
          router.replace('/');
          return;
        }

        setAuthorized(true);

        const restRes = await apiClient.getRestaurantes(true);
        const rests: Restaurante[] = restRes.data || [];
        setRestaurantes(rests);

        if (rests.length === 0) {
          setError('Nenhum restaurante ativo encontrado.');
          setSelectedRestID(null);
          return;
        }

        const hasPersisted =
          selectedRestID != null && rests.some((rest) => rest.restID === selectedRestID);

        setSelectedRestID(hasPersisted ? selectedRestID : rests[0].restID);
      } catch {
        router.replace('/login');
      }
    };

    checkAuth();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (selectedRestID) {
      loadConfiguracoes(selectedRestID);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedRestID]);

  const loadConfiguracoes = async (restID: number) => {
    try {
      setLoading(true);
      setError('');
      const res = await apiClient.getConfiguracaoAcerto(restID);
      setConfiguracoes(res.data || []);
    } catch (err: any) {
      setError(normalizeError(err, 'Erro ao carregar configurações.'));
      setConfiguracoes([]);
    } finally {
      setLoading(false);
    }
  };

  const resetForm = () => {
    setFormData({
      funcao: '',
      base_calculo: 'GORJETA_TOTAL',
      valor_percentual: '',
      valor_absoluto: '',
    });
    setEditingId(null);
    setShowForm(false);
  };

  const handleFormChange = (field: keyof typeof formData, value: string) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const handleBaseCalculoChange = (value: string) => {
    setFormData((prev) => ({
      ...prev,
      base_calculo: value,
      valor_percentual: value === 'ABSOLUTO' ? '' : prev.valor_percentual,
      valor_absoluto: value === 'ABSOLUTO' ? prev.valor_absoluto : '',
    }));
  };

  const handleSaveConfiguracao = async () => {
    if (!selectedRestID) {
      setError('Selecione um restaurante para continuar.');
      return;
    }

    if (!formData.funcao.trim()) {
      setError('Nome da função é obrigatório.');
      return;
    }

    if (formData.base_calculo !== 'ABSOLUTO' && !formData.valor_percentual) {
      setError('Valor percentual é obrigatório.');
      return;
    }

    if (formData.base_calculo === 'ABSOLUTO' && !formData.valor_absoluto) {
      setError('Valor fixo é obrigatório.');
      return;
    }

    try {
      setSaving(true);
      setError('');
      setSuccess('');

      const data = {
        funcao: formData.funcao.trim(),
        base_calculo: formData.base_calculo,
        valor_percentual:
          formData.base_calculo !== 'ABSOLUTO' ? Number(formData.valor_percentual) : null,
        valor_absoluto: formData.base_calculo === 'ABSOLUTO' ? Number(formData.valor_absoluto) : null,
      };

      if (editingId) {
        await apiClient.updateConfiguracaoAcerto(editingId, data);
        setSuccess('Configuração atualizada.');
      } else {
        await apiClient.createConfiguracaoAcerto(selectedRestID, data);
        setSuccess('Configuração criada.');
      }

      await loadConfiguracoes(selectedRestID);
      resetForm();
    } catch (err: any) {
      setError(normalizeError(err, 'Erro ao salvar configuração.'));
    } finally {
      setSaving(false);
    }
  };

  const handleEdit = (config: ConfiguracaoAcerto) => {
    setFormData({
      funcao: config.funcao,
      base_calculo: config.base_calculo,
      valor_percentual: config.valor_percentual?.toString() || '',
      valor_absoluto: config.valor_absoluto?.toString() || '',
    });
    setEditingId(config.id);
    setShowForm(true);
    setError('');
    setSuccess('');
  };

  const handleDelete = async (id: number) => {
    if (!confirm('Tem certeza que deseja apagar esta configuração?')) return;

    try {
      setError('');
      setSuccess('');
      await apiClient.deleteConfiguracaoAcerto(id);
      if (selectedRestID) {
        await loadConfiguracoes(selectedRestID);
      }
      setSuccess('Configuração apagada.');
      if (editingId === id) {
        resetForm();
      }
    } catch (err: any) {
      setError(normalizeError(err, 'Erro ao apagar configuração.'));
    }
  };

  const resumo = useMemo(() => {
    const totais = {
      total: configuracoes.length,
      percentual: configuracoes.filter((c) => c.base_calculo !== 'ABSOLUTO').length,
      fixo: configuracoes.filter((c) => c.base_calculo === 'ABSOLUTO').length,
    };
    return totais;
  }, [configuracoes]);

  if (authorized === null) {
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
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Configuração</p>
            <h1>Acerto</h1>
            <p className={styles.subtitle}>
              Configure regras por função para calcular acertos com base em percentual ou valor fixo.
            </p>
          </div>
          <div className={styles.filters}>
            <button
              type="button"
              className={styles.btnSuccess}
              onClick={() => {
                setShowForm(true);
                setEditingId(null);
                setFormData({
                  funcao: '',
                  base_calculo: 'GORJETA_TOTAL',
                  valor_percentual: '',
                  valor_absoluto: '',
                });
              }}
              disabled={!selectedRestID}
            >
              + Nova configuração
            </button>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {success && <div className={styles.info}>{success}</div>}

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2 style={{ margin: 0 }}>Restaurante</h2>
              <p className={styles.metaText}>Selecione onde deseja gerir as regras.</p>
            </div>
            <div className={styles.selectGroup}>
              <label>Restaurante</label>
              <select
                value={selectedRestID || ''}
                onChange={(e) => setSelectedRestID(Number(e.target.value) || null)}
              >
                {restaurantes.map((rest) => (
                  <option key={rest.restID} value={rest.restID}>
                    {rest.name}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className={styles.summaryGridSmall}>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Regras totais</span>
              <span className={styles.summaryValue}>{resumo.total}</span>
            </div>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Regras percentuais</span>
              <span className={styles.summaryValue}>{resumo.percentual}</span>
            </div>
            <div className={styles.summaryCard}>
              <span className={styles.summaryLabel}>Regras fixas</span>
              <span className={styles.summaryValue}>{resumo.fixo}</span>
            </div>
          </div>
        </div>

        {showForm && (
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <div>
                <h2 style={{ margin: 0 }}>{editingId ? 'Editar configuração' : 'Nova configuração'}</h2>
                <p className={styles.metaText}>Defina a função e a base de cálculo.</p>
              </div>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={resetForm}
                disabled={saving}
              >
                Fechar
              </button>
            </div>

            <div className={styles.inputRow}>
              <div className={styles.inputGroup}>
                <label>Função</label>
                <input
                  type="text"
                  value={formData.funcao}
                  onChange={(e) => handleFormChange('funcao', e.target.value)}
                  placeholder="Ex: Garçom, Cozinha, Chamador"
                />
              </div>

              <div className={styles.selectGroup}>
                <label>Base de cálculo</label>
                <select
                  value={formData.base_calculo}
                  onChange={(e) => handleBaseCalculoChange(e.target.value)}
                >
                  <option value="GORJETA_TOTAL">{baseCalculoLabel.GORJETA_TOTAL}</option>
                  <option value="FATURAMENTO_BASE">{baseCalculoLabel.FATURAMENTO_BASE}</option>
                  <option value="ABSOLUTO">{baseCalculoLabel.ABSOLUTO}</option>
                </select>
              </div>

              {formData.base_calculo === 'ABSOLUTO' ? (
                <div className={styles.inputGroup}>
                  <label>Valor fixo (R$)</label>
                  <input
                    type="number"
                    step="0.01"
                    min="0"
                    value={formData.valor_absoluto}
                    onChange={(e) => handleFormChange('valor_absoluto', e.target.value)}
                    placeholder="0.00"
                  />
                </div>
              ) : (
                <div className={styles.inputGroup}>
                  <label>Percentual (%)</label>
                  <input
                    type="number"
                    step="0.01"
                    min="0"
                    max="100"
                    value={formData.valor_percentual}
                    onChange={(e) => handleFormChange('valor_percentual', e.target.value)}
                    placeholder="0.00"
                  />
                </div>
              )}
            </div>

            <div className={styles.filters}>
              <button
                type="button"
                className={styles.btnPrimary}
                onClick={handleSaveConfiguracao}
                disabled={saving}
              >
                {saving ? 'Salvando...' : editingId ? 'Atualizar' : 'Salvar'}
              </button>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={resetForm}
                disabled={saving}
              >
                Cancelar
              </button>
            </div>
          </div>
        )}

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2 style={{ margin: 0 }}>Configurações cadastradas</h2>
              <p className={styles.metaText}>Regras ativas de acerto por função.</p>
            </div>
          </div>

          {loading ? (
            <p className={styles.muted}>Carregando...</p>
          ) : configuracoes.length === 0 ? (
            <p className={styles.muted}>Nenhuma configuração cadastrada.</p>
          ) : (
            <div className={styles.tableWrapper}>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Função</th>
                    <th>Base de cálculo</th>
                    <th>Valor</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {configuracoes.map((config) => (
                    <tr key={config.id}>
                      <td className={styles.name}>{config.funcao}</td>
                      <td>{baseCalculoLabel[config.base_calculo] || config.base_calculo}</td>
                      <td>
                        {config.base_calculo === 'ABSOLUTO'
                          ? `R$ ${Number(config.valor_absoluto || 0).toFixed(2)}`
                          : `${Number(config.valor_percentual || 0).toFixed(2)}%`}
                      </td>
                      <td>
                        <div className={styles.filters}>
                          <button
                            type="button"
                            className={styles.btnInfo}
                            onClick={() => handleEdit(config)}
                          >
                            Editar
                          </button>
                          <button
                            type="button"
                            className={styles.btnDanger}
                            onClick={() => handleDelete(config.id)}
                          >
                            Apagar
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
      </div>
    </Layout>
  );
}
