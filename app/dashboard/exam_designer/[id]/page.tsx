import Link from "next/link";
import {notFound} from "next/navigation";
import {requireProfile} from "@/lib/auth";
import {DashboardShell} from "@/components/dashboard/dashboard-shell";
import {ExamBuilder} from "@/components/dashboard/exam-builder";
import {ExamExplanationManager} from "@/components/dashboard/exam-explanation-manager";
import type {ExamBooklet} from "@/lib/exams";
import type {ExamBox} from "@/lib/exam-boxes";
import type {StudyField} from "@/lib/study-catalog";
import {toPersianDigits} from "@/lib/persian-date";
type DesignerAttempt = { attempt_id:string; student_name:string; score:number|null; correct_answers:number|null; incorrect_answers:number|null; unanswered_count:number|null; total_questions:number|null; submitted_at:string };
export default async function EditDesignerExam({params,searchParams}:{params:Promise<{id:string}>;searchParams:Promise<{saved?:string;error?:string;page?:string}>}) {
 const {id}=await params;const query=await searchParams;const {supabase,profile}=await requireProfile(["exam_designer"]);
 const attemptPage=Math.max(1,Math.min(200,Number.parseInt(query.page??"1",10)||1));
 const attemptOffset=(attemptPage-1)*50;
 // The details RPC independently checks designer role and exam ownership.
 const [{data:exam},{data:payload,error},{data:boxesData},{data:notesData,error:notesError},{data:attemptsData,error:attemptsError,count:attemptCount}]=await Promise.all([
  supabase.from("exams").select("id,title,description,exam_field,starts_at,start_window_ends_at").eq("id",id).eq("counselor_id",profile.id).single(),
  supabase.rpc("designer_exam_details",{target_exam_id:id}),
  supabase.rpc("designer_exam_boxes"),
  supabase.rpc("designer_exam_box_notes"),
  supabase.rpc("designer_exam_attempts",{target_exam_id:id},{count:"exact"}).range(attemptOffset,attemptOffset+49),
 ]);
 const notes=new Map(((notesData??[]) as {item_id:string;note:string}[]).map(row=>[row.item_id,row.note]));
 const boxes=((Array.isArray(boxesData)?boxesData:[]) as ExamBox[]).map(box=>({...box,note:notes.get(box.item_id)??null}));
 if(!exam)notFound();
 // An RPC failure (stale session, changed role, ...) must not become an
 // unhandled server exception that renders the generic application-error page.
 if(error||!payload)return <DashboardShell role="exam_designer" name={profile.full_name}><section className="portal-heading"><h1>اطلاعات آزمون در دسترس نیست</h1><Link className="button secondary" href="/dashboard/exam_designer">بازگشت</Link></section><section className="portal-card"><p role="alert">دریافت جزئیات آزمون انجام نشد؛ دوباره تلاش کن.</p></section></DashboardShell>;
 const dateTime=(stamp:string)=>new Intl.DateTimeFormat("sv-SE",{timeZone:"Asia/Tehran",year:"numeric",month:"2-digit",day:"2-digit",hour:"2-digit",minute:"2-digit",hour12:false}).format(new Date(stamp));
 const start=dateTime(exam.starts_at);
 return <DashboardShell role="exam_designer" name={profile.full_name}><section className="portal-heading"><h1>{exam.title}</h1><Link className="button secondary" href="/dashboard/exam_designer">بازگشت</Link></section>{query.saved === "explanation" && <p className="portal-alert success" role="status">پاسخنامهٔ تشریحی ذخیره شد.</p>}{query.error === "explanation" && <p className="portal-alert error" role="alert">ذخیرهٔ پاسخنامه انجام نشد؛ دوباره تلاش کن.</p>}{notesError&&<p className="portal-alert error" role="alert">راهنمای مشاور برای باکس‌ها دریافت نشد؛ دوباره تلاش کن.</p>}{payload.locked?<section className="portal-card"><h2>آزمون قفل شده است</h2><p>سؤالات، کلید و زمان آزمونی که شروع شده قابل تغییر نیستند؛ برای آن‌ها آزمون جدید بساز.</p></section>:<>{Number(payload.excluded_student_count)>0&&<p className="portal-alert" role="status">{Number(payload.excluded_student_count).toLocaleString("fa-IR")} دانش‌آموزِ بدون مشاور از فهرست انتخاب کنار گذاشته شده‌اند؛ با ذخیرهٔ تغییرات، انتخاب قبلی آن‌ها از آزمون حذف می‌شود.</p>}<ExamBuilder initial={{id:exam.id,title:exam.title,description:exam.description,examField:(exam.exam_field??"") as StudyField|"",scheduledDate:start.slice(0,10),scheduledTime:start.slice(11,16),windowEndTime:exam.start_window_ends_at?dateTime(exam.start_window_ends_at).slice(11,16):null,students:payload.students??[],boxIds:Array.isArray(payload.box_ids)?payload.box_ids:[],booklets:(Array.isArray(payload.booklets)?payload.booklets as ExamBooklet[]:[]).map(b=>({id:b.id,title:b.title,pdfUrl:b.pdf_url,explanationPdfUrl:b.explanation_pdf_url??"",questionCount:b.question_count,durationMinutes:b.duration_minutes,keyAnswers:b.key_answers??{}}))}} boxes={boxes}/></>}{payload.locked && <ExamExplanationManager examId={exam.id} booklets={Array.isArray(payload.booklets) ? (payload.booklets as ExamBooklet[]).map(b => ({id:b.id,title:b.title,explanation_pdf_url:b.explanation_pdf_url})) : []}/>}<section className="portal-card exam-results" aria-labelledby="designer-attempts-title">
   <div className="portal-card-title"><div><span>شرکت‌کنندگان</span><h2 id="designer-attempts-title">پاسخ‌های ثبت‌شده</h2></div></div>
   {attemptsError ? <p role="alert">دریافت پاسخ‌های شرکت‌کنندگان انجام نشد؛ دوباره تلاش کن.</p>
     : Array.isArray(attemptsData) && attemptsData.length ? <div className="exam-result-list">{(attemptsData as DesignerAttempt[]).map(attempt=><article className="exam-result-card" key={attempt.attempt_id}>
       <div className="exam-result-header"><div><strong>{attempt.student_name}</strong><span>{new Intl.DateTimeFormat("fa-IR",{dateStyle:"medium",timeStyle:"short",timeZone:"Asia/Tehran"}).format(new Date(attempt.submitted_at))}</span></div><div className="exam-result-score-tag">{attempt.score === null ? "درصد هنوز آماده نیست" : `${toPersianDigits(attempt.score)}٪`}</div></div>
       <div className="exam-result-stats-row"><span className="exam-stat-pill success">درست: {toPersianDigits(attempt.correct_answers??0)}</span><span className="exam-stat-pill error">نادرست: {toPersianDigits(attempt.incorrect_answers??0)}</span><span className="exam-stat-pill warning">نزده: {toPersianDigits(attempt.unanswered_count??0)}</span><span className="exam-stat-pill info">کل: {toPersianDigits(attempt.total_questions??0)}</span></div>
       <Link className="button secondary" href={`/dashboard/exam_designer/${id}/attempts/${attempt.attempt_id}`}>مشاهدهٔ پاسخنامه و انتخاب هر سؤال</Link>
     </article>)}</div> : <p>هنوز کسی پاسخ آزمون را ثبت نکرده است.</p>}
   {!attemptsError && (attemptPage>1 || (attemptCount??0)>attemptOffset+50) && <nav className="exam-actions" aria-label="صفحه‌های شرکت‌کنندگان">{attemptPage>1&&<Link className="button secondary" href={`/dashboard/exam_designer/${id}?page=${attemptPage-1}#designer-attempts-title`}>صفحهٔ قبل</Link>}{(attemptCount??0)>attemptOffset+50&&<Link className="button secondary" href={`/dashboard/exam_designer/${id}?page=${attemptPage+1}#designer-attempts-title`}>صفحهٔ بعد</Link>}</nav>}
 </section></DashboardShell>;
}
