import { defaultCourseOffers, findCourseOffer, type CourseOffers } from "@/lib/course-offers";
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
// Ninth grade has no high-school study field. Never persist a synthetic field.
export type CourseContext = { grade: 9; field: null } | { grade: 10 | 11 | 12; field: CourseField };
export type CourseSelection = CourseContext & { course: CourseType; months: 1 | 3 | 6 | 12 };

const grades = ["10", "11", "12"] as const;
const durations = ["1", "3", "6", "12"] as const;
const isCourseType = (value: unknown): value is CourseType =>
  typeof value === "string" && (getCoursePlan(value) !== undefined || legacyCourseTypes.some((item) => item.value === value));

export function parseCourseContext(params: Record<string, unknown>): CourseContext | null {
  const { grade, field } = params;
  if (typeof grade !== "string" && typeof grade !== "number") return null;
  if (String(grade) === "9") return field === null || field === undefined || field === "" || field === "none" ? {grade: 9, field: null} : null;
  if (!grades.includes(String(grade) as (typeof grades)[number]) || typeof field !== "string" || !courseFields.some(candidate => candidate === field)) return null;
  return { grade: Number(grade) as 10 | 11 | 12, field: field as CourseField };
}

export function parseCourseSelection(params: Record<string, unknown>): CourseSelection | null {
  const context = parseCourseContext(params);
  const { course, months } = params;
  if (!context || (typeof months !== "string" && typeof months !== "number") || !isCourseType(course) || !durations.includes(String(months) as (typeof durations)[number]) || (context.grade === 9 && !availableCoursePlans.some(plan => plan.value === course))) return null;
  return { ...context, course, months: Number(months) as CourseSelection["months"] };
}

export function courseCatalogPath(context: CourseContext): string {
  const params: Record<string,string> = {grade: String(context.grade)};
  if (context.field) params.field = context.field;
  return `/courses?${new URLSearchParams(params)}`;
}

export function studentCourseCatalogPath(grade: number | null | undefined, field: string | null | undefined): string {
  const context = parseCourseContext({ grade, field });
  return context ? courseCatalogPath(context) : "/courses";
}

export function courseLandingPath(context: CourseContext): string {
  const params: Record<string,string> = {grade: String(context.grade)};
  if (context.field) params.field = context.field;
  return `/?${new URLSearchParams(params)}#find-path`;
}

export function courseDetailsPath(selection: CourseSelection, returnTo?: "landing"): string {
  const path = `/courses/${selection.grade}/${selection.field ?? "none"}/${selection.course}/${selection.months}`;
  return returnTo === "landing" ? `${path}?return=landing` : path;
}

export function courseRegistrationPath(selection: CourseSelection): string {
  const params: Record<string,string> = {grade: String(selection.grade), course: selection.course, months: String(selection.months)};
  if (selection.field) params.field = selection.field;
  return `/dashboard/registration?${new URLSearchParams(params)}`;
}

export function courseTypeLabel(value: unknown): string {
  return getCoursePlan(value)?.label ?? legacyCourseTypes.find((item) => item.value === value)?.label ?? "";
}

export function courseDurationLabel(value: unknown): string {
  return courseDurations.find((duration) => duration.value === value)?.label ?? "";
}

export function coursesFor(grade: number, field: string | null): CourseSelection[] {
  const context = parseCourseContext({ grade, field });
  if (!context) return [];
  return courseDurations.flatMap(duration => availableCoursePlans.map(plan => ({
    ...context, course: plan.value, months: duration.value,
  })));
}

/** Toman amounts; period prices are always the configured monthly amount times the period. */
export function coursePrice(selection: CourseSelection, offers: CourseOffers = defaultCourseOffers): number | null {
 const monthly = findCourseOffer(offers,selection.grade,selection.course)?.monthly_price;
 return monthly === undefined ? null : monthly * selection.months;
}
