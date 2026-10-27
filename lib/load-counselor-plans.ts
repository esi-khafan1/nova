import type { SupabaseClient } from "@supabase/supabase-js";
import type { CounselorWeeklyPlan } from "@/components/dashboard/weekly-plan-builder";
import { collectQueryPages } from "@/lib/collect-query-pages";
export function loadCounselorPlans(supabase: SupabaseClient, counselorId: string) {
    return collectQueryPages<CounselorWeeklyPlan>(200, (from, to) => supabase.from("weekly_plans").select("id,student_id,week_start,title,notes,status,updated_at,routines,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order,source_grade,preparation_track,exam_year,linked_exam_id)").eq("counselor_id", counselorId).order("week_start", { ascending: false }).order("id").range(from, to), "Counselor plans unavailable");
}
