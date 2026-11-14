import { notFound } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import {dayIso, visiblePlanDays} from "@/lib/student-planning";
import { PrintWeeklyPlan, type PrintablePlan } from "@/components/dashboard/print-weekly-plan";
import { PlannerPrintSuite } from "@/components/dashboard/planner-print-suite";
import { loadPublishedPlannerPrintData } from "@/lib/load-planner-print";
export default async function StudentPrint({params}:{params:Promise<{planId:string}>}){
 const {profile,supabase}=await requireProfile(["student"]);const {planId}=await params;
 if(!/^[0-9a-f-]{36}$/i.test(planId))notFound();
 const {data,error}=await supabase.from("weekly_plans").select("id,student_id,week_start,title,notes,status,routines,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order)").eq("id",planId).eq("student_id",profile.id).eq("status","published").single();
 if(error||!data)notFound();
 const plan=data as PrintablePlan;
 const {data:laterPlans,error:laterError}=await supabase.from("weekly_plans").select("id,week_start").eq("student_id",profile.id).eq("status","published").gt("week_start",plan.week_start).lte("week_start",dayIso(plan.week_start,6));
 if(laterError || !laterPlans) throw new Error("Unable to load published plan dates");
 const visibleDays=visiblePlanDays(plan,laterPlans);
 const printData=await loadPublishedPlannerPrintData(supabase,plan);
 if(!printData) return <PrintWeeklyPlan plan={plan} student={profile} counselorName="مشاور نووا" backHref="/dashboard/student#weekly-plan" visibleDays={visibleDays}/>;
 // The suite is a client component. Never serialize designer-only exam notes
 // into the student's browser, even though the visual print hides them too.
 const studentPlan={...plan,weekly_plan_items:plan.weekly_plan_items.map(item=>({...item,details:item.activity_type==='exam'?null:item.details,topics:printData.itemTopics[item.id]??[]}))};
 return <PlannerPrintSuite plan={studentPlan} student={{full_name:profile.full_name,grade:profile.grade,study_field:profile.study_field}} counselorName="مشاور نووا" backHref="/dashboard/student#weekly-plan" visibleDays={visibleDays} weekDetails={printData.weekDetails} sources={[]} completed={new Set()} reviewRows={printData.reviewRows}/>;
}
