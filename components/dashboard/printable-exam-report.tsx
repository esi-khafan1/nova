import Link from "next/link";
import Image from "next/image";
import { ExamSubjectProgress, type SubjectHistoryRow } from "@/components/dashboard/exam-subject-progress";
import { notFound } from "next/navigation";
import { PrintButton } from "@/components/dashboard/print-button";
import { requireProfile } from "@/lib/auth";
import { calculateBookletResults,formatExamDuration,formatExamSchedule,type ExamBooklet } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";
import "@/app/dashboard/counselor/exams/[id]/report/[attemptId]/report.css";

type Attempt={attempt_id:string;student_id:string;student_name:string;score:number|null;correct_answers:number|null;incorrect_answers:number|null;unanswered_count:number|null;total_questions:number|null;answers:Record<string,number>|null;submitted_at:string};
const percent=(value:number)=>`${toPersianDigits(value.toLocaleString("fa-IR",{maximumFractionDigits:2}))}٪`;
const submittedAtFormatter=new Intl.DateTimeFormat("fa-IR",{dateStyle:"medium",timeStyle:"short",timeZone:"Asia/Tehran"});

export async function PrintableExamReport({params,viewer="counselor"}:{params:Promise<{id:string;attemptId:string}>;viewer?:"counselor"|"student"}){
 const {id,attemptId}=await params;const {supabase,profile}=await requireProfile([viewer]);
 const [{data:exam},{data:attemptsData}]=await Promise.all([supabase.from("exams").select("id,title,description,starts_at,duration_minutes,exam_booklets(id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order,subject_ranges)").eq("id",id).single(),viewer==="student"?supabase.from("exam_attempts").select("*").eq("exam_id",id).eq("student_id",profile.id):supabase.rpc("exam_attempts_for_counselor",{target_exam_id:id})]);
 const attempt=((attemptsData??[]).map((a: {attempt_id?:string;id?:string;student_name?:string})=>({...a,attempt_id:a.attempt_id??a.id,student_name:a.student_name??profile.full_name})) as Attempt[]).find(item=>item.attempt_id===attemptId);if(!exam||!attempt)notFound();
 const {data:reviewBooklets,error:bookletError}=await supabase.rpc(viewer==="student"?"exam_booklets_for_student_report":"exam_booklets_for_counselor",{target_exam_id:id});if(bookletError){if(viewer==="student")notFound();throw new Error("Exam booklet review unavailable");}
 const {data:historyData,error:historyError}=await supabase.rpc("student_exam_subject_progress",{target_student_id:attempt.student_id,target_exam_id:id,target_limit:6});

 const booklets=((reviewBooklets??[]) as ExamBooklet[]).sort((a,b)=>a.sort_order-b.sort_order);const rows=calculateBookletResults(booklets,attempt.answers);const total=attempt.total_questions??rows.reduce((sum,row)=>sum+row.total,0);
 const correct=rows.reduce((n,row)=>n+row.correct,0),incorrect=rows.reduce((n,row)=>n+row.incorrect,0),unanswered=rows.reduce((n,row)=>n+row.unanswered,0);const overall=total?Math.round((correct*3-incorrect)*10000/(total*3))/100:0;
 return <main className="exam-report-page" dir="rtl"><div className="exam-report-toolbar"><Link className="button secondary" href={viewer==="student"?`/dashboard/student/exams/${id}/review`:`/dashboard/counselor/exams?student=${encodeURIComponent(attempt.student_id)}`}>بازگشت به آزمون</Link><PrintButton/></div><article className="exam-report-sheet">
 <header className="exam-report-header"><div className="exam-report-brand"><Image src="/nova/mark.svg" alt="لوگوی نووا" width={58} height={58} unoptimized /><small>مسیر روشن موفقیت تحصیلی</small></div><div className="exam-report-heading"><span>کارنامه آزمون</span><h1>{exam.title}</h1></div><div className="exam-report-student"><span>دانش‌آموز</span><strong>{attempt.student_name||"دانش‌آموز نووا"}</strong></div></header>
 <section className="exam-report-meta"><div><span>تاریخ و زمان شروع</span><strong>{formatExamSchedule(exam.starts_at)}</strong></div><div><span>زمان ثبت پاسخ‌ها</span><strong>{submittedAtFormatter.format(new Date(attempt.submitted_at))}</strong></div><div><span>مدت کل آزمون</span><strong>{formatExamDuration(exam.duration_minutes)}</strong></div><div><span>تعداد کل سؤالات</span><strong>{toPersianDigits(total)}</strong></div></section>
 <section className="exam-report-summary"><div className="correct"><span>پاسخ درست</span><strong>{toPersianDigits(correct)}</strong></div><div className="wrong"><span>پاسخ غلط</span><strong>{toPersianDigits(incorrect)}</strong></div><div className="blank"><span>نزده</span><strong>{toPersianDigits(unanswered)}</strong></div><div className="score"><span>درصد کل</span><strong>{percent(overall)}</strong></div></section>
 <section className="exam-report-content"><div className="exam-report-analysis"><h2>تحلیل دروس</h2><table className="exam-report-table"><thead><tr><th>درس</th><th>سؤال</th><th>درست</th><th>غلط</th><th>نزده</th><th>درصد</th></tr></thead><tbody>{rows.map(row=><tr key={row.title}><th>{row.title}</th><td>{toPersianDigits(row.total)}</td><td>{toPersianDigits(row.correct)}</td><td>{toPersianDigits(row.incorrect)}</td><td>{toPersianDigits(row.unanswered)}</td><td>{percent(row.percentage)}</td></tr>)}<tr className="total-row"><th>جمع کل</th><td>{toPersianDigits(total)}</td><td>{toPersianDigits(correct)}</td><td>{toPersianDigits(incorrect)}</td><td>{toPersianDigits(unanswered)}</td><td>{percent(overall)}</td></tr></tbody></table></div>
 <ExamSubjectProgress rows={(historyData??[]) as SubjectHistoryRow[]} unavailable={Boolean(historyError)} />
 </section><footer className="exam-report-footer"><span>نووا · مسیر روشن موفقیت تحصیلی</span><span>{viewer==="counselor"?`مشاور: ${profile.full_name||"مشاور نووا"}`:"نسخهٔ دانش‌آموز"}</span></footer></article></main>;
}
