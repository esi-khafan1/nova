import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";

type Attempt = { attempt_id: string; student_name: string; score: number | null; correct_answers: number | null; total_questions: number | null; answer_pdf_url: string | null; submitted_at: string };

export default async function CounselorExamResultsPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data: exam }, { data: attemptsData }] = await Promise.all([
    supabase.from("exams").select("id,title,mode,audience,status,description").eq("id", id).eq("counselor_id", profile.id).single(),
    supabase.rpc("exam_attempts_for_counselor", { target_exam_id: id }),
  ]);
  if (!exam) notFound();
  const attempts = (attemptsData ?? []) as Attempt[];
  return <DashboardShell role="counselor" name={profile.full_name}>
    <section className="portal-heading"><div><span>نتایج آزمون</span><h1>{exam.title}</h1><p>{exam.description || "پاسخ‌های ثبت‌شده دانش‌آموزان"}</p></div><Link className="button secondary" href="/dashboard/counselor/exams">بازگشت به آزمون‌ها</Link></section>
    <section className="portal-card exam-results"><div className="portal-card-title"><div><span>شرکت‌کنندگان</span><h2>پاسخ‌های دریافت‌شده</h2></div><strong>{attempts.length.toLocaleString("fa-IR")} نفر</strong></div>
      {attempts.length ? <div className="exam-result-list">{attempts.map((attempt) => <article key={attempt.attempt_id}><div><strong>{attempt.student_name || "دانش‌آموز نووا"}</strong><span>{new Intl.DateTimeFormat("fa-IR", { dateStyle: "medium", timeStyle: "short", timeZone: "Asia/Tehran" }).format(new Date(attempt.submitted_at))}</span></div>{exam.mode === "multiple_choice" ? <strong>{(attempt.score ?? 0).toLocaleString("fa-IR")}% · {(attempt.correct_answers ?? 0).toLocaleString("fa-IR")} از {(attempt.total_questions ?? 0).toLocaleString("fa-IR")}</strong> : attempt.answer_pdf_url ? <a className="button secondary" href={attempt.answer_pdf_url} target="_blank" rel="noreferrer">دریافت پاسخ PDF</a> : null}</article>)}</div> : <p className="portal-empty">هنوز پاسخی ثبت نشده است.</p>}
    </section>
  </DashboardShell>;
}
