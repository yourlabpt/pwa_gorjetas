'use client';

import { useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import styles from '../styles/financeiro-diario.module.css';
import { apiClient } from '../lib/api';

export default function RegisterPage() {
  const router = useRouter();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState('GERENTE');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [info, setInfo] = useState('');

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setInfo('');

    try {
      await apiClient.register({
        name,
        email,
        password,
        role,
      });
      setInfo('Usuário criado com sucesso. Faça login para continuar.');
      setName('');
      setEmail('');
      setPassword('');
      setRole('GERENTE');
    } catch (err: any) {
      const rawMsg = err?.response?.data?.message;
      const msg = Array.isArray(rawMsg)
        ? rawMsg.join('; ')
        : rawMsg || 'Erro ao criar usuário';
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
              Cadastro público permite apenas contas Gerente ou Supervisor.
              Contas Administrador são criadas somente por SUPER_ADMIN.
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
                  minLength={12}
                  maxLength={128}
                />
                <small className={styles.metaText}>
                  Mínimo 12 caracteres com maiúscula, minúscula, número e especial.
                </small>
              </div>
              <div className={styles.inputGroup}>
                <label>Função</label>
                <select value={role} onChange={(e) => setRole(e.target.value)}>
                  <option value="GERENTE">Gerente</option>
                  <option value="SUPERVISOR">Supervisor</option>
                </select>
              </div>
            </div>

            <div className={`${styles.filters} ${styles.formActions}`}>
              <button type="submit" className={styles.btnPrimary} disabled={loading}>
                {loading ? 'Salvando...' : 'Criar usuário'}
              </button>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={() => router.push('/login')}
              >
                Voltar para login
              </button>
            </div>
          </form>
        </div>
      </div>
    </Layout>
  );
}
