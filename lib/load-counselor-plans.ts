import type { SupabaseClient } from "@supabase/supabase-js";
import type { CounselorWeeklyPlan } from "@/components/dashboard/weekly-plan-builder";
import { collectQueryPages } from "@/lib/collect-query-pages";
export function loadCounselorPlans(supabase: SupabaseClient, counselorId: string) {
    return collectQueryPages<CounselorWeeklyPlan>(200, (from, to) => supabase.from("weekly_plans").select("id,student_id,week_start,title,notes,status,updated_at,routines,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order,source_grade,preparation_track,recommended_publisher,exam_year,linked_exam_id)").eq("counselor_id", counselorId).order("week_start", { ascending: false }).order("id").range(from, to), "Counselor plans unavailable");
}
// The RPC derives identity from auth.uid() and retains RLS. The page must still
// wait for fresh Auth/role verification and compare its identity before use.
export type CounselorPlanHistory = Pick<CounselorWeeklyPlan, "id" | "student_id" | "week_start" | "title" | "status"> & {counselor_id: string; weekly_plan_items: {day_of_week: number}[]};
export async function loadCounselorEditorPage<T extends CounselorWeeklyPlan | CounselorPlanHistory>(supabase: SupabaseClient, previousHistory: boolean) {
    const plans: T[] = [];
    let counselorId: string | null = null;
    for (let offset = 0;; offset += 200) {
        const {data,error} = await supabase.rpc("counselor_plan_editor_page", {page_offset: offset, previous_history: previousHistory});
        const page = data as {counselor_id: string; plans: T[]; has_more: boolean} | null;
        if (error || !page || typeof page.counselor_id !== "string" || !Array.isArray(page.plans) ||
            typeof page.has_more !== "boolean" || page.plans.length > 200 || (page.has_more && page.plans.length !== 200)) {
            throw new Error("Counselor plans unavailable");
        }
        if (counselorId !== null && counselorId !== page.counselor_id) throw new Error("Counselor identity changed");
        counselorId = page.counselor_id;
        plans.push(...page.plans);
        if (!page.has_more) return {counselorId, plans};
    }
}

// Published history from earlier counselors is visible to the CURRENT assigned
// counselor via RLS. Do not pass these plans to the editing builder: their
// original authorship remains immutable and only this counselor's own plans
// may be edited.
export function loadAssignedPublishedHistory(supabase: SupabaseClient, counselorId: string) {
    return collectQueryPages<Pick<CounselorWeeklyPlan,"id"|"student_id"|"week_start"|"title"|"status"> & {counselor_id:string;weekly_plan_items:{day_of_week:number}[]}>(200,
      (from,to)=>supabase.from("weekly_plans")
        .select("id,student_id,counselor_id,week_start,title,status,weekly_plan_items(day_of_week)")
        .eq("status","published")
        .neq("counselor_id",counselorId)
        .order("week_start",{ascending:false}).order("id").range(from,to),"Published history unavailable");
}
