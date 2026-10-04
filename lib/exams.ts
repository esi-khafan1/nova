import { formatPersianFullDate } from "@/lib/persian-date";

const timeFormatter = new Intl.DateTimeFormat("fa-IR", {
  hour: "2-digit",
  minute: "2-digit",
  hour12: false,
  timeZone: "Asia/Tehran",
});

export type ExamBooklet = {
  id: string;
  exam_id?: string;
  title: string;
  pdf_url: string;
  question_count: number;
  start_question_number: number;
  end_question_number: number;
  duration_minutes: number;
  sort_order: number;
  key_answers?: Record<string, number>;
};

export type ExamBookletResult = {
  title: string;
  total: number;
  correct: number;
  incorrect: number;
  unanswered: number;
  percentage: number;
};

export function calculateBookletResults(
  booklets: ExamBooklet[],
  answers: Record<string, number> | null,
): ExamBookletResult[] {
  return booklets.map((booklet) => {
    let correct = 0;
    let incorrect = 0;
    let unanswered = 0;

    for (
      let question = booklet.start_question_number;
      question <= booklet.end_question_number;
      question += 1
    ) {
      const answer = answers?.[String(question)];
      const key = booklet.key_answers?.[String(question)];
      if (!answer || !key) unanswered += 1;
      else if (answer === key) correct += 1;
      else incorrect += 1;
    }

    const total = booklet.question_count;
    const percentage =
      total > 0
        ? Math.round(((correct * 3 - incorrect) * 10000) / (total * 3)) / 100
        : 0;

    return {
      title: booklet.title,
      total,
      correct,
      incorrect,
      unanswered,
      percentage,
    };
  });
}

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
