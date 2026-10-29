// The student enters a duration, not a time of day. Keep storage in whole minutes.
export function formatStudyDuration(minutes: number | null | undefined): string {
  if (minutes == null) return "";
  return `${String(Math.floor(minutes / 60)).padStart(2, "0")}:${String(minutes % 60).padStart(2, "0")}`;
}

export function parseStudyDuration(value: string): number | null {
  const normalized = value.trim()
    .replace(/[۰-۹]/g, digit => String(digit.charCodeAt(0) - 1776))
    .replace(/[٠-٩]/g, digit => String(digit.charCodeAt(0) - 1632));
  if (!/^\d{1,2}:[0-5]\d$/.test(normalized)) return null;
  const [hours, minutes] = normalized.split(":").map(Number);
  const total = hours * 60 + minutes;
  return total >= 1 && total <= 1440 ? total : null;
}
