'use client';

import { useEffect, useMemo, useState } from 'react';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';

interface Restaurante {
  restID: number;
  name: string;
}

interface User {
  id: number;
  name: string;
  email: string;
  role: string;
  restaurantes: { restID: number }[];
}

const roleLabel: Record<string, string> = {
  ADMIN: 'Admin',
  SUPERVISOR: 'Supervisor',
  GESTOR: 'Gestor',
};

export default function Usuarios() {
  const [users, setUsers] = useState<User[]>([]);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [selectedRests, setSelectedRests] = useState<number[]>([]);
  const [role, setRole] = useState('GESTOR');

  const fetchAll = async () => {
    try {
      setLoading(true);
      setError('');
      const [u, r] = await Promise.all([
        apiClient.getUsers(),
        apiClient.getRestaurantes(true),
      ]);
      setUsers(u.data || []);
      setRestaurantes(r.data || []);
    } catch (err: any) {
      const msg = err?.response?.data?.message || 'Erro ao carregar usuários';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAll();
  }, []);

  const handleSelectUser = (user: User) => {
    setSelectedUser(user);
    setSelectedRests(user.restaurantes?.map((r) => r.restID) || []);
    setRole(user.role);
    setSuccess('');
    setError('');
  };

  const toggleRest = (restID: number) => {
    setSelectedRests((prev) =>
      prev.includes(restID) ? prev.filter((id) => id !== restID) : [...prev, restID],
    );
  };

  const handleSave = async () => {
    if (!selectedUser) return;
    try {
      setLoading(true);
      setError('');
      await apiClient.updateUserRole(selectedUser.id, role);
      await apiClient.setUserRestaurants(selectedUser.id, selectedRests);
      setSuccess('Usuário atualizado');
      await fetchAll();
      // Refresh selected user object
      const updated = users.find((u) => u.id === selectedUser.id);
      if (updated) {
        setSelectedUser(updated);
      }
    } catch (err: any) {
      const msg = err?.response?.data?.message || 'Erro ao salvar usuário';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  const sortedUsers = useMemo(
    () => [...users].sort((a, b) => a.name.localeCompare(b.name)),
    [users],
  );

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Admin</p>
            <h1>Usuários</h1>
            <p className={styles.subtitle}>
              Admin define quais restaurantes cada gestor ou supervisor pode acessar. Admin tem acesso total por padrão.
            </p>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {success && <div className={styles.info}>{success}</div>}

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2 style={{ margin: 0 }}>Usuários cadastrados</h2>
              <p className={styles.metaText}>Selecione para editar role e restaurantes atribuídos.</p>
            </div>
          </div>
          {loading ? (
            <p className={styles.muted}>Carregando...</p>
          ) : (
            <div className={styles.tableWrapper}>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>Função</th>
                    <th>Restaurantes</th>
                    <th>Ação</th>
                  </tr>
                </thead>
                <tbody>
                  {sortedUsers.map((u) => (
                    <tr key={u.id}>
                      <td className={styles.name}>{u.name}</td>
                      <td>{u.email}</td>
                      <td>{roleLabel[u.role] || u.role}</td>
                      <td>
                        {u.role === 'ADMIN'
                          ? 'Todos'
                          : u.restaurantes?.map((r) => r.restID).join(', ') || '—'}
                      </td>
                      <td>
                        <button className="btn btn-secondary" onClick={() => handleSelectUser(u)}>
                          Editar
                        </button>
                      </td>
                    </tr>
                  ))}
                  {sortedUsers.length === 0 && (
                    <tr>
                      <td colSpan={5} className={styles.emptyCell}>
                        Nenhum usuário encontrado. Crie via /register com admin logado.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {selectedUser && (
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <div>
                <h2 style={{ margin: 0 }}>Editar {selectedUser.name}</h2>
                <p className={styles.metaText}>
                  Gestor deve ter 1 restaurante; Supervisor pode ter vários; Admin ignora seleção.
                </p>
              </div>
            </div>

            <div className={styles.inputRow}>
              <div className={styles.inputGroup}>
                <label>Função</label>
                <select value={role} onChange={(e) => setRole(e.target.value)}>
                  <option value="GESTOR">Gestor</option>
                  <option value="SUPERVISOR">Supervisor</option>
                  <option value="ADMIN">Admin</option>
                </select>
              </div>
              <div className={styles.inputGroup}>
                <label>Restaurantes atribuídos</label>
                <div className={styles.summaryGridSmall}>
                  {restaurantes.map((r) => {
                    const checked = selectedRests.includes(r.restID);
                    return (
                      <label
                        key={r.restID}
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
                          onChange={() => toggleRest(r.restID)}
                          disabled={role === 'ADMIN'}
                        />
                        <div>
                          <div className={styles.name}>{r.name}</div>
                          <div className={styles.metaText}>ID: {r.restID}</div>
                        </div>
                      </label>
                    );
                  })}
                </div>
              </div>
            </div>

            <div className={styles.filters}>
              <button className="btn btn-primary" onClick={handleSave} disabled={loading}>
                {loading ? 'Salvando...' : 'Salvar alterações'}
              </button>
              <button
                className="btn btn-secondary"
                onClick={() => setSelectedUser(null)}
              >
                Fechar
              </button>
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
}
