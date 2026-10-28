import { type FloatingExamSession } from "@/lib/floating-exams";
import { StudentServiceNotice } from "@/components/dashboard/student-service-notice";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { StudentExamsOverview, type StudentExam, type StudentExamAttempt } from "@/components/dashboard/student-exam-card";

export default async function StudentExamsPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["student"], true);
  const params = await searchParams;
  if (profile.registration_status !== "active") return <DashboardShell role="student" name={profile.full_name}><section className="portal-heading"><div><span>آزمون‌های من</span><h1>آزمون‌های کنکوری</h1><p>آزمون‌های اختصاصی پس از فعال‌شدن خدمات و تخصیص طراح آزمون در این بخش نمایش داده می‌شوند.</p></div></section><StudentServiceNotice status={profile.registration_status}/></DashboardShell>;


  const [{ data: examsData }, { data: attemptsData }, {data:sessionsData}] =
    await Promise.all([
      supabase
        .from("exams")
        .select(
          "id,title,description,mode,audience,starts_at,start_window_ends_at,duration_minutes,created_at,exam_booklets(id,question_count)",
        )
        .eq("status", "published")
        .order("starts_at", { ascending: false }),
      supabase
        .from("exam_attempts")
        .select("exam_id,score,correct_answers,total_questions,submitted_at")
        .eq("student_id", profile.id),
      supabase.from("exam_sessions").select("exam_id,expires_at").eq("student_id",profile.id),
    ]);

  const sessions = new Map(((sessionsData ?? []) as Pick<FloatingExamSession,"exam_id"|"expires_at">[]).map(session=>[session.exam_id,session]));
  const exams = (examsData ?? []) as StudentExam[];
  const attempts = new Map(
    ((attemptsData ?? []) as StudentExamAttempt[]).map((attempt) => [
      attempt.exam_id,
      attempt,
    ]),
  );

  return (
    <DashboardShell role="student" name={profile.full_name}>
      {profile.registration_status !== "active" && <StudentServiceNotice status={profile.registration_status}/>}
      <StudentExamsOverview exams={profile.registration_status === "active" ? exams : exams.filter(exam => attempts.has(exam.id))} attempts={attempts} sessions={sessions} error={Boolean(params.error)} />
    </DashboardShell>
  );
}

