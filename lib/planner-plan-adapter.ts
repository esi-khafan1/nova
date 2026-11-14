import { plannerGridToItems, plannerItemsToGrid, type PlannerBlock, type PlannerRoutine, type PlannerTopic } from "./planner-grid";
import type { CounselorWeeklyPlan } from "../components/dashboard/weekly-plan-builder";

/** Complete editor block: the opaque extra is retained even if this client does
 * not know all of its fields. These values are JSON from authorized RPCs. */
export type PlannerEditorBlock = PlannerBlock & {
  examYear: number | null;
  extra: Record<string, unknown> | null;
};
export type PlannerEditorGrid = Array<Array<PlannerEditorBlock | null>>;
export type PublishedPlannerExtras = { week: Record<string, unknown>; items: Record<string, Record<string, unknown>> };

function validDate(value: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const t = Date.parse(`${value}T00:00:00Z`);
  return Number.isFinite(t) && new Date(t).toISOString().slice(0,10) === value;
}
function offsetDay(start: string, day: number): string {
  if (!validDate(start) || !Number.isInteger(day) || day < 0 || day > 6) throw new RangeError("Invalid plan date");
  return new Date(Date.parse(`${start}T00:00:00Z`) + day * 86400000).toISOString().slice(0,10);
}
function record(value: unknown): value is Record<string, unknown> {
  return Boolean(value && typeof value === "object" && !Array.isArray(value));
}
function readTopics(value: unknown): PlannerTopic[] {
  if (!Array.isArray(value)) throw new Error("Invalid topic metadata");
  return value.map(raw => {
    if (!record(raw) || typeof raw.title !== "string") throw new Error("Invalid topic metadata");
    const page = (v: unknown) => {
      if (v == null) return null;
      if (typeof v !== "number" || !Number.isInteger(v) || v < 1) throw new Error("Invalid topic page");
      return v;
    };
    const pageStart = page(raw.pageStart), pageEnd = page(raw.pageEnd);
    if ((pageStart === null) !== (pageEnd === null) || (pageStart !== null && pageEnd !== null && pageStart > pageEnd) || !(raw.bankId == null || typeof raw.bankId === "string")) throw new Error("Invalid topic metadata");
    // Preserve exact JSON shape, including omitted vs null fields. Review
    // history compares topic JSON and must not see a false content change.
    return structuredClone(raw) as PlannerTopic;
  });
}

/** Convert one authorized existing plan to the editable grid without mutating it. */
export function plannerGridFromPlan(plan: CounselorWeeklyPlan, completed: ReadonlySet<string>, extras: PublishedPlannerExtras, today: string): PlannerEditorGrid {
  if (!validDate(plan.week_start) || !validDate(today) || !record(extras) || !record(extras.week) || !record(extras.items)) throw new Error("Invalid plan data");
  const items: PlannerEditorBlock[] = [...plan.weekly_plan_items]
    .sort((a,b)=>a.day_of_week-b.day_of_week || a.sort_order-b.sort_order)
    .map(item=>{
      const extra = extras.items[item.id] ?? null;
      if (extra !== null && !record(extra)) throw new Error("Invalid item metadata");
      const topics = extra && Object.hasOwn(extra,"topics") ? readTopics(extra.topics) : undefined;
      return {
        key:item.id,id:item.id,sourceItemId:item.id,sourceDayOfWeek:item.day_of_week,dayOfWeek:item.day_of_week,
        subject:item.subject,chapter:item.chapter??"",activityType:item.activity_type,
        durationMinutes:item.duration_minutes,targetTestCount:item.target_test_count,details:item.details??"",
        sourceGrade:item.source_grade??null,preparationTrack:item.preparation_track??"konkur",
        recommendedPublisher:item.recommended_publisher??null,examYear:item.exam_year??null,
        linkedExamId:item.linked_exam_id??null,completed:completed.has(item.id),
        locked:offsetDay(plan.week_start,item.day_of_week)<today,
        extra:extra===null?null:structuredClone(extra),...(topics ? {topics} : {}),
      };
    });
  return plannerItemsToGrid(items);
}

/** Build the complete durable snapshot. This does not authorize or publish it;
 * server-side validation and conflict checks remain mandatory. Past blocks are
 * stored in the editor copy but never sent to the legacy saver. */
export function plannerSnapshotFromEditor(input: {
  title: string; notes: string; weekStart: string; today: string;
  planStatus: "draft" | "published" | null;
  grid: PlannerEditorGrid; routines: PlannerRoutine[]; weekExtra: Record<string, unknown>;
}) {
  if (!validDate(input.weekStart) || !validDate(input.today) || !record(input.weekExtra) || input.grid.length !== 7) throw new Error("Invalid editor state");
  const all=plannerGridToItems(input.grid);
  const seenSources = new Set<string>();
  for (const block of all) {
    if (block.sourceItemId) {
      if (seenSources.has(block.sourceItemId) || block.id !== block.sourceItemId ||
          !Number.isInteger(block.sourceDayOfWeek) || Number(block.sourceDayOfWeek) < 0 || Number(block.sourceDayOfWeek) > 6) throw new Error("Invalid source identity");
      seenSources.add(block.sourceItemId);
    } else if (block.id || block.sourceDayOfWeek != null) throw new Error("Item identity has no source");
  }
  const editable=all.filter(item=>offsetDay(input.weekStart,item.dayOfWeek)>=input.today);
  const items=editable.map(item=>({
    id:input.planStatus === "published" && offsetDay(input.weekStart,item.dayOfWeek)===input.today && item.sourceDayOfWeek===item.dayOfWeek ? item.id??null : null,
    sourceItemId:item.sourceItemId??null, dayOfWeek:item.dayOfWeek, startTime:"", durationMinutes:item.durationMinutes,
    subject:item.subject,chapter:item.chapter,activityType:item.activityType,targetTestCount:item.targetTestCount,details:item.details,
    sourceGrade:item.sourceGrade??null,preparationTrack:item.preparationTrack??"konkur",recommendedPublisher:item.recommendedPublisher??null,examYear:item.examYear,
  }));
  const itemExtras=editable.map(item=>{
    if (item.extra !== null && !record(item.extra)) throw new Error("Invalid item metadata");
    const extra=item.extra===null?{}:structuredClone(item.extra);
    if (item.topics !== undefined) extra.topics=readTopics(item.topics);
    return Object.keys(extra).length ? extra : null;
  });
  return {
    title:input.title, notes:input.notes, items, routines:structuredClone(input.routines),
    extras:{week:structuredClone(input.weekExtra),items:itemExtras},
    editor:{grid:structuredClone(input.grid),weekExtra:structuredClone(input.weekExtra)},
  };
}
