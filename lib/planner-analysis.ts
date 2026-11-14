import { summarizePlannerGrid, type PlannerGrid } from "./planner-grid";

/** Derive all analysis directly from the same immutable snapshot as the grid. */
export function analyzePlannerWeek(grid: PlannerGrid) {
  const summary = summarizePlannerGrid(grid);
  const bySubject = new Map<string, { subject: string; minutes: number; tests: number; blocks: number; days: number[] }>();
  grid.forEach((day, dayIndex) => day.forEach(block => {
    if (!block) return;
    const subject = block.subject.trim() || "فعالیت بدون درس";
    const row = bySubject.get(subject) ?? { subject, minutes: 0, tests: 0, blocks: 0, days: Array<number>(7).fill(0) };
    row.minutes += block.durationMinutes;
    row.tests += block.targetTestCount ?? 0;
    row.blocks += 1;
    row.days[dayIndex] += block.durationMinutes;
    bySubject.set(subject, row);
  }));
  const subjects = [...bySubject.values()]
    .sort((a, b) => b.minutes - a.minutes || a.subject.localeCompare(b.subject, "fa"))
    .map(row => ({...row, percent: summary.minutes ? (row.minutes / summary.minutes) * 100 : 0}));
  return {
    ...summary,
    subjects,
    meanDailyMinutes: summary.minutes / 7,
    testsPerHour: summary.minutes ? summary.tests * 60 / summary.minutes : null,
  };
}
