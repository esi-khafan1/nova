/** Pure helpers for the new planner. They do not read or modify published plans. */
export type PlannerTopic = { title: string; pageStart?: number | null; pageEnd?: number | null; bankId?: string | null };
export type PlannerBlock = {
  key: string;
  id?: string | null;
  dayOfWeek: number;
  subject: string;
  chapter: string;
  activityType: string;
  durationMinutes: number;
  targetTestCount: number | null;
  details: string;
  sourceGrade?: number | null;
  preparationTrack?: string;
  recommendedPublisher?: string | null;
  linkedExamId?: string | null;
  completed?: boolean;
  locked?: boolean;
  topics?: PlannerTopic[];
};
export type PlannerDay = Array<PlannerBlock | null>;
export type PlannerGrid = PlannerDay[];
export type PlannerRoutine = { dayOfWeek: number; subject: string; details: string; secondSubject?: string; secondDetails?: string };
export type PlannerTemplate = { days: PlannerGrid; routines: PlannerRoutine[] };
export type GridPosition = { day: number; index: number };

function checkDay(day: number) {
  if (!Number.isInteger(day) || day < 0 || day > 6) throw new RangeError("Invalid day");
}
function checkPosition(grid: PlannerGrid, position: GridPosition, allowEnd = false) {
  checkDay(position.day);
  if (grid.length !== 7 || !Number.isInteger(position.index) || position.index < 0 || position.index >= grid[position.day].length + (allowEnd ? 1 : 0)) throw new RangeError("Invalid grid position");
}
function cloneBlock<T extends PlannerBlock>(block: T): T {
  return { ...block, topics: block.topics?.map(topic => ({ ...topic })) };
}
export function emptyPlannerGrid(): PlannerGrid { return Array.from({ length: 7 }, () => []); }
export function clonePlannerGrid<T extends PlannerBlock>(grid: Array<Array<T | null>>): Array<Array<T | null>> {
  if (grid.length !== 7) throw new RangeError("A planner needs seven days");
  return grid.map(day => day.map(block => block ? cloneBlock(block) : null));
}

/** Move by insertion, preserving the ID and all activity metadata. */
export function movePlannerBlock<T extends PlannerBlock>(grid: Array<Array<T | null>>, from: GridPosition, to: GridPosition): Array<Array<T | null>> {
  checkPosition(grid, from); checkPosition(grid, to, true);
  const block = grid[from.day][from.index];
  if (!block) throw new Error("No block at source");
  if (block.completed || block.locked) throw new Error("Protected block cannot be moved");
  if (from.day === to.day && (from.index === to.index || from.index + 1 === to.index)) return clonePlannerGrid(grid);
  const result = clonePlannerGrid(grid);
  result[from.day].splice(from.index, 1);
  const target = from.day === to.day && from.index < to.index ? to.index - 1 : to.index;
  result[to.day].splice(target, 0, { ...cloneBlock(block), dayOfWeek: to.day });
  return result;
}

/** Copies must never carry progress, database identity or a linked exam. */
export function copyPlannerBlock<T extends PlannerBlock>(block: T, day: number, newKey: string): T {
  checkDay(day);
  if (!newKey || newKey === block.key) throw new Error("A copy needs a new key");
  return { ...cloneBlock(block), key: newKey, id: null, dayOfWeek: day, linkedExamId: null, completed: false, locked: false };
}

/** Apply a snapshot without mutating its source or carrying IDs between students. */
export function applyPlannerTemplate<T extends PlannerBlock>(
  target: Array<Array<T | null>>,
  source: Array<Array<T | null>>,
  mode: "empty" | "replace",
  newKey: () => string,
): Array<Array<T | null>> {
  if (target.length !== 7 || source.length !== 7) throw new RangeError("A planner needs seven days");
  if (mode !== "empty" && mode !== "replace") throw new Error("Invalid template mode");
  if (mode === "replace" && target.some(day => day.some(block => block && (block.completed || block.locked || block.linkedExamId)))) throw new Error("Protected block cannot be replaced");
  const result = mode === "replace" ? Array.from({ length: 7 }, () => [] as Array<T | null>) : clonePlannerGrid(target);
  const keys = new Set(target.flatMap(day => day.flatMap(block => block ? [block.key] : [])));
  for (let day = 0; day < 7; day++) {
    for (let index = 0; index < source[day].length; index++) {
      const block = source[day][index];
      if (!block || (mode === "empty" && result[day][index])) continue;
      const key = newKey();
      if (!key || keys.has(key) || key === block.key) throw new Error("Duplicate copy key");
      keys.add(key);
      while (result[day].length <= index) result[day].push(null);
      result[day][index] = copyPlannerBlock(block, day, key);
    }
  }
  return result;
}

export function summarizePlannerGrid(grid: PlannerGrid, minimumRows = 5) {
  if (grid.length !== 7 || !Number.isInteger(minimumRows) || minimumRows < 0) throw new RangeError("Invalid grid");
  const days = Array.from({ length: 7 }, () => ({ minutes: 0, tests: 0, blocks: 0 }));
  const subjects = new Map<string, { subject: string; minutes: number; tests: number; blocks: number }>();
  for (let day = 0; day < 7; day++) for (const block of grid[day]) {
    if (!block) continue;
    if (!Number.isFinite(block.durationMinutes) || block.durationMinutes < 0 || (block.targetTestCount !== null && (!Number.isFinite(block.targetTestCount) || block.targetTestCount < 0))) throw new RangeError("Invalid block totals");
    const tests = block.targetTestCount ?? 0;
    days[day].minutes += block.durationMinutes; days[day].tests += tests; days[day].blocks++;
    const previous = subjects.get(block.subject) ?? { subject: block.subject, minutes: 0, tests: 0, blocks: 0 };
    previous.minutes += block.durationMinutes; previous.tests += tests; previous.blocks++; subjects.set(block.subject, previous);
  }
  const minutes = days.reduce((sum, day) => sum + day.minutes, 0);
  const tests = days.reduce((sum, day) => sum + day.tests, 0);
  const blocks = days.reduce((sum, day) => sum + day.blocks, 0);
  const slots = Math.max(minimumRows, ...grid.map(day => day.length)) * 7;
  return { minutes, tests, blocks, slots, emptySlots: slots - blocks, days, subjects: [...subjects.values()] };
}

function parseDay(iso: string): number {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(iso)) throw new RangeError("Invalid date");
  const time = Date.parse(`${iso}T00:00:00Z`);
  if (!Number.isFinite(time) || new Date(time).toISOString().slice(0, 10) !== iso) throw new RangeError("Invalid date");
  return time;
}
const DAY_MS = 86_400_000;
export type ReviewSource = { weekStart: string; blocks: PlannerBlock[] };
export type PlannerReview = { key: string; blockKey: string; date: string; offset: 1 | 3 | 7; subject: string; chapter: string; topics: PlannerTopic[] };
/** Derive reviews from current and earlier weeks; callers persist completion separately. */
export function reviewsForWeek(weekStart: string, sources: ReviewSource[]): PlannerReview[] {
  const start = parseDay(weekStart), end = start + 7 * DAY_MS;
  const reviews: PlannerReview[] = [];
  for (const source of sources) {
    const sourceStart = parseDay(source.weekStart);
    for (const block of source.blocks) {
      checkDay(block.dayOfWeek);
      if (["exam", "simulation_exam", "external_simulation_exam", "makeup"].includes(block.activityType)) continue;
      for (const offset of [1, 3, 7] as const) {
        const due = sourceStart + (block.dayOfWeek + offset) * DAY_MS;
        if (due < start || due >= end) continue;
        reviews.push({ key: JSON.stringify([source.weekStart, block.key, offset]), blockKey: block.key, date: new Date(due).toISOString().slice(0, 10), offset, subject: block.subject, chapter: block.chapter, topics: block.topics?.map(topic => ({ ...topic })) ?? [] });
      }
    }
  }
  return reviews.sort((a, b) => a.date.localeCompare(b.date) || a.subject.localeCompare(b.subject, "fa") || a.key.localeCompare(b.key));
}
