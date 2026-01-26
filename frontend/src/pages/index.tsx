import Layout from '../components/Layout';
import styles from '../styles/financeiro-diario.module.css';

export default function Home() {
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
            <a href="/configuracao" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
              <span className={styles.summaryLabel}>Configuração</span>
              <span className={styles.summaryValue}>Ajustar regras</span>
              <span className={styles.summaryMeta}>Defina percentuais e quem participa da distribuição.</span>
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
            <span className={styles.summaryMeta}>Cadastre staff, gestores, supervisores e chamadores.</span>
          </a>
          <a href="/configuracao" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
            <span className={styles.summaryLabel}>Configuração</span>
            <span className={styles.summaryValue}>Distribuição</span>
            <span className={styles.summaryMeta}>Defina percentuais e regras de acerto por restaurante.</span>
          </a>
          <a href="/transacoes" className={styles.summaryCard} style={{ textDecoration: 'none', color: 'inherit' }}>
            <span className={styles.summaryLabel}>Histórico</span>
            <span className={styles.summaryValue}>Transações</span>
            <span className={styles.summaryMeta}>Consulte lançamentos individuais (legado).</span>
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
                Cadastre restaurantes e funcionários e ajuste percentuais em Configuração.
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
