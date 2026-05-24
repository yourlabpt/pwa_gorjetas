'use client';
import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';
import { useSessionPageState } from '../hooks/useSessionPageState';

interface Restaurante {
  restID: number;
  name: string;
  percentagem_gorjeta_base: number;
  ativo: boolean;
}

interface Funcionario {
  funcID: number;
  name: string;
  funcao: string;
}

interface GorjetaEntry {
  valor: string;
  direta: string;
  presente: boolean;
  desconto: string;
}

interface EmployeeTotals {
  poolShare: number;
  directTip: number;
  managerShare: number;
  kitchenShare: number;
  total: number;
}

interface EngineRoleBreakdown {
  rule_id: number;
  role_name: string;
  calculation_type: 'PERCENT' | 'FIXED_AMOUNT';
  calculation_pool: string | null;
  percent_mode?: 'ABSOLUTE_PERCENT' | 'BASE_PERCENT_POINTS';
  split_mode?:
    | 'EQUAL_SPLIT'
    | 'PROPORTIONAL_TO_POOL_INPUT'
    | 'DIRECT_INPUT_ONLY'
    | 'FULL_RATE_PER_EMPLOYEE';
  payment_pool: 'TIP_POOL' | 'FINANCEIRO' | 'ABSOLUTE_EXTERNAL';
  rate: number;
  base_value: number;
  theoretical_amount: number;
  paid_amount: number;
  unpaid_amount: number;
}

interface EngineEmployeeBreakdown {
  rule_id: number;
  role_name: string;
  role_bucket: string;
  funcID: number | null;
  employee_name: string | null;
  calculation_type: 'PERCENT' | 'FIXED_AMOUNT';
  calculation_pool: string | null;
  percent_mode?: 'ABSOLUTE_PERCENT' | 'BASE_PERCENT_POINTS';
  split_mode?:
    | 'EQUAL_SPLIT'
    | 'PROPORTIONAL_TO_POOL_INPUT'
    | 'DIRECT_INPUT_ONLY'
    | 'FULL_RATE_PER_EMPLOYEE';
  payment_pool: 'TIP_POOL' | 'FINANCEIRO' | 'ABSOLUTE_EXTERNAL';
  rate: number;
  theoretical_value: number;
  real_paid_value: number;
  unpaid_value: number;
}

interface EngineComputeResult {
  role_breakdown: EngineRoleBreakdown[];
  employee_breakdown: EngineEmployeeBreakdown[];
  bucket_balances: {
    tip_pool_initial: number;
    tip_pool_remaining: number;
    financeiro_initial: number;
    financeiro_remaining: number;
  };
  totals: {
    total_theoretical: number;
    total_payout: number;
    total_unpaid: number;
    total_from_tip_pool: number;
    total_from_financeiro: number;
    total_external: number;
  };
  errors: string[];
  ok: boolean;
}

interface FechoItemLocal {
  id: number | null;
  templateId: number | null;
  label: string;
  valor: number | '';
  contaNoDeposito: boolean;
}

interface FechoData {
  id: number | null;
  restID: number;
  data: string;
  faturamento_global: number;
  dinheiro_a_depositar: number;
  notas: string | null;
  itens: FechoItemLocal[];
  valor_multibanco?: number | null;
  sobra_especie?: number | null;
  sobra_conta_no_deposito?: boolean | null;
}

interface FechoTemplate {
  id: number;
  label: string;
  ordem: number;
  ativo: boolean;
}

interface SnapshotPresencaEntry {
  funcID: number;
  presente: boolean;
}

const currency = (value: number) => `€ ${value.toFixed(2)}`;
const normalizeRole = (funcao: string) =>
  (funcao || '')
    .toLowerCase()
    .trim()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');
const normalizeFechoLabel = (label: string) =>
  (label || '')
    .toLowerCase()
    .trim()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');
const isStaffRole = (_funcao: string) => false; // Legacy — all roles handled generically
const displayRole = (funcao: string) => funcao || '—';
const toRoleBucket = (roleName: string) => normalizeRole(roleName) || 'outros';
const ROLE_TITLE_LOWERCASE_WORDS = new Set(['de', 'da', 'do', 'dos', 'das', 'e']);
const toRoleSectionTitle = (bucket: string) => {
  const normalized = normalizeRole(bucket).replace(/_/g, ' ').trim();
  if (!normalized) return 'Outros';
  return normalized
    .split(/\s+/)
    .filter(Boolean)
    .map((word, index) =>
      word
        .split('-')
        .map((part, partIndex) => {
          if (!part) return part;
          if (index > 0 && partIndex === 0 && ROLE_TITLE_LOWERCASE_WORDS.has(part)) {
            return part;
          }
          return part.charAt(0).toUpperCase() + part.slice(1);
        })
        .join('-'),
    )
    .join(' ');
};
const round2 = (value: number) => Math.round(value * 100) / 100;
const toFechoItemAmount = (value: number | '' | null | undefined) =>
  round2(Math.max(Number(value) || 0, 0));
const formatMoneyInput = (value: number) => {
  const normalized = round2(value);
  return normalized > 0 ? normalized.toFixed(2) : '';
};
const isFechoBalancingLabel = (label: string) =>
  normalizeFechoLabel(label).includes('multibanco');
const calculateFechoItemsTotal = (items: FechoItemLocal[]) =>
  round2(items.reduce((sum, item) => sum + toFechoItemAmount(item.valor), 0));
const calculateFechoDepositTotal = (items: FechoItemLocal[]) =>
  round2(
    items.reduce(
      (sum, item) =>
        sum + (item.contaNoDeposito ? toFechoItemAmount(item.valor) : 0),
      0,
    ),
  );
const normalizeFechoItems = (
  items: Array<
    Partial<FechoItemLocal> & {
      id: number | null;
      templateId: number | null;
      label: string;
      valor: number | '';
    }
  >,
): FechoItemLocal[] =>
  items.map((item) => ({
    id: item.id,
    templateId: item.templateId,
    label: item.label,
    valor: toFechoItemAmount(item.valor),
    contaNoDeposito:
      typeof item.contaNoDeposito === 'boolean'
        ? item.contaNoDeposito
        : false,
  }));
const splitAmount = (total: number, parts: number): number[] => {
  if (parts <= 1) return [round2(total)];
  const base = round2(total / parts);
  const values = Array(parts).fill(base) as number[];
  const allocated = round2(values.reduce((sum, val) => sum + val, 0));
  values[0] = round2(values[0] + round2(total - allocated));
  return values;
};

const FORM_SESSION_PREFIX = 'fin-diario-form';
const buildFormSessionKey = (restId: number, date: string) =>
  `${FORM_SESSION_PREFIX}:${restId}:${date}`;

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];
const TODAY = new Date().toISOString().split('T')[0];

export default function FinanceiroDiario() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restaurantId, setRestaurantId] = useSessionPageState<number | null>(
    'restaurantId',
    null,
  );
  const [selectedDate, setSelectedDate] = useSessionPageState<string>(
    'selectedDate',
    TODAY,
  );
  const [faturamentoGlobal, setFaturamentoGlobal] = useState('');
  const [percentualBase, setPercentualBase] = useState<number>(11);
  const [backendComputation, setBackendComputation] = useState<EngineComputeResult | null>(null);
  const [computeLoading, setComputeLoading] = useState(false);
  const [computeError, setComputeError] = useState('');
  const [snapshotLoading, setSnapshotLoading] = useState(false);
  const [snapshotMessage, setSnapshotMessage] = useState('');
  const [snapshotLoaded, setSnapshotLoaded] = useState(false);
  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);
  const [gorjetaInputs, setGorjetaInputs] = useState<Record<number, GorjetaEntry>>({});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const formDirtyRef = useRef(false);
  const suppressNextAutoPersistRef = useRef(false);
  const [formDirty, setFormDirty] = useState(false);

  // ── Fecho Financeiro state ──────────────────────────────────────────────
  const [fechoData, setFechoData] = useState<FechoData | null>(null);
  const [fechoFaturamento, setFechoFaturamento] = useState('');
  const [fechoDinheiro, setFechoDinheiro] = useState('');
  const [fechoNotas, setFechoNotas] = useState('');
  const [fechoItens, setFechoItens] = useState<FechoItemLocal[]>([]);
  const [fechoTemplates, setFechoTemplates] = useState<FechoTemplate[]>([]);
  const [showFechoTemplates, setShowFechoTemplates] = useSessionPageState<boolean>(
    'showFechoTemplates',
    false,
  );
  const [newTemplateLabel, setNewTemplateLabel] = useState('');
  const [newTemplateOrdem, setNewTemplateOrdem] = useState('0');
  const [editingTemplate, setEditingTemplate] = useState<{ id: number; label: string; ordem: string } | null>(null);
  const [fechoSaving, setFechoSaving] = useState(false);
  const [fechoSuccess, setFechoSuccess] = useState('');
  const [fechoLoading, setFechoLoading] = useState(false);
  const [fechoSuggestionSyncActive, setFechoSuggestionSyncActive] = useState(false);
  const [fechoMultibanco, setFechoMultibanco] = useState('');
  const [sobraContaNoDeposito, setSobraContaNoDeposito] = useState(false);
  // ────────────────────────────────────────────────────────────────────────

  const persistDraft = useCallback(
    (targetRestaurantId: number | null, targetDate: string) => {
      if (!formDirtyRef.current || !targetRestaurantId || !targetDate) return;
      try {
        const key = buildFormSessionKey(targetRestaurantId, targetDate);
        sessionStorage.setItem(key, JSON.stringify({ gorjetaInputs, faturamentoGlobal }));
      } catch {}
    },
    [gorjetaInputs, faturamentoGlobal],
  );

  // ── Persist gorjeta form data to sessionStorage when user edits ─────────
  useEffect(() => {
    if (!formDirtyRef.current || !restaurantId || !selectedDate) return;
    if (suppressNextAutoPersistRef.current) {
      suppressNextAutoPersistRef.current = false;
      return;
    }
    try {
      const key = buildFormSessionKey(restaurantId, selectedDate);
      sessionStorage.setItem(key, JSON.stringify({ gorjetaInputs, faturamentoGlobal }));
    } catch {}
  }, [restaurantId, selectedDate, gorjetaInputs, faturamentoGlobal]);
  // ────────────────────────────────────────────────────────────────────────

  const handleRestaurantSelectionChange = useCallback(
    (nextRestaurantId: number | null) => {
      persistDraft(restaurantId, selectedDate);
      formDirtyRef.current = false;
      setFormDirty(false);
      setSnapshotLoaded(false);
      suppressNextAutoPersistRef.current = true;
      setRestaurantId(nextRestaurantId);
    },
    [persistDraft, restaurantId, selectedDate, setRestaurantId],
  );

  const handleDateSelectionChange = useCallback(
    (nextDate: string) => {
      persistDraft(restaurantId, selectedDate);
      formDirtyRef.current = false;
      setFormDirty(false);
      setSnapshotLoaded(false);
      suppressNextAutoPersistRef.current = true;
      setSelectedDate(nextDate);
    },
    [persistDraft, restaurantId, selectedDate, setSelectedDate],
  );

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) { router.replace('/login'); return; }
        const meRes = await apiClient.me();
        const role: string = meRes.data?.role || '';
        if (!ALLOWED_ROLES.includes(role)) { router.replace('/'); return; }
        setAuthorized(true);
        try {
          const res = await apiClient.getRestaurantes(true);
          if (res.data?.length) {
            setRestaurantes(res.data);
            const hasPersistedRestaurant =
              restaurantId != null &&
              res.data.some((rest: Restaurante) => rest.restID === restaurantId);
            const nextRestaurantId = hasPersistedRestaurant
              ? restaurantId
              : res.data[0].restID;

            setRestaurantId(nextRestaurantId);
            const selectedRest =
              res.data.find((rest: Restaurante) => rest.restID === nextRestaurantId) ||
              res.data[0];
            const basePercent =
              parseFloat(String(selectedRest?.percentagem_gorjeta_base)) || 11;
            setPercentualBase(basePercent);
          }
        } catch (err) {
          setError('Erro ao carregar restaurantes');
        }
      } catch {
        router.replace('/login');
      }
    };
    checkAuth();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    const loadContext = async () => {
      if (!restaurantId) return;
      try {
        setLoading(true);
        setError('');
        const [funcRes, restRes] = await Promise.all([
          apiClient.getFuncionarios(restaurantId, true),
          apiClient.getRestaurante(restaurantId),
        ]);

        setFuncionarios(funcRes.data || []);

        const basePercent = parseFloat(String(restRes.data?.percentagem_gorjeta_base)) || 11;
        setPercentualBase(basePercent);

        setGorjetaInputs((prev) => {
          const next = { ...prev };
          (funcRes.data || []).forEach((f: Funcionario) => {
            if (!next[f.funcID]) {
              next[f.funcID] = { valor: '', direta: '', presente: false, desconto: '' };
            }
          });
          return next;
        });
      } catch (err) {
        setError('Erro ao carregar dados do restaurante');
      } finally {
        setLoading(false);
      }
    };

    loadContext();
  }, [restaurantId]);

  // ── Fecho Financeiro logic ───────────────────────────────────────────────
  const loadFecho = useCallback(async () => {
    if (!restaurantId) return;
    setFechoLoading(true);
    try {
      const [fechoRes, templatesRes] = await Promise.all([
        apiClient.getFecho(restaurantId, selectedDate),
        apiClient.getFechoTemplates(restaurantId),
      ]);
      const f: FechoData = fechoRes.data;
      setFechoData(f);
      setFechoFaturamento(f.faturamento_global ? String(f.faturamento_global) : '');
      setFechoDinheiro(f.dinheiro_a_depositar ? String(f.dinheiro_a_depositar) : '');
      setFechoNotas(f.notas ?? '');
      // Populate Multibanco from dedicated column or scan items for backward compat
      if (f.valor_multibanco != null) {
        setFechoMultibanco(String(f.valor_multibanco));
      } else {
        const mbItem = (f.itens ?? []).find((item) => isFechoBalancingLabel(item.label));
        setFechoMultibanco(mbItem ? String(toFechoItemAmount(mbItem.valor)) : '');
      }
      setSobraContaNoDeposito(f.sobra_conta_no_deposito ?? false);
      // Filter Multibanco items out of fechoItens (now a standalone field)
      const filteredItems = (f.itens ?? []).filter((item) => !isFechoBalancingLabel(item.label));
      setFechoItens(normalizeFechoItems(filteredItems));
      setFechoTemplates(templatesRes.data ?? []);
      setFechoSuggestionSyncActive(false);
    } catch {
      // silently ignore; fecho is optional
    } finally {
      setFechoLoading(false);
    }
  }, [restaurantId, selectedDate]);

  useEffect(() => {
    loadFecho();
  }, [loadFecho]);

  const handleSaveFecho = async () => {
    if (!restaurantId) return;
    setFechoSaving(true);
    setFechoSuccess('');
    try {
      const multibancoVal = parseFloat(fechoMultibanco) || 0;
      const sobraVal = sobraEmEspecie;
      // Build items: user items + Multibanco + Sobra for backward-compat reads
      const allItems = [
        ...fechoItens.map((item) => ({
          templateId: item.templateId ?? undefined,
          label: item.label,
          valor: toFechoItemAmount(item.valor),
          contaNoDeposito: item.contaNoDeposito,
        })),
        {
          templateId: fechoTemplates.find((t) => isFechoBalancingLabel(t.label))?.id ?? undefined,
          label: 'Multibanco',
          valor: multibancoVal,
          contaNoDeposito: false,
        },
        ...(sobraVal !== 0
          ? [{
              templateId: undefined as number | undefined,
              label: 'Sobra em Espécie',
              valor: sobraVal,
              contaNoDeposito: sobraContaNoDeposito,
            }]
          : []),
      ];
      const body = {
        data: selectedDate,
        faturamento_global: parseFloat(fechoFaturamento) || 0,
        dinheiro_a_depositar: parseFloat(fechoDinheiro) || 0,
        valor_multibanco: multibancoVal,
        sobra_especie: sobraVal,
        sobra_conta_no_deposito: sobraContaNoDeposito,
        notas: fechoNotas.trim() || undefined,
        itens: allItems,
      };
      const res = await apiClient.saveFecho(restaurantId, body);
      const saved: FechoData = res.data;
      setFechoData(saved);
      // Filter Multibanco/Sobra back out of fechoItens
      const filteredSaved = (saved.itens ?? []).filter(
        (item) => !isFechoBalancingLabel(item.label) && normalizeFechoLabel(item.label) !== 'sobra em especie',
      );
      setFechoItens(normalizeFechoItems(filteredSaved));
      setFechoSuccess('Fecho guardado com sucesso!');
      setTimeout(() => setFechoSuccess(''), 3000);
    } catch (err: any) {
      setError(err?.response?.data?.message ?? 'Erro ao guardar fecho');
    } finally {
      setFechoSaving(false);
    }
  };

  const updateFechoItem = <K extends keyof FechoItemLocal>(
    index: number,
    field: K,
    value: FechoItemLocal[K],
  ) => {
    setFechoSuggestionSyncActive(false);
    let nextItems: FechoItemLocal[] = [];
    setFechoItens((prev) => {
      const next = [...prev];
      next[index] = { ...next[index], [field]: value };
      nextItems = next;
      return next;
    });
    syncFechoDinheiroFromItems(nextItems);
  };

  const syncFechoDinheiroFromItems = useCallback((items: FechoItemLocal[], includeSobra?: boolean) => {
    const itemsDeposit = calculateFechoDepositTotal(items);
    // When sobra is included in deposit, we don't know sobraEmEspecie here because it depends on
    // items — so we let the caller or a separate effect handle it. For now, just use items total.
    setFechoDinheiro(formatMoneyInput(itemsDeposit));
  }, []);

  const removeFechoItem = (index: number) => {
    setFechoSuggestionSyncActive(false);
    let nextItems: FechoItemLocal[] = [];
    setFechoItens((prev) => {
      nextItems = prev.filter((_, i) => i !== index);
      return nextItems;
    });
    syncFechoDinheiroFromItems(nextItems);
  };

  const addFechoItem = () => {
    setFechoSuggestionSyncActive(false);
    let nextItems: FechoItemLocal[] = [];
    setFechoItens((prev) => {
      nextItems = [
        ...prev,
        {
          id: null,
          templateId: null,
          label: '',
          valor: '' as const,
          contaNoDeposito: false,
        },
      ];
      return nextItems;
    });
    syncFechoDinheiroFromItems(nextItems);
  };

  const toggleFechoItemContaNoDeposito = (index: number) => {
    setFechoSuggestionSyncActive(false);
    let nextItems: FechoItemLocal[] = [];
    setFechoItens((prev) => {
      const next = [...prev];
      next[index] = {
        ...next[index],
        contaNoDeposito: !next[index].contaNoDeposito,
      };
      nextItems = next;
      return next;
    });
    syncFechoDinheiroFromItems(nextItems);
  };

  const applySelectedItemsToDepositField = useCallback(() => {
    syncFechoDinheiroFromItems(fechoItens);
  }, [fechoItens, syncFechoDinheiroFromItems]);

  const handleAddTemplate = async () => {
    if (!restaurantId || !newTemplateLabel.trim()) return;
    try {
      await apiClient.createFechoTemplate(restaurantId, {
        label: newTemplateLabel.trim(),
        ordem: parseInt(newTemplateOrdem) || 0,
      });
      setNewTemplateLabel('');
      setNewTemplateOrdem('0');
      await loadFecho();
    } catch {
      setError('Erro ao criar template');
    }
  };

  const handleSaveTemplate = async () => {
    if (!restaurantId || !editingTemplate) return;
    try {
      await apiClient.updateFechoTemplate(editingTemplate.id, restaurantId, {
        label: editingTemplate.label.trim(),
        ordem: parseInt(editingTemplate.ordem) || 0,
      });
      setEditingTemplate(null);
      const res = await apiClient.getFechoTemplates(restaurantId);
      setFechoTemplates(res.data ?? []);
    } catch {
      setError('Erro ao atualizar template');
    }
  };

  const handleDeleteTemplate = async (id: number) => {
    if (!restaurantId) return;
    if (!window.confirm('Remover este template?')) return;
    try {
      await apiClient.deleteFechoTemplate(id, restaurantId);
      setFechoItens((prev) => prev.filter((item) => item.templateId !== id));
      await loadFecho();
    } catch {
      setError('Erro ao remover template');
    }
  };
  // ────────────────────────────────────────────────────────────────────────

  const handleGorjetaChange = (
    funcID: number,
    field: 'valor' | 'direta' | 'desconto',
    value: string,
  ) => {
    formDirtyRef.current = true;
    setFormDirty(true);
    setGorjetaInputs((prev) => ({
      ...prev,
      [funcID]: {
        valor: prev[funcID]?.valor || '',
        direta: prev[funcID]?.direta || '',
        presente: prev[funcID]?.presente || false,
        desconto: prev[funcID]?.desconto || '',
        [field]: value,
      },
    }));
  };

  const handlePresencaChange = (funcID: number, presente: boolean) => {
    formDirtyRef.current = true;
    setFormDirty(true);
    setGorjetaInputs((prev) => ({
      ...prev,
      [funcID]: {
        valor: prev[funcID]?.valor || '',
        direta: prev[funcID]?.direta || '',
        presente,
        desconto: prev[funcID]?.desconto || '',
      },
    }));
  };

  const basePercentNumber = typeof percentualBase === 'number'
    ? percentualBase
    : parseFloat(String(percentualBase)) || 0;

  const dailyInputRows = useMemo(
    () =>
      funcionarios
        .map((func) => {
          const entry = gorjetaInputs[func.funcID] || {
            valor: '',
            direta: '',
            presente: false,
            desconto: '',
          };
          return {
            funcionario: func,
            tipValue: parseFloat(entry.valor) || 0,
            directValue: parseFloat(entry.direta) || 0,
            presente: Boolean(entry.presente),
          };
        }),
    [funcionarios, gorjetaInputs],
  );

  const tipPoolInput = dailyInputRows.reduce((sum, row) => sum + row.tipValue, 0);
  const staffInputsPayload = useMemo(
    () =>
      dailyInputRows.map((row) => ({
        funcID: row.funcionario.funcID,
        valor_pool: row.tipValue,
        valor_direto: row.directValue,
      })),
    [dailyInputRows],
  );
  const staffDirectTipPoolTotal = dailyInputRows
    .reduce((sum, row) => sum + row.directValue, 0);
  const faturamentoNumber = parseFloat(faturamentoGlobal) || 0;
  const totalTips = tipPoolInput;
  const faturamentoComGorjeta =
    basePercentNumber > 0 ? tipPoolInput / (basePercentNumber / 100) : 0;
  const faturamentoSemGorjeta = Math.max(faturamentoNumber - totalTips, 0);
  const difference = faturamentoNumber - faturamentoComGorjeta;

  useEffect(() => {
    if (!restaurantId) {
      setBackendComputation(null);
      setComputeError('');
      return;
    }

    let cancelled = false;
    const timer = setTimeout(async () => {
      try {
        setComputeLoading(true);
        const res = await apiClient.computeFinanceiroPayouts(restaurantId, {
          faturamento_global: faturamentoNumber,
          faturamento_com_gorjeta: faturamentoComGorjeta,
          faturamento_sem_gorjeta: faturamentoSemGorjeta,
          valor_total_gorjetas: tipPoolInput,
          staff_direct_tip_pool_total: staffDirectTipPoolTotal,
          base_percentual: basePercentNumber,
          staff: staffInputsPayload,
          data: selectedDate,
          insufficientFundsPolicy: 'PARTIAL',
        });

        if (cancelled) return;
        setBackendComputation(res.data || null);
        setComputeError('');
      } catch (err: any) {
        if (cancelled) return;
        const msg = err?.response?.data?.message;
        setComputeError(
          Array.isArray(msg)
            ? msg.join(', ')
            : msg || 'Não foi possível calcular a distribuição no backend.',
        );
        setBackendComputation(null);
      } finally {
        if (!cancelled) setComputeLoading(false);
      }
    }, 250);

    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [
    restaurantId,
    selectedDate,
    faturamentoNumber,
    faturamentoComGorjeta,
    faturamentoSemGorjeta,
    tipPoolInput,
    staffInputsPayload,
    staffDirectTipPoolTotal,
    basePercentNumber,
  ]);

  const calculations = useMemo(() => {
    const roleBreakdown = backendComputation?.role_breakdown || [];
    const employeeBreakdown = backendComputation?.employee_breakdown || [];
    const employeeById = new Map(funcionarios.map((f) => [f.funcID, f]));
    const absoluteExternalBuckets = new Set(
      roleBreakdown
        .filter((line) => line.payment_pool === 'ABSOLUTE_EXTERNAL')
        .map((line) => toRoleBucket(line.role_name)),
    );
    const absoluteExternalFuncIds = new Set<number>(
      funcionarios
        .filter((f) => absoluteExternalBuckets.has(toRoleBucket(f.funcao)))
        .map((f) => f.funcID)
        .concat(
          employeeBreakdown
        .filter(
          (line) =>
            line.funcID != null && line.payment_pool === 'ABSOLUTE_EXTERNAL',
        )
            .map((line) => line.funcID as number),
        ),
    );

    const roleTotals: Record<
      string,
      {
        theoretical: number;
        paid: number;
        unpaid: number;
        paidFromTipPool: number;
        paidFromFinanceiro: number;
        paidExternal: number;
      }
    > = {};
    const ensureRoleTotal = (bucket: string) => {
      if (!roleTotals[bucket]) {
        roleTotals[bucket] = {
          theoretical: 0,
          paid: 0,
          unpaid: 0,
          paidFromTipPool: 0,
          paidFromFinanceiro: 0,
          paidExternal: 0,
        };
      }
      return roleTotals[bucket];
    };

    roleBreakdown.forEach((line) => {
      const bucket = toRoleBucket(line.role_name);
      const target = ensureRoleTotal(bucket);

      target.theoretical += line.theoretical_amount || 0;
      target.paid += line.paid_amount || 0;
      target.unpaid += line.unpaid_amount || 0;
      if (line.payment_pool === 'TIP_POOL') {
        target.paidFromTipPool += line.paid_amount || 0;
      } else if (line.payment_pool === 'FINANCEIRO') {
        target.paidFromFinanceiro += line.paid_amount || 0;
      } else if (line.payment_pool === 'ABSOLUTE_EXTERNAL') {
        target.paidExternal += line.paid_amount || 0;
      }
    });

    const employeeTotals: Record<number, EmployeeTotals> = {};
    const employeePaidByEngine: Record<number, number> = {};

    dailyInputRows.forEach((row) => {
      const isAbsoluteExternal = absoluteExternalFuncIds.has(
        row.funcionario.funcID,
      );
      const directValue = row.directValue;
      employeeTotals[row.funcionario.funcID] = {
        poolShare: 0,
        directTip: directValue,
        managerShare: 0,
        kitchenShare: 0,
        total: directValue,
      };
      if (isAbsoluteExternal) {
        employeePaidByEngine[row.funcionario.funcID] = directValue;
      }
    });

    const resolveEmployeeBreakdownBucket = (line: EngineEmployeeBreakdown) => {
      if (line.funcID != null) {
        const employeeRole = employeeById.get(line.funcID)?.funcao;
        const employeeBucket = toRoleBucket(employeeRole || '');
        if (employeeBucket) return employeeBucket;
      }
      return toRoleBucket(line.role_name || line.role_bucket || '');
    };

    employeeBreakdown.forEach((line) => {
      if (line.funcID == null) return;
      const funcID = line.funcID;
      const directTip = parseFloat(gorjetaInputs[funcID]?.direta || '0') || 0;
      const directRaw = gorjetaInputs[funcID]?.direta ?? '';
      const hasDirectInput = directRaw !== '';

      if (!employeeTotals[funcID]) {
        employeeTotals[funcID] = {
          poolShare: 0,
          directTip,
          managerShare: 0,
          kitchenShare: 0,
          total: directTip,
        };
      }

      if (absoluteExternalFuncIds.has(funcID)) {
        const paidFromBackend = line.real_paid_value || 0;
        const effectiveAbsolute = hasDirectInput ? directTip : paidFromBackend;
        employeeTotals[funcID].poolShare = 0;
        employeeTotals[funcID].directTip = effectiveAbsolute;
        employeeTotals[funcID].total = effectiveAbsolute;
        employeePaidByEngine[funcID] = effectiveAbsolute;
        return;
      }

      const paid = line.real_paid_value || 0;
      const lineBucket = resolveEmployeeBreakdownBucket(line);
      employeeTotals[funcID].poolShare += paid;
      employeeTotals[funcID].total += paid;

      employeePaidByEngine[funcID] = (employeePaidByEngine[funcID] || 0) + paid;
    });

    const buildBucketRows = (bucket: string) => {
      const map = new Map<
        number,
        {
          funcionario: Funcionario;
          teorico: number;
          real: number;
          unpaid: number;
        }
      >();

      employeeBreakdown
        .filter(
          (line) =>
            line.funcID != null && resolveEmployeeBreakdownBucket(line) === bucket,
        )
        .forEach((line) => {
          const funcID = line.funcID as number;
          const func = employeeById.get(funcID);
          if (!func) return;
          if (!map.has(funcID)) {
            map.set(funcID, {
              funcionario: func,
              teorico: 0,
              real: 0,
              unpaid: 0,
            });
          }
          const current = map.get(funcID)!;
          current.teorico += line.theoretical_value || 0;
          current.real += line.real_paid_value || 0;
          current.unpaid += line.unpaid_value || 0;
        });

      return Array.from(map.values());
    };



    // Build all role groups dynamically — no hardcoded known buckets
    const allBucketsFromEngine = Array.from(
      new Set(
        employeeBreakdown.map((line) => resolveEmployeeBreakdownBucket(line)),
      ),
    );
    const otherRoleGroups = allBucketsFromEngine
      .map((bucket) => ({
        bucket,
        label: bucket
          .split('_')
          .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
          .join(' '),
        rows: buildBucketRows(bucket),
      }));

    const directTipOnlyTotal = dailyInputRows.reduce(
      (sum, row) =>
        sum +
        (absoluteExternalFuncIds.has(row.funcionario.funcID)
          ? 0
          : row.directValue),
      0,
    );
    const absoluteInputTotal = dailyInputRows.reduce(
      (sum, row) =>
        sum +
        (absoluteExternalFuncIds.has(row.funcionario.funcID)
          ? row.directValue
          : 0),
      0,
    );
    const distributedFromPool = backendComputation?.totals.total_from_tip_pool || 0;
    const distributedTotal = backendComputation?.totals.total_payout || 0;

    const poolInitial =
      backendComputation?.bucket_balances.tip_pool_initial ?? tipPoolInput;
    const poolNotAllocated = round2(
      Math.max(
        backendComputation?.bucket_balances.tip_pool_remaining ??
          (poolInitial - distributedFromPool),
        0,
      ),
    );

    return {
      basePercentNumber,
      tipPool: tipPoolInput,
      directTotal: directTipOnlyTotal,
      absoluteInputTotal,
      totalTips,
      faturamentoNumber,
      faturamentoComGorjeta,
      faturamentoSemGorjeta,
      difference,
      employeeTotals,
      employeePaidByEngine,
      distributedTotal,
      distributedFromPool,
      otherRoleGroups,
      roleTotals,
      poolInitial,
      poolNotAllocated,
      totalUnpaid: backendComputation?.totals.total_unpaid || 0,
      engineErrors: backendComputation?.errors || [],
    };
  }, [
    backendComputation,
    funcionarios,
    gorjetaInputs,
    dailyInputRows,
    tipPoolInput,
    totalTips,
    faturamentoNumber,
    faturamentoComGorjeta,
    faturamentoSemGorjeta,
    difference,
    basePercentNumber,
  ]);

  const {
    tipPool,
    directTotal,
    absoluteInputTotal,
    employeePaidByEngine,
    distributedFromPool,
    roleTotals,
    poolInitial,
    poolNotAllocated,
    totalUnpaid,
  } = calculations;

  const resumoOperacionalSuggestedItems = useMemo(() => {
    type SuggestionCategory = string;

    const classifyTemplateCategory = (label: string): SuggestionCategory | null => {
      const normalized = normalizeFechoLabel(label);
      if (normalized.includes('gorjeta') && normalized.includes('percent')) {
        return 'gorjeta_percentual_total';
      }
      if (normalized.includes('multibanco')) return null;
      // Dynamic: try to match template label to any known role bucket
      const allRoleBuckets = Array.from(
        new Set([
          ...funcionarios.map((f) => toRoleBucket(f.funcao)),
          ...(backendComputation?.role_breakdown || []).map((r) => toRoleBucket(r.role_name)),
        ]),
      );
      for (const bucket of allRoleBuckets) {
        if (bucket && normalized.includes(bucket)) return `non_pool_${bucket}`;
      }
      return null;
    };

    const templatesByCategory = new Map<SuggestionCategory, FechoTemplate[]>();
    fechoTemplates.forEach((template) => {
      const category = classifyTemplateCategory(template.label);
      if (!category) return;
      if (!templatesByCategory.has(category)) templatesByCategory.set(category, []);
      templatesByCategory.get(category)!.push(template);
    });

    const resolveSuggestionTemplate = (category: SuggestionCategory) => {
      const candidates = (templatesByCategory.get(category) || []).slice().sort(
        (a, b) => a.ordem - b.ordem,
      );
      return candidates[0] || null;
    };

    const tipPoolPaidByEmployee = new Map<number, number>();
    const rulePaidByEmployee = new Map<number, number>();
    (backendComputation?.employee_breakdown || []).forEach((line) => {
      if (line.funcID == null) return;
      const paid = line.real_paid_value || 0;
      rulePaidByEmployee.set(
        line.funcID,
        (rulePaidByEmployee.get(line.funcID) || 0) + paid,
      );
      if (line.payment_pool !== 'TIP_POOL') return;
      tipPoolPaidByEmployee.set(
        line.funcID,
        (tipPoolPaidByEmployee.get(line.funcID) || 0) + paid,
      );
    });

    const absoluteExternalBuckets = new Set(
      (backendComputation?.role_breakdown || [])
        .filter((line) => line.payment_pool === 'ABSOLUTE_EXTERNAL')
        .map((line) => toRoleBucket(line.role_name)),
    );

    const roleBucketByEmployeeId = new Map<number, string>();
    funcionarios.forEach((func) => {
      roleBucketByEmployeeId.set(func.funcID, toRoleBucket(func.funcao));
    });
    (backendComputation?.employee_breakdown || []).forEach((line) => {
      if (line.funcID == null) return;
      if (roleBucketByEmployeeId.has(line.funcID)) return;
      roleBucketByEmployeeId.set(
        line.funcID,
        toRoleBucket(line.role_name || line.role_bucket),
      );
    });

    const outsidePoolByBucket: Record<string, number> = {};
    roleBucketByEmployeeId.forEach((bucket, funcID) => {
      const directRaw = gorjetaInputs[funcID]?.direta ?? '';
      const directValue = parseFloat(directRaw || '0') || 0;
      const rulesPaid = Number(rulePaidByEmployee.get(funcID) || 0);
      const fromTipPool = Number(tipPoolPaidByEmployee.get(funcID) || 0);
      const isAbsoluteRole = absoluteExternalBuckets.has(bucket);
      const effective = isAbsoluteRole
        ? (directRaw !== '' ? directValue : rulesPaid)
        : (rulesPaid + directValue);
      const outsidePool = round2(Math.max(effective - fromTipPool, 0));
      if (outsidePool <= 0) return;
      outsidePoolByBucket[bucket] = round2((outsidePoolByBucket[bucket] || 0) + outsidePool);
    });

    const gorjetaPercentualDistribuida = round2(distributedFromPool || 0);

    const baseSuggestions: Array<{
      category: SuggestionCategory;
      defaultLabel: string;
      valor: number;
      always?: boolean;
      contaNoDeposito?: boolean;
    }> = [
      {
        category: 'gorjeta_percentual_total',
        defaultLabel: 'Gorjeta Percentual (Distribuída)',
        valor: gorjetaPercentualDistribuida,
      },
    ];

    // Dynamically add suggestions for each role bucket with outside-pool payments
    Object.entries(outsidePoolByBucket).forEach(([bucket, valor]) => {
      if (valor <= 0) return;
      const title = toRoleSectionTitle(bucket);
      baseSuggestions.push({
        category: `non_pool_${bucket}`,
        defaultLabel: `Pagamento ${title} (fora Gorjeta Percentual + Diretas)`,
        valor: round2(valor),
      });
    });

    return baseSuggestions
      .filter((item) => item.always || round2(item.valor) > 0)
      .map((item) => {
        const template = resolveSuggestionTemplate(item.category);
        return {
          id: null,
          templateId: template?.id ?? null,
          label: template?.label || item.defaultLabel,
          valor: round2(item.valor),
          contaNoDeposito:
            typeof item.contaNoDeposito === 'boolean'
              ? item.contaNoDeposito
              : false,
        };
      });
  }, [
    backendComputation,
    distributedFromPool,
    fechoTemplates,
    faturamentoNumber,
    funcionarios,
    gorjetaInputs,
  ]);

  const mergeFechoItemsWithSuggestions = useCallback(
    (prev: FechoItemLocal[], suggestedItems: FechoItemLocal[]) => {
      const suggestedLabelKeys = new Set(
        suggestedItems.map((item) => normalizeFechoLabel(item.label)),
      );
      const legacyAutoSuggestionLabelKeys = new Set(
        [
          'despesas',
          'gorjeta percentual (distribuida)',
          'pagamento gerentes (fora gorjeta percentual)',
          'pagamento supervisores (fora gorjeta percentual)',
          'pagamento chamadores (fora gorjeta percentual)',
          'pagamento cozinha/bar (fora gorjeta percentual)',
          'pagamento cozinha (fora gorjeta percentual)',
          'pagamento bar (fora gorjeta percentual)',
          'pagamento staff (fora gorjeta percentual)',
          'outros pagamentos (fora gorjeta percentual)',
        ].map((label) => normalizeFechoLabel(label)),
      );
      const existingByLabel = new Map(
        prev.map((item) => [normalizeFechoLabel(item.label), item]),
      );
      const existingByTemplateId = new Map(
        prev
          .filter((item) => item.templateId != null)
          .map((item) => [item.templateId as number, item]),
      );

      const mergedSuggested = suggestedItems.map((item) => {
        const key = normalizeFechoLabel(item.label);
        const existing =
          (item.templateId != null
            ? existingByTemplateId.get(item.templateId)
            : undefined) || existingByLabel.get(key);
        return {
          id: existing?.id ?? null,
          templateId: item.templateId ?? existing?.templateId ?? null,
          label: item.label,
          valor: toFechoItemAmount(item.valor),
          contaNoDeposito:
            typeof existing?.contaNoDeposito === 'boolean'
              ? existing.contaNoDeposito
              : item.contaNoDeposito,
        };
      });

      const customItems = prev.filter((item) => {
        const labelKey = normalizeFechoLabel(item.label);
        if (suggestedLabelKeys.has(labelKey)) return false;
        if (legacyAutoSuggestionLabelKeys.has(labelKey)) return false;
        if (
          item.templateId != null &&
          suggestedItems.some((suggestion) => suggestion.templateId === item.templateId)
        ) {
          return false;
        }
        return true;
      });
      return [...mergedSuggested, ...customItems];
    },
    [],
  );

  const resumoOperacionalSuggestedItemsTotal = useMemo(
    () =>
      calculateFechoItemsTotal(resumoOperacionalSuggestedItems),
    [resumoOperacionalSuggestedItems],
  );

  const resumoOperacionalSuggestedDepositTotal = useMemo(
    () => calculateFechoDepositTotal(resumoOperacionalSuggestedItems),
    [resumoOperacionalSuggestedItems],
  );

  const resumoOperacionalSuggestedPayoutTotal = useMemo(
    () =>
      round2(
        Math.max(
          resumoOperacionalSuggestedItemsTotal - resumoOperacionalSuggestedDepositTotal,
          0,
        ),
      ),
    [resumoOperacionalSuggestedDepositTotal, resumoOperacionalSuggestedItemsTotal],
  );

  const fechoItemsTotal = useMemo(
    () => calculateFechoItemsTotal(fechoItens),
    [fechoItens],
  );

  const fechoDepositSelectedTotal = useMemo(
    () => calculateFechoDepositTotal(fechoItens),
    [fechoItens],
  );

  const fechoRemainingBalance = useMemo(
    () => round2((parseFloat(fechoFaturamento) || 0) - fechoItemsTotal),
    [fechoFaturamento, fechoItemsTotal],
  );

  const valorTotalEspecie = useMemo(
    () => round2((parseFloat(fechoFaturamento) || 0) - (parseFloat(fechoMultibanco) || 0)),
    [fechoFaturamento, fechoMultibanco],
  );

  const sobraEmEspecie = useMemo(
    () => round2(valorTotalEspecie - fechoItemsTotal),
    [valorTotalEspecie, fechoItemsTotal],
  );

  const applyResumoOperacionalSuggestions = useCallback(() => {
    if (!backendComputation) {
      setSnapshotMessage(
        'Aguarde o cálculo no Financeiro Diário antes de aplicar sugestões no resumo.',
      );
      setTimeout(() => setSnapshotMessage(''), 3000);
      return;
    }

    if (faturamentoNumber <= 0 && resumoOperacionalSuggestedItems.length === 0) {
      setSnapshotMessage(
        'Sem valores calculados para sugerir neste momento. Preencha o dia primeiro.',
      );
      setTimeout(() => setSnapshotMessage(''), 3000);
      return;
    }

    setFechoFaturamento(
      faturamentoNumber > 0 ? round2(faturamentoNumber).toFixed(2) : '',
    );
    let nextItems: FechoItemLocal[] = [];
    setFechoItens((prev) => {
      nextItems = mergeFechoItemsWithSuggestions(prev, resumoOperacionalSuggestedItems);
      return nextItems;
    });
    syncFechoDinheiroFromItems(nextItems);
    setFechoSuggestionSyncActive(true);

    setFechoSuccess('Sugestões do Financeiro Diário aplicadas. Revise e ajuste se necessário.');
    setTimeout(() => setFechoSuccess(''), 3000);
  }, [
    backendComputation,
    faturamentoNumber,
    mergeFechoItemsWithSuggestions,
    resumoOperacionalSuggestedItems,
    syncFechoDinheiroFromItems,
  ]);

  useEffect(() => {
    if (!fechoSuggestionSyncActive || !backendComputation) return;
    setFechoFaturamento(
      faturamentoNumber > 0 ? round2(faturamentoNumber).toFixed(2) : '',
    );
    let nextItems: FechoItemLocal[] = [];
    setFechoItens((prev) => {
      nextItems = mergeFechoItemsWithSuggestions(prev, resumoOperacionalSuggestedItems);
      return nextItems;
    });
    syncFechoDinheiroFromItems(nextItems);
  }, [
    backendComputation,
    faturamentoNumber,
    fechoSuggestionSyncActive,
    mergeFechoItemsWithSuggestions,
    resumoOperacionalSuggestedItems,
    syncFechoDinheiroFromItems,
  ]);

  const roleRulesByBucket = useMemo(() => {
    const map = new Map<string, EngineRoleBreakdown[]>();
    (backendComputation?.role_breakdown || []).forEach((rule) => {
      const bucket = toRoleBucket(rule.role_name);
      if (!map.has(bucket)) map.set(bucket, []);
      map.get(bucket)!.push(rule);
    });
    return map;
  }, [backendComputation]);

  const isAbsoluteExternalRole = useCallback((funcao: string) => {
    const bucket = toRoleBucket(funcao);
    const roleRules = roleRulesByBucket.get(bucket) || [];
    return roleRules.some((r) => r.payment_pool === 'ABSOLUTE_EXTERNAL');
  }, [roleRulesByBucket]);

  const groupedEmployeeRows = useMemo(() => {
    const rowsByBucket = new Map<string, Funcionario[]>();
    funcionarios.forEach((func) => {
      const bucket = toRoleBucket(func.funcao);
      if (!rowsByBucket.has(bucket)) rowsByBucket.set(bucket, []);
      rowsByBucket.get(bucket)!.push(func);
    });

    const rulesOrderBuckets: string[] = [];
    (backendComputation?.role_breakdown || []).forEach((rule) => {
      const bucket = toRoleBucket(rule.role_name);
      if (!rowsByBucket.has(bucket)) return;
      if (!rulesOrderBuckets.includes(bucket)) rulesOrderBuckets.push(bucket);
    });

    const defaultBucketOrder = [
      ...rulesOrderBuckets,
    ];

    const remainingBuckets = Array.from(rowsByBucket.keys()).filter(
      (bucket) => !rulesOrderBuckets.includes(bucket),
    );
    const orderedRemaining = [
      ...remainingBuckets
        .slice()
        .sort((a, b) =>
          toRoleSectionTitle(a).localeCompare(toRoleSectionTitle(b), 'pt-PT', {
            sensitivity: 'base',
          }),
        ),
    ];
    const orderedBuckets = [...defaultBucketOrder, ...orderedRemaining];

    return orderedBuckets.map((bucket) => ({
      bucket,
      title: toRoleSectionTitle(bucket),
      rows: (rowsByBucket.get(bucket) || []).slice().sort((a, b) => {
        const byName = a.name.localeCompare(b.name);
        return byName !== 0 ? byName : a.funcID - b.funcID;
      }),
    }));
  }, [backendComputation, funcionarios]);


  const employeeValuesById = useMemo(() => {
    const values: Record<
      number,
      {
        calculated: number;
        rulesEffective: number;
        directEffective: number;
        descontoValue: number;
        effective: number;
        unpaid: number;
      }
    > = {};

    funcionarios.forEach((func) => {
      values[func.funcID] = {
        calculated: 0,
        rulesEffective: 0,
        directEffective: 0,
        descontoValue: 0,
        effective: 0,
        unpaid: 0,
      };
    });

    (backendComputation?.employee_breakdown || []).forEach((line) => {
      if (line.funcID == null) return;
      const funcID = line.funcID;
      if (!values[funcID]) {
        values[funcID] = {
          calculated: 0,
          rulesEffective: 0,
          directEffective: 0,
          descontoValue: 0,
          effective: 0,
          unpaid: 0,
        };
      }
      values[funcID].calculated += line.theoretical_value || 0;
      values[funcID].rulesEffective += line.real_paid_value || 0;
      values[funcID].unpaid += line.unpaid_value || 0;
    });

    funcionarios.forEach((func) => {
      const directRaw = gorjetaInputs[func.funcID]?.direta ?? '';
      const directValue = parseFloat(directRaw || '0') || 0;
      const isAbsoluteRole = isAbsoluteExternalRole(func.funcao);
      const current = values[func.funcID] || {
        calculated: 0,
        rulesEffective: 0,
        directEffective: 0,
        descontoValue: 0,
        effective: 0,
        unpaid: 0,
      };
      const desconto = parseFloat(gorjetaInputs[func.funcID]?.desconto || '0') || 0;

      if (isAbsoluteRole) {
        if (directRaw !== '') {
          values[func.funcID] = {
            calculated: directValue,
            rulesEffective: 0,
            directEffective: directValue,
            descontoValue: desconto,
            effective: Math.max(0, directValue - desconto),
            unpaid: 0,
          };
          return;
        }

        values[func.funcID] = {
          ...current,
          directEffective: 0,
          descontoValue: desconto,
          effective: Math.max(0, current.rulesEffective - desconto),
          unpaid: 0,
        };
        return;
      }

      values[func.funcID] = {
        ...current,
        directEffective: directValue,
        descontoValue: desconto,
        effective: Math.max(0, current.rulesEffective + directValue - desconto),
      };
    });

    return values;
  }, [backendComputation, funcionarios, gorjetaInputs, isAbsoluteExternalRole]);

  const distributionRoleCards = useMemo(() => {
    const groupedBucketOrder = groupedEmployeeRows.map((group) => group.bucket);
    const groupedBucketIndex = new Map(
      groupedBucketOrder.map((bucket, index) => [bucket, index]),
    );

    const effectiveByBucket: Record<string, { effective: number; rulesEffective: number; directEffective: number; unpaid: number }> = {};
    funcionarios.forEach((func) => {
      const bucket = toRoleBucket(func.funcao);
      if (!effectiveByBucket[bucket]) {
        effectiveByBucket[bucket] = { effective: 0, rulesEffective: 0, directEffective: 0, unpaid: 0 };
      }
      const vals = employeeValuesById[func.funcID];
      if (vals) {
        effectiveByBucket[bucket].effective += vals.effective;
        effectiveByBucket[bucket].rulesEffective += vals.rulesEffective;
        effectiveByBucket[bucket].directEffective += vals.directEffective;
        effectiveByBucket[bucket].unpaid += vals.unpaid;
      }
    });

    const allBuckets = Array.from(
      new Set([...groupedBucketOrder, ...Object.keys(roleTotals || {}), ...Object.keys(effectiveByBucket)]),
    );

    return allBuckets
      .map((bucket) => {
        const engineTotals = roleTotals[bucket] || {
          theoretical: 0,
          paid: 0,
          unpaid: 0,
          paidFromTipPool: 0,
          paidFromFinanceiro: 0,
          paidExternal: 0,
        };
        const eff = effectiveByBucket[bucket] || { effective: 0, rulesEffective: 0, directEffective: 0, unpaid: 0 };
        return {
          bucket,
          title: toRoleSectionTitle(bucket),
          totals: {
            ...engineTotals,
            paid: round2(eff.effective),
            unpaid: round2(eff.unpaid),
          },
          effective: round2(eff.effective),
          rulesEffective: round2(eff.rulesEffective),
          directEffective: round2(eff.directEffective),
        };
      })
      .filter(
        ({ bucket, totals, effective }) =>
          groupedBucketIndex.has(bucket) ||
          totals.theoretical > 0 ||
          effective > 0 ||
          totals.paidFromTipPool > 0 ||
          totals.paidFromFinanceiro > 0 ||
          totals.paidExternal > 0,
      )
      .sort((a, b) => {
        const idxA = groupedBucketIndex.get(a.bucket);
        const idxB = groupedBucketIndex.get(b.bucket);
        if (idxA != null && idxB != null) return idxA - idxB;
        if (idxA != null) return -1;
        if (idxB != null) return 1;
        return a.title.localeCompare(b.title, 'pt-PT', { sensitivity: 'base' });
      });
  }, [employeeValuesById, funcionarios, groupedEmployeeRows, roleTotals]);

  const handleSalvarFinanceiro = async () => {
    if (!restaurantId || !selectedDate) {
      setSnapshotMessage('Selecione restaurante e dia antes de salvar.');
      setTimeout(() => setSnapshotMessage(''), 2500);
      return;
    }
    if (computeLoading) {
      setSnapshotMessage('Aguarde o recálculo no backend para salvar.');
      setTimeout(() => setSnapshotMessage(''), 2500);
      return;
    }
    if (!backendComputation) {
      setSnapshotMessage('A distribuição ainda não foi calculada no backend.');
      setTimeout(() => setSnapshotMessage(''), 3000);
      return;
    }

    try {
      setSnapshotLoading(true);
      const staffEntries = funcionarios.map((f) => {
          const entry = gorjetaInputs[f.funcID] || {
            valor: '0',
            direta: '0',
            presente: false,
            desconto: '0',
          };
          const directValue = parseFloat(entry.direta) || 0;
          const descontoValue = parseFloat(entry.desconto) || 0;
          const absoluteExternal = isAbsoluteExternalRole(f.funcao);
          return {
            funcID: f.funcID,
            valor_pool: parseFloat(entry.valor) || 0,
            valor_direto: directValue,
            valor_pago: absoluteExternal
              ? directValue
              : employeePaidByEngine[f.funcID] || 0,
            desconto: descontoValue > 0 ? descontoValue : undefined,
          };
        });
      const presencas = funcionarios.map((f) => ({
        funcID: f.funcID,
        presente: Boolean(gorjetaInputs[f.funcID]?.presente),
      }));

      const payload = {
        data: selectedDate,
        faturamento_global: faturamentoNumber,
        base_percentual: basePercentNumber,
        faturamento_com_gorjeta: faturamentoComGorjeta,
        faturamento_sem_gorjeta: faturamentoSemGorjeta,
        valor_total_gorjetas: tipPool,
        staff_direct_tip_pool_total: staffDirectTipPoolTotal,
        insufficientFundsPolicy: 'PARTIAL' as const,
        staff: staffEntries,
        presencas,
      };

      await apiClient.saveFinanceiroSnapshot(restaurantId, payload);
      // Clear sessionStorage after successful save so next load fetches fresh data
      formDirtyRef.current = false;
      setFormDirty(false);
      try { sessionStorage.removeItem(buildFormSessionKey(restaurantId, selectedDate)); } catch {}
      setSnapshotMessage('Snapshot salvo com sucesso.');
      setTimeout(() => setSnapshotMessage(''), 3000);
    } catch (err) {
      setSnapshotMessage('Erro ao salvar snapshot.');
      setTimeout(() => setSnapshotMessage(''), 3000);
    } finally {
      setSnapshotLoading(false);
    }
  };

  const loadSnapshot = async () => {
    if (!restaurantId || !selectedDate || funcionarios.length === 0) return;

    // Check sessionStorage for unsaved edits before hitting backend
    const formKey = buildFormSessionKey(restaurantId, selectedDate);
    try {
      const raw = sessionStorage.getItem(formKey);
      if (raw) {
        const stored = JSON.parse(raw);
        if (stored.gorjetaInputs && typeof stored.gorjetaInputs === 'object') {
          const merged: Record<number, GorjetaEntry> = {};
          funcionarios.forEach((f) => {
            merged[f.funcID] = stored.gorjetaInputs[f.funcID] || { valor: '', direta: '', presente: false, desconto: '' };
          });
          setGorjetaInputs(merged);
          setFaturamentoGlobal(stored.faturamentoGlobal ?? '');
          setSnapshotLoaded(true);
          formDirtyRef.current = false;
          setFormDirty(true);
          return;
        }
      }
    } catch {}

    // Build defaults based on current employees to avoid stale values when switching datas
    const defaultStaffState: Record<number, GorjetaEntry> = {};
    funcionarios.forEach((f) => {
      defaultStaffState[f.funcID] = { valor: '', direta: '', presente: false, desconto: '' };
    });

    setGorjetaInputs(defaultStaffState);
    setFaturamentoGlobal('');

    try {
      setSnapshotLoading(true);
      setSnapshotLoaded(false);
      let data: any | null = null;
      try {
        const res = await apiClient.getFinanceiroSnapshot(restaurantId, selectedDate);
        data = res.data;
      } catch (err: any) {
        // fallback: try range endpoint in case the single-day endpoint returns 404
        try {
          const rangeRes = await apiClient.getFinanceiroSnapshotRange(
            restaurantId,
            selectedDate,
            selectedDate,
          );
          data = Array.isArray(rangeRes.data) ? rangeRes.data[0] : null;
        } catch {
          // keep data as null and handle below
        }
        if (!data) {
          throw err;
        }
      }

      if (!data) {
        setSnapshotMessage('Nenhum dado salvo para este dia ainda.');
        setTimeout(() => setSnapshotMessage(''), 3000);
        return;
      }

      if (data.faturamento_inserido !== null && data.faturamento_inserido !== undefined) {
        setFaturamentoGlobal(String(data.faturamento_inserido));
      }

      const gorjetaState: Record<number, GorjetaEntry> = { ...defaultStaffState };
      const funcionarioById = new Map(funcionarios.map((f) => [f.funcID, f]));
      const unresolvedEntries: Array<{
        roleBucket: string;
        poolValue: number;
        directValue: number;
      }> = [];

      (data.entries || []).forEach((e: any) => {
        const roleBucket = toRoleBucket(e.role || '');
        const entryFunc =
          e.funcID != null ? funcionarioById.get(Number(e.funcID)) : undefined;
        const employeeBucket = entryFunc ? toRoleBucket(entryFunc.funcao || '') : '';
        const effectiveBucket = employeeBucket || roleBucket;
        const poolValue = Number(e.valor_pool || 0);
        const directValue = Number(e.valor_direto || 0);
        const paidValue = Number(e.valor_pago || 0);
        const hasExplicitInput = poolValue > 0 || directValue > 0;
        const legacyAbsoluteValue =
          (effectiveBucket === 'chamador' || employeeBucket === 'chamador') &&
          !hasExplicitInput
            ? paidValue
            : 0;
        const legacyStaffPoolValue =
          (effectiveBucket === 'staff' || employeeBucket === 'staff') &&
          !hasExplicitInput
            ? paidValue
            : 0;
        const resolvedPool = poolValue > 0 ? poolValue : legacyStaffPoolValue;
        const resolvedDirect = directValue > 0 ? directValue : legacyAbsoluteValue;

        const descontoValue = Number(e.desconto || 0);

        if (e.funcID != null && gorjetaState[e.funcID] !== undefined) {
          const existing = gorjetaState[e.funcID];
          gorjetaState[e.funcID] = {
            valor: resolvedPool > 0 ? resolvedPool.toString() : '',
            direta: resolvedDirect > 0 ? resolvedDirect.toString() : '',
            presente: existing?.presente || false,
            desconto: descontoValue > 0 ? descontoValue.toString() : '',
          };
          return;
        }

        unresolvedEntries.push({
          roleBucket: effectiveBucket,
          poolValue: resolvedPool,
          directValue: resolvedDirect,
        });
      });

      unresolvedEntries.forEach((entry) => {
        if (entry.poolValue <= 0 && entry.directValue <= 0) return;
        const matching = funcionarios.filter(
          (func) => toRoleBucket(func.funcao) === entry.roleBucket,
        );
        if (!matching.length) return;

        const poolSplit = splitAmount(entry.poolValue, matching.length);
        const directSplit = splitAmount(entry.directValue, matching.length);
        matching.forEach((func, idx) => {
          const current = gorjetaState[func.funcID] || {
            valor: '',
            direta: '',
            presente: false,
            desconto: '',
          };
          const currentPool = parseFloat(current.valor || '0') || 0;
          const currentDirect = parseFloat(current.direta || '0') || 0;
          const mergedPool = round2(currentPool + (poolSplit[idx] || 0));
          const mergedDirect = round2(currentDirect + (directSplit[idx] || 0));
          gorjetaState[func.funcID] = {
            valor: mergedPool > 0 ? mergedPool.toString() : '',
            direta: mergedDirect > 0 ? mergedDirect.toString() : '',
            presente: current.presente,
            desconto: current.desconto,
          };
        });
      });

      const presencaByFuncID = new Map<number, boolean>();
      ((data.presencas || []) as SnapshotPresencaEntry[]).forEach((presenca) => {
        if (!Number.isFinite(Number(presenca.funcID))) return;
        presencaByFuncID.set(Number(presenca.funcID), Boolean(presenca.presente));
      });
      funcionarios.forEach((func) => {
        if (!gorjetaState[func.funcID]) {
          gorjetaState[func.funcID] = {
            valor: '',
            direta: '',
            presente: false,
            desconto: '',
          };
        }
        gorjetaState[func.funcID] = {
          ...gorjetaState[func.funcID],
          presente: presencaByFuncID.get(func.funcID) || false,
        };
      });

      setGorjetaInputs(gorjetaState);
      setSnapshotLoaded(true);
      formDirtyRef.current = false;
      setFormDirty(false);
      setSnapshotMessage('Dados salvos carregados. Edite e salve novamente.');
      setTimeout(() => setSnapshotMessage(''), 3000);
    } catch (err) {
      // ignore load errors to avoid blocking UI, keep defaults
      formDirtyRef.current = false;
      setFormDirty(false);
      setSnapshotMessage('Não foi possível carregar os dados salvos. Tente novamente.');
      setTimeout(() => setSnapshotMessage(''), 4000);
    } finally {
      setSnapshotLoading(false);
    }
  };

  useEffect(() => {
    loadSnapshot();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [restaurantId, selectedDate, funcionarios]);

  if (authorized === null) return <Layout><div className={styles.container}><p className={styles.muted}>Verificando permissões…</p></div></Layout>;

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Fechamento diário</p>
            <h1>Financeiro Diário</h1>
            <p className={styles.subtitle}>
              Selecione o dia e informe os valores. As regras são exibidas em linguagem simples com
              os mesmos parâmetros configurados por função: tipo, taxa, base, pagamento e divisão.
            </p>
          </div>

          <div className={styles.filters}>
            <div className={styles.selectGroup}>
              <label>Restaurante</label>
              <select
                value={restaurantId || ''}
                onChange={(e) =>
                  handleRestaurantSelectionChange(
                    parseInt(e.target.value, 10) || null,
                  )
                }
              >
                <option value="">Selecione</option>
                {restaurantes.map((rest) => (
                  <option key={rest.restID} value={rest.restID}>
                    {rest.name}
                  </option>
                ))}
              </select>
            </div>

            <div className={styles.selectGroup}>
              <label>Dia</label>
              <input
                type="date"
                value={selectedDate}
                onChange={(e) => handleDateSelectionChange(e.target.value)}
              />
            </div>

            <div className={styles.selectGroup}>
              <label>&nbsp;</label>
              <button
                type="button"
                className={styles.btnPrimary}
                onClick={handleSalvarFinanceiro}
                disabled={snapshotLoading || computeLoading || !restaurantId}
              >
                {snapshotLoading ? 'Salvando...' : computeLoading ? 'Calculando...' : 'Salvar dia'}
              </button>
              {formDirty && (
                <span className={styles.unsavedBadge}><span className={styles.unsavedDot} />Não salvo</span>
              )}
            </div>
            <div className={styles.selectGroup}>
              <label>&nbsp;</label>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={loadSnapshot}
                disabled={snapshotLoading || !restaurantId}
              >
                {snapshotLoading ? 'Carregando...' : 'Carregar dados salvos'}
              </button>
              {snapshotLoaded && (
                <span className={styles.metaText}>Modo edição: dados carregados</span>
              )}
            </div>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {computeError && <div className={styles.error}>{computeError}</div>}
        {snapshotMessage && <div className={styles.info}>{snapshotMessage}</div>}
        {snapshotLoading && <div className={styles.info}>Carregando / salvando snapshot...</div>}
        {computeLoading && <div className={styles.info}>Recalculando distribuição com o motor do backend...</div>}
        {!computeLoading && backendComputation && backendComputation.errors?.length > 0 && (
          <div className={styles.info}>{backendComputation.errors.join(' | ')}</div>
        )}
        {loading && <div className={styles.info}>Carregando dados do restaurante...</div>}

      <div className={styles.summaryGrid}>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Faturamento Global</span>
          <strong className={styles.summaryValue}>{currency(faturamentoNumber)}</strong>
        </div>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Faturamento Gorjetado</span>
          <strong className={styles.summaryValue}>{currency(faturamentoComGorjeta)}</strong>
          <span className={styles.summaryMeta}>Base {basePercentNumber || 0}%</span>
        </div>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Total de Gorjetas recebidas (pool)</span>
          <strong className={styles.summaryValue}>{currency(totalTips)}</strong>
          <span className={styles.summaryMeta}>
            Pool: {currency(tipPool)} · Diretas (gorjeta): {currency(directTotal)} · Absolutos externos: {currency(absoluteInputTotal)}
          </span>
        </div>
        <div className={styles.summaryCard}>
          <span className={styles.summaryLabel}>Faturamento Líquido (Sem gorjetas)</span>
          <strong className={styles.summaryValue}>{currency(faturamentoSemGorjeta)}</strong>
        </div>
      </div>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Entradas do dia</h2>
              <p>Inclua faturamento global e gorjetas por funcionário.</p>
            </div>
            <span className={styles.chip}>Cálculo automático</span>
          </div>

          <div className={styles.inputRow}>
            <div className={styles.inputGroup}>
              <label>Faturamento Global (€)</label>
              <input
                type="number"
                step="0.01"
                value={faturamentoGlobal}
                onChange={(e) => { formDirtyRef.current = true; setFormDirty(true); setFaturamentoGlobal(e.target.value); }}
                placeholder="0.00"
              />
            </div>
            <div className={styles.inputGroup}>
              <label>Percentual base da gorjeta (%)</label>
              <input
                type="number"
                step="0.1"
                value={percentualBase}
                onChange={(e) => setPercentualBase(parseFloat(e.target.value) || 0)}
              />
            </div>
            <div className={styles.inputGroup}>
              <label>Gorjetas registadas (pool)</label>
              <div className={styles.readonlyBox}>{currency(totalTips)}</div>
              <span className={styles.inlineMeta}>Diretas são registadas à parte (fora do TIP_POOL)</span>
            </div>
          </div>

          <p className={styles.inlineMeta} style={{ marginBottom: '10px' }}>
            A listagem está unificada por grupos de função e inicia na ordem das regras ativas.
          </p>

          {groupedEmployeeRows.map((group) => (
            <div className={styles.tableWrapper} key={group.bucket} style={{ marginTop: '16px' }}>
              <h3 style={{ marginBottom: '8px' }}>{group.title}</h3>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Funcionário</th>
                    <th>Função</th>
                    <th>Presente</th>
                    <th>Gorjeta Percentual (€)</th>
                    <th>Gorjeta Direta (€)</th>
                    <th>Desconto (€)</th>
                    <th>Valor Calculado (€)</th>
                    <th>Valor Efetivo (€)</th>
                    <th>Valor Não Pago (€)</th>
                  </tr>
                </thead>
                <tbody>
                  {group.rows.map((func) => {
                    const entry = gorjetaInputs[func.funcID] || {
                      valor: '',
                      direta: '',
                      presente: false,
                      desconto: '',
                    };
                    const isAbsoluteRole = isAbsoluteExternalRole(func.funcao);
                    const calculatedValue = employeeValuesById[func.funcID]?.calculated || 0;
                    const rulesEffectiveValue =
                      employeeValuesById[func.funcID]?.rulesEffective || 0;
                    const directEffectiveValue =
                      employeeValuesById[func.funcID]?.directEffective || 0;
                    const descontoVal = employeeValuesById[func.funcID]?.descontoValue || 0;
                    const effectiveValue = employeeValuesById[func.funcID]?.effective || 0;
                    const unpaidValue = employeeValuesById[func.funcID]?.unpaid || 0;
                    return (
                      <tr key={func.funcID}>
                        <td>
                          <div className={styles.nameCell}>
                            <span className={styles.avatar}>
                              {func.name.slice(0, 1).toUpperCase()}
                            </span>
                            <div>
                              <div className={styles.name}>{func.name}</div>
                              <div className={styles.metaText}>ID #{func.funcID}</div>
                            </div>
                          </div>
                        </td>
                        <td className={styles.muted}>{displayRole(func.funcao)}</td>
                        <td>
                          <label
                            className={styles.metaText}
                            style={{ display: 'inline-flex', alignItems: 'center', gap: '8px' }}
                          >
                            <input
                              type="checkbox"
                              checked={Boolean(entry.presente)}
                              onChange={(e) =>
                                handlePresencaChange(func.funcID, e.target.checked)
                              }
                            />
                            {entry.presente ? 'Sim' : 'Não'}
                          </label>
                        </td>
                        <td>
                          <input
                            type="number"
                            step="0.01"
                            value={isAbsoluteRole ? '' : entry.valor}
                            onChange={(e) =>
                              handleGorjetaChange(func.funcID, 'valor', e.target.value)
                            }
                            className={styles.smallInput}
                            placeholder={isAbsoluteRole ? 'Não usa pool' : '0.00'}
                            disabled={isAbsoluteRole}
                          />
                        </td>
                        <td>
                          <input
                            type="number"
                            step="0.01"
                            value={entry.direta}
                            onChange={(e) =>
                              handleGorjetaChange(func.funcID, 'direta', e.target.value)
                            }
                            className={styles.smallInput}
                            placeholder={isAbsoluteRole ? 'Valor absoluto' : '0.00'}
                          />
                        </td>
                        <td>
                          <input
                            type="number"
                            step="0.01"
                            min="0"
                            value={entry.desconto}
                            onChange={(e) =>
                              handleGorjetaChange(func.funcID, 'desconto', e.target.value)
                            }
                            className={styles.smallInput}
                            placeholder="0.00"
                          />
                        </td>
                        <td className={styles.muted}>{currency(calculatedValue)}</td>
                        <td>
                          <div className={styles.highlight}>{currency(effectiveValue)}</div>
                          <div className={styles.metaText}>
                            Regras: {currency(rulesEffectiveValue)}
                          </div>
                          <div className={styles.metaText}>
                            Diretas: {currency(directEffectiveValue)}
                          </div>
                          {descontoVal > 0 && (
                            <div className={styles.metaText} style={{ color: '#e74c3c' }}>
                              Desconto: -{currency(descontoVal)}
                            </div>
                          )}
                        </td>
                        <td className={styles.muted}>{currency(unpaidValue)}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          ))}
        </section>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Distribuição por Função</h2>
              <p>
                Resultado final por função, respeitando exatamente as regras ativas e o saldo real de
                cada fonte de pagamento.
              </p>
            </div>
          </div>

          <div className={styles.distributionGrid}>
            {distributionRoleCards.map(({ bucket, title, totals, effective, rulesEffective, directEffective }) => (
              <div key={`dist-role-${bucket}`} className={styles.distributionCard}>
                <div className={styles.distributionTitle}>{title}</div>
                <div className={styles.distributionValue}>
                  {currency(effective)}
                </div>
                <div className={styles.distributionMeta}>
                  Regras: {currency(rulesEffective)}
                  {directEffective > 0 && <> · Diretas: {currency(directEffective)}</>}
                </div>
                {(totals.paidFromTipPool > 0 || totals.paidFromFinanceiro > 0 || totals.paidExternal > 0) && (
                  <div className={styles.distributionMeta}>
                    {totals.paidFromTipPool > 0 && <>Pool: {currency(totals.paidFromTipPool)} </>}
                    {totals.paidFromFinanceiro > 0 && <>· Financeiro: {currency(totals.paidFromFinanceiro)} </>}
                    {totals.paidExternal > 0 && <>· Externo: {currency(totals.paidExternal)}</>}
                  </div>
                )}
                {totals.unpaid > 0 && (
                  <div className={styles.distributionMeta} style={{ color: '#e74c3c' }}>
                    Não pago: {currency(totals.unpaid)}
                  </div>
                )}
              </div>
            ))}

            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Pool não distribuído</div>
              <div className={styles.distributionValue}>
                {currency(poolNotAllocated)}
              </div>
              <div className={styles.distributionMeta}>
                Pool inicial: {currency(poolInitial)} · Distribuído do pool: {currency(distributedFromPool)}
              </div>
            </div>

            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Total não pago</div>
              <div className={styles.distributionValue}>{currency(totalUnpaid)}</div>
              <div className={styles.distributionMeta}>
                Diferença entre teórico e pago por falta de saldo no pool de pagamento.
              </div>
            </div>
          </div>

          <div className={styles.notice}>
            <div>
              {distributionRoleCards
                .map((item) => (
                  <span key={`summary-role-${item.bucket}`}>
                    <strong>{item.title}:</strong> {currency(item.effective)}
                    {' · '}
                  </span>
                ))}
              <strong>Pool inicial:</strong> {currency(poolInitial)}
              {' · '}
              <strong>Pool distribuído (TIP_POOL):</strong> {currency(distributedFromPool)}
              {' · '}
              <strong>Pool não distribuído:</strong> {currency(poolNotAllocated)}
            </div>
          </div>
        </section>

        {/* Bottom Save Button */}
        <div style={{ margin: '16px 0' }}>
          <button
            type="button"
            className={styles.btnPrimary}
            onClick={handleSalvarFinanceiro}
            disabled={snapshotLoading || computeLoading || !restaurantId}
            style={{ width: '100%', padding: '14px 24px', fontSize: 16, fontWeight: 700 }}
          >
            {snapshotLoading ? 'Salvando...' : computeLoading ? 'Calculando...' : 'Salvar dia'}
          </button>
          {formDirty && (
            <span className={styles.unsavedBadge} style={{ marginTop: 8, justifyContent: 'center' }}><span className={styles.unsavedDot} />Não salvo</span>
          )}
        </div>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Resumo Operacional</h2>
              <p>Fecho de caixa com linhas personalizadas e depósito selecionável.</p>
            </div>
            {!fechoLoading && fechoData !== null && (
              <span
                style={{
                  alignSelf: 'center',
                  padding: '6px 12px',
                  borderRadius: 999,
                  fontSize: 13,
                  fontWeight: 700,
                  background: fechoData.id ? '#dcfce7' : '#fef9c3',
                  color: fechoData.id ? '#166534' : '#854d0e',
                }}
              >
                {fechoData.id ? '✓ Guardado' : '● Novo'}
              </span>
            )}
          </div>

          {fechoSuccess && <div className={styles.info}>{fechoSuccess}</div>}

          <div className={styles.notice} style={{ marginBottom: 14 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
              <div>
                <strong>Sugestão automática:</strong>{' '}
                {resumoOperacionalSuggestedItems.length} linhas · Total{' '}
                {currency(resumoOperacionalSuggestedItemsTotal)} · Depósito sugerido{' '}
                {currency(resumoOperacionalSuggestedDepositTotal)}
                {resumoOperacionalSuggestedItems.length > 0 && (
                  <details className={styles.metaText} style={{ marginTop: 6 }}>
                    <summary>Ver itens sugeridos</summary>
                    <div style={{ marginTop: 6 }}>
                      {resumoOperacionalSuggestedItems
                        .map((item) => `${item.label}: ${currency(item.valor)}`)
                        .join(' · ')}
                    </div>
                  </details>
                )}
              </div>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={applyResumoOperacionalSuggestions}
                disabled={!restaurantId || computeLoading}
              >
                Aplicar sugestão
              </button>
            </div>
          </div>

          {/* Summary bar */}
          {(parseFloat(fechoFaturamento) > 0 || parseFloat(fechoDinheiro) > 0 || fechoItemsTotal > 0) && (
            <div className={styles.summaryGridSmall} style={{ marginBottom: 16 }}>
              <div className={styles.summaryCard}>
                <span className={styles.summaryLabel}>Faturamento</span>
                <strong className={styles.summaryValue}>{currency(parseFloat(fechoFaturamento) || 0)}</strong>
              </div>
              <div className={styles.summaryCard}>
                <span className={styles.summaryLabel}>Multibanco</span>
                <strong className={styles.summaryValue}>{currency(parseFloat(fechoMultibanco) || 0)}</strong>
              </div>
              <div className={styles.summaryCard}>
                <span className={styles.summaryLabel}>Dinheiro a Depositar</span>
                <strong className={styles.summaryValue}>{currency(parseFloat(fechoDinheiro) || 0)}</strong>
              </div>
              <div className={styles.summaryCard}>
                <span className={styles.summaryLabel}>Valor em Espécie</span>
                <strong className={styles.summaryValue}>{currency(valorTotalEspecie)}</strong>
              </div>
              {fechoItemsTotal > 0 && (
                <div className={styles.summaryCard}>
                  <span className={styles.summaryLabel}>Total Canais</span>
                  <strong className={styles.summaryValue}>{currency(fechoItemsTotal)}</strong>
                </div>
              )}
              <div className={styles.summaryCard}>
                <span className={styles.summaryLabel}>Sobra em Espécie</span>
                <strong className={styles.summaryValue} style={{ color: sobraEmEspecie < 0 ? '#dc2626' : sobraEmEspecie === 0 ? '#166534' : '#854d0e' }}>
                  {currency(sobraEmEspecie)}
                </strong>
              </div>
            </div>
          )}

          {/* 1. Faturamento Global */}
          <div className={styles.inputRow}>
            <div className={styles.inputGroup}>
              <label>Faturamento Global (€)</label>
              <input
                type="number"
                min="0"
                step="0.01"
                value={fechoFaturamento}
                onChange={(e) => {
                  setFechoSuggestionSyncActive(false);
                  setFechoFaturamento(e.target.value);
                }}
                placeholder="0.00"
              />
            </div>

            {/* 2. Multibanco (manual) */}
            <div className={styles.inputGroup}>
              <label>Multibanco (€)</label>
              <input
                type="number"
                min="0"
                step="0.01"
                value={fechoMultibanco}
                onChange={(e) => {
                  setFechoSuggestionSyncActive(false);
                  setFechoMultibanco(e.target.value);
                }}
                placeholder="0.00"
              />
              <div className={styles.metaText} style={{ marginTop: 4 }}>
                Valor manual — não se auto-ajusta.
              </div>
            </div>
          </div>

          {/* 3. Valor a Depositar */}
          <div className={styles.inputRow}>
            <div className={styles.inputGroup}>
              <label>Dinheiro a Depositar (€)</label>
              <input
                type="number"
                min="0"
                step="0.01"
                value={fechoDinheiro}
                onChange={(e) => {
                  setFechoSuggestionSyncActive(false);
                  setFechoDinheiro(e.target.value);
                }}
                placeholder="0.00"
              />
              <div className={styles.metaText} style={{ marginTop: 6 }}>
                Linhas marcadas para depósito: {currency(fechoDepositSelectedTotal)}
                {sobraContaNoDeposito && sobraEmEspecie !== 0 && (
                  <span> + Sobra: {currency(sobraEmEspecie)}</span>
                )}
              </div>
              <button
                type="button"
                className={styles.btnSecondary}
                style={{ marginTop: 8 }}
                onClick={applySelectedItemsToDepositField}
              >
                Usar linhas marcadas
              </button>
            </div>

            {/* 4. Valor Total em Espécie (read-only) */}
            <div className={styles.inputGroup}>
              <label>Valor Total em Espécie (€)</label>
              <input
                type="text"
                value={currency(valorTotalEspecie)}
                readOnly
                disabled
                style={{ background: '#f3f4f6', cursor: 'not-allowed' }}
              />
              <div className={styles.metaText} style={{ marginTop: 4 }}>
                = Faturamento − Multibanco (calculado)
              </div>
            </div>
          </div>

          {/* 5. Canais / Quebras */}
          <div className={styles.notice} style={{ marginBottom: 16 }}>
            <div>
              <strong>Canais / Quebras:</strong> Total {currency(fechoItemsTotal)}
              <div className={styles.metaText} style={{ marginTop: 4 }}>
                Adicione as linhas de destino do dinheiro em espécie (gorjetas, pagamentos, etc.).
              </div>
            </div>
          </div>

          <div style={{ marginBottom: 16 }}>
            <h3 style={{ margin: '0 0 8px', fontSize: 15, color: '#374151', fontWeight: 700 }}>Quebras / Canais</h3>
            {fechoItens.length > 0 ? (
              <div className={styles.tableWrapper}>
                <table className={styles.table}>
                  <thead>
                    <tr>
                      <th>Descrição</th>
                      <th>Valor (€)</th>
                      <th>Depósito</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {fechoItens.map((item, idx) => (
                      <tr key={idx}>
                        <td>
                          <input
                            type="text"
                            value={item.label}
                            onChange={(e) => updateFechoItem(idx, 'label', e.target.value)}
                            className={styles.smallInput}
                            style={{ width: '100%' }}
                            placeholder="Descrição"
                          />
                        </td>
                        <td>
                          <input
                            type="number"
                            min="0"
                            step="0.01"
                            value={item.valor}
                            onChange={(e) =>
                              updateFechoItem(
                                idx,
                                'valor',
                                e.target.value === '' ? '' : parseFloat(e.target.value) || 0,
                              )
                            }
                            className={styles.smallInput}
                          />
                        </td>
                        <td>
                          <button
                            type="button"
                            className={item.contaNoDeposito ? styles.btnPrimary : styles.btnSecondary}
                            style={{ padding: '6px 10px', fontSize: 12 }}
                            onClick={() => toggleFechoItemContaNoDeposito(idx)}
                          >
                            {item.contaNoDeposito ? 'Conta no depósito' : 'Ignorar'}
                          </button>
                        </td>
                        <td>
                          <button
                            type="button"
                            className={styles.btnDanger}
                            style={{ padding: '4px 10px', fontSize: 14 }}
                            onClick={() => removeFechoItem(idx)}
                          >
                            ×
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            ) : (
              <p style={{ color: '#6b7280', fontSize: 14, margin: '0 0 8px' }}>
                Nenhum item. Adicione abaixo ou configure templates.
              </p>
            )}
            <button
              onClick={addFechoItem}
              style={{ marginTop: 8, padding: '7px 14px', background: 'none', border: '1px dashed #94a3b8', borderRadius: 8, color: '#475569', fontSize: 13, cursor: 'pointer' }}
            >
              + Adicionar linha
            </button>
          </div>

          {/* 6. Sobra em Espécie (read-only + deposit toggle) */}
          <div className={styles.inputGroup} style={{ marginBottom: 16 }}>
            <label>Sobra em Espécie (€)</label>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <input
                type="text"
                value={currency(sobraEmEspecie)}
                readOnly
                disabled
                style={{
                  background: '#f3f4f6',
                  cursor: 'not-allowed',
                  color: sobraEmEspecie < 0 ? '#dc2626' : sobraEmEspecie === 0 ? '#166534' : '#854d0e',
                  fontWeight: 700,
                  textAlign: 'center',
                  flex: 1,
                }}
              />
              <button
                type="button"
                className={sobraContaNoDeposito ? styles.btnPrimary : styles.btnSecondary}
                style={{ padding: '6px 10px', fontSize: 12, whiteSpace: 'nowrap' }}
                onClick={() => setSobraContaNoDeposito((v) => !v)}
              >
                {sobraContaNoDeposito ? 'Conta no depósito' : 'Ignorar'}
              </button>
            </div>
            <div className={styles.metaText} style={{ marginTop: 4 }}>
              = Valor em Espécie − Total Canais (calculado)
            </div>
          </div>

          {/* Observações */}
          <div className={styles.inputGroup} style={{ marginBottom: 16 }}>
              <label>Notas</label>
              <textarea
                value={fechoNotas}
                onChange={(e) => setFechoNotas(e.target.value)}
                placeholder="Observações adicionais do fecho, como explicações para diferenças entre faturamento e dinheiro a depositar"
                style={{ padding: '10px 12px', border: '1px solid #d1d5db', borderRadius: 8, fontSize: 14, resize: 'vertical', minHeight: 60, fontFamily: 'inherit' }}
              />
          </div>

          {/* Save */}
          <div className={styles.responsiveActionRow}>
            <button
              className={styles.btnSuccess}
              onClick={handleSaveFecho}
              disabled={fechoSaving || !restaurantId}
            >
              {fechoSaving ? 'A guardar…' : fechoData?.id ? 'Atualizar Fecho' : 'Guardar Fecho'}
            </button>
          </div>

          {/* Templates – collapsible */}
          <div style={{ borderTop: '1px solid #e5e7eb', paddingTop: 14 }}>
            <button
              onClick={() => setShowFechoTemplates((v) => !v)}
              style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 8, fontSize: 14, fontWeight: 700, color: '#374151', padding: 0 }}
            >
              Templates de Itens
              <span style={{ fontSize: 11 }}>{showFechoTemplates ? '▲' : '▼'}</span>
            </button>
            {showFechoTemplates && (
              <div style={{ marginTop: 12 }}>
                {fechoTemplates.length === 0 && (
                  <p style={{ color: '#6b7280', fontSize: 14 }}>Sem templates configurados.</p>
                )}
                {fechoTemplates.map((t) => (
                  <div key={t.id} className={styles.responsiveRow} style={{ marginBottom: 8 }}>
                    {editingTemplate?.id === t.id ? (
                      <>
                        <input
                          type="text"
                          value={editingTemplate.label}
                          onChange={(e) => setEditingTemplate((prev) => prev ? { ...prev, label: e.target.value } : prev)}
                          className={styles.responsiveGrow}
                          style={{ padding: '8px 10px', border: '1px solid #d1d5db', borderRadius: 8, fontSize: 14 }}
                        />
                        <input
                          type="number"
                          value={editingTemplate.ordem}
                          onChange={(e) => setEditingTemplate((prev) => prev ? { ...prev, ordem: e.target.value } : prev)}
                          placeholder="Ordem"
                          className={styles.responsiveFixedSm}
                          style={{ padding: '8px 10px', border: '1px solid #d1d5db', borderRadius: 8, fontSize: 14 }}
                        />
                        <button className={styles.btnPrimary} style={{ padding: '8px 14px', fontSize: 13 }} onClick={handleSaveTemplate}>Salvar</button>
                        <button className={styles.btnSecondary} style={{ padding: '8px 14px', fontSize: 13 }} onClick={() => setEditingTemplate(null)}>Cancelar</button>
                      </>
                    ) : (
                      <>
                        <span className={styles.responsiveGrow} style={{ fontSize: 14, color: '#111827' }}>
                          {t.label}
                          <span style={{ color: '#9ca3af', fontSize: 12, marginLeft: 8 }}>ordem {t.ordem}</span>
                        </span>
                        <button className={styles.btnInfo} style={{ padding: '6px 12px', fontSize: 12 }} onClick={() => setEditingTemplate({ id: t.id, label: t.label, ordem: String(t.ordem) })}>Editar</button>
                        <button className={styles.btnDanger} style={{ padding: '6px 12px', fontSize: 12 }} onClick={() => handleDeleteTemplate(t.id)}>×</button>
                      </>
                    )}
                  </div>
                ))}
                <div className={styles.responsiveRow} style={{ marginTop: 10 }}>
                  <input
                    type="text"
                    placeholder="Novo template (ex: Multibanco)"
                    value={newTemplateLabel}
                    onChange={(e) => setNewTemplateLabel(e.target.value)}
                    className={styles.responsiveGrow}
                    style={{ padding: '8px 10px', border: '1px solid #d1d5db', borderRadius: 8, fontSize: 14 }}
                  />
                  <input
                    type="number"
                    placeholder="Ordem"
                    value={newTemplateOrdem}
                    onChange={(e) => setNewTemplateOrdem(e.target.value)}
                    className={styles.responsiveFixedSm}
                    style={{ padding: '8px 10px', border: '1px solid #d1d5db', borderRadius: 8, fontSize: 14 }}
                  />
                  <button
                    className={styles.btnPrimary}
                    style={{ padding: '8px 14px', fontSize: 13 }}
                    onClick={handleAddTemplate}
                    disabled={!newTemplateLabel.trim()}
                  >
                    Adicionar
                  </button>
                </div>
              </div>
            )}
          </div>
        </section>
      </div>
    </Layout>
  );
}
