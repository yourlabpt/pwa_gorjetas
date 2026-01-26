import React, { useEffect, useState } from 'react';
import Layout from '../../components/Layout';
import { apiClient } from '../../lib/api';
import styles from '../../styles/configuracao-acerto.module.css';

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

export default function ConfiguracaoPage() {
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [selectedRestID, setSelectedRestID] = useState<number | null>(null);
  const [configuracoes, setConfiguracoes] = useState<ConfiguracaoAcerto[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const [formData, setFormData] = useState({
    staffPercent: '7.00',
    gestorPercent: '1.00',
    supervisorPercent: '0.50',
  });

  useEffect(() => {
    const loadRestaurantes = async () => {
      try {
        const res = await apiClient.getRestaurantes(true);
        setRestaurantes(res.data);
        if (res.data.length > 0) {
          setSelectedRestID(res.data[0].restID);
        }
      } catch (err) {
        setError('Erro ao carregar restaurantes');
      }
    };
    loadRestaurantes();
  }, []);

  useEffect(() => {
    if (selectedRestID) {
      loadConfiguracoes();
    }
  }, [selectedRestID]);

  const loadConfiguracoes = async () => {
    try {
      setLoading(true);
      const res = await apiClient.getConfiguracaoAcerto(selectedRestID!);
      setConfiguracoes(res.data);

      const byFuncao: Record<string, ConfiguracaoAcerto> = {};
      res.data.forEach((c: ConfiguracaoAcerto) => {
        byFuncao[c.funcao.toLowerCase()] = c;
      });

      setFormData({
        staffPercent: byFuncao['staff']?.valor_percentual?.toString() || '7.00',
        gestorPercent: byFuncao['gestor']?.valor_percentual?.toString() || '1.00',
        supervisorPercent: byFuncao['supervisor']?.valor_percentual?.toString() || '0.50',
      });
      setError('');
    } catch (err) {
      setError('Erro ao carregar configurações');
      setConfiguracoes([]);
    } finally {
      setLoading(false);
    }
  };

  const handleFormChange = (field: keyof typeof formData, value: string) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const upsertConfig = async (
    funcao: string,
    base_calculo: string,
    valor_percentual: number | null,
  ) => {
    const existing = configuracoes.find(
      (c) => c.funcao.toLowerCase() === funcao.toLowerCase(),
    );
    const payload = {
      funcao,
      base_calculo,
      valor_percentual,
      valor_absoluto: null,
    };

    if (existing) {
      await apiClient.updateConfiguracaoAcerto(existing.id, payload);
    } else {
      await apiClient.createConfiguracaoAcerto(selectedRestID!, payload);
    }
  };

  const handleSaveConfiguracao = async () => {
    if (!selectedRestID) {
      setError('Selecione um restaurante');
      return;
    }

    const staffPercent = parseFloat(formData.staffPercent) || 0;
    const gestorPercent = parseFloat(formData.gestorPercent) || 0;
    const supervisorPercent = parseFloat(formData.supervisorPercent) || 0;

    try {
      setLoading(true);
      await upsertConfig('staff', 'GORJETA_TOTAL', staffPercent);
      await upsertConfig('gestor', 'FATURAMENTO_BASE', gestorPercent);
      await upsertConfig('supervisor', 'FATURAMENTO_BASE', supervisorPercent);

      await loadConfiguracoes();
      setError('');
    } catch (err: any) {
      setError(err.response?.data?.message || 'Erro ao salvar configuração');
    } finally {
      setLoading(false);
    }
  };

  const getValue = (funcao: string) => {
    const found = configuracoes.find((c) => c.funcao.toLowerCase() === funcao);
    return found?.valor_percentual?.toFixed(2) || '--';
  };

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.header}>
          <h1>Configuração por Restaurante</h1>
          <p className={styles.subtitle}>
            Defina quanto cada tipo de colaborador recebe. Cozinha fica com o restante das gorjetas
            depois de staff + gestor + supervisor. Cada restaurante tem sua própria configuração.
          </p>
        </div>

        <div className={styles.restauranteSelector}>
          <label>Restaurante</label>
          <select
            value={selectedRestID || ''}
            onChange={(e) => setSelectedRestID(parseInt(e.target.value))}
          >
            {restaurantes.map((r) => (
              <option key={r.restID} value={r.restID}>
                {r.name}
              </option>
            ))}
          </select>
        </div>

        {error && <div className={styles.error}>{error}</div>}

        <div className={styles.mainContent}>
          <section className={styles.configSection}>
            <div className={styles.sectionHeader}>
              <h2>Distribuição por tipo de colaborador</h2>
            </div>

            <div className={styles.cardGrid}>
              <div className={styles.card}>
                <div className={styles.cardHeader}>
                  <div>
                    <p className={styles.kicker}>Pool de gorjetas</p>
                    <h3>Staff</h3>
                  </div>
                  <span className={styles.pill}>Base: % das gorjetas</span>
                </div>
                <p className={styles.cardText}>
                  Percentual do pool de gorjetas para todos os funcionários staff. Cozinha recebe o
                  restante depois de gestor/supervisor.
                </p>
                <label className={styles.inputLabel}>Percentual do pool (%)</label>
                <input
                  type="number"
                  step="0.1"
                  min="0"
                  value={formData.staffPercent}
                  onChange={(e) => handleFormChange('staffPercent', e.target.value)}
                  className={styles.input}
                />
                <div className={styles.helper}>
                  Soma desejada: igual à percentagem base de gorjeta (ex: 11%). O que faltar irá para a
                  cozinha.
                </div>
              </div>

              <div className={styles.card}>
                <div className={styles.cardHeader}>
                  <div>
                    <p className={styles.kicker}>Sobre faturamento sem gorjeta</p>
                    <h3>Gestor</h3>
                  </div>
                  <span className={styles.pill}>Base: faturamento - gorjeta</span>
                </div>
                <p className={styles.cardText}>
                  Percentual aplicado ao faturamento sem gorjeta. Recebe apenas se houver saldo no pool
                  após pagar o staff.
                </p>
                <label className={styles.inputLabel}>Percentual (%)</label>
                <input
                  type="number"
                  step="0.1"
                  min="0"
                  value={formData.gestorPercent}
                  onChange={(e) => handleFormChange('gestorPercent', e.target.value)}
                  className={styles.input}
                />
                <div className={styles.helper}>
                  Ex.: 1% do faturamento sem gorjeta, limitado ao saldo do pool depois do staff.
                </div>
              </div>

              <div className={styles.card}>
                <div className={styles.cardHeader}>
                  <div>
                    <p className={styles.kicker}>Sobre faturamento sem gorjeta</p>
                    <h3>Supervisor</h3>
                  </div>
                  <span className={styles.pill}>Base: faturamento - gorjeta</span>
                </div>
                <p className={styles.cardText}>
                  Percentual aplicado ao faturamento sem gorjeta. Recebe apenas se houver saldo no pool
                  após staff e gestor.
                </p>
                <label className={styles.inputLabel}>Percentual (%)</label>
                <input
                  type="number"
                  step="0.1"
                  min="0"
                  value={formData.supervisorPercent}
                  onChange={(e) => handleFormChange('supervisorPercent', e.target.value)}
                  className={styles.input}
                />
                <div className={styles.helper}>
                  Ex.: 0.5% do faturamento sem gorjeta, limitado ao saldo do pool.
                </div>
              </div>
            </div>

            <div className={styles.actions}>
              <button
                className={styles.btnPrimary}
                onClick={handleSaveConfiguracao}
                disabled={loading}
              >
                {loading ? 'Salvando...' : 'Salvar configuração'}
              </button>
            </div>

            <div className={styles.summary}>
              <div>
                <strong>Staff:</strong> {parseFloat(formData.staffPercent || '0').toFixed(2)}% do pool
              </div>
              <div>
                <strong>Gestor:</strong> {parseFloat(formData.gestorPercent || '0').toFixed(2)}% do
                faturamento sem gorjeta (limitado ao pool)
              </div>
              <div>
                <strong>Supervisor:</strong>{' '}
                {parseFloat(formData.supervisorPercent || '0').toFixed(2)}% do faturamento sem gorjeta
                (limitado ao pool)
              </div>
              <div className={styles.helper}>
                Cozinha: recebe o restante do pool após staff + gestor + supervisor.
              </div>
            </div>

            <div className={styles.summary} style={{ marginTop: '12px' }}>
              <div>
                <strong>Valores atuais gravados:</strong>
              </div>
              <div>Staff: {getValue('staff')}%</div>
              <div>Gestor: {getValue('gestor')}%</div>
              <div>Supervisor: {getValue('supervisor')}%</div>
            </div>
          </section>
        </div>
      </div>
    </Layout>
  );
}
