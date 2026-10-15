import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { ExamBuilder } from "@/components/dashboard/exam-builder";
import { requireProfile } from "@/lib/auth";
import { examSaveErrorMessage } from "@/lib/exam-save-errors";
import { formatExamSchedule } from "@/lib/exams";
export default async function ExamDesignerPage({searchParams}:{searchParams:Promise<Record<string,string|undefined>>}) {
 const {supabase,profile}=await requireProfile(["exam_designer"]);const params=await searchParams;
 const {data:exams,error}=await supabase.from("exams").select("id,title,status,starts_at,duration_minutes").eq("counselor_id",profile.id).order("created_at",{ascending:false});
 return <DashboardShell role="exam_designer" name={profile.full_name}><section className="portal-heading"><div><span>پنل طراح آزمون</span><h1>طراحی و مدیریت آزمون</h1><p>دفترچه‌ها را آماده کن، کلید را وارد کن و دانش‌آموزها را با جست‌وجوی نام به آزمون اضافه کن.</p></div></section>
 {params.saved&&<div className="portal-alert success">{params.saved==="published"?"آزمون منتشر شد و برای دانش‌آموزهای انتخاب‌شده قابل مشاهده است.":"پیش‌نویس ذخیره شد."}</div>}{params.error&&<div className="portal-alert error">{examSaveErrorMessage(params.error)}</div>}
 <ExamBuilder/><section className="portal-card"><h2>آزمون‌های من</h2>{error?<p role="alert">دریافت آزمون‌ها انجام نشد.</p>:exams?.length?<div className="exam-list">{exams.map(e=><article key={e.id}><div><h3>{e.title}</h3><p>{e.status==="published"?"منتشرشده":e.status==="draft"?"پیش‌نویس":"بایگانی"} · {formatExamSchedule(e.starts_at)} · {e.duration_minutes.toLocaleString("fa-IR")} دقیقه</p></div><Link className="button secondary" href={`/dashboard/exam_designer/${e.id}`}>مدیریت آزمون و دانش‌آموزها</Link></article>)}</div>:<p>هنوز آزمونی نساخته‌ای.</p>}</section></DashboardShell>;
}
