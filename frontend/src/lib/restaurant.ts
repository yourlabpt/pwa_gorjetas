import { apiClient } from './api';

let cachedRestID: number | null = null;

export async function getActiveRestaurant(): Promise<number> {
  if (cachedRestID !== null) {
    return cachedRestID;
  }

  try {
    const response = await apiClient.getRestaurantes(true);
    if (response.data && response.data.length > 0) {
      cachedRestID = response.data[0].restID;
      return cachedRestID as number;
    } else {
      throw new Error('Nenhum restaurante ativo encontrado');
    }
  } catch (err) {
    console.error('Erro ao carregar restaurante:', err);
    throw err;
  }
}

export function resetRestaurantCache() {
  cachedRestID = null;
}
