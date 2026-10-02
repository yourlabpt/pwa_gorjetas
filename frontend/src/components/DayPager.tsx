import { ReactNode } from 'react';
import styles from '../styles/financeiro-diario.module.css';
import { dayOfMonth, weekdayPT } from '../lib/dates';

export type DayStatus = 'saved' | 'draft' | 'missing' | 'future';

export interface DayChip {
  date: string; // YYYY-MM-DD
  status: DayStatus;
  note?: string;
}

/** "‹ previous | title | next ›" bar used to flip days or periods like book pages. */
export function PagerBar({
  title,
  prevLabel,
  nextLabel,
  onPrev,
  onNext,
  nextDisabled = false,
  children,
}: {
  title: string;
  prevLabel: string;
  nextLabel: string;
  onPrev: () => void;
  onNext: () => void;
  nextDisabled?: boolean;
  children?: ReactNode;
}) {
  return (
    <div className={styles.pagerBar}>
      <button type="button" className={styles.pagerBtn} onClick={onPrev} data-view-allowed="true">
        ‹ {prevLabel}
      </button>
      <div className={styles.pagerTitle} aria-live="polite">
        {title}
      </div>
      <button
        type="button"
        className={styles.pagerBtn}
        onClick={onNext}
        disabled={nextDisabled}
        data-view-allowed="true"
      >
        {nextLabel} ›
      </button>
      {children}
    </div>
  );
}

const STATUS_LABEL: Record<DayStatus, string> = {
  saved: 'guardado',
  draft: 'rascunho não guardado',
  missing: 'sem dados',
  future: 'futuro',
};

/** Clickable strip of days coloured by status. A week fills the row; longer periods scroll. */
export function DayStrip({
  days,
  selected,
  onPick,
  scroll = false,
}: {
  days: DayChip[];
  selected?: string;
  onPick: (date: string) => void;
  scroll?: boolean;
}) {
  return (
    <div className={scroll ? styles.dayStripScroll : styles.dayStrip}>
      {days.map((day) => (
        <button
          key={day.date}
          type="button"
          className={`${styles.dayChip} ${styles[`dayChip_${day.status}`]} ${
            day.date === selected ? styles.dayChipSelected : ''
          }`}
          onClick={() => onPick(day.date)}
          disabled={day.status === 'future'}
          title={`${day.date}: ${STATUS_LABEL[day.status]}`}
          aria-label={`${weekdayPT(day.date)} ${dayOfMonth(day.date)}, ${STATUS_LABEL[day.status]}`}
          aria-current={day.date === selected ? 'date' : undefined}
          data-view-allowed="true"
        >
          <span className={styles.dayChipWeekday}>{weekdayPT(day.date)}</span>
          <strong className={styles.dayChipDay}>{dayOfMonth(day.date)}</strong>
          {day.note !== undefined && <span className={styles.dayChipNote}>{day.note}</span>}
        </button>
      ))}
    </div>
  );
}

export function DayLegend() {
  return (
    <div className={styles.dayLegend}>
      <span><i className={`${styles.legendDot} ${styles.dayChip_saved}`} />Guardado</span>
      <span><i className={`${styles.legendDot} ${styles.dayChip_draft}`} />Rascunho não guardado</span>
      <span><i className={`${styles.legendDot} ${styles.dayChip_missing}`} />Sem dados</span>
    </div>
  );
}
