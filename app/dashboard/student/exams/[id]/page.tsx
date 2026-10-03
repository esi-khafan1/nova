import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentExamForm } from "@/components/dashboard/student-exam-form";
import { requireProfile } from "@/lib/auth";
import { examEndsAt, formatExamDuration, formatExamSchedule, getExamTimeState } from "@/lib/exams";

type Question = { id: string; prompt: string; options: string[]; sort_order: number };

export default async function StudentExamPage({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<Record<string, string | undefined>> }) {
  const { id } = await params;
  const query = await searchParams;
  const { supabase, profile } = await requireProfile(["student"]);
  const [{ data: exam }, { data: attempt }] = await Promise.all([
    supabase.from("exams").select("id,title,description,mode,question_pdf_url,starts_at,duration_minutes,exam_questions(id,prompt,options,sort_order)").eq("id", id).eq("status", "published").single(),
    supabase.from("exam_attempts").select("score,correct_answers,total_questions,answer_pdf_url,submitted_at").eq("exam_id", id).eq("student_id", profile.id).maybeSingle(),
  ]);
  if (!exam) notFound();
  const questions = ((exam.exam_questions ?? []) as Question[]).sort((a, b) => a.sort_order - b.sort_order);
  const timeState = getExamTimeState(exam.starts_at, exam.duration_minutes);
  const endsAt = examEndsAt(exam.starts_at, exam.duration_minutes).toISOString();
  return <DashboardShell role="student" name={profile.full_name}>
    <section className="portal-heading"><div><span>{exam.mode === "multiple_choice" ? "آزمون تستی" : "آزمون PDF"}</span><h1>{exam.title}</h1><p>{exam.description || "پاسخ‌ها را با دقت ثبت کن؛ هر آزمون فقط یک‌بار قابل ارسال است."}</p><p className="exam-schedule">شروع: {formatExamSchedule(exam.starts_at)} · مدت: {formatExamDuration(exam.duration_minutes)}</p></div><Link className="button secondary" href="/dashboard/student/exams">بازگشت</Link></section>
    {query.error && <div className="portal-alert error">ارسال انجام نشد. پاسخ‌ها یا فایل PDF را بررسی کن.</div>}
    {attempt ? <section className="portal-card exam-submitted"><h2>پاسخ تو ثبت شده است</h2>{attempt.score !== null ? <p>درصد پاسخ صحیح: <strong>{attempt.score.toLocaleString("fa-IR")}%</strong> — {attempt.correct_answers?.toLocaleString("fa-IR")} پاسخ درست از {attempt.total_questions?.toLocaleString("fa-IR")}</p> : <p>فایل پاسخ برای بررسی مشاور ارسال شد.</p>}</section> : timeState === "upcoming" ? <section className="portal-card exam-gate"><h2>آزمون هنوز شروع نشده است</h2><p>در زمان اعلام‌شده به همین صفحه برگرد.</p></section> : timeState === "ended" ? <section className="portal-card exam-gate"><h2>مهلت آزمون تمام شده است</h2><p>دیگر امکان شروع یا ثبت پاسخ وجود ندارد.</p></section> : <section className="portal-card"><StudentExamForm examId={exam.id} mode={exam.mode} pdfUrl={exam.question_pdf_url} questions={questions} endsAt={endsAt} /></section>}
  </DashboardShell>;
}
