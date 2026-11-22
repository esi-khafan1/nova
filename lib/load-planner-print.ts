import type { SupabaseClient } from "@supabase/supabase-js";
import type { PrintablePlan, PrintableWeekDetails } from "@/components/dashboard/print-weekly-plan";
import { printableTodayReviews } from "@/lib/planner-review-today";
import { parsePublishedTopics } from "@/lib/planner-published-topics";

/** Load authorized published print extras. null means the project has not yet
 * installed the optional planner RPCs; permission/network errors fail closed. */
export async function loadPublishedPlannerPrintData(supabase: SupabaseClient, plan: PrintablePlan) {
  const [reviews, extras] = await Promise.all([
    supabase.rpc("planner_review_today_v2", {target_student_id:plan.student_id}),
    supabase.rpc("planner_get_published_extras", {target_plan_id:plan.id}),
  ]);
  const missing = (code: string | undefined) => code === "PGRST202" || code === "42883";
  if ((reviews.error && missing(reviews.error.code)) || (extras.error && missing(extras.error.code))) {
    if ((reviews.error && !missing(reviews.error.code)) || (extras.error && !missing(extras.error.code))) throw new Error("Unable to load print data");
    return null;
  }
  if (reviews.error || extras.error || !extras.data || typeof extras.data !== "object" || Array.isArray(extras.data) || !extras.data.week || typeof extras.data.week !== "object" || Array.isArray(extras.data.week)) throw new Error("Unable to load print data");
  const raw = extras.data.week as Record<string, unknown>;
  const weekDetails: PrintableWeekDetails = {};
  for (const key of ["goal", "wakeTime", "sleepTime", "mobileLimit"] as const) {
    if (raw[key] != null && typeof raw[key] !== "string") throw new Error("Invalid print metadata");
    if (typeof raw[key] === "string") weekDetails[key] = raw[key];
  }
  const itemTopics = parsePublishedTopics(extras.data.items);
  const reviewRows = printableTodayReviews(reviews.data);
  const start = Date.parse(`${plan.week_start}T00:00:00Z`);
  if (!Number.isFinite(start) || new Date(start).toISOString().slice(0,10) !== plan.week_start) throw new Error("Invalid print week");
  const end = new Date(start + 6 * 86400000).toISOString().slice(0,10);
  return {weekDetails,reviewRows:reviewRows.filter(row=>row.date>=plan.week_start&&row.date<=end),itemTopics};
}
