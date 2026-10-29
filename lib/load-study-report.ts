import type { SupabaseClient } from "@supabase/supabase-js";
import type { StudyPlan, StudyCompletion } from "@/lib/student-planning";
import { collectQueryPages } from "@/lib/collect-query-pages";
export async function loadStudyReport(supabase: SupabaseClient, studentId: string) {
    const [plans, completions] = await Promise.all([
        collectQueryPages<StudyPlan>(200, (from, to) => supabase.from('weekly_plans').select('id,title,week_start,notes,weekly_plan_items(id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order,source_grade,preparation_track,recommended_publisher,exam_year,linked_exam_id)').eq('student_id', studentId).eq('status', 'published').order('week_start', { ascending: false }).order('id').range(from, to), 'Study plans unavailable'),
        collectQueryPages<StudyCompletion>(500, (from, to) => supabase.from('weekly_plan_item_completions').select('item_id,completed_at,checked_at,completed_test_count,completed_minutes').eq('student_id', studentId).order('item_id').range(from, to), 'Study reports unavailable'),
    ]);
    return { plans, completions };
}
