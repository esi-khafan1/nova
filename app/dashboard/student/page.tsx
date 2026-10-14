import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentPlanningPanel } from "@/components/dashboard/student-planning-panel";
import { StudentDashboardRefresh } from "@/components/dashboard/student-dashboard-refresh";
import { requireProfile } from "@/lib/auth";
import { tehranToday, type StudyPlan, type StudyCompletion } from "@/lib/student-planning";
export default async function StudentDashboard(){
 const {supabase,profile}=await requireProfile(["student"]); const plans:StudyPlan[]=[],completions:StudyCompletion[]=[];let failed=false;
 for(let from=0;;from+=200){const {data,error}=await supabase.from("weekly_plans").select("id,title,week_start,notes,weekly_plan_items(id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order,source_grade,preparation_track,exam_year)").eq("student_id",profile.id).eq("status","published").order("week_start",{ascending:false}).order("id").range(from,from+199);if(error){failed=true;break;}plans.push(...(data??[]) as StudyPlan[]);if(!data||data.length<200)break;}
 if(!failed)for(let from=0;;from+=500){const {data,error}=await supabase.from("weekly_plan_item_completions").select("item_id,completed_at,completed_test_count").eq("student_id",profile.id).order("item_id").range(from,from+499);if(error){failed=true;break;}completions.push(...(data??[]) as StudyCompletion[]);if(!data||data.length<500)break;}
 return <DashboardShell role="student" name={profile.full_name}><StudentDashboardRefresh currentDate={tehranToday()}/>{failed?<section className="portal-card portal-alert error" role="alert"><h1>برنامه‌ها فعلاً دریافت نشدند</h1><p>دوباره صفحه را باز کن. این پیام به معنی نداشتن برنامه یا گزارش نیست.</p><a href="/dashboard/student">تلاش دوباره</a></section>:<StudentPlanningPanel audience="student" plans={plans} completions={completions} today={tehranToday()} profile={{full_name:profile.full_name,grade:profile.grade,study_field:profile.study_field}}/>}</DashboardShell>;
}
