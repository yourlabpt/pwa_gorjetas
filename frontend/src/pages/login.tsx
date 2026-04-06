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
  const [showPassword, setShowPassword] = useState(false);

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
                Use suas credenciais para acessar o painel. Gerentes veem o restaurante atribuído; supervisores veem o grupo.
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
                  placeholder="gerente@restaurante.com"
                />
              </div>

              <div className={styles.inputGroup}>
                <label>Senha</label>
                <div style={{ position: 'relative' }}>
                  <input
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    placeholder="•••••••"
                    style={{ paddingRight: '2.8rem' }}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword((v) => !v)}
                    aria-label={showPassword ? 'Ocultar senha' : 'Mostrar senha'}
                    style={{
                      position: 'absolute',
                      right: '10px',
                      top: '50%',
                      transform: 'translateY(-50%)',
                      background: 'none',
                      border: 'none',
                      cursor: 'pointer',
                      padding: '4px',
                      display: 'flex',
                      alignItems: 'center',
                      color: '#6b7280',
                      lineHeight: 1,
                    }}
                  >
                    {showPassword ? (
                      // Eye-off icon
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94" />
                        <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19" />
                        <line x1="1" y1="1" x2="23" y2="23" />
                      </svg>
                    ) : (
                      // Eye icon
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                        <circle cx="12" cy="12" r="3" />
                      </svg>
                    )}
                  </button>
                </div>
              </div>

              <div className={`${styles.filters} ${styles.formActions}`} style={{ justifyContent: 'center' }}>
                <button type="submit" className={styles.btnPrimary} disabled={loading}>
                  {loading ? 'Entrando...' : 'Entrar'}
                </button>
                <button
                  type="button"
                  className={styles.btnSecondary}
                  onClick={() => router.push('/register')}
                  disabled={loading}
                >
                  Criar conta
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </Layout>
  );
}
