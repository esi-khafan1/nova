export const courseTypes = [
  { value: "with_exam", label: "مشاوره با آزمون" },
  { value: "with_support", label: "مشاوره با پشتیبان" },
  { value: "simple_consultant", label: "مشاوره ساده" },
] as const;
export const courseDurations = [
  { value: 3, label: "۳ ماهه" },
  { value: 6, label: "۶ ماهه" },
  { value: 12, label: "یک‌ساله" },
] as const;
export const courseFields = ["mathematics", "experimental_sciences", "humanities"] as const;
export type CourseSelection = { grade: 10 | 11 | 12; field: typeof courseFields[number]; course: typeof courseTypes[number]["value"]; months: 3 | 6 | 12 };
export function parseCourseSelection(params: Record<string, unknown>): CourseSelection | null {
  const { grade, field, course, months } = params;
  if ((typeof grade !== "string" && typeof grade !== "number") || (typeof months !== "string" && typeof months !== "number")) return null;
  if (!["10", "11", "12"].includes(String(grade)) || typeof field !== "string" || !courseFields.some(f => f === field) || typeof course !== "string" || !courseTypes.some(c => c.value === course) || !["3", "6", "12"].includes(String(months))) return null;
  return { grade: Number(grade), field, course, months: Number(months) } as CourseSelection;
}
export function courseRegistrationPath(selection: CourseSelection): string {
  return `/dashboard/registration?${new URLSearchParams({grade: String(selection.grade), field: selection.field, course: selection.course, months: String(selection.months)})}`;
}
export function courseTypeLabel(value: unknown): string { return courseTypes.find(c => c.value === value)?.label ?? ""; }
export function courseDurationLabel(value: unknown): string { return courseDurations.find(d => d.value === value)?.label ?? ""; }
export function coursesFor(grade: number, field: string): CourseSelection[] {
  return courseDurations.flatMap(duration => courseTypes.map(course => parseCourseSelection({ grade, field, course: course.value, months: duration.value }))).filter((c): c is CourseSelection => c !== null);
}
