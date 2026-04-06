import { ReactNode } from 'react';
import Navigation from './Navigation';
import styles from './Layout.module.css';

interface LayoutProps {
  children: ReactNode;
}

export default function Layout({ children }: LayoutProps) {
  return (
    <div className={styles.layoutRoot}>
      <Navigation />
      <main className={styles.mainContent}>
        <div className="container">{children}</div>
      </main>
    </div>
  );
}
