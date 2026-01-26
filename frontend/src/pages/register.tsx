'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import styles from '../styles/financeiro-diario.module.css';
import { apiClient } from '../lib/api';

interface Restaurante {
  restID: number;
  name: string;
}

export default function RegisterPage() {
  const router = useRouter();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState('GESTOR');
  const [restaurants, setRestaurants] = useState<Restaurante[]>([]);
  const [selected, setSelected] = useState<number[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [info, setInfo] = useState('');

  useEffect(() => {
    const loadRestaurants = async () => {
      try {
        const res = await apiClient.getRestaurantes(true);
        setRestaurants(res.data || []);
      } catch {
        setInfo('Faça login como supervisor/admin para listar restaurantes ao criar usuários.');
      }
    };
    loadRestaurants();
  }, []);

  const toggleRest = (restID: number) => {
    setSelected((prev) =>
      prev.includes(restID) ? prev.filter((id) => id !== restID) : [...prev, restID],
    );
  };

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      await apiClient.register({
        name,
        email,
        password,
        role,
        restaurantIds: selected,
      });
      router.push('/financeiro-diario');
    } catch (err: any) {
      const msg = err?.response?.data?.message || 'Erro ao criar usuário';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Acesso</p>
            <h1>Novo usuário</h1>
            <p className={styles.subtitle}>
              Crie gestores ou supervisores. Gestor acessa um restaurante; supervisor pode ver vários.
            </p>
          </div>
        </div>

        <div className={styles.section} style={{ maxWidth: 720 }}>
          {error && <div className={styles.error}>{error}</div>}
          {info && <div className={styles.info}>{info}</div>}
          <form onSubmit={handleRegister}>
            <div className={styles.inputRow}>
              <div className={styles.inputGroup}>
                <label>Nome</label>
                <input value={name} onChange={(e) => setName(e.target.value)} required />
              </div>
              <div className={styles.inputGroup}>
                <label>E-mail</label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>
              <div className={styles.inputGroup}>
                <label>Senha</label>
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  minLength={6}
                />
              </div>
              <div className={styles.inputGroup}>
                <label>Função</label>
                <select value={role} onChange={(e) => setRole(e.target.value)}>
                  <option value="GESTOR">Gestor</option>
                  <option value="SUPERVISOR">Supervisor</option>
                  <option value="ADMIN">Admin</option>
                </select>
              </div>
            </div>

            <div className={styles.inputGroup}>
              <label>Restaurantes atribuídos</label>
              {restaurants.length === 0 ? (
                <p className={styles.muted}>Nenhum restaurante carregado.</p>
              ) : (
                <div className={styles.summaryGridSmall}>
                  {restaurants.map((r) => {
                    const checked = selected.includes(r.restID);
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
                        />
                        <div>
                          <div className={styles.name}>{r.name}</div>
                          <div className={styles.metaText}>ID: {r.restID}</div>
                        </div>
                      </label>
                    );
                  })}
                </div>
              )}
              <small className={styles.metaText}>
                Supervisores podem ter vários restaurantes; gestores normalmente apenas um.
              </small>
            </div>

            <div className={styles.filters}>
              <button type="submit" className="btn btn-primary" disabled={loading}>
                {loading ? 'Salvando...' : 'Criar usuário'}
              </button>
              <button type="button" className="btn btn-secondary" onClick={() => router.push('/login')}>
                Ir para login
              </button>
            </div>
          </form>
        </div>
      </div>
    </Layout>
  );
}
