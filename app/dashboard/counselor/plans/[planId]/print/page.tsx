import { notFound } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import {dayIso, visiblePlanDays} from "@/lib/student-planning";
import { PrintWeeklyPlan,type PrintablePlan } from "@/components/dashboard/print-weekly-plan";
import type { StudyField } from "@/lib/study-catalog";
type StudentDirectoryRow={student_id:string;full_name:string;grade:number|null;study_field:StudyField|null};
export default async function PrintWeeklyPlanPage({
  params,
}: {
  params: Promise<{ planId: string }>;
}) {
  const { planId } = await params;
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data: planData }, { data: directoryData }] = await Promise.all([
    supabase
      .from("weekly_plans")
      .select(
        "id,student_id,counselor_id,week_start,title,notes,status,routines,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order)",
      )
      .eq("id", planId)
      .single(),
    supabase.rpc("counselor_student_directory"),
  ]);

  if (!planData) notFound();

  const plan = planData as PrintablePlan;
  const student = (directoryData as StudentDirectoryRow[] | null)?.find(
    (item) => item.student_id === plan.student_id,
  );
  // RLS allows prior published plans only for the student's current counselor.
  // Drafts stay restricted to their author; never print an unassigned student.
  if (!student || (planData.counselor_id !== profile.id && planData.status !== "published")) notFound();
  let visibleDays=7;
  if(plan.status === "published") {
    const {data:laterPlans,error:laterError}=await supabase.from("weekly_plans").select("id,week_start").eq("student_id",plan.student_id).eq("status","published").gt("week_start",plan.week_start).lte("week_start",dayIso(plan.week_start,6));
    if(laterError || !laterPlans) throw new Error("Unable to load published plan dates");
    visibleDays=visiblePlanDays(plan,laterPlans);
  }
  return <PrintWeeklyPlan plan={plan} student={student} counselorName={planData.counselor_id === profile.id ? profile.full_name : "مشاور پیشین نووا"} backHref="/dashboard/counselor/plans" visibleDays={visibleDays}/>;
}
