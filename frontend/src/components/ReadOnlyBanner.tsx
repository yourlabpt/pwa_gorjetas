import styles from './ReadOnlyBanner.module.css';

interface ReadOnlyBannerProps {
  visible?: boolean;
}

export default function ReadOnlyBanner({ visible = false }: ReadOnlyBannerProps) {
  if (!visible) return null;

  return (
    <div className={styles.banner} role="status">
      Modo visualização — alterações desativadas
    </div>
  );
}
