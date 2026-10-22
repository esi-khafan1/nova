import { CounselorStudentStudyEditor } from "@/components/dashboard/counselor-student-study-editor";
import { ReportRefreshButton } from "@/components/dashboard/report-refresh-button";
import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentPlanningPanel } from "@/components/dashboard/student-planning-panel";
import { StudentDashboardRefresh } from "@/components/dashboard/student-dashboard-refresh";
import { requireProfile } from "@/lib/auth";
import { loadStudyReport } from "@/lib/load-study-report";
import { tehranToday } from "@/lib/student-planning";
import type { StudyField } from "@/lib/study-catalog";
export default async function CounselorStudentReport({params}:{params:Promise<{studentId:string}>}){
 const {studentId}=await params;const {supabase,profile}=await requireProfile(['counselor']);
 if(!/^[0-9a-f-]{36}$/i.test(studentId))notFound();
 const {data:directory,error}=await supabase.rpc('counselor_student_directory').eq('student_id',studentId);if(error)throw new Error('Student directory unavailable');
 const student=(directory as {student_id:string;full_name:string;grade:number|null;study_field:StudyField|null;is_selected:boolean}[]).find(s=>s.student_id===studentId&&s.is_selected);if(!student)notFound();
 let report:Awaited<ReturnType<typeof loadStudyReport>>|null=null;try{report=await loadStudyReport(supabase,studentId);}catch{}
 return <DashboardShell role="counselor" name={profile.full_name}><StudentDashboardRefresh currentDate={tehranToday()}/><div className="cp-report-actions"><ReportRefreshButton/><Link href="/dashboard/counselor/students">← دانش‌آموزان و گزارش‌ها</Link><Link className="button" href={`/dashboard/counselor/plans?student=${studentId}`}>برنامه‌ریزی این دانش‌آموز</Link></div><CounselorStudentStudyEditor key={student.student_id} student={student}/>{report?<StudentPlanningPanel {...report} profile={student} today={tehranToday()} audience="counselor"/>:<section className="portal-card portal-alert error" role="alert"><h1>گزارش دریافت نشد</h1><p>این خطا به معنی خالی بودن گزارش نیست. دوباره صفحه را باز کن.</p></section>}</DashboardShell>;
}
