import { parseIsoDate, persianMonthNames, persianNumber, persianParts } from "./persian-date";
import { dayIso, overlapsWindow } from "./student-planning";

type PlanWindow = {id:string;student_id:string;week_start:string;status:string;weekly_plan_items?:{day_of_week:number}[]};
const defaultMessage = "این بازه با روزهای دارای فعالیتِ برنامهٔ دیگری هم‌پوشانی دارد.";

function dateLabel(date:string, includeYear:boolean) {
  const parts=persianParts(parseIsoDate(date));
  return `${persianNumber.format(parts.day)} ${persianMonthNames[parts.month-1]}${includeYear ? ` ${persianNumber.format(parts.year)}` : ""}`;
}

/** Explain conflicts with earlier plans, without changing the overlap rule. */
export function plannerOverlapMessage(start:string, plans:PlanWindow[], studentId:string, excludeId:string, candidateDays:number[], today:string):string {
  // An existing plan, a later plan or incomplete data needs different guidance.
  // Keep the original general message rather than suggesting a misleading date.
  if (excludeId) return defaultMessage;
  const previousDays:string[]=[];
  for (const plan of plans) {
    if (!overlapsWindow(start,[plan],studentId,excludeId,candidateDays)) continue;
    if (plan.week_start>start || !plan.weekly_plan_items) return defaultMessage;
    const days=plan.weekly_plan_items
      .filter(item=>Number.isInteger(item.day_of_week)&&item.day_of_week>=0&&item.day_of_week<=6)
      .map(item=>dayIso(plan.week_start,item.day_of_week))
      .filter(day=>day>=start);
    // Two plans cannot share a start date even if the previous plan is empty.
    if (!days.length) return defaultMessage;
    previousDays.push(...days);
  }
  if (!previousDays.length) return defaultMessage;
  const lastDay=previousDays.sort().at(-1)!;
  let candidate=dayIso(lastDay,1);
  if (candidate<today) candidate=today;
  // Check all loaded plans before recommending a date. The server's existing
  // protections remain authoritative if another plan appears or isn't visible.
  for (let i=0;i<31;i++,candidate=dayIso(candidate,1)) {
    if (overlapsWindow(candidate,plans,studentId,excludeId,candidateDays)) continue;
    const includeYear=persianParts(parseIsoDate(lastDay)).year!==persianParts(parseIsoDate(candidate)).year;
    return `برنامهٔ قبلی تا ${dateLabel(lastDay,includeYear)} فعالیت دارد. تاریخ شروع را ${dateLabel(candidate,includeYear)} یا بعد از آن انتخاب کنید.`;
  }
  return defaultMessage;
}
