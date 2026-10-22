import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentPlanningPanel } from "@/components/dashboard/student-planning-panel";
import { StudentDashboardRefresh } from "@/components/dashboard/student-dashboard-refresh";
import { StudentServiceNotice } from "@/components/dashboard/student-service-notice";
import { requireProfile } from "@/lib/auth";
import {loadStudentDashboard} from "@/lib/load-student-dashboard";
import { tehranToday } from "@/lib/student-planning";
export default async function StudentDashboard(){
 // The zero-identity-argument RPC enforces student role/activation/RLS itself.
 // Never render its data until fresh getUser + profile checks also succeed.
 const [{profile},loaded]=await Promise.all([
  requireProfile(["student"],true),loadStudentDashboard(),
 ]);
 const active=profile.registration_status==="active";
 const failed=active&&(loaded.failed||loaded.studentId!==profile.id||!loaded.active);
 const plans=active&&!failed?loaded.plans:[],completions=active&&!failed?loaded.completions:[];
 return <DashboardShell role="student" name={profile.full_name}><StudentServiceNotice status={profile.registration_status}/><StudentDashboardRefresh currentDate={tehranToday()}/>{failed?<section className="portal-card portal-alert error" role="alert"><h1>برنامه‌ها فعلاً دریافت نشدند</h1><p>دوباره صفحه را باز کن. این پیام به معنی نداشتن برنامه یا گزارش نیست.</p><a href="/dashboard/student">تلاش دوباره</a></section>:<StudentPlanningPanel audience="student" plans={plans} completions={completions} today={tehranToday()} profile={{full_name:profile.full_name,grade:profile.grade,study_field:profile.study_field}}/>}</DashboardShell>;
}
