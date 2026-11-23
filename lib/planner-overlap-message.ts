import { formatPersianFullDate, parseIsoDate } from "./persian-date";
import { dayIso, overlapsWindow } from "./student-planning";

type PlanWindow = {id:string;student_id:string;week_start:string;status:string;weekly_plan_items?:{day_of_week:number}[]};
const dateLabel = (date:string) => formatPersianFullDate(parseIsoDate(date));
const datesLabel = (dates:Set<string>) => [...dates].sort().map(dateLabel).join("، ");

/** Explain the same overlap rule used by the editor; this never changes it.
 * Older plan activities reserve their dates, whereas a newer plan reserves
 * its window even if the newer plan itself has no boxes on those dates. */
export function plannerOverlapMessage(start:string, plans:PlanWindow[], studentId:string, excludeId:string, candidateDays:number[], today:string, privateDrafts:boolean): string {
  const draftNotice=privateDrafts ? "تغییر تاریخ، پیش‌نویس جداگانه‌ای باز می‌کند؛ پیش‌نویس فعلی حذف نمی‌شود." : "پیش از تغییر تاریخ از اطلاعات واردشده محافظت کن؛ با تغییر تاریخ، فرم دیگری باز می‌شود.";
  const previousDays=new Set<string>(), laterDays=new Set<string>(), sameStarts=new Set<string>(), unknownStarts=new Set<string>();
  for (const plan of plans) {
    if (!overlapsWindow(start, [plan], studentId, excludeId, candidateDays)) continue;
    if (plan.week_start === start) { sameStarts.add(plan.week_start); continue; }
    if (plan.week_start < start) {
      if (!plan.weekly_plan_items) { unknownStarts.add(plan.week_start); continue; }
      for (const item of plan.weekly_plan_items) {
        const day=dayIso(plan.week_start,item.day_of_week);
        if (day>=start) previousDays.add(day);
      }
    } else {
      for (const day of candidateDays) {
        const date=dayIso(start,day);
        if (date>=plan.week_start) laterDays.add(date);
      }
    }
  }
  const messages:string[]=[];
  if (previousDays.size) messages.push(`برنامهٔ قبلی در ${datesLabel(previousDays)} فعالیت دارد و با شروع برنامهٔ جدید تداخل می‌کند.`);
  if (sameStarts.size) messages.push(`برنامهٔ دیگری از ${datesLabel(sameStarts)} شروع شده است؛ دو برنامه نمی‌توانند شروع یکسان داشته باشند.`);
  if (laterDays.size) messages.push(`فعالیت‌های برنامهٔ فعلی در ${datesLabel(laterDays)} با بازهٔ برنامهٔ دیگری که بعداً شروع می‌شود تداخل دارند.`);
  if (unknownStarts.size) messages.push("اطلاعات روزهای برنامهٔ دیگر کامل دریافت نشده است؛ قبل از تغییر تاریخ، صفحه را تازه‌سازی کن.");
  if (!messages.length) return "این برنامه با بازهٔ برنامهٔ دیگری تداخل دارد. تاریخ شروع و برنامه‌های دانش‌آموز را بررسی کن.";

  // Only suggest a start date for a new program blocked by earlier activity.
  // Check all loaded plans, not just the one that first caused a conflict.
  // A changed start opens a different working draft; do not claim a transfer.
  if (previousDays.size && !excludeId && !unknownStarts.size && !sameStarts.size && !laterDays.size) {
    let candidate=dayIso([...previousDays].sort().at(-1)!,1);
    if (candidate<today) candidate=today;
    let suggested:string|null=null;
    for (let i=0;i<31;i++,candidate=dayIso(candidate,1)) {
      if (!overlapsWindow(candidate,plans,studentId,excludeId,candidateDays)) {suggested=candidate;break;}
    }
    if (suggested) messages.push(`با اطلاعات فعلی می‌توانی تاریخ شروع ${dateLabel(suggested)} را بررسی کنی. ${draftNotice}`);
    else messages.push(`تاریخ شروع دیگری را پس از فعالیت‌های برنامهٔ قبلی انتخاب و تداخل برنامه‌های دیگر را بررسی کن. ${draftNotice}`);
  } else if (!unknownStarts.size) {
    messages.push(`تاریخ شروع یا فعالیت‌های برنامه را بررسی کن. ${draftNotice}`);
  }
  return messages.join(" ");
}
