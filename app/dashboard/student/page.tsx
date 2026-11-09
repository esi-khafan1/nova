import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentPlanningPanel } from "@/components/dashboard/student-planning-panel";
import { StudentDashboardRefresh } from "@/components/dashboard/student-dashboard-refresh";
import { StudentServiceNotice } from "@/components/dashboard/student-service-notice";
import { StudentProfileCompletionNotice } from "@/components/dashboard/student-profile-completion-notice";
import { StudentNameForm } from "@/components/dashboard/student-name-form";
import { requireProfile } from "@/lib/auth";
import { loadStudentAccount } from "@/lib/load-student-account";
import { verifiedMobileForAccount } from "@/lib/phone-auth";
import { loadStudentDashboard } from "@/lib/load-student-dashboard";
import { requiredStudentFieldsIssue, requiredStudentNameIssue } from "@/lib/registration";
import { tehranToday } from "@/lib/student-planning";
import type { StudentPlanExam } from "@/lib/student-plan-exams";

export default async function StudentDashboard() {
  // The zero-identity-argument RPC enforces student role/activation/RLS itself.
  // Never render its data until fresh getUser + profile checks also succeed.
  const authPromise = requireProfile(["student"], true);
  const [auth, loaded, account, assignedExams] = await Promise.all([
    authPromise,
    loadStudentDashboard(),
    authPromise.then(({ supabase, profile, user }) =>
      loadStudentAccount(supabase, profile, verifiedMobileForAccount(user)).catch(() => null)),
    authPromise.then(async ({ supabase, profile }) => {
      if (profile.registration_status !== "active") return { exams: [] as StudentPlanExam[], attemptIds: [] as string[], failed: false };
      // The student's RLS-filtered exam list includes both picker assignments
      // and linked exam boxes; no service-role client or elevated read is used.
      const [{ data: exams, error: examsError }, { data: attempts, error: attemptsError }, { data: extensions, error: extensionsError }] = await Promise.all([
        supabase.from("exams").select("id,title,description,starts_at,start_window_ends_at,duration_minutes")
          .eq("status", "published").order("starts_at", { ascending: false }),
        supabase.from("exam_attempts").select("exam_id").eq("student_id", profile.id).not("submitted_at", "is", null),
        supabase.rpc("student_exam_extensions"),
      ]);
      const submittedIds = new Set((attempts ?? []).map(attempt => attempt.exam_id));
      const extensionByExam = new Map(((extensions ?? []) as { exam_id: string; starts_at: string; ends_at: string }[])
        .map(extension => [extension.exam_id, extension]));
      const effectiveExams = ((exams ?? []) as StudentPlanExam[]).map(exam => {
        const extension = extensionByExam.get(exam.id);
        return extension && !submittedIds.has(exam.id)
          ? { ...exam, starts_at: extension.starts_at, start_window_ends_at: extension.ends_at, extended: true, extension_starts_at: extension.starts_at, extension_ends_at: extension.ends_at }
          : exam;
      });
      return { exams: effectiveExams, attemptIds: [...submittedIds], failed: Boolean(examsError || attemptsError || extensionsError) };
    }).catch(() => ({ exams: [] as StudentPlanExam[], attemptIds: [] as string[], failed: true })),
  ]);
  const { profile } = auth;
  const active = profile.registration_status === "active";
  // A failed account read is not proof of missing information.
  const completionIssue = account && !account.error ? requiredStudentFieldsIssue(account.values, true) : null;
  const failed = active && (loaded.failed || loaded.studentId !== profile.id || !loaded.active || assignedExams.failed);
  const plans = active && !failed ? loaded.plans : [];
  const completions = active && !failed ? loaded.completions : [];
  const dailyNotes = active && !failed ? loaded.dailyNotes : [];
  return <DashboardShell role="student" name={profile.full_name}>
    {!profile.full_name?.trim() && <StudentNameForm/>}
    <StudentServiceNotice status={profile.registration_status} grade={profile.grade} studyField={profile.study_field}/>
    {completionIssue && <StudentProfileCompletionNotice issue={completionIssue} active={active} focusName={Boolean(account && requiredStudentNameIssue(account.values))}/>}
    <StudentDashboardRefresh currentDate={tehranToday()}/>
    {failed ? <section className="portal-card portal-alert error" role="alert"><h1>برنامه‌ها و آزمون‌ها فعلاً کامل دریافت نشدند</h1><p>دوباره صفحه را باز کن. این پیام به معنی نداشتن برنامه، آزمون یا گزارش نیست.</p><a href="/dashboard/student">تلاش دوباره</a></section> : <StudentPlanningPanel audience="student" plans={plans} completions={completions} dailyNotes={dailyNotes} exams={assignedExams.exams} submittedExamIds={assignedExams.attemptIds} today={tehranToday()} profile={{ full_name: profile.full_name, grade: profile.grade, study_field: profile.study_field }}/>}
  </DashboardShell>;
}
