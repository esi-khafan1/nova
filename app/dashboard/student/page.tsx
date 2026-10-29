import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentPlanningPanel } from "@/components/dashboard/student-planning-panel";
import { StudentDashboardRefresh } from "@/components/dashboard/student-dashboard-refresh";
import { StudentServiceNotice } from "@/components/dashboard/student-service-notice";
import { StudentProfileCompletionNotice } from "@/components/dashboard/student-profile-completion-notice";
import { requireProfile } from "@/lib/auth";
import { loadStudentAccount } from "@/lib/load-student-account";
import { verifiedMobileForAccount } from "@/lib/phone-auth";
import { loadStudentDashboard } from "@/lib/load-student-dashboard";
import { validateRegistration } from "@/lib/registration";
import { tehranToday } from "@/lib/student-planning";

export default async function StudentDashboard() {
  // The zero-identity-argument RPC enforces student role/activation/RLS itself.
  // Never render its data until fresh getUser + profile checks also succeed.
  const authPromise = requireProfile(["student"], true);
  const [auth, loaded, account] = await Promise.all([
    authPromise,
    loadStudentDashboard(),
    authPromise.then(({ supabase, profile, user }) => profile.registration_status === "active"
      ? loadStudentAccount(supabase, profile, verifiedMobileForAccount(user)).catch(() => null)
      : null),
  ]);
  const { profile } = auth;
  const active = profile.registration_status === "active";
  // A failed account read is not proof of missing information.
  const completionIssue = active && account && !account.error ? validateRegistration(account.values, true) : null;
  const failed = active && (loaded.failed || loaded.studentId !== profile.id || !loaded.active);
  const plans = active && !failed ? loaded.plans : [];
  const completions = active && !failed ? loaded.completions : [];
  return <DashboardShell role="student" name={profile.full_name}>
    <StudentServiceNotice status={profile.registration_status} grade={profile.grade} studyField={profile.study_field}/>
    {completionIssue && <StudentProfileCompletionNotice issue={completionIssue}/>}
    <StudentDashboardRefresh currentDate={tehranToday()}/>
    {failed ? <section className="portal-card portal-alert error" role="alert"><h1>برنامه‌ها فعلاً دریافت نشدند</h1><p>دوباره صفحه را باز کن. این پیام به معنی نداشتن برنامه یا گزارش نیست.</p><a href="/dashboard/student">تلاش دوباره</a></section> : <StudentPlanningPanel audience="student" plans={plans} completions={completions} today={tehranToday()} profile={{ full_name: profile.full_name, grade: profile.grade, study_field: profile.study_field }}/>}
  </DashboardShell>;
}
