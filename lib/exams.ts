const examDateTimeFormatter = new Intl.DateTimeFormat(
  "fa-IR-u-ca-persian",
  {
    dateStyle: "full",
    timeStyle: "short",
    timeZone: "Asia/Tehran",
  },
);

export function examEndsAt(startsAt: string, durationMinutes: number) {
  return new Date(
    new Date(startsAt).getTime() + durationMinutes * 60_000,
  );
}

export function formatExamSchedule(startsAt: string) {
  return examDateTimeFormatter.format(new Date(startsAt));
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