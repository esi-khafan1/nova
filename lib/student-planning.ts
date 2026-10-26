import { addDays, parseIsoDate, toIsoDate } from "@/lib/persian-date";
export type StudyItem = { id:string; plan_id:string; day_of_week:number; duration_minutes:number; subject:string; chapter:string|null; activity_type:string; target_test_count:number|null; details:string|null; sort_order:number; source_grade?:10|11|12|null; preparation_track?:"konkur"|"final_exam"; exam_year?:number|null };
export type StudyPlan = { id:string; title:string; week_start:string; notes:string|null; weekly_plan_items:StudyItem[] };
export type StudyCompletion = { item_id:string; completed_at:string; checked_at?:string|null; completed_test_count:number|null };
export function tehranToday() { const parts=new Intl.DateTimeFormat("en-US",{timeZone:"Asia/Tehran",year:"numeric",month:"2-digit",day:"2-digit"}).formatToParts(new Date());const value=(type:string)=>parts.find(p=>p.type===type)?.value??"";return `${value("year")}-${value("month")}-${value("day")}`; }
export const dayIso = (start:string, offset:number) => toIsoDate(addDays(parseIsoDate(start),offset));
export const containsDay = (plan:StudyPlan,date:string) => plan.week_start<=date && dayIso(plan.week_start,6)>=date;
export function activityRatio(item:StudyItem, completion?:StudyCompletion) {
 if (!completion) return 0;
 if (item.activity_type === "practice_tests") {
  const goal=item.target_test_count;
  // Legacy test items without a target have no measurable fulfillment ratio.
  if (!goal || goal<=0) return 0;
  return Math.min(1,Math.max(0,(completion.completed_test_count??0)/goal));
 }
 return 1;
}
export function studiedMinutes(item:StudyItem, completion?:StudyCompletion){
 return activityRatio(item,completion)*item.duration_minutes;
}
export function summarizeItems(items:StudyItem[], completions:Map<string,StudyCompletion>) {
 let minutes=0,weightedMinutes=0,tests=0,goal=0,checked=0,realized=0;
 for(const item of items){const done=completions.get(item.id);const ratio=activityRatio(item,done);realized+=ratio;weightedMinutes+=ratio*item.duration_minutes;if(item.activity_type==='practice_tests')goal+=item.target_test_count??0;if(done){checked++;minutes+=item.duration_minutes;if(item.activity_type==='practice_tests')tests+=done.completed_test_count??0;}}
 const plannedMinutes=items.reduce((n,i)=>n+i.duration_minutes,0);
 return {minutes,weightedMinutes,hours:weightedMinutes/60,plannedMinutes,plannedHours:plannedMinutes/60,tests,goal,checked,percent:items.length?Math.round(realized/items.length*100):null,count:items.length};
}
export function overlapsWindow(start:string, plans:{id:string;week_start:string;student_id:string;status:string}[],studentId:string,excludeId='') {
 const end=dayIso(start,6);return plans.some(p=>p.id!==excludeId&&p.student_id===studentId&&['draft','published'].includes(p.status)&&p.week_start<=end&&dayIso(p.week_start,6)>=start);
}

// Only a student's own progress controls are shown; past days stay editable.
export function canEditStudentProgress(audience:"student"|"counselor",date:string,today:string){return audience==="student"&&date<=today;}
