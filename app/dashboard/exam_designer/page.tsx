import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { ExamBuilder } from "@/components/dashboard/exam-builder";
import { boxLabel, type ExamBox } from "@/lib/exam-boxes";
import { requireProfile } from "@/lib/auth";
import { examSaveErrorMessage } from "@/lib/exam-save-errors";
import { formatExamSchedule } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";
export default async function ExamDesignerPage({searchParams}:{searchParams:Promise<Record<string,string|undefined>>}) {
 const {supabase,profile}=await requireProfile(["exam_designer"]);const params=await searchParams;
 const [{data:exams,error},{data:boxesData,error:boxesError}]=await Promise.all([
  supabase.from("exams").select("id,title,status,starts_at,duration_minutes").eq("counselor_id",profile.id).order("created_at",{ascending:false}),
  supabase.rpc("designer_exam_boxes"),
 ]);
 const boxes=(Array.isArray(boxesData)?boxesData:[]) as ExamBox[];
 const pending=boxes.filter(box=>!box.linked_exam_id);
 return <DashboardShell role="exam_designer" name={profile.full_name}><section className="portal-heading"><div><span>پنل طراح آزمون</span><h1>طراحی و مدیریت آزمون</h1><p>دفترچه‌ها را آماده کن، کلید را وارد کن و دانش‌آموزان دارای مشاور را با جست‌وجوی نام به آزمون اضافه کن.</p></div></section>
 {params.saved&&<div className="portal-alert success">{params.saved==="published"?"آزمون منتشر شد و برای دانش‌آموزهای انتخاب‌شده قابل مشاهده است.":"پیش‌نویس ذخیره شد."}</div>}{params.error&&<div className="portal-alert error">{examSaveErrorMessage(params.error)}</div>}
 <section className="portal-card exam-box-requests"><div className="portal-card-title"><div><span>درخواست‌های مشاورها</span><h2>باکس‌های آزمون منتظر طراحی</h2></div><span className="exam-summary-pill">{toPersianDigits(pending.length)} درخواست</span></div>
 <p>هر باکس فقط یک «آزمون» در برنامه‌ هفتگی مشاور است؛ روز و درس همان باکس اینجا نمایش داده می‌شود. آزمون شبیه‌ساز ارسال نمی‌شود.</p>
 {boxesError?<p role="alert">دریافت باکس‌های آزمون انجام نشد؛ دوباره صفحه را باز کن.</p>:pending.length?<div className="exam-list">{pending.map(box=><article key={box.item_id}><div><h3>{box.student_name} · {box.subject}</h3><p>{boxLabel(box)} · {box.chapter||"مبحث آزاد"} · {toPersianDigits(box.duration_minutes)} دقیقه</p></div><Link className="button secondary" href={`/dashboard/exam_designer?box=${box.item_id}#exam-boxes`}>ساخت آزمون برای این باکس</Link></article>)}</div>:<p>فعلاً باکس آزمون تازه‌ای ارسال نشده است.</p>}
 </section>
 <ExamBuilder boxes={boxes} initialBoxId={params.box}/><section className="portal-card"><h2>آزمون‌های من</h2>{error?<p role="alert">دریافت آزمون‌ها انجام نشد.</p>:exams?.length?<div className="exam-list">{exams.map(e=><article key={e.id}><div><h3>{e.title}</h3><p>{e.status==="published"?"منتشرشده":e.status==="draft"?"پیش‌نویس":"بایگانی"} · {formatExamSchedule(e.starts_at)} · {e.duration_minutes.toLocaleString("fa-IR")} دقیقه</p></div><Link className="button secondary" href={`/dashboard/exam_designer/${e.id}`}>مدیریت آزمون و دانش‌آموزها</Link></article>)}</div>:<p>هنوز آزمونی نساخته‌ای.</p>}</section></DashboardShell>;
}
