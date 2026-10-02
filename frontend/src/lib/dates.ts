// Day helpers on plain 'YYYY-MM-DD' strings. All math is done in UTC so a
// day never shifts with the browser's timezone or daylight saving.

const DAY_MS = 86_400_000;
const WEEKDAYS = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
const MONTHS = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

const toDate = (ymd: string) => new Date(`${ymd}T00:00:00Z`);
const toYmd = (d: Date) => d.toISOString().slice(0, 10);

/** Today's date in Lisbon (the restaurants' business day). */
export const todayLisbon = () =>
  new Intl.DateTimeFormat('en-CA', { timeZone: 'Europe/Lisbon' }).format(new Date());

export const addDays = (ymd: string, n: number) => toYmd(new Date(toDate(ymd).getTime() + n * DAY_MS));

/** Monday of the week containing ymd. */
export const startOfWeek = (ymd: string) => addDays(ymd, -((toDate(ymd).getUTCDay() + 6) % 7));

/** Inclusive list of days from..to (empty if from > to), at most `max` days. */
export const listDays = (from: string, to: string, max = 400) => {
  const days: string[] = [];
  for (let d = from; d <= to && days.length < max; d = addDays(d, 1)) days.push(d);
  return days;
};

/** Same day-of-month n months later, clamped to the month's last day (Jan 31 + 1 = Feb 28). */
export const addMonths = (ymd: string, n: number) => {
  const d = toDate(ymd);
  const first = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth() + n, 1));
  const lastDay = new Date(Date.UTC(first.getUTCFullYear(), first.getUTCMonth() + 1, 0)).getUTCDate();
  return toYmd(new Date(Date.UTC(first.getUTCFullYear(), first.getUTCMonth(), Math.min(d.getUTCDate(), lastDay))));
};

export const weekdayPT = (ymd: string) => WEEKDAYS[toDate(ymd).getUTCDay()];
export const dayOfMonth = (ymd: string) => toDate(ymd).getUTCDate();

/** "Ter, 29 set 2026" */
export const formatDayPT = (ymd: string) => {
  const d = toDate(ymd);
  return `${WEEKDAYS[d.getUTCDay()]}, ${d.getUTCDate()} ${MONTHS[d.getUTCMonth()]} ${d.getUTCFullYear()}`;
};

/** "1 set – 30 set 2026" */
export const formatRangePT = (from: string, to: string) => {
  const a = toDate(from);
  const b = toDate(to);
  const year = a.getUTCFullYear() === b.getUTCFullYear() ? '' : ` ${a.getUTCFullYear()}`;
  return `${a.getUTCDate()} ${MONTHS[a.getUTCMonth()]}${year} – ${b.getUTCDate()} ${MONTHS[b.getUTCMonth()]} ${b.getUTCFullYear()}`;
};

const monthStart = (ymd: string, offset = 0) => {
  const d = toDate(ymd);
  return toYmd(new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth() + offset, 1)));
};
const monthEnd = (ymd: string, offset = 0) => addDays(monthStart(ymd, offset + 1), -1);

export type PeriodPreset = 'week' | 'lastweek' | 'month' | 'lastmonth';

export const presetPeriod = (preset: PeriodPreset, today: string = todayLisbon()) => {
  switch (preset) {
    case 'week': {
      const from = startOfWeek(today);
      return { from, to: addDays(from, 6) };
    }
    case 'lastweek': {
      const from = addDays(startOfWeek(today), -7);
      return { from, to: addDays(from, 6) };
    }
    case 'month':
      return { from: monthStart(today), to: monthEnd(today) };
    case 'lastmonth':
      return { from: monthStart(today, -1), to: monthEnd(today, -1) };
  }
};

/** Which preset (if any) a range matches exactly. */
export const matchPreset = (from: string, to: string, today: string = todayLisbon()) =>
  (['week', 'lastweek', 'month', 'lastmonth'] as PeriodPreset[]).find((p) => {
    const r = presetPeriod(p, today);
    return r.from === from && r.to === to;
  });

/**
 * Move a period one "page" back (dir = -1) or forward (dir = 1).
 * A one-month span steps by month, keeping its start day: 1–31 Jan -> 1–28 Feb, and
 * 20 May–19 Jun -> 20 Jun–19 Jul (restaurants that close on the 20th).
 * Any other range steps by its own length.
 */
export const shiftPeriod = (from: string, to: string, dir: 1 | -1) => {
  if (addMonths(from, 1) === addDays(to, 1)) {
    const nextFrom = addMonths(from, dir);
    return { from: nextFrom, to: addDays(addMonths(nextFrom, 1), -1) };
  }
  const length = Math.round((toDate(to).getTime() - toDate(from).getTime()) / DAY_MS) + 1;
  return { from: addDays(from, dir * length), to: addDays(to, dir * length) };
};
