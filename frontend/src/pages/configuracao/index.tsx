import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import Layout from '../../components/Layout';
import { apiClient } from '../../lib/api';
import styles from '../../styles/configuracao-acerto.module.css';

interface Restaurante {
  restID: number;
  name: string;
}

interface RegraDistribuicao {
  id: number;
  ativo: boolean;
}

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];

export default function ConfiguracaoPage() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [regrasPorRest, setRegrasPorRest] = useState<Record<number, RegraDistribuicao[]>>({});

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) {
          router.replace('/login');
          return;
        }

        const me = await apiClient.me();
        const role: string = me.data?.role || '';
        if (!ALLOWED_ROLES.includes(role)) {
          router.replace('/');
          return;
        }

        setAuthorized(true);
        await loadAll();
      } catch {
        router.replace('/login');
      }
    };

    checkAuth();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const loadAll = async () => {
    try {
      setLoading(true);
      setError('');

      const res = await apiClient.getRestaurantes(true);
      const rests: Restaurante[] = res.data || [];
      setRestaurantes(rests);

      const regrasMap: Record<number, RegraDistribuicao[]> = {};
      await Promise.all(
        rests.map(async (rest) => {
          try {
            const regrasRes = await apiClient.getRegrasDistribuicao(rest.restID, true);
            regrasMap[rest.restID] = regrasRes.data || [];
          } catch {
            regrasMap[rest.restID] = [];
          }
        }),
      );

      setRegrasPorRest(regrasMap);
    } catch {
      setError('Erro ao carregar configurações.');
    } finally {
      setLoading(false);
    }
  };

  const totalRegras = Object.values(regrasPorRest).reduce(
    (sum, regras) => sum + regras.length,
    0,
  );
  const totalRegrasAtivas = Object.values(regrasPorRest).reduce(
    (sum, regras) => sum + regras.filter((r) => r.ativo).length,
    0,
  );

  if (authorized === null) {
    return (
      <Layout>
        <div className={styles.container}>
          <p>Verificando permissões...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.header}>
          <h1>Configuração</h1>
          <p className={styles.subtitle}>
            Gestão centralizada das regras de distribuição e configurações de acerto.
          </p>
        </div>

        {error && <div className={styles.error}>{error}</div>}

        <div className={styles.mainContent} style={{ marginBottom: '16px' }}>
          <section className={styles.configSection}>
            <div className={styles.sectionHeader}>
              <h2>Visão geral</h2>
            </div>
            <div style={{ display: 'grid', gap: '10px', gridTemplateColumns: 'repeat(auto-fit, minmax(190px, 1fr))' }}>
              <div className={styles.card}>
                <p className={styles.kicker}>Restaurantes ativos</p>
                <h3>{restaurantes.length}</h3>
              </div>
              <div className={styles.card}>
                <p className={styles.kicker}>Regras totais</p>
                <h3>{totalRegras}</h3>
              </div>
              <div className={styles.card}>
                <p className={styles.kicker}>Regras ativas</p>
                <h3>{totalRegrasAtivas}</h3>
              </div>
            </div>

            <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', marginTop: '14px' }}>
              <Link href="/restaurantes" className={styles.btnPrimary}>
                Gerir regras de distribuição
              </Link>
              <Link href="/configuracao/acerto" className={styles.btnPrimary}>
                Gerir configuração de acerto
              </Link>
            </div>
          </section>
        </div>

        <div className={styles.mainContent}>
          <section className={styles.configSection}>
            <div className={styles.sectionHeader}>
              <h2>Regras por restaurante</h2>
            </div>

            {loading ? (
              <p style={{ color: '#6b7280' }}>Carregando...</p>
            ) : restaurantes.length === 0 ? (
              <p style={{ color: '#6b7280' }}>Nenhum restaurante ativo encontrado.</p>
            ) : (
              <div className={styles.cardGrid}>
                {restaurantes.map((rest) => {
                  const regras = regrasPorRest[rest.restID] || [];
                  const ativas = regras.filter((r) => r.ativo).length;
                  return (
                    <div key={rest.restID} className={styles.card}>
                      <p className={styles.kicker}>Restaurante</p>
                      <h3>{rest.name}</h3>
                      <p style={{ marginTop: '4px', color: '#6b7280', fontSize: '13px' }}>
                        {ativas} ativas · {regras.length} total
                      </p>
                    </div>
                  );
                })}
              </div>
            )}
          </section>
        </div>
      </div>
    </Layout>
  );
}
