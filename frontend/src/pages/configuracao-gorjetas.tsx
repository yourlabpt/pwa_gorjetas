'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';

export default function ConfiguracaoGorjetas() {
  const router = useRouter();

  useEffect(() => {
    const timer = setTimeout(() => {
      router.replace('/restaurantes');
    }, 1500);
    return () => clearTimeout(timer);
  }, [router]);

  return (
    <Layout>
      <div style={{ padding: '24px' }}>
        <h1>Configuração de gorjetas unificada</h1>
        <p>
          Esta página foi descontinuada. A gestão de regras agora é feita em
          <strong> Restaurantes</strong>.
        </p>
        <p>Redirecionando...</p>
      </div>
    </Layout>
  );
}
