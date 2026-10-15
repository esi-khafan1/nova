// Keep the existing five-minute scheduling lead, but calculate it in Tehran,
// rounding UP to a real selectable minute instead of truncating seconds.
export const EXAM_SCHEDULE_LEAD_MINUTES = 5;
const tehranFormatter = new Intl.DateTimeFormat("en-GB", {
  timeZone: "Asia/Tehran", year: "numeric", month: "2-digit", day: "2-digit",
  hour: "2-digit", minute: "2-digit", hourCycle: "h23",
});
export function tehranDateTime(now: Date) {
  const parts = tehranFormatter.formatToParts(now);
  const part = (name: Intl.DateTimeFormatPartTypes) => parts.find(p => p.type === name)?.value ?? "";
  return { date: `${part("year")}-${part("month")}-${part("day")}`, time: `${part("hour")}:${part("minute")}` };
}
export function earliestExamSchedule(now = new Date()) {
  const stamp = Math.ceil((now.getTime() + EXAM_SCHEDULE_LEAD_MINUTES * 60_000) / 60_000) * 60_000;
  return { ...tehranDateTime(new Date(stamp)), today: tehranDateTime(now).date };
}
export function isExamTime(value: string) { return /^([01]\d|2[0-3]):[0-5]\d$/.test(value); }
export function timeAfter(value: string, minutes: number): string | null {
  if (!isExamTime(value)) return null;
  const [hour, minute] = value.split(":").map(Number);
  const total = hour * 60 + minute + minutes;
  if (total < 0 || total >= 24 * 60) return null;
  return `${String(Math.floor(total / 60)).padStart(2, "0")}:${String(total % 60).padStart(2, "0")}`;
}
export function validWindowEnd(start: string, previous: string): string {
  if (isExamTime(previous) && previous > start) return previous;
  return timeAfter(start, 60) ?? "23:59";
}
export function clampExamTime(value: string, minimum?: string): string {
  if (minimum && isExamTime(minimum) && (!isExamTime(value) || value < minimum)) return minimum;
  return value;
}
