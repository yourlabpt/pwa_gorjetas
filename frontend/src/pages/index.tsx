'use client';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];

export default function Home() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) { router.replace('/login'); return; }
        const res = await apiClient.me();
        const role: string = res.data?.role || '';
        if (!ALLOWED_ROLES.includes(role)) { router.replace('/'); return; }
        setAuthorized(true);
      } catch {
        router.replace('/login');
      }
    };
    checkAuth();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (authorized === null) return <Layout><div className={styles.container}><p className={styles.muted}>Verificando permissões…</p></div></Layout>;

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Painel</p>
            <h1>Início</h1>
            <p className={styles.subtitle}>
              Bem-vindo ao hub do restaurante: lance o dia, acompanhe os números e mantenha o time alinhado.
            </p>
          </div>
        </div>

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2 style={{ margin: 0 }}>O que você quer fazer agora?</h2>
              <p className={styles.metaText}>
                Ações rápidas para o fluxo diário.
              </p>
            </div>
          </div>
          <div className={styles.summaryGridSmall}>
            <a href="/financeiro-diario" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
              <span className={styles.summaryLabel}>Operação</span>
              <span className={styles.summaryValue}>Registrar dia</span>
              <span className={styles.summaryMeta}>Informe faturamento, gorjetas e salve o snapshot diário.</span>
            </a>
            <a href="/relatorios" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
              <span className={styles.summaryLabel}>Análise</span>
              <span className={styles.summaryValue}>Ver relatórios</span>
              <span className={styles.summaryMeta}>Compare dias e veja totais por colaborador.</span>
            </a>
            <a href="/acerto-final" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
              <span className={styles.summaryLabel}>Fechamento</span>
              <span className={styles.summaryValue}>Acerto final</span>
              <span className={styles.summaryMeta}>Feche um período com ajuste por função e por funcionário.</span>
            </a>
            <a href="/configuracao" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
              <span className={styles.summaryLabel}>Configuração</span>
              <span className={styles.summaryValue}>Ajustar regras</span>
              <span className={styles.summaryMeta}>Gestão central de regras e acertos por restaurante.</span>
            </a>
          </div>
        </div>

        <div className={styles.summaryGrid}>
          <a href="/restaurantes" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
            <span className={styles.summaryLabel}>Base</span>
            <span className={styles.summaryValue}>Restaurantes</span>
            <span className={styles.summaryMeta}>Gerencie percentagem base e ativações.</span>
          </a>
          <a href="/funcionarios" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
            <span className={styles.summaryLabel}>Equipe</span>
            <span className={styles.summaryValue}>Funcionários</span>
            <span className={styles.summaryMeta}>Cadastre staff, gerentes, supervisores e chamadores.</span>
          </a>
          <a href="/restaurantes" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
            <span className={styles.summaryLabel}>Regras</span>
            <span className={styles.summaryValue}>Distribuição</span>
            <span className={styles.summaryMeta}>Configure cálculo e pagamento por função em cada restaurante.</span>
          </a>
          <a href="/configuracao/acerto" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
            <span className={styles.summaryLabel}>Fechamento</span>
            <span className={styles.summaryValue}>Acertos</span>
            <span className={styles.summaryMeta}>Ajuste regras de acerto para fechamento de períodos.</span>
          </a>
        </div>

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2 style={{ margin: 0 }}>Como funciona</h2>
              <p className={styles.metaText}>
                Siga o fluxo: configure percentuais, lance o dia no Financeiro e visualize nos relatórios.
              </p>
            </div>
          </div>
          <div className={styles.summaryGridSmall}>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Configurar</div>
              <div className={styles.distributionValue}>Passo 1 — Base</div>
              <div className={styles.distributionMeta}>
                Cadastre restaurantes e funcionários e ajuste as regras centralizadas.
              </div>
            </div>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Lançar</div>
              <div className={styles.distributionValue}>Passo 2 — Dia</div>
              <div className={styles.distributionMeta}>
                Preencha faturamento global, gorjetas e distribuições no Financeiro Diário.
              </div>
            </div>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Analisar</div>
              <div className={styles.distributionValue}>Passo 3 — Visão</div>
              <div className={styles.distributionMeta}>
                Acompanhe múltiplos dias no relatório e confira os valores por colaborador.
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}
