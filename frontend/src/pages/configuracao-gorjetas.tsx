'use client';

import { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';

interface Configuracao {
  configID: number;
  funcao: string;
  percentagem: number;
  ativo: boolean;
}

interface Restaurante {
  restID: number;
  name: string;
  endereco?: string;
  contacto?: string;
  percentagem_gorjeta_base: number;
  ativo: boolean;
}

export default function ConfiguracaoGorjetas() {
  const [restID, setRestID] = useState<number | null>(null);
  const [configs, setConfigs] = useState<Configuracao[]>([]);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editValue, setEditValue] = useState('');
  const [showAddForm, setShowAddForm] = useState(false);
  const [newFuncao, setNewFuncao] = useState('');
  const [newPercentagem, setNewPercentagem] = useState('');
  const [showDeleteRestaurante, setShowDeleteRestaurante] = useState(false);
  const [restToDelete, setRestToDelete] = useState<number | null>(null);

  useEffect(() => {
    loadRestaurant();
  }, []);

  useEffect(() => {
    if (restID) {
      fetchConfigs();
    }
  }, [restID]);

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

  const fetchConfigs = async () => {
    if (!restID) return;
    try {
      setLoading(true);
      setError('');
      const response = await apiClient.getConfiguracoes(restID);
      setConfigs(response.data);
    } catch (err) {
      setError('Erro ao carregar configurações');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (config: Configuracao) => {
    setEditingId(config.configID);
    setEditValue(config.percentagem.toString());
  };

  const handleSave = async (configID: number) => {
    try {
      await apiClient.updateConfiguracao(configID, {
        percentagem: parseFloat(editValue),
      });
      setEditingId(null);
      setEditValue('');
      setSuccess('Configuração atualizada com sucesso!');
      setTimeout(() => setSuccess(''), 3000);
      await fetchConfigs();
    } catch (err) {
      setError('Erro ao salvar configuração');
      console.error(err);
    }
  };

  const handleCancel = () => {
    setEditingId(null);
    setEditValue('');
  };

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!newFuncao.trim() || !newPercentagem) {
      setError('Preencha a função e a percentagem');
      return;
    }

    try {
      await apiClient.createConfiguracao({
        restID: restID!,
        funcao: newFuncao.trim(),
        percentagem: parseFloat(newPercentagem),
      });
      setNewFuncao('');
      setNewPercentagem('');
      setShowAddForm(false);
      setSuccess('Função adicionada com sucesso!');
      setTimeout(() => setSuccess(''), 3000);
      await fetchConfigs();
    } catch (err: any) {
      const errorMsg = err.response?.data?.message || 'Erro ao adicionar função';
      setError(errorMsg);
      console.error(err);
    }
  };

  const handleDelete = async (configID: number) => {
    if (!confirm('Tem certeza que deseja remover esta função?')) {
      return;
    }

    try {
      await apiClient.deleteConfiguracao(configID);
      setSuccess('Função removida com sucesso!');
      setTimeout(() => setSuccess(''), 3000);
      await fetchConfigs();
    } catch (err) {
      setError('Erro ao remover função');
      console.error(err);
    }
  };

  const getTotalPercentagem = () => {
    return configs.reduce((acc, config) => acc + parseFloat(config.percentagem.toString()), 0);
  };

  const handleDeleteRestauranteConfirm = async () => {
    if (!restToDelete) return;

    const confirmMsg = `Tem certeza que deseja DELETAR o restaurante "${restaurantes.find(r => r.restID === restToDelete)?.name}"?\n\nEsta ação é irreversível e todas as configurações e dados associados serão removidos.`;
    
    if (!confirm(confirmMsg)) {
      return;
    }

    try {
      setLoading(true);
      await apiClient.deleteRestaurante(restToDelete);
      setSuccess('Restaurante deletado com sucesso!');
      setTimeout(() => {
        setShowDeleteRestaurante(false);
        setRestToDelete(null);
        loadRestaurant();
      }, 1000);
    } catch (err) {
      setError('Erro ao deletar restaurante');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout>
      <h1>Configuração de Distribuição de Gorjetas</h1>

      {error && <div className="alert alert-error">{error}</div>}
      {success && <div className="alert alert-success">{success}</div>}

      {loading ? (
        <div className="loading">Carregando...</div>
      ) : (
        <div>
          <p className="mb-4 text-muted">
            Configure as funções de colaboradores e a distribuição de gorjeta para cada função.
            A percentagem total deve corresponder à percentagem base do restaurante (normalmente 11%).
          </p>

          {configs.length > 0 && (
            <div style={{ marginBottom: '16px', padding: '12px', backgroundColor: '#ecf0f1', borderRadius: '4px' }}>
              <div className="flex-between">
                <strong>Total de Percentagem Configurada:</strong>
                <span style={{ fontSize: '18px', fontWeight: 'bold', color: getTotalPercentagem() === 11 ? 'green' : 'orange' }}>
                  {getTotalPercentagem().toFixed(2)}%
                </span>
              </div>
              {getTotalPercentagem() !== 11 && (
                <small style={{ color: 'orange', display: 'block', marginTop: '8px' }}>
                  ⚠️ Recomenda-se que o total seja 11% (ou a percentagem base configurada no restaurante)
                </small>
              )}
            </div>
          )}

          {configs.length === 0 ? (
            <div className="empty-state">
              <div className="empty-state-icon">⚙️</div>
              <p>Nenhuma função configurada. Adicione a primeira função para começar.</p>
            </div>
          ) : (
            <table style={{ marginBottom: '24px' }}>
              <thead>
                <tr>
                  <th>Função</th>
                  <th>Percentagem (%)</th>
                  <th>Status</th>
                  <th>Ações</th>
                </tr>
              </thead>
              <tbody>
                {configs.map((config) => (
                  <tr key={config.configID}>
                    <td>
                      <strong>{config.funcao}</strong>
                    </td>
                    <td>
                      {editingId === config.configID ? (
                        <input
                          type="number"
                          step="0.01"
                          value={editValue}
                          onChange={(e) => setEditValue(e.target.value)}
                          style={{ width: '100px' }}
                        />
                      ) : (
                        `${parseFloat(config.percentagem.toString()).toFixed(2)}%`
                      )}
                    </td>
                    <td>
                      {config.ativo ? (
                        <span style={{ color: 'green' }}>✓ Ativa</span>
                      ) : (
                        <span style={{ color: 'red' }}>✗ Inativa</span>
                      )}
                    </td>
                    <td>
                      {editingId === config.configID ? (
                        <div className="flex gap-2">
                          <button
                            onClick={() => handleSave(config.configID)}
                            className="btn btn-success"
                            style={{ fontSize: '12px', padding: '4px 8px' }}
                          >
                            Salvar
                          </button>
                          <button
                            onClick={handleCancel}
                            className="btn btn-secondary"
                            style={{ fontSize: '12px', padding: '4px 8px' }}
                          >
                            Cancelar
                          </button>
                        </div>
                      ) : (
                        <div className="flex gap-2">
                          <button
                            onClick={() => handleEdit(config)}
                            className="btn btn-primary"
                            style={{ fontSize: '12px', padding: '4px 8px' }}
                          >
                            Editar
                          </button>
                          <button
                            onClick={() => handleDelete(config.configID)}
                            className="btn btn-danger"
                            style={{ fontSize: '12px', padding: '4px 8px' }}
                          >
                            Remover
                          </button>
                        </div>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          <div style={{ marginBottom: '24px' }}>
            {!showAddForm ? (
              <button
                onClick={() => setShowAddForm(true)}
                className="btn btn-primary"
              >
                + Adicionar Nova Função
              </button>
            ) : (
              <div className="card">
                <h3>Adicionar Nova Função</h3>
                <form onSubmit={handleAdd}>
                  <div className="form-group">
                    <label>Nome da Função *</label>
                    <input
                      type="text"
                      placeholder="Ex: garcom, cozinha, douglas"
                      value={newFuncao}
                      onChange={(e) => setNewFuncao(e.target.value)}
                      required
                    />
                  </div>

                  <div className="form-group">
                    <label>Percentagem de Distribuição (%) *</label>
                    <input
                      type="number"
                      step="0.01"
                      placeholder="Ex: 7.00"
                      value={newPercentagem}
                      onChange={(e) => setNewPercentagem(e.target.value)}
                      required
                    />
                  </div>

                  <div className="flex gap-2">
                    <button type="submit" className="btn btn-success">
                      Adicionar
                    </button>
                    <button
                      type="button"
                      onClick={() => {
                        setShowAddForm(false);
                        setNewFuncao('');
                        setNewPercentagem('');
                      }}
                      className="btn btn-secondary"
                    >
                      Cancelar
                    </button>
                  </div>
                </form>
              </div>
            )}
          </div>

          <div className="mt-4 p-4" style={{ backgroundColor: '#ecf0f1', borderRadius: '4px' }}>
            <h3>Como funciona</h3>
            <ul style={{ marginLeft: '20px' }}>
              <li>A gorjeta total é calculada com base na percentagem base do restaurante (11%)</li>
              <li>Cada função recebe uma parte desta gorjeta conforme sua percentagem</li>
              <li>A soma de todas as percentagens deve resultar em 100% da gorjeta</li>
              <li>Exemplo: 7% garçom + 3% cozinha + 1% supervisor = 11% (100% da gorjeta de 11%)</li>
              <li>Você pode adicionar, editar ou remover funções conforme necessário</li>
            </ul>
          </div>

          {restID && (
            <div className="mt-4 p-4" style={{ backgroundColor: '#ecf0f1', borderRadius: '4px' }}>
              <h3>Como funciona</h3>
              <ul style={{ marginLeft: '20px' }}>
                <li>A gorjeta total é calculada com base na percentagem base do restaurante (11%)</li>
                <li>Cada função recebe uma parte desta gorjeta conforme sua percentagem</li>
                <li>A soma de todas as percentagens deve resultar em 100% da gorjeta</li>
                <li>Exemplo: 7% garçom + 3% cozinha + 1% supervisor = 11% (100% da gorjeta de 11%)</li>
                <li>Você pode adicionar, editar ou remover funções conforme necessário</li>
              </ul>
            </div>
          )}

          {restaurantes.length > 0 && (
            <div className="mt-4 p-4" style={{ backgroundColor: '#ffe6e6', borderRadius: '4px', border: '1px solid #ffcccc' }}>
              <h3 style={{ color: '#cc0000', marginTop: 0 }}>⚙️ Opções Avançadas (Oculto)</h3>
              <button
                onClick={() => setShowDeleteRestaurante(!showDeleteRestaurante)}
                className="btn"
                style={{
                  backgroundColor: '#cc0000',
                  color: 'white',
                  border: 'none',
                  borderRadius: '4px',
                  cursor: 'pointer',
                  padding: '8px 16px',
                  fontSize: '14px',
                }}
              >
                🗑️ Deletar Restaurante
              </button>

              {showDeleteRestaurante && (
                <div style={{ marginTop: '12px', padding: '12px', backgroundColor: '#fff', borderRadius: '4px', border: '2px solid #cc0000' }}>
                  <p style={{ color: '#cc0000', fontWeight: 'bold', margin: '0 0 12px 0' }}>
                    ⚠️ ATENÇÃO: Esta ação é irreversível!
                  </p>
                  <div className="form-group" style={{ marginBottom: '12px' }}>
                    <label>Selecione o Restaurante para Deletar:</label>
                    <select
                      value={restToDelete || ''}
                      onChange={(e) => setRestToDelete(Number(e.target.value) || null)}
                      style={{
                        padding: '8px',
                        borderRadius: '4px',
                        border: '1px solid #cc0000',
                        fontSize: '14px',
                        width: '100%',
                      }}
                    >
                      <option value="">-- Selecione um restaurante --</option>
                      {restaurantes.map((rest) => (
                        <option key={rest.restID} value={rest.restID}>
                          {rest.name} (Base: {rest.percentagem_gorjeta_base}%)
                        </option>
                      ))}
                    </select>
                  </div>
                  {restToDelete && (
                    <p style={{ margin: '0 0 12px 0', color: '#333' }}>
                      Ao deletar "<strong>{restaurantes.find(r => r.restID === restToDelete)?.name}</strong>", todos os dados associados (configurações, funcionários, transações) serão removidos permanentemente.
                    </p>
                  )}
                  <div style={{ display: 'flex', gap: '8px' }}>
                    <button
                      onClick={handleDeleteRestauranteConfirm}
                      disabled={!restToDelete || loading}
                      className="btn"
                      style={{
                        backgroundColor: restToDelete ? '#cc0000' : '#ccc',
                        color: 'white',
                        border: 'none',
                        borderRadius: '4px',
                        cursor: restToDelete ? 'pointer' : 'not-allowed',
                        padding: '8px 16px',
                        fontSize: '14px',
                        opacity: loading ? 0.5 : 1,
                      }}
                    >
                      {loading ? 'Deletando...' : '✓ Confirmar Exclusão'}
                    </button>
                    <button
                      onClick={() => {
                        setShowDeleteRestaurante(false);
                        setRestToDelete(null);
                      }}
                      className="btn btn-secondary"
                      style={{
                        padding: '8px 16px',
                        fontSize: '14px',
                      }}
                    >
                      ✕ Cancelar
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
      )}
    </Layout>
  );
}
