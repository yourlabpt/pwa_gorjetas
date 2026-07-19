export const OPERATIONAL_ROLES = [
  'SUPER_ADMIN',
  'ADMIN',
  'SUPERVISOR',
  'GERENTE',
  'VISUALIZADOR',
];

export const RESTAURANT_PAGE_ROLES = [
  'SUPER_ADMIN',
  'ADMIN',
  'SUPERVISOR',
  'VISUALIZADOR',
];

export function isReadOnlyRole(role: string): boolean {
  return role === 'VISUALIZADOR';
}

export function roleDisplayLabel(role: string | null | undefined): string {
  switch (role) {
    case 'GERENTE':
      return 'Gerente';
    case 'SUPERVISOR':
      return 'Supervisor';
    case 'ADMIN':
      return 'Administrador';
    case 'SUPER_ADMIN':
      return 'Super Administrador';
    case 'VISUALIZADOR':
      return 'Visualizador';
    default:
      return role || '';
  }
}
