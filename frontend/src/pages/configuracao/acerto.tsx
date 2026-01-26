import React, { useState, useEffect } from 'react';
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

export default function ConfiguracaoAcertoPage() {
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [selectedRestID, setSelectedRestID] = useState<number | null>(null);
  const [configuracoes, setConfiguracoes] = useState<ConfiguracaoAcerto[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [showForm, setShowForm] = useState(false);

  // Form state
  const [formData, setFormData] = useState({
    funcao: '',
    base_calculo: 'GORJETA_TOTAL',
    valor_percentual: '',
    valor_absoluto: '',
  });

  // Carregar restaurantes
  useEffect(() => {
    const loadRestaurantes = async () => {
      try {
        const res = await apiClient.getRestaurantes(true);
        setRestaurantes(res.data);
        if (res.data.length > 0) {
          setSelectedRestID(res.data[0].restID);
        }
      } catch (err) {
        console.error('Erro ao carregar restaurantes:', err);
      }
    };
    loadRestaurantes();
  }, []);

  // Carregar configurações quando restaurante mudar
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
      setError('');
    } catch (err) {
      setError('Erro ao carregar configurações');
      setConfiguracoes([]);
    } finally {
      setLoading(false);
    }
  };

  const handleFormChange = (
    field: keyof typeof formData,
    value: string
  ) => {
    setFormData((prev) => ({
      ...prev,
      [field]: value,
    }));
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
    if (!formData.funcao.trim()) {
      setError('Nome da função é obrigatório');
      return;
    }

    if (formData.base_calculo !== 'ABSOLUTO' && !formData.valor_percentual) {
      setError('Valor percentual é obrigatório');
      return;
    }

    if (formData.base_calculo === 'ABSOLUTO' && !formData.valor_absoluto) {
      setError('Valor absoluto é obrigatório');
      return;
    }

    try {
      setLoading(true);
      const data = {
        funcao: formData.funcao,
        base_calculo: formData.base_calculo,
        valor_percentual:
          formData.base_calculo !== 'ABSOLUTO'
            ? parseFloat(formData.valor_percentual)
            : null,
        valor_absoluto:
          formData.base_calculo === 'ABSOLUTO'
            ? parseFloat(formData.valor_absoluto)
            : null,
      };

      if (editingId) {
        await apiClient.updateConfiguracaoAcerto(editingId, data);
      } else {
        await apiClient.createConfiguracaoAcerto(selectedRestID!, data);
      }

      await loadConfiguracoes();
      resetForm();
      setError('');
    } catch (err: any) {
      setError(
        err.response?.data?.message || 'Erro ao salvar configuração'
      );
    } finally {
      setLoading(false);
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
  };

  const handleDelete = async (id: number) => {
    if (confirm('Tem certeza que deseja deletar esta configuração?')) {
      try {
        await apiClient.deleteConfiguracaoAcerto(id);
        await loadConfiguracoes();
      } catch (err) {
        setError('Erro ao deletar configuração');
      }
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

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>Configuração de Acerto e Distribuição</h1>
      </div>

      <div className={styles.restauranteSelector}>
        <label>Selecione o Restaurante:</label>
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
            <h2>Distribuição de Gorjetas e Faturamento</h2>
            {!showForm && (
              <button
                className={styles.btnPrimary}
                onClick={() => setShowForm(true)}
              >
                + Adicionar Função
              </button>
            )}
          </div>

          {showForm && (
            <div className={styles.formCard}>
              <h3>{editingId ? 'Editar' : 'Adicionar'} Função</h3>

              <div className={styles.formGroup}>
                <label>Nome da Função:</label>
                <input
                  type="text"
                  value={formData.funcao}
                  onChange={(e) =>
                    handleFormChange('funcao', e.target.value)
                  }
                  placeholder="ex: Garçom, Cozinha, Chamador"
                />
              </div>

              <div className={styles.formGroup}>
                <label>Base de Cálculo:</label>
                <select
                  value={formData.base_calculo}
                  onChange={(e) =>
                    handleBaseCalculoChange(e.target.value)
                  }
                >
                  <option value="GORJETA_TOTAL">
                    Percentual das Gorjetas Totais
                  </option>
                  <option value="FATURAMENTO_BASE">
                    Percentual do Faturamento Base (11%)
                  </option>
                  <option value="ABSOLUTO">Valor Fixo (R$)</option>
                </select>
              </div>

              {formData.base_calculo !== 'ABSOLUTO' && (
                <div className={styles.formGroup}>
                  <label>Percentual (%):</label>
                  <input
                    type="number"
                    step="0.01"
                    min="0"
                    max="100"
                    value={formData.valor_percentual}
                    onChange={(e) =>
                      handleFormChange('valor_percentual', e.target.value)
                    }
                    placeholder="0.00"
                  />
                </div>
              )}

              {formData.base_calculo === 'ABSOLUTO' && (
                <div className={styles.formGroup}>
                  <label>Valor (R$):</label>
                  <input
                    type="number"
                    step="0.01"
                    min="0"
                    value={formData.valor_absoluto}
                    onChange={(e) =>
                      handleFormChange('valor_absoluto', e.target.value)
                    }
                    placeholder="0.00"
                  />
                </div>
              )}

              <div className={styles.formInfo}>
                <p>
                  <strong>Como funciona:</strong>
                </p>
                <ul>
                  <li>
                    <strong>Gorjeta Total:</strong> Recebe o % da soma de todas
                    as gorjetas do período
                  </li>
                  <li>
                    <strong>Faturamento Base:</strong> Recebe o % de 11% do
                    faturamento total
                  </li>
                  <li>
                    <strong>Valor Fixo:</strong> Recebe sempre o mesmo valor
                    (ex: R$ 50/dia)
                  </li>
                </ul>
              </div>

              <div className={styles.formActions}>
                <button
                  className={styles.btnPrimary}
                  onClick={handleSaveConfiguracao}
                  disabled={loading}
                >
                  {loading
                    ? 'Salvando...'
                    : editingId
                    ? 'Atualizar'
                    : 'Salvar'}
                </button>
                <button
                  className={styles.btnSecondary}
                  onClick={resetForm}
                  disabled={loading}
                >
                  Cancelar
                </button>
              </div>
            </div>
          )}

          <div className={styles.tableContainer}>
            {loading && !showForm ? (
              <div className={styles.loading}>Carregando...</div>
            ) : configuracoes.length > 0 ? (
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Função</th>
                    <th>Base de Cálculo</th>
                    <th>Valor</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {configuracoes.map((config) => (
                    <tr key={config.id}>
                      <td className={styles.funcao}>{config.funcao}</td>
                      <td>{config.base_calculo.replace(/_/g, ' ')}</td>
                      <td>
                        {config.base_calculo === 'ABSOLUTO'
                          ? `R$ ${config.valor_absoluto?.toFixed(2)}`
                          : `${config.valor_percentual?.toFixed(2)}%`}
                      </td>
                      <td className={styles.actions}>
                        <button
                          className={styles.btnEdit}
                          onClick={() => handleEdit(config)}
                        >
                          Editar
                        </button>
                        <button
                          className={styles.btnDelete}
                          onClick={() => handleDelete(config.id)}
                        >
                          Deletar
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : (
              <div className={styles.noData}>
                Nenhuma configuração criada. Clique em "Adicionar Função" para
                começar.
              </div>
            )}
          </div>
        </section>

        <section className={styles.infoSection}>
          <h2>Exemplo de Cálculo</h2>
          <div className={styles.example}>
            <h3>Cenário</h3>
            <ul>
              <li>Faturamento Total: R$ 5.000,00</li>
              <li>Gorjetas Totais: R$ 300,00</li>
              <li>Faturamento Base (11%): R$ 550,00</li>
            </ul>

            <h3>Com as configurações abaixo:</h3>
            <table className={styles.exampleTable}>
              <thead>
                <tr>
                  <th>Função</th>
                  <th>Base</th>
                  <th>Valor</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Garçom</td>
                  <td>Gorjeta Total</td>
                  <td>80%</td>
                </tr>
                <tr>
                  <td>Cozinha</td>
                  <td>Faturamento Base</td>
                  <td>50%</td>
                </tr>
                <tr>
                  <td>Chamador</td>
                  <td>Valor Fixo</td>
                  <td>R$ 50,00</td>
                </tr>
              </tbody>
            </table>

            <h3>Resultado:</h3>
            <ul>
              <li>
                <strong>Garçom:</strong> R$ 300,00 × 80% = <strong>R$ 240,00</strong>
              </li>
              <li>
                <strong>Cozinha:</strong> R$ 550,00 × 50% = <strong>R$ 275,00</strong>
              </li>
              <li>
                <strong>Chamador:</strong> <strong>R$ 50,00</strong> (fixo)
              </li>
            </ul>
          </div>
        </section>
      </div>
    </div>
  );
}
