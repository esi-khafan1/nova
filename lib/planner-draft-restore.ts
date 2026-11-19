import { plannerGridFromPlan, plannerSnapshotFromEditor, type PlannerEditorBlock, type PlannerEditorGrid, type PublishedPlannerExtras } from "./planner-plan-adapter";
import { plannerGridToItems, type PlannerRoutine } from "./planner-grid";
import type { CounselorWeeklyPlan } from "../components/dashboard/weekly-plan-builder";
import type { PlannerDraftContext } from "./planner-draft-session";

export type PlannerRestoreConflict = {
  kind: "published-changed" | "source-missing" | "protected-removed" | "protected-changed" | "day-elapsed";
  sourceItemId?: string;
  key?: string;
  dayOfWeek?: number;
};

const isRecord = (value: unknown): value is Record<string, unknown> => Boolean(value && typeof value === "object" && !Array.isArray(value));
const maybeString = (value: unknown) => value == null || typeof value === "string";
const maybeNumber = (value: unknown) => value == null || (typeof value === "number" && Number.isFinite(value));
function dayDate(start: string, day: number) {
  const value=Date.parse(`${start}T00:00:00Z`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(start) || !Number.isFinite(value) || new Date(value).toISOString().slice(0,10)!==start || !Number.isInteger(day) || day<0 || day>6) throw new Error("Invalid date");
  return new Date(value+day*86400000).toISOString().slice(0,10);
}
// Supabase/Postgres can represent the same instant with different timezone and
// fractional formatting. Compare all six microsecond digits, not JS millis.
function timestampMicros(value: string): bigint {
  const match=/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.(\d{1,6}))?(?:Z|[+-]\d{2}:\d{2})$/i.exec(value);
  const ms=Date.parse(value);
  if (!match || !Number.isFinite(ms)) throw new Error("Invalid plan timestamp");
  return BigInt(ms)*BigInt(1000)+BigInt((match[1]??"").padEnd(6,"0").slice(3,6));
}
function canonical(value: unknown): string {
  // Values come from JSON; key ordering alone must not create false conflicts.
  if (Array.isArray(value)) return `[${value.map(canonical).join(",")}]`;
  if (isRecord(value)) return `{${Object.keys(value).filter(key=>value[key]!==undefined).sort().map(key=>`${JSON.stringify(key)}:${canonical(value[key])}`).join(",")}}`;
  return JSON.stringify(value) ?? "null";
}
function extras(block: PlannerEditorBlock) {
  const value=block.extra ? structuredClone(block.extra) : {};
  if (block.topics !== undefined) value.topics=structuredClone(block.topics);
  return value;
}
function sameContent(a: PlannerEditorBlock, b: PlannerEditorBlock) {
  return canonical({day:a.dayOfWeek,subject:a.subject,chapter:a.chapter,activity:a.activityType,duration:a.durationMinutes,tests:a.targetTestCount,details:a.details,grade:a.sourceGrade??null,track:a.preparationTrack??"konkur",publisher:a.recommendedPublisher??null,examYear:a.examYear,extra:extras(a)}) ===
    canonical({day:b.dayOfWeek,subject:b.subject,chapter:b.chapter,activity:b.activityType,duration:b.durationMinutes,tests:b.targetTestCount,details:b.details,grade:b.sourceGrade??null,track:b.preparationTrack??"konkur",publisher:b.recommendedPublisher??null,examYear:b.examYear,extra:extras(b)});
}
function sameExamIdentity(a: PlannerEditorBlock,b: PlannerEditorBlock) {
  return a.dayOfWeek===b.dayOfWeek && a.subject===b.subject && a.chapter===b.chapter && a.activityType===b.activityType;
}

/** Restore a private draft against newly loaded authoritative plan, progress and
 * exam links. Conflicts are returned, never resolved by silently dropping an
 * edit. The caller must keep the draft and block publication until resolved. */
export function restorePlannerDraft(input: {
  snapshot: unknown;
  context: PlannerDraftContext;
  today: string;
  freshPlan: CounselorWeeklyPlan | null;
  freshPlanUpdatedAt: string | null;
  basePlanUpdatedAt: string | null;
  completed: ReadonlySet<string>;
  publishedExtras: PublishedPlannerExtras;
}) {
  const {snapshot,context,freshPlan}=input;
  dayDate(context.weekStart,0);dayDate(input.today,0);
  if (freshPlan ? freshPlan.id!==context.planId || freshPlan.student_id!==context.studentId || freshPlan.week_start!==context.weekStart : context.planId!==null) throw new Error("Plan context changed");
  if ((context.planId===null)!==(input.basePlanUpdatedAt===null) || (context.planId===null)!==(input.freshPlanUpdatedAt===null)) throw new Error("Missing plan version");
  if (!isRecord(snapshot) || typeof snapshot.title!=="string" || typeof snapshot.notes!=="string" || !Array.isArray(snapshot.routines) || !isRecord(snapshot.editor) || !isRecord(snapshot.editor.weekExtra) || !Array.isArray(snapshot.editor.grid) || snapshot.editor.grid.length!==7) throw new Error("Invalid editor snapshot");
  const grid=structuredClone(snapshot.editor.grid) as PlannerEditorGrid;
  if (grid.some(day=>!Array.isArray(day))) throw new Error("Invalid editor snapshot");
  const all=plannerGridToItems(grid);
  for (const item of all) {
    if (!isRecord(item) || typeof item.key!=="string" || !item.key || typeof item.subject!=="string" || typeof item.chapter!=="string" || typeof item.activityType!=="string" || typeof item.details!=="string" || typeof item.durationMinutes!=="number" || !Number.isFinite(item.durationMinutes) || !(item.targetTestCount===null || (typeof item.targetTestCount==="number" && Number.isFinite(item.targetTestCount))) || !maybeString(item.id) || !maybeString(item.sourceItemId) || !maybeString(item.linkedExamId) || !maybeNumber(item.sourceGrade) || !maybeString(item.preparationTrack) || !maybeString(item.recommendedPublisher) || !(item.examYear===null || (typeof item.examYear==="number" && Number.isFinite(item.examYear))) || (item.extra!==null && !isRecord(item.extra)) || (item.completed!==undefined && typeof item.completed!=="boolean") || (item.locked!==undefined && typeof item.locked!=="boolean")) throw new Error("Invalid editor block");
  }
  const routines=structuredClone(snapshot.routines) as PlannerRoutine[];
  const days=new Set<number>();
  if (routines.length!==7) throw new Error("Invalid routines");
  for (const r of routines) {
    if (!isRecord(r) || !Number.isInteger(r.dayOfWeek) || r.dayOfWeek<0 || r.dayOfWeek>6 || days.has(r.dayOfWeek) || typeof r.subject!=="string" || typeof r.details!=="string" || !(r.secondSubject===undefined || typeof r.secondSubject==="string") || !(r.secondDetails===undefined || typeof r.secondDetails==="string")) throw new Error("Invalid routines");
    for(const value of [r.durationMinutes,r.secondDurationMinutes]) if(value!=null && (typeof value!=='number'||!Number.isInteger(value)||value<1||value>1440)) throw new Error('Invalid routine duration');
    days.add(r.dayOfWeek);
  }
  const weekExtra=structuredClone(snapshot.editor.weekExtra);
  // Check identity and topic metadata without trusting the stale precomputed
  // publication payload. The caller will recompute it for today's date.
  plannerSnapshotFromEditor({title:snapshot.title,notes:snapshot.notes,weekStart:context.weekStart,today:input.today,planStatus:freshPlan?.status??null,grid,routines,weekExtra});
  const live=freshPlan?plannerGridToItems(plannerGridFromPlan(freshPlan,input.completed,input.publishedExtras,input.today)):[];
  const byId=new Map(live.map(block=>[block.sourceItemId,block]));
  const present=new Set(all.map(block=>block.sourceItemId).filter(Boolean));
  const conflicts: PlannerRestoreConflict[]=[];
  if (input.basePlanUpdatedAt && input.freshPlanUpdatedAt && timestampMicros(input.basePlanUpdatedAt)!==timestampMicros(input.freshPlanUpdatedAt)) conflicts.push({kind:"published-changed"});
  for (const original of live) {
    if (!present.has(original.sourceItemId) && (original.completed || original.linkedExamId || original.locked)) conflicts.push({kind:"protected-removed",sourceItemId:original.sourceItemId??undefined,dayOfWeek:original.dayOfWeek});
  }
  for (const day of grid) for (const item of day) {
    if (!item) continue;
    const original=item.sourceItemId?byId.get(item.sourceItemId):undefined;
    const elapsed=dayDate(context.weekStart,item.dayOfWeek)<input.today;
    if (item.sourceItemId && (!original || original.sourceDayOfWeek!==item.sourceDayOfWeek)) conflicts.push({kind:"source-missing",sourceItemId:item.sourceItemId,key:item.key,dayOfWeek:item.dayOfWeek});
    if (original && ((original.completed && !sameContent(item,original)) || (original.linkedExamId && !sameExamIdentity(item,original)))) conflicts.push({kind:"protected-changed",sourceItemId:item.sourceItemId??undefined,key:item.key,dayOfWeek:item.dayOfWeek});
    if ((elapsed || original?.locked) && (!original || !sameContent(item,original))) conflicts.push({kind:"day-elapsed",sourceItemId:item.sourceItemId??undefined,key:item.key,dayOfWeek:item.dayOfWeek});
    // Flags stored in a draft are historical; only the freshly loaded records
    // determine protection. A missing original is conservatively locked.
    item.completed=Boolean(original?.completed);
    item.linkedExamId=original?.linkedExamId??null;
    item.locked=elapsed || Boolean(original?.locked) || Boolean(item.sourceItemId && !original);
  }
  return {title:snapshot.title,notes:snapshot.notes,grid,routines,weekExtra,conflicts,canPublish:conflicts.length===0};
}
