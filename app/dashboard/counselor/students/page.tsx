import { CounselorStudentCard } from "@/components/dashboard/counselor-student-card";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import type { StudyField } from "@/lib/study-catalog";
export default async function CounselorReports(){const {supabase,profile}=await requireProfile(['counselor']);const {data,error}=await supabase.rpc('counselor_student_directory');const students=((data??[]) as {student_id:string;full_name:string;grade:number|null;study_field:StudyField|null;is_selected:boolean}[]).filter(s=>s.is_selected);
 return <DashboardShell role="counselor" name={profile.full_name}><section className="sp-welcome"><div><span className="sp-eyebrow">کنار هر دانش‌آموز، یک مسیر روشن</span><h1>دانش‌آموزان و گزارش‌ها</h1></div></section>{error?<p className="portal-alert error" role="alert">فهرست دانش‌آموزان دریافت نشد؛ دوباره تلاش کن.</p>:<><div className="cp-student-grid">{students.map(s=><CounselorStudentCard key={s.student_id} student={s}/>)}{!students.length&&<section className="sp-empty"><h2>هنوز دانش‌آموزی توسط ادمین اختصاص داده نشده</h2></section>}</div></>}</DashboardShell>;
}
