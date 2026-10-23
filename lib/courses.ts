import { availableCoursePlans, getCoursePlan, legacyCourseTypes, type CoursePlanId, type LegacyCourseType } from "@/lib/course-plans";

export const courseDurations = [
  { value: 1, label: "۱ ماهه" },
  { value: 3, label: "۳ ماهه" },
  { value: 6, label: "۶ ماهه" },
  { value: 12, label: "یک‌ساله" },
] as const;

export const courseFields = ["mathematics", "experimental_sciences", "humanities"] as const;
export type CourseField = (typeof courseFields)[number];
export type CourseType = CoursePlanId | LegacyCourseType;
export type CourseSelection = { grade: 10 | 11 | 12; field: CourseField; course: CourseType; months: 1 | 3 | 6 | 12 };
export type CourseContext = Pick<CourseSelection, "grade" | "field">;

const grades = ["10", "11", "12"] as const;
const durations = ["1", "3", "6", "12"] as const;
const isCourseType = (value: unknown): value is CourseType =>
  typeof value === "string" && (getCoursePlan(value) !== undefined || legacyCourseTypes.some((item) => item.value === value));

export function parseCourseContext(params: Record<string, unknown>): CourseContext | null {
  const { grade, field } = params;
  if ((typeof grade !== "string" && typeof grade !== "number") || typeof field !== "string") return null;
  if (!grades.includes(String(grade) as (typeof grades)[number]) || !courseFields.some((candidate) => candidate === field)) return null;
  return { grade: Number(grade) as CourseContext["grade"], field: field as CourseField };
}

export function parseCourseSelection(params: Record<string, unknown>): CourseSelection | null {
  const { grade, field, course, months } = params;
  if ((typeof grade !== "string" && typeof grade !== "number") || (typeof months !== "string" && typeof months !== "number")) return null;
  if (!grades.includes(String(grade) as (typeof grades)[number]) || typeof field !== "string" || !courseFields.some((candidate) => candidate === field) || !isCourseType(course) || !durations.includes(String(months) as (typeof durations)[number])) return null;
  return { grade: Number(grade) as CourseSelection["grade"], field: field as CourseField, course, months: Number(months) as CourseSelection["months"] };
}

export function courseCatalogPath(context: CourseContext): string {
  return `/courses?${new URLSearchParams({ grade: String(context.grade), field: context.field })}`;
}

export function courseLandingPath(context: CourseContext): string {
  return `/?${new URLSearchParams({ grade: String(context.grade), field: context.field })}#find-path`;
}

export function courseDetailsPath(selection: CourseSelection, returnTo?: "landing"): string {
  const path = `/courses/${selection.grade}/${selection.field}/${selection.course}/${selection.months}`;
  return returnTo === "landing" ? `${path}?return=landing` : path;
}

export function courseRegistrationPath(selection: CourseSelection): string {
  return `/dashboard/registration?${new URLSearchParams({grade: String(selection.grade), field: selection.field, course: selection.course, months: String(selection.months)})}`;
}

export function courseTypeLabel(value: unknown): string {
  return getCoursePlan(value)?.label ?? legacyCourseTypes.find((item) => item.value === value)?.label ?? "";
}

export function courseDurationLabel(value: unknown): string {
  return courseDurations.find((duration) => duration.value === value)?.label ?? "";
}

export function coursesFor(grade: number, field: string): CourseSelection[] {
  const context = parseCourseContext({ grade, field });
  if (!context) return [];
  return courseDurations.flatMap((duration) => availableCoursePlans.map((plan) => ({
    ...context,
    course: plan.value,
    months: duration.value,
  })));
}

/** Toman amounts; longer durations are exact multiples, with no additional discount. */
export function coursePrice(selection: CourseSelection): {original: number; discounted: number} | null {
 if (selection.course !== "base" && selection.course !== "progress") return null;
 const monthly = selection.grade === 12
  ? {base: {original: 3200000, discounted: 2290000}, progress: {original: 3500000, discounted: 2590000}}
  : {base: {original: 3000000, discounted: 2100000}, progress: {original: 3400000, discounted: 2390000}};
 const price=monthly[selection.course];
 return {original:price.original*selection.months,discounted:price.discounted*selection.months};
}
