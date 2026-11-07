import { notFound } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import {dayIso, visiblePlanDays} from "@/lib/student-planning";
import { PrintWeeklyPlan, type PrintablePlan } from "@/components/dashboard/print-weekly-plan";
export default async function StudentPrint({params}:{params:Promise<{planId:string}>}){
 const {profile,supabase}=await requireProfile(["student"]);const {planId}=await params;
 if(!/^[0-9a-f-]{36}$/i.test(planId))notFound();
 const {data,error}=await supabase.from("weekly_plans").select("id,student_id,week_start,title,notes,status,routines,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order)").eq("id",planId).eq("student_id",profile.id).eq("status","published").single();
 if(error||!data)notFound();
 const plan=data as PrintablePlan;
 const {data:laterPlans,error:laterError}=await supabase.from("weekly_plans").select("id,week_start").eq("student_id",profile.id).eq("status","published").gt("week_start",plan.week_start).lte("week_start",dayIso(plan.week_start,6));
 if(laterError || !laterPlans) throw new Error("Unable to load published plan dates");
 const visibleDays=visiblePlanDays(plan,laterPlans);
 return <PrintWeeklyPlan plan={plan} student={profile} counselorName="مشاور نووا" backHref="/dashboard/student#weekly-plan" visibleDays={visibleDays}/>;
}
