import axios, { AxiosInstance } from 'axios';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001';
const TOKEN_KEY = 'auth_token';

class ApiClient {
  private client: AxiosInstance;
  private token: string | null = null;

  constructor() {
    this.client = axios.create({
      baseURL: API_BASE_URL,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.client.interceptors.request.use((config) => {
      if (typeof window !== 'undefined') {
        this.token = this.token || localStorage.getItem(TOKEN_KEY);
      }
      if (this.token) {
        config.headers = config.headers || {};
        (config.headers as any).Authorization = `Bearer ${this.token}`;
      }
      return config;
    });

    this.client.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error?.response?.status === 401 && typeof window !== 'undefined') {
          localStorage.removeItem(TOKEN_KEY);
          this.token = null;
        }
        return Promise.reject(error);
      },
    );
  }

  setAuthToken(token: string | null) {
    this.token = token;
    if (typeof window !== 'undefined') {
      if (token) {
        localStorage.setItem(TOKEN_KEY, token);
      } else {
        localStorage.removeItem(TOKEN_KEY);
      }
    }
  }

  // Auth
  async login(email: string, password: string) {
    const res = await this.client.post('/auth/login', { email, password });
    if (res.data?.accessToken) {
      this.setAuthToken(res.data.accessToken);
    }
    return res;
  }

  async register(data: { name: string; email: string; password: string; role: string; restaurantIds?: number[] }) {
    const res = await this.client.post('/auth/register', data);
    if (res.data?.accessToken) {
      this.setAuthToken(res.data.accessToken);
    }
    return res;
  }

  async me() {
    return this.client.get('/auth/me');
  }

  // Restaurantes
  async getRestaurantes(ativo?: boolean) {
    const params: any = {};
    if (ativo !== undefined) params.ativo = ativo;
    return this.client.get('/restaurantes', { params });
  }

  async getRestaurante(restID: number) {
    return this.client.get(`/restaurantes/${restID}`);
  }

  async createRestaurante(data: any) {
    return this.client.post('/restaurantes', data);
  }

  async updateRestaurante(restID: number, data: any) {
    return this.client.put(`/restaurantes/${restID}`, data);
  }

  async toggleRestauranteActive(restID: number) {
    return this.client.put(`/restaurantes/${restID}/toggle-active`);
  }

  async deleteRestaurante(restID: number) {
    return this.client.delete(`/restaurantes/${restID}`);
  }

  // Funcionarios
  async getFuncionarios(restID: number, ativo?: boolean) {
    const params: any = { restID };
    if (ativo !== undefined) params.ativo = ativo;
    return this.client.get('/funcionarios', { params });
  }

  async getFuncionarioById(funcID: number) {
    // This will be used to get all restaurants where a funcionario works
    try {
      return this.client.get(`/funcionarios/${funcID}`);
    } catch (err) {
      // Fallback: return empty if endpoint doesn't exist yet
      return { data: null };
    }
  }

  async createFuncionario(data: any) {
    return this.client.post('/funcionarios', data);
  }

  async updateFuncionario(funcID: number, data: any) {
    return this.client.put(`/funcionarios/${funcID}`, data);
  }

  async deleteFuncionario(funcID: number) {
    return this.client.delete(`/funcionarios/${funcID}`);
  }

  // Configuracao Gorjetas
  async getConfiguracoes(restID: number) {
    return this.client.get('/configuracao-gorjetas', { params: { restID } });
  }

  async createConfiguracao(data: any) {
    return this.client.post('/configuracao-gorjetas', data);
  }

  async updateConfiguracao(configID: number, data: any) {
    return this.client.put(`/configuracao-gorjetas/${configID}`, data);
  }

  async deleteConfiguracao(configID: number) {
    return this.client.delete(`/configuracao-gorjetas/${configID}`);
  }

  // Transacoes
  async createTransacao(data: any) {
    return this.client.post('/transacoes', data);
  }

  async getTransacoes(restID: number, funcID?: number, from?: string, to?: string) {
    const params: any = { restID };
    if (funcID) params.funcID = funcID;
    if (from) params.from = from;
    if (to) params.to = to;
    return this.client.get('/transacoes', { params });
  }

  async getTransacao(tranID: number) {
    return this.client.get(`/transacoes/${tranID}`);
  }

  // Distribuicao
  async getDistribuicoesByTransacao(tranID: number) {
    return this.client.get(`/distribuicao-gorjetas/transacao/${tranID}`);
  }

  async getDistribuicoesByFuncionario(funcID: number, from?: string, to?: string, restID?: number) {
    const params: any = {};
    if (from) params.from = from;
    if (to) params.to = to;
    if (restID) params.restID = restID;
    return this.client.get(`/distribuicao-gorjetas/funcionario/${funcID}`, { params });
  }

  // Relatorios
  async getRelatorioFuncionarios(restID: number, from?: string, to?: string) {
    const params: any = { restID };
    if (from) params.from = from;
    if (to) params.to = to;
    return this.client.get('/relatorios/funcionarios', { params });
  }

  async getRelatorioResumo(restID: number, from?: string, to?: string) {
    const params: any = { restID };
    if (from) params.from = from;
    if (to) params.to = to;
    return this.client.get('/relatorios/resumo', { params });
  }

  async getRelatorioFaturamento(restID: number, from?: string, to?: string) {
    const params: any = { restID };
    if (from) params.from = from;
    if (to) params.to = to;
    return this.client.get('/relatorios/faturamento', { params });
  }

  // Faturamento Diario
  async createFaturamentoDiario(restID: number, data: any) {
    return this.client.post('/faturamento-diario', data, {
      params: { restID },
    });
  }

  async getFaturamentoDiario(restID: number, data: string) {
    return this.client.get('/faturamento-diario', {
      params: { restID, data },
    });
  }

  async getFaturamentoPeriodo(restID: number, dataInicio: string, dataFim: string) {
    return this.client.get('/faturamento-diario/periodo/list', {
      params: { restID, dataInicio, dataFim },
    });
  }

  async updateFaturamentoDiario(id: number, restID: number, data: any) {
    return this.client.put(`/faturamento-diario/${id}`, data, {
      params: { restID },
    });
  }

  async deleteFaturamentoDiario(id: number, restID: number) {
    return this.client.delete(`/faturamento-diario/${id}`, {
      params: { restID },
    });
  }

  // Configuracao Acerto
  async getConfiguracaoAcerto(restID: number) {
    return this.client.get('/configuracao-acerto', { params: { restID } });
  }

  async createConfiguracaoAcerto(restID: number, data: any) {
    return this.client.post('/configuracao-acerto', data, {
      params: { restID },
    });
  }

  async updateConfiguracaoAcerto(id: number, data: any) {
    return this.client.put(`/configuracao-acerto/${id}`, data);
  }

  async deleteConfiguracaoAcerto(id: number) {
    return this.client.delete(`/configuracao-acerto/${id}`);
  }

  // Acerto Periodo
  async createAcertoPeriodo(restID: number, data: any) {
    return this.client.post('/acerto-periodo', data, {
      params: { restID },
    });
  }

  async getAcertoPeriodos(
    restID: number,
    dataInicio?: string,
    dataFim?: string,
    pago?: boolean,
  ) {
    const params: any = { restID };
    if (dataInicio) params.dataInicio = dataInicio;
    if (dataFim) params.dataFim = dataFim;
    if (pago !== undefined) params.pago = pago;
    return this.client.get('/acerto-periodo', { params });
  }

  async getAcertoPeriodo(id: number) {
    return this.client.get(`/acerto-periodo/${id}`);
  }

  async marcarAcertoComoPago(id: number) {
    return this.client.put(`/acerto-periodo/${id}/marcar-pago`, {});
  }

  // Financeiro Snapshot
  async saveFinanceiroSnapshot(restID: number, data: any) {
    return this.client.post('/faturamento-diario/snapshot', data, {
      params: { restID },
    });
  }

  async getFinanceiroSnapshot(restID: number, data: string) {
    return this.client.get('/faturamento-diario/snapshot', {
      params: { restID, data },
    });
  }

  async getFinanceiroSnapshotRange(restID: number, from: string, to: string) {
    return this.client.get('/faturamento-diario/snapshot/range', {
      params: { restID, from, to },
    });
  }

  // Users (admin only)
  async getUsers() {
    return this.client.get('/users');
  }

  async updateUserRole(id: number, role: string) {
    return this.client.put(`/users/${id}/role`, { role });
  }

  async setUserRestaurants(id: number, restIDs: number[]) {
    return this.client.put(`/users/${id}/restaurantes`, { restIDs });
  }
}

export const apiClient = new ApiClient();
