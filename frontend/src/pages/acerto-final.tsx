'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
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

type CalculationType = 'PERCENT' | 'FIXED_AMOUNT';
type PaymentSource = 'TIP_POOL' | 'FINANCEIRO' | 'ABSOLUTE_EXTERNAL';
type SettlementType = 'DIARIO' | 'PERIODO';
type SettlementModeSummary = 'DIARIO' | 'PERIODO' | 'MISTO';

interface RegraDistribuicao {
  id: number;
  role_name: string;
  calculation_type: CalculationType;
  rate: number;
  payment_source: PaymentSource;
  tipo_de_acerto?: SettlementType;
  ordem: number;
  ativo: boolean;
}

interface SnapshotEntry {
  funcID: number | null;
  role: string;
  employee_name?: string | null;
  employee_funcao?: string | null;
  valor_pool: number;
  valor_direto: number;
  valor_teorico: number;
  valor_pago: number;
}

interface SnapshotPresencaEntry {
  funcID: number;
  presente: boolean;
}

interface SnapshotDay {
  data: string;
  faturamento_inserido: number | null;
  faturamento_com_gorjeta?: number | null;
  faturamento_sem_gorjeta?: number | null;
  valor_total_gorjetas?: number | null;
  presencas?: SnapshotPresencaEntry[];
  entries: SnapshotEntry[];
}

interface SourceRatios {
  TIP_POOL: number;
  FINANCEIRO: number;
  ABSOLUTE_EXTERNAL: number;
}

interface BucketConfig {
  bucket: string;
  rules: RegraDistribuicao[];
  settlementMode: SettlementModeSummary;
  dailyShare: number;
  sourceRatios: SourceRatios;
}

interface AggregatedEmployeeRow {
  funcID: number;
  name: string;
  funcao: string;
  bucket: string;
  diasTrabalhados: number;
  acumuladoTeorico: number;
  acumuladoPago: number;
  acumuladoDireto: number;
  acumuladoPeriodo: number;
  jaRecebidoDiario: number;
  sugeridoAcerto: number;
  settlementMode: SettlementModeSummary;
  sourceRatios: SourceRatios;
}

const ALLOWED_ROLES = ['SUPER_ADMIN', 'ADMIN', 'SUPERVISOR', 'GERENTE'];
const TODAY = new Date().toISOString().split('T')[0];
const FIRST_DAY_OF_MONTH = new Date(
  new Date().getFullYear(),
  new Date().getMonth(),
  1,
)
  .toISOString()
  .split('T')[0];

const round2 = (value: number) => Math.round(value * 100) / 100;
const currency = (value: number) => `€ ${round2(value).toFixed(2)}`;

const normalizeRole = (value: string) =>
  (value || '')
    .toLowerCase()
    .trim()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');

const toRoleBucket = (roleName: string) => {
  const role = normalizeRole(roleName);
  if (role === 'staff' || role.includes('garcom')) return 'staff';
  if (role.includes('gestor') || role.includes('gerente')) return 'gerente';
  if (role.includes('supervisor')) return 'supervisor';
  if (role.includes('cozinha')) return 'cozinha';
  if (role === 'bar' || role.includes('bar')) return 'bar';
  if (role.includes('chamador')) return 'chamador';
  return role || 'outros';
};

const bucketTitle = (bucket: string) => {
  if (bucket === 'supervisor') return 'Gestores';
  if (bucket === 'chamador') return 'Chamadores';
  if (bucket === 'gerente') return 'Gerentes';
  if (bucket === 'staff') return 'Staff';
  if (bucket === 'cozinha') return 'Cozinha';
  if (bucket === 'bar') return 'Bar';
  return bucket
    .split('_')
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ');
};

const defaultSourceRatios: SourceRatios = {
  TIP_POOL: 1,
  FINANCEIRO: 0,
  ABSOLUTE_EXTERNAL: 0,
};

const toNumberSafe = (value: any): number => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
};

const weightForRule = (rule: RegraDistribuicao): number => {
  const rate = Math.abs(toNumberSafe(rule.rate));
  return rate > 0 ? rate : 1;
};

const normalizeSourceRatios = (weights: SourceRatios): SourceRatios => {
  const total = weights.TIP_POOL + weights.FINANCEIRO + weights.ABSOLUTE_EXTERNAL;
  if (total <= 0) return { ...defaultSourceRatios };
  return {
    TIP_POOL: weights.TIP_POOL / total,
    FINANCEIRO: weights.FINANCEIRO / total,
    ABSOLUTE_EXTERNAL: weights.ABSOLUTE_EXTERNAL / total,
  };
};

const allocateBySourceRatios = (
  value: number,
  ratios: SourceRatios,
): Record<PaymentSource, number> => {
  const normalizedValue = round2(Math.max(value, 0));
  if (normalizedValue <= 0) {
    return {
      TIP_POOL: 0,
      FINANCEIRO: 0,
      ABSOLUTE_EXTERNAL: 0,
    };
  }

  const provisional = {
    TIP_POOL: round2(normalizedValue * ratios.TIP_POOL),
    FINANCEIRO: round2(normalizedValue * ratios.FINANCEIRO),
    ABSOLUTE_EXTERNAL: round2(normalizedValue * ratios.ABSOLUTE_EXTERNAL),
  };

  const allocated = round2(
    provisional.TIP_POOL + provisional.FINANCEIRO + provisional.ABSOLUTE_EXTERNAL,
  );
  const delta = round2(normalizedValue - allocated);

  const sourceOrder: PaymentSource[] = ['TIP_POOL', 'FINANCEIRO', 'ABSOLUTE_EXTERNAL'];
  const sortedSources = [...sourceOrder].sort((a, b) => ratios[b] - ratios[a]);
  const targetSource = sortedSources[0] || 'TIP_POOL';
  provisional[targetSource] = round2(provisional[targetSource] + delta);

  return provisional;
};

const parseInputValue = (raw: string | undefined): number => {
  if (!raw) return 0;
  const normalized = raw.replace(',', '.').trim();
  const parsed = Number(normalized);
  return Number.isFinite(parsed) ? Math.max(parsed, 0) : 0;
};

const isExternalOnlyRatios = (ratios: SourceRatios) =>
  ratios.ABSOLUTE_EXTERNAL > 0.999 &&
  ratios.TIP_POOL < 0.001 &&
  ratios.FINANCEIRO < 0.001;

const computeSourceAllocationForRow = (
  row: Pick<AggregatedEmployeeRow, 'sourceRatios' | 'acumuladoDireto'>,
  value: number,
): Record<PaymentSource, number> => {
  const normalizedValue = round2(Math.max(value, 0));
  if (normalizedValue <= 0) {
    return {
      TIP_POOL: 0,
      FINANCEIRO: 0,
      ABSOLUTE_EXTERNAL: 0,
    };
  }

  if (isExternalOnlyRatios(row.sourceRatios)) {
    return {
      TIP_POOL: 0,
      FINANCEIRO: 0,
      ABSOLUTE_EXTERNAL: normalizedValue,
    };
  }

  // Direct tips are external by nature and should not consume TIP_POOL/FINANCEIRO.
  const directPart = round2(
    Math.min(normalizedValue, Math.max(row.acumuladoDireto || 0, 0)),
  );
  const rulePart = round2(Math.max(normalizedValue - directPart, 0));
  const fromRules = allocateBySourceRatios(rulePart, row.sourceRatios);

  return {
    TIP_POOL: fromRules.TIP_POOL,
    FINANCEIRO: fromRules.FINANCEIRO,
    ABSOLUTE_EXTERNAL: round2(fromRules.ABSOLUTE_EXTERNAL + directPart),
  };
};

export default function AcertoFinalPage() {
  const router = useRouter();

  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [restID, setRestID] = useSessionPageState<number | null>('acertoFinalRestID', null);
  const [fromDate, setFromDate] = useSessionPageState<string>('acertoFinalFrom', FIRST_DAY_OF_MONTH);
  const [toDate, setToDate] = useSessionPageState<string>('acertoFinalTo', TODAY);

  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);
  const [regras, setRegras] = useState<RegraDistribuicao[]>([]);
  const [snapshots, setSnapshots] = useState<SnapshotDay[]>([]);

  const [acertoInputs, setAcertoInputs] = useState<Record<number, string>>({});
  const [formulaMultiplier, setFormulaMultiplier] = useState('1.00');
  const [formulaOffset, setFormulaOffset] = useState('0.00');

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [info, setInfo] = useState('');

  const selectedRestaurant = useMemo(
    () => restaurantes.find((rest) => rest.restID === restID) || null,
    [restaurantes, restID],
  );

  const loadRestaurantes = useCallback(async () => {
    const res = await apiClient.getRestaurantes(true);
    const list = (res.data || []) as Restaurante[];
    setRestaurantes(list);

    if (!list.length) {
      setRestID(null);
      return;
    }

    const hasCurrent = restID != null && list.some((rest) => rest.restID === restID);
    if (!hasCurrent) {
      setRestID(list[0].restID);
    }
  }, [restID, setRestID]);

  const loadPeriodoData = useCallback(async () => {
    if (!restID) return;

    try {
      setLoading(true);
      setError('');
      setInfo('');

      const effectiveFrom = fromDate || TODAY;
      const effectiveTo = toDate || effectiveFrom;

      const [funcRes, regrasRes, snapshotsRes] = await Promise.all([
        apiClient.getFuncionarios(restID, true),
        apiClient.getRegrasDistribuicao(restID),
        apiClient.getFinanceiroSnapshotRange(restID, effectiveFrom, effectiveTo),
      ]);

      setFuncionarios((funcRes.data || []) as Funcionario[]);
      setRegras(((regrasRes.data || []) as RegraDistribuicao[]).filter((rule) => rule.ativo !== false));
      setSnapshots((snapshotsRes.data || []) as SnapshotDay[]);
    } catch (err: any) {
      const backendMessage = err?.response?.data?.message;
      const normalizedMessage = Array.isArray(backendMessage)
        ? backendMessage.join(' | ')
        : backendMessage;
      setError(normalizedMessage || 'Erro ao carregar dados do período.');
    } finally {
      setLoading(false);
    }
  }, [fromDate, restID, toDate]);

  useEffect(() => {
    const bootstrap = async () => {
      try {
        const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) {
          router.replace('/login');
          return;
        }

        const meRes = await apiClient.me();
        const role: string = meRes.data?.role || '';
        if (!ALLOWED_ROLES.includes(role)) {
          router.replace('/');
          return;
        }

        setAuthorized(true);
        await loadRestaurantes();
      } catch {
        router.replace('/login');
      }
    };

    bootstrap();
  }, [loadRestaurantes, router]);

  useEffect(() => {
    if (!restID) return;
    loadPeriodoData();
  }, [loadPeriodoData, restID]);

  const bucketConfigs = useMemo(() => {
    const orderedRules = [...regras].sort((a, b) => a.ordem - b.ordem);
    const grouped = new Map<string, RegraDistribuicao[]>();

    orderedRules.forEach((rule) => {
      const bucket = toRoleBucket(rule.role_name);
      if (!grouped.has(bucket)) grouped.set(bucket, []);
      grouped.get(bucket)!.push(rule);
    });

    const configByBucket = new Map<string, BucketConfig>();

    grouped.forEach((rulesInBucket, bucket) => {
      const sourceWeights: SourceRatios = {
        TIP_POOL: 0,
        FINANCEIRO: 0,
        ABSOLUTE_EXTERNAL: 0,
      };
      let dailyWeight = 0;
      let periodWeight = 0;

      rulesInBucket.forEach((rule) => {
        const weight = weightForRule(rule);
        sourceWeights[rule.payment_source] += weight;

        const tipoAcerto = rule.tipo_de_acerto || 'DIARIO';
        if (tipoAcerto === 'PERIODO') {
          periodWeight += weight;
        } else {
          dailyWeight += weight;
        }
      });

      const sourceRatios = normalizeSourceRatios(sourceWeights);
      const totalSettlementWeight = dailyWeight + periodWeight;
      const dailyShare =
        totalSettlementWeight > 0 ? round2(dailyWeight / totalSettlementWeight) : 1;

      let settlementMode: SettlementModeSummary = 'DIARIO';
      if (dailyWeight > 0 && periodWeight > 0) settlementMode = 'MISTO';
      else if (periodWeight > 0) settlementMode = 'PERIODO';

      configByBucket.set(bucket, {
        bucket,
        rules: rulesInBucket,
        settlementMode,
        dailyShare,
        sourceRatios,
      });
    });

    return configByBucket;
  }, [regras]);

  const orderedBuckets = useMemo(() => {
    const bucketsFromRules: string[] = [];
    [...regras]
      .sort((a, b) => a.ordem - b.ordem)
      .forEach((rule) => {
        const bucket = toRoleBucket(rule.role_name);
        if (!bucketsFromRules.includes(bucket)) bucketsFromRules.push(bucket);
      });

    const bucketsFromEmployees = Array.from(
      new Set(funcionarios.map((func) => toRoleBucket(func.funcao))),
    );

    const defaults = ['supervisor', 'chamador', 'gerente', 'staff', 'cozinha', 'bar'];
    const merged = [...new Set([...bucketsFromRules, ...bucketsFromEmployees])];
    const ordered = [
      ...bucketsFromRules,
      ...defaults.filter((bucket) => merged.includes(bucket) && !bucketsFromRules.includes(bucket)),
      ...merged
        .filter((bucket) => !bucketsFromRules.includes(bucket) && !defaults.includes(bucket))
        .sort((a, b) => a.localeCompare(b)),
    ];

    return [...new Set(ordered)];
  }, [funcionarios, regras]);

  const aggregatedRows = useMemo(() => {
    const employeeMap = new Map<number, AggregatedEmployeeRow>();
    const workedDays = new Map<number, Set<string>>();

    funcionarios.forEach((func) => {
      const bucket = toRoleBucket(func.funcao);
      const bucketConfig = bucketConfigs.get(bucket);
      employeeMap.set(func.funcID, {
        funcID: func.funcID,
        name: func.name,
        funcao: func.funcao,
        bucket,
        diasTrabalhados: 0,
        acumuladoTeorico: 0,
        acumuladoPago: 0,
        acumuladoDireto: 0,
        acumuladoPeriodo: 0,
        jaRecebidoDiario: 0,
        sugeridoAcerto: 0,
        settlementMode: bucketConfig?.settlementMode || 'DIARIO',
        sourceRatios: bucketConfig?.sourceRatios || { ...defaultSourceRatios },
      });
    });

    snapshots.forEach((day) => {
      (day.presencas || []).forEach((presenca) => {
        if (!presenca.presente) return;
        if (!workedDays.has(presenca.funcID)) workedDays.set(presenca.funcID, new Set<string>());
        workedDays.get(presenca.funcID)!.add(day.data);
      });

      (day.entries || []).forEach((entry) => {
        if (entry.funcID == null) return;

        const funcID = Number(entry.funcID);
        const existing = employeeMap.get(funcID);
        const fallbackBucket = toRoleBucket(entry.employee_funcao || entry.role || 'outros');
        const fallbackConfig = bucketConfigs.get(fallbackBucket);

        if (!existing) {
          employeeMap.set(funcID, {
            funcID,
            name: entry.employee_name || `Func ${funcID}`,
            funcao: entry.employee_funcao || entry.role || '—',
            bucket: fallbackBucket,
            diasTrabalhados: 0,
            acumuladoTeorico: 0,
            acumuladoPago: 0,
            acumuladoDireto: 0,
            acumuladoPeriodo: 0,
            jaRecebidoDiario: 0,
            sugeridoAcerto: 0,
            settlementMode: fallbackConfig?.settlementMode || 'DIARIO',
            sourceRatios: fallbackConfig?.sourceRatios || { ...defaultSourceRatios },
          });
        }

        const current = employeeMap.get(funcID)!;
        current.acumuladoTeorico = round2(current.acumuladoTeorico + toNumberSafe(entry.valor_teorico));
        current.acumuladoPago = round2(current.acumuladoPago + toNumberSafe(entry.valor_pago));
        current.acumuladoDireto = round2(current.acumuladoDireto + toNumberSafe(entry.valor_direto));

        if (!current.name || current.name.startsWith('Func ')) {
          current.name = entry.employee_name || current.name;
        }
      });
    });

    employeeMap.forEach((row, funcID) => {
      row.diasTrabalhados = workedDays.get(funcID)?.size || 0;
      const bucketConfig = bucketConfigs.get(row.bucket);
      const dailyShare = bucketConfig?.dailyShare ?? 1;
      row.settlementMode = bucketConfig?.settlementMode || row.settlementMode;
      row.sourceRatios = bucketConfig?.sourceRatios || row.sourceRatios;

      const externalOnly = isExternalOnlyRatios(row.sourceRatios);
      row.acumuladoPeriodo = externalOnly
        ? round2(Math.max(row.acumuladoPago, row.acumuladoDireto))
        : round2(row.acumuladoPago + row.acumuladoDireto);

      row.jaRecebidoDiario =
        row.settlementMode === 'PERIODO'
          ? 0
          : round2(row.acumuladoPeriodo * dailyShare);
      row.sugeridoAcerto = row.acumuladoPeriodo;
    });

    return Array.from(employeeMap.values()).sort((a, b) => {
      const idxA = orderedBuckets.indexOf(a.bucket);
      const idxB = orderedBuckets.indexOf(b.bucket);
      if (idxA !== idxB) return idxA - idxB;
      const byName = a.name.localeCompare(b.name);
      if (byName !== 0) return byName;
      return a.funcID - b.funcID;
    });
  }, [bucketConfigs, funcionarios, orderedBuckets, snapshots]);

  const aggregatedSeed = useMemo(() => {
    const snapshotKey = snapshots
      .map((day) => `${day.data}:${(day.entries || []).length}`)
      .join('|');
    const rulesKey = regras
      .map((rule) => `${rule.id}:${rule.tipo_de_acerto || 'DIARIO'}`)
      .join('|');
    return `${restID || 'none'}::${fromDate}::${toDate}::${snapshotKey}::${rulesKey}::${aggregatedRows.length}`;
  }, [aggregatedRows.length, fromDate, regras, restID, snapshots, toDate]);

  useEffect(() => {
    const nextInputs: Record<number, string> = {};
    aggregatedRows.forEach((row) => {
      nextInputs[row.funcID] = row.sugeridoAcerto.toFixed(2);
    });
    setAcertoInputs(nextInputs);
  }, [aggregatedSeed, aggregatedRows]);

  const groupedRows = useMemo(() => {
    return orderedBuckets
      .map((bucket) => {
        const rows = aggregatedRows.filter((row) => row.bucket === bucket);
        if (!rows.length) return null;

        const config = bucketConfigs.get(bucket);
        return {
          bucket,
          title: bucketTitle(bucket),
          settlementMode: config?.settlementMode || 'DIARIO',
          sourceRatios: config?.sourceRatios || { ...defaultSourceRatios },
          rows,
        };
      })
      .filter(Boolean) as Array<{
      bucket: string;
      title: string;
      settlementMode: SettlementModeSummary;
      sourceRatios: SourceRatios;
      rows: AggregatedEmployeeRow[];
    }>;
  }, [aggregatedRows, bucketConfigs, orderedBuckets]);

  const periodTotals = useMemo(() => {
    const basePercent = toNumberSafe(selectedRestaurant?.percentagem_gorjeta_base);

    let faturamentoGlobal = 0;
    let faturamentoGorjetado = 0;
    let faturamentoLiquido = 0;
    let gorjetasPercentuais = 0;
    let gorjetasDiretas = 0;

    snapshots.forEach((day) => {
      const dayGlobal = toNumberSafe(day.faturamento_inserido);
      const dayTips = toNumberSafe(day.valor_total_gorjetas);
      const dayGorjetadoStored = toNumberSafe(day.faturamento_com_gorjeta);
      const dayLiquidoStored = toNumberSafe(day.faturamento_sem_gorjeta);

      const dayGorjetado =
        dayGorjetadoStored > 0
          ? dayGorjetadoStored
          : basePercent > 0
            ? round2(dayTips / (basePercent / 100))
            : 0;
      const dayLiquido =
        dayLiquidoStored > 0 ? dayLiquidoStored : Math.max(dayGlobal - dayTips, 0);

      faturamentoGlobal += dayGlobal;
      faturamentoGorjetado += dayGorjetado;
      faturamentoLiquido += dayLiquido;
      gorjetasPercentuais += dayTips;

      (day.entries || []).forEach((entry) => {
        gorjetasDiretas += toNumberSafe(entry.valor_direto);
      });
    });

    const faturamentoNaoGorjetado = Math.max(faturamentoGlobal - faturamentoGorjetado, 0);

    return {
      faturamentoGlobal: round2(faturamentoGlobal),
      faturamentoGorjetado: round2(faturamentoGorjetado),
      faturamentoNaoGorjetado: round2(faturamentoNaoGorjetado),
      faturamentoLiquido: round2(faturamentoLiquido),
      gorjetasPercentuais: round2(gorjetasPercentuais),
      gorjetasDiretas: round2(gorjetasDiretas),
    };
  }, [selectedRestaurant, snapshots]);

  const calculations = useMemo(() => {
    const perSourceDistributed: Record<PaymentSource, number> = {
      TIP_POOL: 0,
      FINANCEIRO: 0,
      ABSOLUTE_EXTERNAL: 0,
    };

    const rowsWithCurrent = aggregatedRows.map((row) => {
      const currentValue = round2(parseInputValue(acertoInputs[row.funcID]));
      const sourceAlloc = computeSourceAllocationForRow(row, currentValue);

      perSourceDistributed.TIP_POOL = round2(
        perSourceDistributed.TIP_POOL + sourceAlloc.TIP_POOL,
      );
      perSourceDistributed.FINANCEIRO = round2(
        perSourceDistributed.FINANCEIRO + sourceAlloc.FINANCEIRO,
      );
      perSourceDistributed.ABSOLUTE_EXTERNAL = round2(
        perSourceDistributed.ABSOLUTE_EXTERNAL + sourceAlloc.ABSOLUTE_EXTERNAL,
      );

      return {
        ...row,
        currentAcerto: currentValue,
        sourceAlloc,
      };
    });

    const availableBySource: Record<PaymentSource, number> = {
      TIP_POOL: periodTotals.gorjetasPercentuais,
      FINANCEIRO: periodTotals.faturamentoLiquido,
      ABSOLUTE_EXTERNAL: round2(
        rowsWithCurrent.reduce(
          (sum, row) =>
            sum + computeSourceAllocationForRow(row, row.sugeridoAcerto).ABSOLUTE_EXTERNAL,
          0,
        ),
      ),
    };

    const remainingBySource: Record<PaymentSource, number> = {
      TIP_POOL: round2(availableBySource.TIP_POOL - perSourceDistributed.TIP_POOL),
      FINANCEIRO: round2(
        availableBySource.FINANCEIRO - perSourceDistributed.FINANCEIRO,
      ),
      ABSOLUTE_EXTERNAL: round2(
        availableBySource.ABSOLUTE_EXTERNAL - perSourceDistributed.ABSOLUTE_EXTERNAL,
      ),
    };

    const totalsByBucket = new Map<
      string,
      {
        acumulado: number;
        recebidoDiario: number;
        acertoAtual: number;
      }
    >();

    rowsWithCurrent.forEach((row) => {
      if (!totalsByBucket.has(row.bucket)) {
        totalsByBucket.set(row.bucket, {
          acumulado: 0,
          recebidoDiario: 0,
          acertoAtual: 0,
        });
      }
      const current = totalsByBucket.get(row.bucket)!;
      current.acumulado = round2(current.acumulado + row.acumuladoPeriodo);
      current.recebidoDiario = round2(current.recebidoDiario + row.jaRecebidoDiario);
      current.acertoAtual = round2(current.acertoAtual + row.currentAcerto);
    });

    return {
      rowsWithCurrent,
      availableBySource,
      perSourceDistributed,
      remainingBySource,
      totalsByBucket,
      totalAcerto: round2(rowsWithCurrent.reduce((sum, row) => sum + row.currentAcerto, 0)),
      totalAcumulado: round2(
        rowsWithCurrent.reduce((sum, row) => sum + row.acumuladoPeriodo, 0),
      ),
      totalRecebidoDiario: round2(
        rowsWithCurrent.reduce((sum, row) => sum + row.jaRecebidoDiario, 0),
      ),
    };
  }, [acertoInputs, aggregatedRows, periodTotals]);

  const groupedRowsWithCurrent = useMemo(() => {
    const rowsByFuncID = new Map(
      calculations.rowsWithCurrent.map((row) => [row.funcID, row]),
    );

    return groupedRows.map((group) => {
      const rows = group.rows
        .map((row) => rowsByFuncID.get(row.funcID) || null)
        .filter(Boolean) as Array<AggregatedEmployeeRow & {
        currentAcerto: number;
        sourceAlloc: Record<PaymentSource, number>;
      }>;

      return {
        ...group,
        rows,
      };
    });
  }, [calculations.rowsWithCurrent, groupedRows]);

  const handleAcertoChange = (funcID: number, value: string) => {
    setAcertoInputs((prev) => ({ ...prev, [funcID]: value }));
  };

  const resetToSuggested = () => {
    const next: Record<number, string> = {};
    aggregatedRows.forEach((row) => {
      next[row.funcID] = row.sugeridoAcerto.toFixed(2);
    });
    setAcertoInputs(next);
    setInfo('Valores redefinidos para o acumulado sugerido do período.');
    setTimeout(() => setInfo(''), 2500);
  };

  const applyFormula = () => {
    const multiplier = parseInputValue(formulaMultiplier);
    const offset = parseInputValue(formulaOffset);

    const next: Record<number, string> = {};
    aggregatedRows.forEach((row) => {
      const nextValue = round2(row.sugeridoAcerto * multiplier + offset);
      next[row.funcID] = nextValue.toFixed(2);
    });
    setAcertoInputs(next);
    setInfo('Fórmula aplicada aos valores finais por funcionário.');
    setTimeout(() => setInfo(''), 2500);
  };

  const hasNegativeBalance =
    calculations.remainingBySource.TIP_POOL < 0 ||
    calculations.remainingBySource.FINANCEIRO < 0 ||
    calculations.remainingBySource.ABSOLUTE_EXTERNAL < 0;

  if (authorized === null) {
    return (
      <Layout>
        <div className={styles.container}>
          <p className={styles.muted}>Verificando permissões…</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Fechamento por período</p>
            <h1>Acerto Final</h1>
            <p className={styles.subtitle}>
              Calculadora de acerto por função e funcionário, com dedução dinâmica por fonte de
              pagamento conforme as regras ativas do restaurante.
            </p>
          </div>

          <div className={styles.filters}>
            <div className={styles.selectGroup}>
              <label>Restaurante</label>
              <select
                value={restID || ''}
                onChange={(e) => setRestID(parseInt(e.target.value, 10) || null)}
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
              <label>De</label>
              <input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} />
            </div>
            <div className={styles.selectGroup}>
              <label>Até</label>
              <input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} />
            </div>
            <div className={styles.selectGroup}>
              <label>&nbsp;</label>
              <button
                type="button"
                className={styles.btnPrimary}
                onClick={loadPeriodoData}
                disabled={!restID || loading}
              >
                {loading ? 'Carregando...' : 'Aplicar'}
              </button>
            </div>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {info && <div className={styles.info}>{info}</div>}
        {loading && <div className={styles.info}>Atualizando dados do período...</div>}

        {!loading && snapshots.length === 0 && (
          <div className={styles.info}>
            Nenhum snapshot encontrado no período selecionado. Salve os dias no Financeiro Diário
            antes de fechar o período.
          </div>
        )}

        <div className={styles.summaryGrid}>
          <div className={styles.summaryCard}>
            <span className={styles.summaryLabel}>Faturamento Global</span>
            <strong className={styles.summaryValue}>{currency(periodTotals.faturamentoGlobal)}</strong>
          </div>
          <div className={styles.summaryCard}>
            <span className={styles.summaryLabel}>Faturamento Gorjetado</span>
            <strong className={styles.summaryValue}>{currency(periodTotals.faturamentoGorjetado)}</strong>
          </div>
          <div className={styles.summaryCard}>
            <span className={styles.summaryLabel}>Faturamento Não Gorjetado</span>
            <strong className={styles.summaryValue}>
              {currency(periodTotals.faturamentoNaoGorjetado)}
            </strong>
          </div>
          <div className={styles.summaryCard}>
            <span className={styles.summaryLabel}>Faturamento Líquido</span>
            <strong className={styles.summaryValue}>{currency(periodTotals.faturamentoLiquido)}</strong>
          </div>
          <div className={styles.summaryCard}>
            <span className={styles.summaryLabel}>Gorjetas Percentuais</span>
            <strong className={styles.summaryValue}>{currency(periodTotals.gorjetasPercentuais)}</strong>
          </div>
          <div className={styles.summaryCard}>
            <span className={styles.summaryLabel}>Gorjetas Diretas</span>
            <strong className={styles.summaryValue}>{currency(periodTotals.gorjetasDiretas)}</strong>
          </div>
        </div>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Calculadora Flexível</h2>
              <p>
                Ajuste todos os valores finais por fórmula (multiplicador + adicional), similar a
                um preenchimento em lote de planilha.
              </p>
            </div>
          </div>

          <div className={styles.inputRow}>
            <div className={styles.inputGroup}>
              <label>Multiplicador</label>
              <input
                type="number"
                step="0.01"
                value={formulaMultiplier}
                onChange={(e) => setFormulaMultiplier(e.target.value)}
                placeholder="1.00"
              />
            </div>
            <div className={styles.inputGroup}>
              <label>Adicional por funcionário (€)</label>
              <input
                type="number"
                step="0.01"
                value={formulaOffset}
                onChange={(e) => setFormulaOffset(e.target.value)}
                placeholder="0.00"
              />
            </div>
          </div>

          <div className={styles.filters} style={{ marginTop: 10 }}>
            <button type="button" className={styles.btnSecondary} onClick={applyFormula}>
              Aplicar fórmula
            </button>
            <button type="button" className={styles.btnSecondary} onClick={resetToSuggested}>
              Voltar ao sugerido
            </button>
          </div>
        </section>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Saldos por Fonte de Pagamento</h2>
              <p>
                O total final digitado é abatido automaticamente das fontes conforme a regra de cada
                função.
              </p>
            </div>
          </div>

          <div className={styles.distributionGrid}>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>TIP_POOL</div>
              <div className={styles.distributionValue}>
                {currency(calculations.remainingBySource.TIP_POOL)}
              </div>
              <div className={styles.distributionMeta}>
                Disponível: {currency(calculations.availableBySource.TIP_POOL)} · Distribuído:{' '}
                {currency(calculations.perSourceDistributed.TIP_POOL)}
              </div>
            </div>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>FINANCEIRO</div>
              <div className={styles.distributionValue}>
                {currency(calculations.remainingBySource.FINANCEIRO)}
              </div>
              <div className={styles.distributionMeta}>
                Disponível: {currency(calculations.availableBySource.FINANCEIRO)} · Distribuído:{' '}
                {currency(calculations.perSourceDistributed.FINANCEIRO)}
              </div>
            </div>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>EXTERNO</div>
              <div className={styles.distributionValue}>
                {currency(calculations.remainingBySource.ABSOLUTE_EXTERNAL)}
              </div>
              <div className={styles.distributionMeta}>
                Disponível: {currency(calculations.availableBySource.ABSOLUTE_EXTERNAL)} ·
                Distribuído: {currency(calculations.perSourceDistributed.ABSOLUTE_EXTERNAL)}
              </div>
            </div>
            <div className={styles.distributionCard}>
              <div className={styles.distributionTitle}>Total do Acerto Final</div>
              <div className={styles.distributionValue}>{currency(calculations.totalAcerto)}</div>
              <div className={styles.distributionMeta}>
                Acumulado: {currency(calculations.totalAcumulado)} · Já recebido (diário):{' '}
                {currency(calculations.totalRecebidoDiario)}
              </div>
            </div>
          </div>

          {hasNegativeBalance && (
            <div className={styles.error} style={{ marginTop: 12 }}>
              O acerto final atual ultrapassa o saldo de uma ou mais fontes de pagamento. Ajuste os
              valores por funcionário ou revise as regras da função.
            </div>
          )}
        </section>

        <section className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2>Acerto por Função e Funcionário</h2>
              <p>
                Para regras com tipo de acerto Diário, os valores entram como já recebidos no
                período. Para Período, o fechamento é ajustado aqui.
              </p>
            </div>
          </div>

          {groupedRowsWithCurrent.length === 0 ? (
            <div className={styles.info}>Sem funcionários ou regras no período selecionado.</div>
          ) : (
            groupedRowsWithCurrent.map((group) => {
              const totals = calculations.totalsByBucket.get(group.bucket) || {
                acumulado: 0,
                recebidoDiario: 0,
                acertoAtual: 0,
              };
              const sourceHint = [
                group.sourceRatios.TIP_POOL > 0
                  ? `TIP_POOL ${round2(group.sourceRatios.TIP_POOL * 100).toFixed(1)}%`
                  : null,
                group.sourceRatios.FINANCEIRO > 0
                  ? `FINANCEIRO ${round2(group.sourceRatios.FINANCEIRO * 100).toFixed(1)}%`
                  : null,
                group.sourceRatios.ABSOLUTE_EXTERNAL > 0
                  ? `EXTERNO ${round2(group.sourceRatios.ABSOLUTE_EXTERNAL * 100).toFixed(1)}%`
                  : null,
              ]
                .filter(Boolean)
                .join(' · ');

              return (
                <div className={styles.tableWrapper} key={group.bucket} style={{ marginTop: 16 }}>
                  <h3 style={{ marginBottom: 8 }}>{group.title}</h3>
                  <p className={styles.metaText} style={{ marginBottom: 10 }}>
                    Tipo de acerto: <strong>{group.settlementMode}</strong>
                    {sourceHint ? ` · Fonte(s): ${sourceHint}` : ''}
                  </p>

                  <table className={styles.table}>
                    <thead>
                      <tr>
                        <th>Funcionário</th>
                        <th>Dias</th>
                        <th>Acumulado período</th>
                        <th>Já recebido (diário)</th>
                        <th>Valor final acertado</th>
                        <th>Diferença</th>
                      </tr>
                    </thead>
                    <tbody>
                      {group.rows.map((row) => {
                        const delta = round2(row.currentAcerto - row.acumuladoPeriodo);
                        return (
                          <tr key={row.funcID}>
                            <td>
                              <div className={styles.nameCell}>
                                <span className={styles.avatar}>
                                  {row.name.slice(0, 1).toUpperCase()}
                                </span>
                                <div>
                                  <div className={styles.name}>{row.name}</div>
                                  <div className={styles.metaText}>{row.funcao}</div>
                                </div>
                              </div>
                            </td>
                            <td>{row.diasTrabalhados}</td>
                            <td>{currency(row.acumuladoPeriodo)}</td>
                            <td>{currency(row.jaRecebidoDiario)}</td>
                            <td>
                              <input
                                type="number"
                                step="0.01"
                                min="0"
                                className={styles.smallInput}
                                value={acertoInputs[row.funcID] ?? row.sugeridoAcerto.toFixed(2)}
                                onChange={(e) => handleAcertoChange(row.funcID, e.target.value)}
                              />
                            </td>
                            <td
                              className={
                                delta >= 0 ? styles.highlight : styles.muted
                              }
                            >
                              {currency(delta)}
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                    <tfoot>
                      <tr>
                        <th>Total {group.title}</th>
                        <th>—</th>
                        <th>{currency(totals.acumulado)}</th>
                        <th>{currency(totals.recebidoDiario)}</th>
                        <th>{currency(totals.acertoAtual)}</th>
                        <th>{currency(round2(totals.acertoAtual - totals.acumulado))}</th>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              );
            })
          )}
        </section>
      </div>
    </Layout>
  );
}
