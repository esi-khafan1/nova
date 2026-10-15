import Link from "next/link";
import {notFound} from "next/navigation";
import {requireProfile} from "@/lib/auth";
import {DashboardShell} from "@/components/dashboard/dashboard-shell";
import {ExamBuilder} from "@/components/dashboard/exam-builder";
import type {ExamBooklet} from "@/lib/exams";
import type {StudyField} from "@/lib/study-catalog";
export default async function EditDesignerExam({params}:{params:Promise<{id:string}>}) {
 const {id}=await params;const {supabase,profile}=await requireProfile(["exam_designer"]);
 const {data:exam}=await supabase.from("exams").select("id,title,description,exam_field,starts_at,start_window_ends_at").eq("id",id).eq("counselor_id",profile.id).single();if(!exam)notFound();
 const {data:payload,error}=await supabase.rpc("designer_exam_details",{target_exam_id:id});if(error||!payload)throw new Error("Exam details unavailable");
 const dateTime=(stamp:string)=>new Intl.DateTimeFormat("sv-SE",{timeZone:"Asia/Tehran",year:"numeric",month:"2-digit",day:"2-digit",hour:"2-digit",minute:"2-digit",hour12:false}).format(new Date(stamp));
 const start=dateTime(exam.starts_at);
 return <DashboardShell role="exam_designer" name={profile.full_name}><section className="portal-heading"><h1>{exam.title}</h1><Link className="button secondary" href="/dashboard/exam_designer">بازگشت</Link></section>{payload.locked?<section className="portal-card"><h2>آزمون قفل شده است</h2><p>آزمونی که شروع شده یا پاسخ ثبت‌شده دارد قابل تغییر نیست؛ برای حفظ پاسخ‌ها و کارنامه‌ها آزمون جدید بساز.</p></section>:<ExamBuilder initial={{id:exam.id,title:exam.title,description:exam.description,examField:(exam.exam_field??"") as StudyField|"",scheduledDate:start.slice(0,10),scheduledTime:start.slice(11,16),windowEndTime:exam.start_window_ends_at?dateTime(exam.start_window_ends_at).slice(11,16):null,students:payload.students??[],booklets:(payload.booklets as ExamBooklet[]).map(b=>({id:b.id,title:b.title,pdfUrl:b.pdf_url,questionCount:b.question_count,durationMinutes:b.duration_minutes,keyAnswers:b.key_answers??{}}))}}/>}</DashboardShell>;
}
