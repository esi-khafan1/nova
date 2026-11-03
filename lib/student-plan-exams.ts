import type { StudyPlan } from "@/lib/student-planning";

export type StudentPlanExam = {
  id: string;
  title: string;
  description: string | null;
  starts_at: string;
  start_window_ends_at: string | null;
  duration_minutes: number;
};

const tehranDate = new Intl.DateTimeFormat("en-US", {
  timeZone: "Asia/Tehran", year: "numeric", month: "2-digit", day: "2-digit",
});

export function examPlanDay(startsAt: string) {
  const date = new Date(startsAt);
  if (Number.isNaN(date.getTime())) return "";
  const parts = tehranDate.formatToParts(date);
  const part = (type: string) => parts.find(item => item.type === type)?.value ?? "";
  return `${part("year")}-${part("month")}-${part("day")}`;
}

/** A linked counselor box already represents this exam. Only picker-only
 * assignments need their own (read-only) study box; never duplicate a link. */
export function standalonePlanExams(exams: StudentPlanExam[], plans: StudyPlan[]) {
  const linked = new Set(plans.flatMap(plan => plan.weekly_plan_items
    .filter(item => item.activity_type === "exam" && item.linked_exam_id)
    .map(item => item.linked_exam_id)));
  return exams.filter(exam => !linked.has(exam.id) && Boolean(examPlanDay(exam.starts_at)));
}
