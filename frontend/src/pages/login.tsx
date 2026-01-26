'use client';

import { useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import styles from '../styles/financeiro-diario.module.css';
import { apiClient } from '../lib/api';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      await apiClient.login(email, password);
      router.push('/financeiro-diario');
    } catch (err: any) {
      const msg = err?.response?.data?.message || 'Falha ao entrar. Verifique e-mail e senha.';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout>
      <div className={styles.container} style={{ minHeight: '70vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <div style={{ width: '100%', maxWidth: 640 }}>
          <div className={styles.pageHeader} style={{ textAlign: 'center', justifyContent: 'center' }}>
            <div>
              <p className={styles.kicker}>Acesso</p>
              <h1>Entrar</h1>
              <p className={styles.subtitle}>
                Use suas credenciais para acessar o painel. Gestores veem o restaurante atribuído; supervisores veem o grupo.
              </p>
            </div>
          </div>

          <div className={styles.section} style={{ margin: '0 auto', maxWidth: 520 }}>
            {error && <div className={styles.error}>{error}</div>}
            <form onSubmit={handleLogin}>
              <div className={styles.inputGroup}>
                <label>E-mail</label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  placeholder="gestor@restaurante.com"
                />
              </div>

              <div className={styles.inputGroup}>
                <label>Senha</label>
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  placeholder="•••••••"
                />
              </div>

              <div className={styles.filters} style={{ justifyContent: 'center' }}>
                <button type="submit" className="btn btn-primary" disabled={loading}>
                  {loading ? 'Entrando...' : 'Entrar'}
                </button>
                <button
                  type="button"
                  className="btn btn-secondary"
                  onClick={() => router.push('/register')}
                >
                  Criar novo usuário
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </Layout>
  );
}
