'use client';

import { useState, useEffect } from 'react';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';

interface Funcionario {
  funcID: number;
  name: string;
  contacto: string;
  funcao: string;
  ativo: boolean;
  restID: number;
}

interface Restaurante {
  restID: number;
  name: string;
}

const DEFAULT_FUNCOES = ['staff', 'garcom', 'cozinha', 'supervisor', 'chamador'];

const defaultFuncao = (options: string[] = DEFAULT_FUNCOES) =>
  options.length > 0 ? options[0] : 'staff';

export default function Funcionarios() {
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restID, setRestID] = useState<number | null>(null);
  const [funcoesDisponiveis, setFuncoesDisponiveis] = useState<string[]>(DEFAULT_FUNCOES);
  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    contacto: '',
    funcao: defaultFuncao(),
    restID: '',
    restIDs: [] as string[],
  });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingFuncaoName, setEditingFuncaoName] = useState<string>(''); // Store name+funcao for finding all instances
  const displayFuncao = (funcao: string) => {
    const role = (funcao || '').toLowerCase();
    if (role === 'garcom' || role === 'staff') return 'Staff';
    return funcao || '-';
  };

  useEffect(() => {
    loadRestaurant();
  }, []);

  useEffect(() => {
    if (restID) {
      fetchFuncionarios();
      loadFuncoes(restID);
    }
  }, [restID]);

  const loadRestaurant = async () => {
    try {
      const response = await apiClient.getRestaurantes(true);
      if (response.data && response.data.length > 0) {
        setRestaurantes(response.data);
        setRestID(response.data[0].restID);
        setFormData(prev => ({ ...prev, restID: response.data[0].restID.toString() }));
      } else {
        setError('Nenhum restaurante ativo encontrado. Crie um restaurante primeiro.');
      }
    } catch (err) {
      setError('Erro ao carregar restaurantes');
      console.error(err);
    }
  };

  const fetchFuncionarios = async () => {
    if (!restID) return;
    try {
      setLoading(true);
      setError('');
      const response = await apiClient.getFuncionarios(restID, true);
      setFuncionarios(response.data);
    } catch (err) {
      setError('Erro ao carregar funcionários');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const loadFuncoes = async (restauranteId: number) => {
    try {
      const response = await apiClient.getConfiguracoes(restauranteId);
      const fromConfigs = (response.data || [])
        .map((c: { funcao: string }) => (c.funcao || '').trim())
        .filter(Boolean);

      let merged = Array.from(new Set([...fromConfigs, ...DEFAULT_FUNCOES]));

      if (formData.funcao && !merged.includes(formData.funcao)) {
        merged = [...merged, formData.funcao];
      }

      setFuncoesDisponiveis(merged);
      setFormData((prev) => ({
        ...prev,
        funcao:
          prev.funcao && merged.includes(prev.funcao) ? prev.funcao : defaultFuncao(merged),
      }));
    } catch (err) {
      console.error('Erro ao carregar funções do restaurante', err);
      setFuncoesDisponiveis(DEFAULT_FUNCOES);
      setFormData((prev) => ({
        ...prev,
        funcao:
          prev.funcao && DEFAULT_FUNCOES.includes(prev.funcao)
            ? prev.funcao
            : defaultFuncao(DEFAULT_FUNCOES),
      }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    try {
      if (editingId && editingFuncaoName) {
        // EDITING MODE: Update existing funcionario(s)
        if (!formData.name) {
          setError('Nome é obrigatório');
          return;
        }

        if (formData.restIDs.length === 0) {
          setError('Selecione pelo menos um restaurante');
          return;
        }

        const currentRestaurants = formData.restIDs.map(id => parseInt(id));
        const [oldName, oldFuncao] = editingFuncaoName.split('|');
        const previousRestaurants: number[] = [];

        // Find ALL previous restaurants where this funcionario exists (same name + funcao)
        for (const rest of restaurantes) {
          try {
            const funcResponse = await apiClient.getFuncionarios(rest.restID, true);
            const found = funcResponse.data.find(
              (f: Funcionario) => f.name === oldName && f.funcao === oldFuncao
            );
            if (found) {
              previousRestaurants.push(rest.restID);
            }
          } catch (err) {
            // Continue
          }
        }

        // Restaurants to add (newly selected)
        const restaurantesToAdd = currentRestaurants.filter(r => !previousRestaurants.includes(r));
        
        // Restaurants to remove (were selected before, now unchecked)
        const restaurantesToRemove = previousRestaurants.filter(r => !currentRestaurants.includes(r));

        // Update existing records in restaurants that remain selected
        for (const restID of currentRestaurants.filter(r => previousRestaurants.includes(r))) {
          try {
            const funcResponse = await apiClient.getFuncionarios(restID, true);
            const funcInRest = funcResponse.data.find(
              (f: Funcionario) => f.name === oldName && f.funcao === oldFuncao
            );
            if (funcInRest) {
              await apiClient.updateFuncionario(funcInRest.funcID, {
                name: formData.name,
                contacto: formData.contacto,
                funcao: formData.funcao,
              });
            }
          } catch (err) {
            console.error(`Erro ao atualizar funcionário no restaurante ${restID}:`, err);
          }
        }

        // Add funcionario to new restaurants
        for (const restID of restaurantesToAdd) {
          try {
            await apiClient.createFuncionario({
              name: formData.name,
              contacto: formData.contacto,
              funcao: formData.funcao,
              restID: restID,
            });
          } catch (err) {
            console.error(`Erro ao adicionar funcionário ao restaurante ${restID}:`, err);
          }
        }

        // Delete funcionario from removed restaurants
        for (const restID of restaurantesToRemove) {
          try {
            const funcResponse = await apiClient.getFuncionarios(restID, true);
            const funcInRest = funcResponse.data.find(
              (f: Funcionario) => f.name === oldName && f.funcao === oldFuncao
            );
            if (funcInRest) {
              await apiClient.deleteFuncionario(funcInRest.funcID);
            }
          } catch (err) {
            console.error(`Erro ao remover funcionário do restaurante ${restID}:`, err);
          }
        }

      } else {
        // CREATING MODE: Create new funcionario(s)
        const selectedRests = formData.restIDs.length > 0 ? formData.restIDs : [];
        
        if (!selectedRests.length) {
          setError('Selecione pelo menos um restaurante');
          return;
        }

        if (!formData.name) {
          setError('Nome é obrigatório');
          return;
        }

        // Create funcionario in all selected restaurants
        for (const restID of selectedRests) {
          await apiClient.createFuncionario({
            name: formData.name,
            contacto: formData.contacto,
            funcao: formData.funcao,
            restID: parseInt(restID),
          });
        }
      }

      setFormData({
        name: '',
        contacto: '',
        funcao: defaultFuncao(funcoesDisponiveis),
        restID: restID?.toString() || '',
        restIDs: [],
      });
      setEditingId(null);
      setEditingFuncaoName('');
      setShowForm(false);
      await fetchFuncionarios();
    } catch (err: any) {
      const errorMsg = err.response?.data?.message || 'Erro ao salvar funcionário';
      setError(errorMsg);
      console.error(err);
    }
  };

  const handleEdit = async (func: Funcionario) => {
    setEditingId(func.funcID);
    setEditingFuncaoName(`${func.name}|${func.funcao}`); // Store identifier to find all instances
    setFuncoesDisponiveis((prev) =>
      prev.includes(func.funcao) ? prev : [...prev, func.funcao]
    );
    
    // Load all restaurants where this funcionario (same name + funcao) is assigned
    try {
      const restaurantesAssignados: string[] = [];
      
      // Check each restaurant to see if a funcionario with same name+funcao exists
      for (const rest of restaurantes) {
        try {
          const funcResponse = await apiClient.getFuncionarios(rest.restID, true);
          const found = funcResponse.data.find(
            (f: Funcionario) => f.name === func.name && f.funcao === func.funcao
          );
          if (found) {
            restaurantesAssignados.push(rest.restID.toString());
          }
        } catch (err) {
          // Continue checking other restaurants
        }
      }

      setFormData({
        name: func.name,
        contacto: func.contacto || '',
        funcao: func.funcao,
        restID: func.restID.toString(),
        restIDs: restaurantesAssignados.length > 0 ? restaurantesAssignados : [func.restID.toString()],
      });
    } catch (err) {
      console.error('Erro ao carregar restaurantes do funcionário:', err);
      setFormData({
        name: func.name,
        contacto: func.contacto || '',
        funcao: func.funcao,
        restID: func.restID.toString(),
        restIDs: [func.restID.toString()],
      });
    }
    
    setShowForm(true);
  };

  const handleDelete = async (funcID: number) => {
    if (confirm('Tem certeza que deseja deletar este funcionário?')) {
      try {
        await apiClient.deleteFuncionario(funcID);
        await fetchFuncionarios();
      } catch (err) {
        setError('Erro ao deletar funcionário');
        console.error(err);
      }
    }
  };

  const handleCancel = () => {
    setShowForm(false);
    setEditingId(null);
    setFormData({
      name: '',
      contacto: '',
      funcao: defaultFuncao(funcoesDisponiveis),
      restID: restID?.toString() || '',
      restIDs: [],
    });
  };

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Administração</p>
            <h1>Funcionários</h1>
            <p className={styles.subtitle}>
              Cadastre e mantenha o time de cada restaurante usando o mesmo visual do Financeiro.
            </p>
          </div>
          <div className={styles.filters}>
            <button
              onClick={() => setShowForm(!showForm)}
              className="btn btn-success"
            >
              {showForm ? 'Fechar formulário' : '+ Novo Funcionário'}
            </button>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}

        {restaurantes.length > 1 && (
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <div>
                <h2 style={{ margin: 0 }}>Filtro por restaurante</h2>
                <p className={styles.metaText}>
                  A lista e edição consideram o restaurante selecionado.
                </p>
              </div>
              <div className={styles.selectGroup}>
                <label>Restaurante</label>
                <select
                  value={restID || ''}
                  onChange={(e) => {
                    const newRestID = Number(e.target.value);
                    setRestID(newRestID);
                    setFormData(prev => ({ ...prev, restID: newRestID.toString() }));
                  }}
                >
                  {restaurantes.map((rest) => (
                    <option key={rest.restID} value={rest.restID}>
                      {rest.name}
                    </option>
                  ))}
                </select>
              </div>
            </div>
          </div>
        )}

        {showForm && (
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <div>
                <h2 style={{ margin: 0 }}>{editingId ? 'Editar' : 'Novo'} Funcionário</h2>
                <p className={styles.metaText}>Selecione restaurantes e defina função.</p>
              </div>
              <button onClick={handleCancel} className="btn btn-secondary">
                Cancelar
              </button>
            </div>

            <form onSubmit={handleSubmit}>
              <div className={styles.inputGroup}>
                <label>
                  Restaurante(s) *
                  {editingId && (
                    <span className={styles.metaText}> (onde este colaborador trabalha)</span>
                  )}
                </label>
                <div className={styles.summaryGridSmall}>
                  {restaurantes.map((rest) => {
                    const checked = formData.restIDs.includes(rest.restID.toString());
                    return (
                      <label
                        key={rest.restID}
                        className={styles.summaryCard}
                        style={{
                          borderColor: checked ? '#6366f1' : '#e5e7eb',
                          boxShadow: checked ? '0 4px 12px rgba(99,102,241,0.12)' : undefined,
                          cursor: 'pointer',
                          display: 'flex',
                          gap: '12px',
                          alignItems: 'center',
                        }}
                      >
                        <input
                          type="checkbox"
                          checked={checked}
                          onChange={(e) => {
                            if (e.target.checked) {
                              setFormData(prev => ({
                                ...prev,
                                restIDs: [...prev.restIDs, rest.restID.toString()],
                              }));
                            } else {
                              setFormData(prev => ({
                                ...prev,
                                restIDs: prev.restIDs.filter(id => id !== rest.restID.toString()),
                              }));
                            }
                          }}
                        />
                        <div>
                          <div className={styles.name}>{rest.name}</div>
                          <div className={styles.metaText}>ID: {rest.restID}</div>
                        </div>
                      </label>
                    );
                  })}
                </div>
                {formData.restIDs.length === 0 && (
                  <small className={styles.negative}>Selecione pelo menos um restaurante</small>
                )}
                {formData.restIDs.length > 0 && (
                  <small className={styles.positive}>
                    ✓ {formData.restIDs.length} restaurante(s) selecionado(s)
                  </small>
                )}
              </div>

              <div className={styles.inputRow}>
                <div className={styles.inputGroup}>
                  <label>Nome *</label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) =>
                      setFormData({ ...formData, name: e.target.value })
                    }
                    required
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Contacto</label>
                  <input
                    type="text"
                    value={formData.contacto}
                    onChange={(e) =>
                      setFormData({ ...formData, contacto: e.target.value })
                    }
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Função *</label>
                  <select
                    value={formData.funcao}
                    onChange={(e) =>
                      setFormData({ ...formData, funcao: e.target.value })
                    }
                    required
                  >
                    {funcoesDisponiveis.map((funcao) => (
                      <option key={funcao} value={funcao}>
                        {displayFuncao(funcao)}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className={styles.filters}>
                <button type="submit" className="btn btn-primary">
                  {editingId ? 'Atualizar' : 'Criar'}
                </button>
                <button
                  type="button"
                  onClick={handleCancel}
                  className="btn btn-secondary"
                >
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        )}

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2 style={{ margin: 0 }}>Equipe cadastrada</h2>
              <p className={styles.metaText}>
                Filtrado pelo restaurante selecionado. Inclui staff, gestores, supervisores e chamadores.
              </p>
            </div>
          </div>

          {loading ? (
            <p className={styles.muted}>Carregando...</p>
          ) : funcionarios.length === 0 ? (
            <p className={styles.muted}>Nenhum funcionário cadastrado.</p>
          ) : (
            <div className={styles.tableWrapper}>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Nome</th>
                    <th>Restaurante</th>
                    <th>Função</th>
                    <th>Contacto</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {funcionarios.map((func) => (
                    <tr key={func.funcID}>
                      <td className={styles.name}>{func.name}</td>
                      <td>{restaurantes.find(r => r.restID === func.restID)?.name || '-'}</td>
                      <td>{displayFuncao(func.funcao)}</td>
                      <td>{func.contacto || '-'}</td>
                      <td>
                        <div className={styles.filters}>
                          <button
                            onClick={() => handleEdit(func)}
                            className="btn btn-secondary"
                          >
                            Editar
                          </button>
                          <button
                            onClick={() => handleDelete(func.funcID)}
                            className="btn btn-danger"
                          >
                            Deletar
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
