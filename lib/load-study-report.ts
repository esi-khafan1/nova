import type { SupabaseClient } from "@supabase/supabase-js";
import type { StudyPlan,StudyCompletion } from "@/lib/student-planning";
export async function loadStudyReport(supabase:SupabaseClient,studentId:string){
 const plans:StudyPlan[]=[],completions:StudyCompletion[]=[];
 for(let from=0;;from+=200){const {data,error}=await supabase.from('weekly_plans').select('id,title,week_start,notes,weekly_plan_items(id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order,source_grade,preparation_track,exam_year)').eq('student_id',studentId).eq('status','published').order('week_start',{ascending:false}).order('id').range(from,from+199);if(error)throw new Error('Study plans unavailable');plans.push(...(data??[]) as StudyPlan[]);if(!data||data.length<200)break;}
 for(let from=0;;from+=500){const {data,error}=await supabase.from('weekly_plan_item_completions').select('item_id,completed_at,completed_test_count').eq('student_id',studentId).order('item_id').range(from,from+499);if(error)throw new Error('Study reports unavailable');completions.push(...(data??[]) as StudyCompletion[]);if(!data||data.length<500)break;}
 return {plans,completions};
}
