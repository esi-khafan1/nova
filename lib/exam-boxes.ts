import { formatPersianFullDate, parseIsoDate } from "@/lib/persian-date";

/**
 * Shared between the exam-designer Server Components and the client-side box
 * picker. This module must NOT have a "use client" directive: importing a
 * runtime value (like boxLabel) from a client module into a Server Component
 * turns it into a client reference that throws when called on the server.
 */
export type ExamBox = {
  item_id: string;
  plan_id: string;
  student_id: string;
  student_name: string;
  box_date: string;
  day_of_week: number;
  week_start: string;
  subject: string;
  chapter: string | null;
  duration_minutes: number;
  linked_exam_id: string | null;
  linked_exam_title: string | null;
  linked_exam_owned: boolean;
};

export function boxLabel(box: ExamBox) {
  try {
    return formatPersianFullDate(parseIsoDate(box.box_date));
  } catch {
    return box.box_date;
  }
}
