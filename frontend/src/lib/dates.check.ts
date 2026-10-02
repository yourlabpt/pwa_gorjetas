// Self-check for dates.ts. Run: node frontend/src/lib/dates.check.ts  (Node 22.6+ strips types)
import assert from 'node:assert/strict';
import {
  addDays,
  formatDayPT,
  formatRangePT,
  addMonths,
  listDays,
  matchPreset,
  presetPeriod,
  shiftPeriod,
  startOfWeek,
} from './dates.ts';

assert.equal(addDays('2026-02-28', 1), '2026-03-01');
assert.equal(addDays('2028-02-28', 1), '2028-02-29'); // leap year
assert.equal(addDays('2026-03-29', 1), '2026-03-30'); // DST change day in Lisbon
assert.equal(startOfWeek('2026-09-29'), '2026-09-28'); // Tue -> Mon
assert.equal(startOfWeek('2026-10-04'), '2026-09-28'); // Sun -> Mon
assert.equal(startOfWeek('2026-09-28'), '2026-09-28');
assert.deepEqual(listDays('2026-09-29', '2026-10-01'), ['2026-09-29', '2026-09-30', '2026-10-01']);
assert.deepEqual(listDays('2026-10-02', '2026-10-01'), []);
assert.equal(listDays('0002-09-01', '2026-09-30', 93).length, 93); // half-typed year must not loop for ages
assert.equal(addMonths('2026-01-31', 1), '2026-02-28');
assert.equal(addMonths('2026-05-20', 1), '2026-06-20');
assert.equal(addMonths('2026-01-15', -1), '2025-12-15');
assert.equal(formatDayPT('2026-09-29'), 'Ter, 29 set 2026');
assert.equal(formatRangePT('2026-09-01', '2026-09-30'), '1 set – 30 set 2026');
assert.equal(formatRangePT('2025-12-29', '2026-01-04'), '29 dez 2025 – 4 jan 2026');

// Whole months step by calendar month, including short months and year ends.
assert.deepEqual(shiftPeriod('2026-01-01', '2026-01-31', 1), { from: '2026-02-01', to: '2026-02-28' });
assert.deepEqual(shiftPeriod('2026-03-01', '2026-03-31', -1), { from: '2026-02-01', to: '2026-02-28' });
assert.deepEqual(shiftPeriod('2028-01-01', '2028-01-31', 1), { from: '2028-02-01', to: '2028-02-29' });
assert.deepEqual(shiftPeriod('2026-12-01', '2026-12-31', 1), { from: '2027-01-01', to: '2027-01-31' });
// Monthly cycles that start on another day keep that day (restaurant 6 closes 20th–19th).
assert.deepEqual(shiftPeriod('2026-05-20', '2026-06-19', 1), { from: '2026-06-20', to: '2026-07-19' });
assert.deepEqual(shiftPeriod('2026-06-20', '2026-07-19', -1), { from: '2026-05-20', to: '2026-06-19' });
assert.deepEqual(shiftPeriod('2026-12-20', '2027-01-19', 1), { from: '2027-01-20', to: '2027-02-19' });
// Other ranges step by their own length (weekly Mon–Sun acertos land on the next saved week).
assert.deepEqual(shiftPeriod('2026-08-03', '2026-08-09', -1), { from: '2026-07-27', to: '2026-08-02' });
assert.deepEqual(shiftPeriod('2026-09-28', '2026-10-04', -1), { from: '2026-09-21', to: '2026-09-27' });
assert.deepEqual(shiftPeriod('2026-09-10', '2026-09-24', 1), { from: '2026-09-25', to: '2026-10-09' });

assert.deepEqual(presetPeriod('week', '2026-09-30'), { from: '2026-09-28', to: '2026-10-04' });
assert.deepEqual(presetPeriod('lastweek', '2026-09-30'), { from: '2026-09-21', to: '2026-09-27' });
assert.deepEqual(presetPeriod('month', '2026-02-10'), { from: '2026-02-01', to: '2026-02-28' });
assert.deepEqual(presetPeriod('lastmonth', '2026-01-15'), { from: '2025-12-01', to: '2025-12-31' });
assert.equal(matchPreset('2026-09-01', '2026-09-30', '2026-09-30'), 'month');
assert.equal(matchPreset('2026-09-02', '2026-09-30', '2026-09-30'), undefined);

console.log('dates.ts: all checks passed');
