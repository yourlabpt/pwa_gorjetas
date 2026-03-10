'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';
import { useSessionPageState } from '../hooks/useSessionPageState';

interface Funcionario {
  funcID: number;
  name: string;
  contacto: string;
  funcao: string;
  data_admissao?: string | null;
  iban?: string | null;
  salario?: number | null;
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

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];

export default function Funcionarios() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restID, setRestID] = useSessionPageState<number | null>('restID', null);
  const [funcoesDisponiveis, setFuncoesDisponiveis] = useState<string[]>(DEFAULT_FUNCOES);
  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    contacto: '',
    funcao: defaultFuncao(),
    data_admissao: '',
    iban: '',
    salario: '',
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
  const formatDate = (value?: string | null) => {
    if (!value) return '-';
    const [year, month, day] = value.split('T')[0].split('-');
    if (!year || !month || !day) return '-';
    return `${day}/${month}/${year}`;
  };
  const buildFuncionarioPayload = () => ({
    name: formData.name.trim(),
    contacto: formData.contacto.trim() || undefined,
    funcao: formData.funcao,
    data_admissao: formData.data_admissao || undefined,
    iban: formData.iban.trim() || undefined,
    salario:
      formData.salario.trim() === '' ? undefined : Number(formData.salario),
  });
  const getMissingEmployeeData = (func: Funcionario) => {
    const missing: string[] = [];
    if (!func.data_admissao) missing.push('Data de Admissão');
    if (!func.iban) missing.push('IBAN');
    if (func.salario == null) missing.push('Salário');
    return missing;
  };

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
        const hasPersistedRestaurant =
          restID != null &&
          response.data.some((rest: Restaurante) => rest.restID === restID);
        const nextRestID = hasPersistedRestaurant ? restID : response.data[0].restID;
        setRestID(nextRestID);
        setFormData((prev) => ({ ...prev, restID: nextRestID.toString() }));
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
      const regrasRes = await apiClient.getRegrasDistribuicao(restauranteId, true);
      const fromRegras = (regrasRes.data || [])
        .map((r: { role_name?: string }) => (r.role_name || '').trim())
        .filter(Boolean);

      let merged = Array.from(new Set([...fromRegras, ...DEFAULT_FUNCOES])).sort((a, b) =>
        a.localeCompare(b, 'pt-PT', { sensitivity: 'base' }),
      );

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
      const payload = buildFuncionarioPayload();
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
                ...payload,
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
              ...payload,
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
            ...payload,
            restID: parseInt(restID),
          });
        }
      }

      setFormData({
        name: '',
        contacto: '',
        funcao: defaultFuncao(funcoesDisponiveis),
        data_admissao: '',
        iban: '',
        salario: '',
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
        data_admissao: func.data_admissao?.split('T')[0] || '',
        iban: func.iban || '',
        salario: func.salario != null ? String(func.salario) : '',
        restID: func.restID.toString(),
        restIDs: restaurantesAssignados.length > 0 ? restaurantesAssignados : [func.restID.toString()],
      });
    } catch (err) {
      console.error('Erro ao carregar restaurantes do funcionário:', err);
      setFormData({
        name: func.name,
        contacto: func.contacto || '',
        funcao: func.funcao,
        data_admissao: func.data_admissao?.split('T')[0] || '',
        iban: func.iban || '',
        salario: func.salario != null ? String(func.salario) : '',
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
      data_admissao: '',
      iban: '',
      salario: '',
      restID: restID?.toString() || '',
      restIDs: [],
    });
  };

  if (authorized === null) return <Layout><div className={styles.container}><p className={styles.muted}>Verificando permissões…</p></div></Layout>;

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
              type="button"
              onClick={() => setShowForm(!showForm)}
              className={styles.btnSuccess}
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
              <button type="button" onClick={handleCancel} className={styles.btnSecondary}>
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

              <div className={styles.inputRow}>
                <div className={styles.inputGroup}>
                  <label>Data de Admissão</label>
                  <input
                    type="date"
                    value={formData.data_admissao}
                    onChange={(e) =>
                      setFormData({ ...formData, data_admissao: e.target.value })
                    }
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>IBAN</label>
                  <input
                    type="text"
                    value={formData.iban}
                    onChange={(e) =>
                      setFormData({ ...formData, iban: e.target.value })
                    }
                    placeholder="PT50 0002 0123 1234 5678 9015 4"
                  />
                </div>
                <div className={styles.inputGroup}>
                  <label>Salário (€)</label>
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={formData.salario}
                    onChange={(e) =>
                      setFormData({ ...formData, salario: e.target.value })
                    }
                    placeholder="0.00"
                  />
                </div>
              </div>

              <p className={styles.metaText}>
                Campos novos podem ficar em branco temporariamente, mas devem ser completados.
              </p>

              <div className={styles.filters}>
                <button type="submit" className={styles.btnPrimary}>
                  {editingId ? 'Atualizar' : 'Criar'}
                </button>
                <button
                  type="button"
                  onClick={handleCancel}
                  className={styles.btnSecondary}
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
                Filtrado pelo restaurante selecionado. Inclui staff, gerentes, supervisores e chamadores.
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
                    <th>Data de Admissão</th>
                    <th>IBAN</th>
                    <th>Salário</th>
                    <th>Pendências</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {funcionarios.map((func) => {
                    const missingData = getMissingEmployeeData(func);
                    return (
                      <tr key={func.funcID}>
                        <td className={styles.name}>{func.name}</td>
                        <td>{restaurantes.find(r => r.restID === func.restID)?.name || '-'}</td>
                        <td>{displayFuncao(func.funcao)}</td>
                        <td>{func.contacto || '-'}</td>
                        <td>
                          {formatDate(func.data_admissao)}
                        </td>
                        <td>{func.iban || '-'}</td>
                        <td>
                          {func.salario != null
                            ? `€ ${Number(func.salario).toFixed(2)}`
                            : '-'}
                        </td>
                        <td>
                          {missingData.length > 0 ? (
                            <span className={styles.negative}>
                              Completar: {missingData.join(', ')}
                            </span>
                          ) : (
                            <span className={styles.positive}>Completo</span>
                          )}
                        </td>
                        <td>
                          <div className={styles.filters}>
                            <button
                              type="button"
                              onClick={() => handleEdit(func)}
                              className={styles.btnInfo}
                            >
                              Editar
                            </button>
                            <button
                              type="button"
                              onClick={() => handleDelete(func.funcID)}
                              className={styles.btnDanger}
                            >
                              Deletar
                            </button>
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}
