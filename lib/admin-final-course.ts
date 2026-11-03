import { availableCoursePlans } from "@/lib/course-plans";
import { courseDurations } from "@/lib/courses";

// The student's requested plan is not an authorization to assign a service.
// Empty means no administrator-assigned plan, even if a paid request exists.
export function parseAdminFinalCourse(form: FormData, prefix = ""): { course: string | null; months: number | null } | null {
  const course = form.get(`${prefix}service_course_type`);
  const months = form.get(`${prefix}service_course_duration_months`);
  if (typeof course !== "string" || typeof months !== "string") return null;
  if (!course && !months) return { course: null, months: null };
  if (!availableCoursePlans.some((plan) => plan.value === course) ||
    !courseDurations.some((duration) => String(duration.value) === months)) return null;
  return { course, months: Number(months) };
}
