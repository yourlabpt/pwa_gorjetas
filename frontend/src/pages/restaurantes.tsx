'use client';

import { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';

interface Restaurante {
  restID: number;
  name: string;
  endereco?: string;
  contacto?: string;
  percentagem_gorjeta_base: number;
  ativo: boolean;
}

interface Configuracao {
  configID: number;
  funcao: string;
  percentagem: number;
  ativo: boolean;
}

interface FuncaoConfig {
  funcao: string;
  percentagem: string;
}

const formatFuncao = (funcao: string) => {
  const role = (funcao || '').toLowerCase();
  if (role === 'garcom' || role === 'staff') return 'Staff';
  return funcao || '-';
};

export default function Restaurantes() {
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [configuracoes, setConfiguracoes] = useState<Record<number, Configuracao[]>>({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [expandedRestaurant, setExpandedRestaurant] = useState<number | null>(null);
  const [editingConfigs, setEditingConfigs] = useState<number | null>(null);
  
  const [formData, setFormData] = useState({
    name: '',
    endereco: '',
    contacto: '',
    percentagem_gorjeta_base: '11.00',
  });

  const [configFuncoes, setConfigFuncoes] = useState<FuncaoConfig[]>([
    { funcao: 'staff', percentagem: '7.00' },
    { funcao: 'cozinha', percentagem: '3.00' },
    { funcao: 'supervisor', percentagem: '1.00' },
  ]);

  useEffect(() => {
    fetchRestaurantes();
  }, []);

  const fetchRestaurantes = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await apiClient.getRestaurantes();
      setRestaurantes(response.data);
      
      // Fetch configurations for each restaurant
      const configsMap: Record<number, Configuracao[]> = {};
      for (const rest of response.data) {
        try {
          const configResponse = await apiClient.getConfiguracoes(rest.restID);
          configsMap[rest.restID] = configResponse.data;
        } catch (err) {
          configsMap[rest.restID] = [];
        }
      }
      setConfiguracoes(configsMap);
    } catch (err) {
      setError('Erro ao carregar restaurantes');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      // Update existing restaurant
      await apiClient.updateRestaurante(editingId!, {
        name: formData.name,
        endereco: formData.endereco || undefined,
        contacto: formData.contacto || undefined,
        percentagem_gorjeta_base: parseFloat(formData.percentagem_gorjeta_base),
      });
      setSuccess('Restaurante atualizado com sucesso!');
      
      setTimeout(() => setSuccess(''), 3000);
      setEditingId(null);
      setShowForm(false);
      setFormData({
        name: '',
        endereco: '',
        contacto: '',
        percentagem_gorjeta_base: '11.00',
      });
      await fetchRestaurantes();
    } catch (err) {
      setError('Erro ao atualizar restaurante');
      console.error(err);
    }
  };

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      setError('');
      // Create new restaurant with default configurations
      const newRest = await apiClient.createRestaurante({
        name: formData.name,
        endereco: formData.endereco || undefined,
        contacto: formData.contacto || undefined,
        percentagem_gorjeta_base: parseFloat(formData.percentagem_gorjeta_base),
      });
      
      // Create default configurations for the new restaurant
      const defaultConfigs = [
        { funcao: 'staff', percentagem: '7.00' },
        { funcao: 'cozinha', percentagem: '3.00' },
        { funcao: 'supervisor', percentagem: '1.00' },
      ];
      
      for (const config of defaultConfigs) {
        try {
          await apiClient.createConfiguracao({
            restID: newRest.data.restID,
            funcao: config.funcao,
            percentagem: parseFloat(config.percentagem),
          });
        } catch (err) {
          console.error(`Erro ao criar configuração ${config.funcao}:`, err);
        }
      }
      
      setSuccess('Restaurante criado com sucesso!');
      setTimeout(() => setSuccess(''), 3000);
      setShowForm(false);
      setFormData({
        name: '',
        endereco: '',
        contacto: '',
        percentagem_gorjeta_base: '11.00',
      });
      await fetchRestaurantes();
    } catch (err: any) {
      const errorMsg = err.response?.data?.message || 'Erro ao criar restaurante';
      setError(errorMsg);
      console.error(err);
    }
  };

  const handleEdit = (rest: Restaurante) => {
    setEditingId(rest.restID);
    setFormData({
      name: rest.name,
      endereco: rest.endereco || '',
      contacto: rest.contacto || '',
      percentagem_gorjeta_base: parseFloat(rest.percentagem_gorjeta_base as any).toFixed(2),
    });
    setShowForm(true);
    setEditingConfigs(null);
  };

  const handleCancel = () => {
    setShowForm(false);
    setEditingConfigs(null);
    setEditingId(null);
    setFormData({
      name: '',
      endereco: '',
      contacto: '',
      percentagem_gorjeta_base: '11.00',
    });
    setConfigFuncoes([
      { funcao: 'staff', percentagem: '7.00' },
      { funcao: 'cozinha', percentagem: '3.00' },
      { funcao: 'supervisor', percentagem: '1.00' },
    ]);
  };

  const handleToggleActive = async (restID: number) => {
    try {
      await apiClient.toggleRestauranteActive(restID);
      setSuccess('Restaurante atualizado com sucesso!');
      setTimeout(() => setSuccess(''), 3000);
      await fetchRestaurantes();
    } catch (err) {
      setError('Erro ao atualizar restaurante');
      console.error(err);
    }
  };

  const handleSaveConfigs = async (restID: number) => {
    try {
      // Get existing configurations
      const existingConfigs = configuracoes[restID] || [];
      
      // Delete removed configurations
      for (const existing of existingConfigs) {
        const stillExists = configFuncoes.some(c => c.funcao === existing.funcao);
        if (!stillExists) {
          await apiClient.deleteConfiguracao(existing.configID);
        }
      }
      
      // Update or create configurations
      for (const config of configFuncoes) {
        if (!config.funcao.trim() || !config.percentagem) continue;
        
        const existing = existingConfigs.find(c => c.funcao === config.funcao);
        if (existing) {
          // Update existing
          await apiClient.updateConfiguracao(existing.configID, {
            percentagem: parseFloat(config.percentagem),
          });
        } else {
          // Create new
          await apiClient.createConfiguracao({
            restID,
            funcao: config.funcao.trim(),
            percentagem: parseFloat(config.percentagem),
          });
        }
      }
      
      setSuccess('Configurações salvas com sucesso!');
      setTimeout(() => setSuccess(''), 3000);
      setEditingConfigs(null);
      await fetchRestaurantes();
    } catch (err) {
      setError('Erro ao salvar configurações');
      console.error(err);
    }
  };

  const getTotalPercentagem = (configs: FuncaoConfig[] = configFuncoes) => {
    return configs.reduce((acc, config) => acc + parseFloat(config.percentagem || '0'), 0);
  };

  const addFuncaoConfig = () => {
    setConfigFuncoes([...configFuncoes, { funcao: '', percentagem: '' }]);
  };

  const removeFuncaoConfig = (index: number) => {
    setConfigFuncoes(configFuncoes.filter((_, i) => i !== index));
  };

  const updateFuncaoConfig = (index: number, field: 'funcao' | 'percentagem', value: string) => {
    const updated = [...configFuncoes];
    updated[index][field] = value;
    setConfigFuncoes(updated);
  };

  if (loading) return <Layout>Carregando...</Layout>;

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Administração</p>
            <h1>Restaurantes</h1>
            <p className={styles.subtitle}>
              Gerencie dados básicos e percentuais de distribuição por restaurante.
            </p>
          </div>
          <div className={styles.filters}>
            <button
              onClick={() => setShowForm(!showForm)}
              className="btn btn-primary"
            >
              {showForm ? 'Fechar formulário' : '+ Novo Restaurante'}
            </button>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {success && <div className={styles.info}>{success}</div>}

        {showForm && (
          <div className={styles.section} style={{ marginBottom: '16px' }}>
            <div className={styles.sectionHeader}>
              <div>
                <h2>{editingId ? 'Editar Restaurante' : 'Novo Restaurante'}</h2>
                <p>Dados básicos e percentagem base de gorjeta.</p>
              </div>
              <button onClick={handleCancel} className="btn btn-secondary">
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
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Endereço</label>
                  <input
                    type="text"
                    value={formData.endereco}
                    onChange={(e) => setFormData({ ...formData, endereco: e.target.value })}
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Contacto</label>
                  <input
                    type="text"
                    value={formData.contacto}
                    onChange={(e) => setFormData({ ...formData, contacto: e.target.value })}
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Percentagem Base (%) *</label>
                  <input
                    type="number"
                    step="0.01"
                    required
                    value={formData.percentagem_gorjeta_base}
                    onChange={(e) => setFormData({ ...formData, percentagem_gorjeta_base: e.target.value })}
                  />
                  <small className={styles.metaText}>
                    Percentual total de gorjeta a ser distribuído (ex: 11%)
                  </small>
                </div>
              </div>

              {!editingId && (
                <div className={styles.notice}>
                  As funções padrão (staff 7%, cozinha 3%, supervisor 1%) serão criadas automaticamente.
                </div>
              )}

              <div className={styles.filters}>
                <button type="submit" className="btn btn-success">
                  {editingId ? 'Atualizar Restaurante' : 'Criar Restaurante'}
                </button>
                <button type="button" onClick={handleCancel} className="btn btn-secondary">
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        )}

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Lista de Restaurantes ({restaurantes.length})</h2>
              <p>Expanda para ver configurações e ajustar percentuais.</p>
            </div>
          </div>

          {restaurantes.length === 0 ? (
            <p className={styles.muted}>Nenhum restaurante criado ainda.</p>
          ) : (
            <div className={styles.summaryGrid}>
              {restaurantes.map((rest) => (
                <div
                  key={rest.restID}
                  className={styles.summaryCard}
                  style={{ backgroundColor: rest.ativo ? '#fff' : '#f9fafb' }}
                >
                  <div className={styles.sectionHeader} style={{ marginBottom: '8px' }}>
                    <div>
                      <h3 style={{ margin: 0 }}>{rest.name}</h3>
                      <p className={styles.metaText}>
                        Percentagem Base: {parseFloat(rest.percentagem_gorjeta_base as any).toFixed(2)}%
                      </p>
                      <p className={styles.metaText}>Endereço: {rest.endereco || '-'}</p>
                      <p className={styles.metaText}>Contacto: {rest.contacto || '-'}</p>
                    </div>
                    <div className={styles.filters}>
                      <span className={styles.chip} style={{ background: rest.ativo ? '#e0f7e9' : '#fdecea', color: rest.ativo ? '#0f9d58' : '#d93025' }}>
                        {rest.ativo ? 'Ativo' : 'Inativo'}
                      </span>
                      <button
                        onClick={() => setExpandedRestaurant(expandedRestaurant === rest.restID ? null : rest.restID)}
                        className="btn btn-primary"
                      >
                        {expandedRestaurant === rest.restID ? 'Fechar' : 'Detalhes'}
                      </button>
                    </div>
                  </div>

                  <div className={styles.filters} style={{ marginBottom: '10px' }}>
                    <button onClick={() => handleEdit(rest)} className="btn btn-info">
                      Editar dados
                    </button>
                    <button
                      onClick={() => handleToggleActive(rest.restID)}
                      className="btn"
                      style={{ backgroundColor: rest.ativo ? '#f59e0b' : '#10b981', color: '#fff' }}
                    >
                      {rest.ativo ? 'Desativar' : 'Ativar'}
                    </button>
                  </div>

                  {expandedRestaurant === rest.restID && (
                    <div className={styles.section} style={{ marginTop: '10px' }}>
                      <div className={styles.sectionHeader}>
                        <div>
                          <h4 style={{ margin: 0 }}>Configuração de Funções</h4>
                          <p className={styles.metaText}>
                            Percentuais por função para {rest.name}.
                          </p>
                        </div>
                        {editingConfigs !== rest.restID && (
                          <button
                            onClick={() => {
                              setEditingConfigs(rest.restID);
                              setConfigFuncoes(
                                (configuracoes[rest.restID] || []).map(c => ({
                                  funcao: c.funcao,
                                  percentagem: c.percentagem.toString(),
                                }))
                              );
                            }}
                            className="btn btn-secondary"
                          >
                            Editar configurações
                          </button>
                        )}
                      </div>

                      {editingConfigs === rest.restID ? (
                        <div>
                          <div className={styles.summaryCard} style={{ marginBottom: '12px' }}>
                            <div className={styles.sectionHeader} style={{ marginBottom: 0 }}>
                              <strong>Total: {getTotalPercentagem().toFixed(2)}%</strong>
                              {getTotalPercentagem() !== parseFloat(formData.percentagem_gorjeta_base) && (
                                <small className={styles.muted}>
                                  Deve somar {formData.percentagem_gorjeta_base}%
                                </small>
                              )}
                            </div>
                          </div>

                          {configFuncoes.map((config, index) => (
                            <div key={index} className={styles.inputRow} style={{ marginBottom: '8px' }}>
                              <div className={styles.inputGroup}>
                                <label>Função</label>
                                <input
                                  type="text"
                                  placeholder="Ex: staff (antigo garçom)"
                                  value={config.funcao}
                                  onChange={(e) => updateFuncaoConfig(index, 'funcao', e.target.value)}
                                />
                              </div>
                              <div className={styles.inputGroup}>
                                <label>Percentagem (%)</label>
                                <input
                                  type="number"
                                  step="0.01"
                                  placeholder="7.00"
                                  value={config.percentagem}
                                  onChange={(e) => updateFuncaoConfig(index, 'percentagem', e.target.value)}
                                />
                              </div>
                              {configFuncoes.length > 1 && (
                                <div className={styles.inputGroup}>
                                  <label>&nbsp;</label>
                                  <button
                                    type="button"
                                    onClick={() => removeFuncaoConfig(index)}
                                    className="btn btn-danger"
                                  >
                                    Remover
                                  </button>
                                </div>
                              )}
                            </div>
                          ))}

                          <button
                            type="button"
                            onClick={addFuncaoConfig}
                            className="btn btn-secondary"
                            style={{ marginBottom: '12px' }}
                          >
                            + Adicionar Função
                          </button>

                          <div className={styles.filters}>
                            <button
                              onClick={() => handleSaveConfigs(rest.restID)}
                              className="btn btn-success"
                            >
                              ✓ Salvar
                            </button>
                            <button
                              onClick={() => {
                                setEditingConfigs(null);
                                setConfigFuncoes([]);
                              }}
                              className="btn btn-secondary"
                            >
                              ✕ Cancelar
                            </button>
                          </div>
                        </div>
                      ) : (
                        <div className={styles.tableWrapper}>
                          <table className={styles.table}>
                            <thead>
                              <tr>
                                <th>Função</th>
                                <th>Percentagem</th>
                              </tr>
                            </thead>
                            <tbody>
                              {(configuracoes[rest.restID] || []).map((config) => (
                                <tr key={config.configID}>
                                  <td>{formatFuncao(config.funcao)}</td>
                                  <td>{parseFloat(config.percentagem.toString()).toFixed(2)}%</td>
                                </tr>
                              ))}
                              {(configuracoes[rest.restID] || []).length === 0 && (
                                <tr>
                                  <td colSpan={2} className={styles.emptyCell}>
                                    Nenhuma configuração cadastrada.
                                  </td>
                                </tr>
                              )}
                            </tbody>
                          </table>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}
