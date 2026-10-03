import { formatPersianFullDate } from "@/lib/persian-date";

const timeFormatter = new Intl.DateTimeFormat("fa-IR", {
  hour: "2-digit",
  minute: "2-digit",
  hour12: false,
  timeZone: "Asia/Tehran",
});

export function examEndsAt(startsAt: string, durationMinutes: number) {
  return new Date(
    new Date(startsAt).getTime() + durationMinutes * 60_000,
  );
}

export function formatExamSchedule(startsAt: string) {
  const date = new Date(startsAt);
  const tehranDate = new Date(
    date.toLocaleString("en-US", { timeZone: "Asia/Tehran" }),
  );
  return `${formatPersianFullDate(tehranDate)}، ساعت ${timeFormatter.format(date)}`;
}

export function formatExamDuration(durationMinutes: number) {
  return `${durationMinutes.toLocaleString("fa-IR")} دقیقه`;
}

export function getExamTimeState(
  startsAt: string,
  durationMinutes: number,
  now = new Date(),
) {
  const start = new Date(startsAt);
  const end = examEndsAt(startsAt, durationMinutes);
  if (now < start) return "upcoming" as const;
  if (now >= end) return "ended" as const;
  return "active" as const;
}