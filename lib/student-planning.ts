import { addDays, parseIsoDate, toIsoDate } from "@/lib/persian-date";
export type StudyItem = { id:string; plan_id:string; day_of_week:number; duration_minutes:number; subject:string; chapter:string|null; activity_type:string; target_test_count:number|null; details:string|null; sort_order:number; source_grade?:9|10|11|12|null; preparation_track?:"konkur"|"final_exam"; exam_year?:number|null; recommended_publisher?:string|null; linked_exam_id?:string|null };
export type StudyPlan = { id:string; title:string; week_start:string; notes:string|null; weekly_plan_items:StudyItem[] };
export type StudyCompletion = { item_id:string; completed_at:string; checked_at?:string|null; completed_test_count:number|null; completed_minutes?:number|null; test_duration_recorded?:boolean };
export function tehranToday() { const parts=new Intl.DateTimeFormat("en-US",{timeZone:"Asia/Tehran",year:"numeric",month:"2-digit",day:"2-digit"}).formatToParts(new Date());const value=(type:string)=>parts.find(p=>p.type===type)?.value??"";return `${value("year")}-${value("month")}-${value("day")}`; }
export const dayIso = (start:string, offset:number) => toIsoDate(addDays(parseIsoDate(start),offset));
export const containsDay = (plan:StudyPlan,date:string) => plan.week_start<=date && dayIso(plan.week_start,6)>=date;
export function activityRatio(item:StudyItem, completion?:StudyCompletion) {
 if (!completion) return 0;
 if (item.activity_type === "practice_tests") {
  const goal=item.target_test_count;
  // A tick without an entered count means the full target was done, not an
  // assertion that the student entered an actual count. Legacy targetless
  // boxes likewise have no numeric goal to measure, but the tick is complete.
  if (!goal || goal<=0 || completion.completed_test_count==null) return 1;
  return Math.min(1,Math.max(0,completion.completed_test_count/goal));
 }
 return completion.completed_minutes==null?1:Math.min(1,Math.max(0,completion.completed_minutes/item.duration_minutes));
}
export function studiedMinutes(item:StudyItem, completion?:StudyCompletion){
 if(!completion)return 0;
 if(item.activity_type==='practice_tests' && !completion.test_duration_recorded) return activityRatio(item,completion)*item.duration_minutes;
 return completion.completed_minutes??item.duration_minutes;
}
export function summarizeItems(items:StudyItem[], completions:Map<string,StudyCompletion>) {
 let minutes=0,weightedMinutes=0,tests=0,goal=0,checked=0,realized=0;
 for(const item of items){const done=completions.get(item.id);const ratio=activityRatio(item,done);realized+=ratio;weightedMinutes+=studiedMinutes(item,done);if(item.activity_type==='practice_tests')goal+=item.target_test_count??0;if(done){checked++;minutes+=studiedMinutes(item,done);if(item.activity_type==='practice_tests')tests+=done.completed_test_count??item.target_test_count??0;}}
 const plannedMinutes=items.reduce((n,i)=>n+i.duration_minutes,0);
 return {minutes,weightedMinutes,hours:weightedMinutes/60,plannedMinutes,plannedHours:plannedMinutes/60,tests,goal,checked,percent:items.length?Math.round(realized/items.length*100):null,count:items.length};
}
export function completedTestBreakdown(items: StudyItem[], completions: Map<string, StudyCompletion>) {
 const groups = new Map<string, { subject: string; chapter: string | null; count: number }>();
 for (const item of items) {
  if (item.activity_type !== "practice_tests") continue;
  const completion = completions.get(item.id);
  if (!completion) continue;
  const count = completion.completed_test_count ?? item.target_test_count ?? 0;
  if (count <= 0) continue;
  const chapter = item.chapter?.trim() || null;
  const key = JSON.stringify([item.subject, chapter]);
  const previous = groups.get(key);
  groups.set(key, {subject:item.subject, chapter, count:(previous?.count??0)+count});
 }
 return [...groups.values()].sort((a,b)=>a.subject.localeCompare(b.subject,"fa") || (a.chapter??"").localeCompare(b.chapter??"","fa"));
}

type PlanWindow = {id:string;week_start:string;student_id:string;status:string;weekly_plan_items?:{day_of_week:number}[]};
export function overlapsWindow(start:string, plans:PlanWindow[], studentId:string, excludeId='', candidateDays:number[] = []) {
 const end=dayIso(start,6);
 return plans.some(p=>{
  if(p.id===excludeId || p.student_id!==studentId || !['draft','published'].includes(p.status) || p.week_start>end || dayIso(p.week_start,6)<start)return false;
  if(p.week_start===start)return true;
  if(p.week_start<start) return !p.weekly_plan_items || p.weekly_plan_items.some(item=>dayIso(p.week_start,item.day_of_week)>=start);
  return candidateDays.some(day=>dayIso(start,day)>=p.week_start);
 });
}

// Only published plans are supplied. Preserve legacy overlaps that contain
// activity boxes: never hide existing work when calculating the visible end.
export function visiblePlanDays(plan:{id:string;week_start:string;weekly_plan_items:{day_of_week:number}[]}, publishedPlans:{id:string;week_start:string}[]):number {
 let count=7;
 for(const next of publishedPlans){
  if(next.id===plan.id || next.week_start<=plan.week_start || next.week_start>dayIso(plan.week_start,6))continue;
  if(plan.weekly_plan_items.some(item=>dayIso(plan.week_start,item.day_of_week)>=next.week_start))continue;
  const offset=Array.from({length:7},(_,i)=>i).find(i=>dayIso(plan.week_start,i)===next.week_start);
  if(offset!==undefined)count=Math.min(count,offset);
 }
 return count;
}

// Only a student's own progress controls are shown; past days stay editable.
export function canEditStudentProgress(audience:"student"|"counselor",date:string,today:string){return audience==="student"&&date<=today;}
