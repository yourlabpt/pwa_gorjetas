import Link from 'next/link';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import styles from './Navigation.module.css';
import { apiClient } from '../lib/api';

export default function Navigation() {
  const [isOpen, setIsOpen] = useState(false);
  const [userEmail, setUserEmail] = useState<string | null>(null);
  const [userRole, setUserRole] = useState<string | null>(null);
  const router = useRouter();

  const toggleMenu = () => {
    setIsOpen(!isOpen);
  };

  const closeMenu = () => {
    setIsOpen(false);
  };

  useEffect(() => {
    const bootstrapUser = async () => {
      try {
        const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) return;
        const res = await apiClient.me();
        setUserEmail(res.data?.email || null);
        setUserRole(res.data?.role || null);
      } catch {
        setUserEmail(null);
        setUserRole(null);
      }
    };
    bootstrapUser();
  }, []);

  const handleLogout = () => {
    apiClient.setAuthToken(null);
    setUserEmail(null);
    setUserRole(null);
    router.push('/login');
  };

  const userInitial = (userEmail || '?').slice(0, 1).toUpperCase();
  const isLoggedIn = Boolean(userEmail);

  return (
    <nav className={styles.navbar}>
      <div className={styles.navContainer}>
        <Link href="/" className={styles.logo} onClick={closeMenu}>
          Gorjetas
        </Link>
        
        <button 
          className={styles.hamburger}
          onClick={toggleMenu}
          aria-label="Toggle menu"
        >
          <span className={`${styles.hamburgerLine} ${isOpen ? styles.open : ''}`}></span>
          <span className={`${styles.hamburgerLine} ${isOpen ? styles.open : ''}`}></span>
          <span className={`${styles.hamburgerLine} ${isOpen ? styles.open : ''}`}></span>
        </button>
        
        <ul className={`${styles.navMenu} ${isOpen ? styles.open : ''}`}>
          <li>
            <Link href="/" className={styles.navLink} onClick={closeMenu}>
              Início
            </Link>
          </li>
          <li>
            <Link href="/financeiro-diario" className={styles.navLink} onClick={closeMenu}>
              Financeiro Diário
            </Link>
          </li>
          <li>
            <Link href="/funcionarios" className={styles.navLink} onClick={closeMenu}>
              Funcionários
            </Link>
          </li>
          {userRole !== 'GESTOR' && (
            <li>
              <Link href="/restaurantes" className={styles.navLink} onClick={closeMenu}>
                Restaurantes
              </Link>
            </li>
          )}
          <li>
            <Link href="/relatorios" className={styles.navLink} onClick={closeMenu}>
              Relatórios
            </Link>
          </li>
          <li>
            <Link href="/configuracao" className={styles.navLink} onClick={closeMenu}>
              Configuração
            </Link>
          </li>
          {userRole === 'ADMIN' && (
            <li>
              <Link href="/usuarios" className={styles.navLink} onClick={closeMenu}>
                Usuários
              </Link>
            </li>
          )}
        </ul>

        <div className={styles.accountArea}>
          <div
            className={`${styles.accountBadge} ${isLoggedIn ? styles.accountBadgeOn : styles.accountBadgeOff}`}
            title={isLoggedIn ? `Logado como ${userEmail}` : 'Não autenticado'}
          >
            {userInitial}
          </div>
          <div className={styles.accountText}>
            <span className={styles.accountEmail}>
              {isLoggedIn ? userEmail : 'Visitante'}
            </span>
            <span className={styles.accountMeta}>
              {isLoggedIn ? (userRole || 'Conta') : 'Clique para entrar'}
            </span>
          </div>
          {isLoggedIn ? (
            <button className={styles.accountAction} onClick={handleLogout} title="Sair">
              Sair
            </button>
          ) : (
            <Link href="/login" className={`${styles.accountAction} ${styles.accountActionGhost}`} onClick={closeMenu}>
              Entrar
            </Link>
          )}
        </div>
      </div>
    </nav>
  );
}
