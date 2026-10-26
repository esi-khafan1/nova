import { notFound } from "next/navigation";
import { requireProfile } from "@/lib/auth";
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
        "id,student_id,week_start,title,notes,status,routines,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order)",
      )
      .eq("id", planId)
      .eq("counselor_id", profile.id)
      .single(),
    supabase.rpc("counselor_student_directory"),
  ]);

  if (!planData) notFound();

  const plan = planData as PrintablePlan;
  const student = (directoryData as StudentDirectoryRow[] | null)?.find(
    (item) => item.student_id === plan.student_id,
  );
  return <PrintWeeklyPlan plan={plan} student={student} counselorName={profile.full_name} backHref="/dashboard/counselor/plans"/>;
}
