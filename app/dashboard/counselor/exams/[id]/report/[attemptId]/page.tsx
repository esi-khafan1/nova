import Link from "next/link";
import { notFound } from "next/navigation";
import { PrintButton } from "@/components/dashboard/print-button";
import { requireProfile } from "@/lib/auth";
import { calculateBookletResults, formatExamDuration, formatExamSchedule, type ExamBooklet } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";
import "./report.css";

type Attempt = { attempt_id: string; student_name: string; score: number | null; correct_answers: number | null; incorrect_answers: number | null; unanswered_count: number | null; total_questions: number | null; answers: Record<string, number> | null; submitted_at: string };
const percent = (value: number) => `${toPersianDigits(value.toLocaleString("fa-IR", { maximumFractionDigits: 2 }))}٪`;

export default async function PrintableExamReport({ params }: { params: Promise<{ id: string; attemptId: string }> }) {
  const { id, attemptId } = await params;
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data: exam }, { data: attemptsData }] = await Promise.all([
    supabase.from("exams").select("id,title,description,starts_at,duration_minutes,exam_booklets(id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order,key_answers)").eq("id", id).eq("counselor_id", profile.id).single(),
    supabase.rpc("exam_attempts_for_counselor", { target_exam_id: id }),
  ]);
  const attempt = ((attemptsData ?? []) as Attempt[]).find((item) => item.attempt_id === attemptId);
  if (!exam || !attempt) notFound();
  const booklets = ((exam.exam_booklets ?? []) as ExamBooklet[]).sort((a, b) => a.sort_order - b.sort_order);
  const rows = calculateBookletResults(booklets, attempt.answers);
  const total = attempt.total_questions ?? rows.reduce((sum, row) => sum + row.total, 0);
  return <main className="exam-report-page" dir="rtl">
    <div className="exam-report-toolbar"><Link className="button secondary" href={`/dashboard/counselor/exams/${id}`}>بازگشت به نتایج</Link><PrintButton /></div>
    <article className="exam-report-sheet">
      <header className="exam-report-header"><div className="exam-report-brand"><strong>Nova</strong><span>مؤسسه مشاوره</span></div><div><span>کارنامه آزمون</span><h1>{exam.title}</h1></div></header>
      <section className="exam-report-meta"><div><span>نام دانش‌آموز</span><strong>{attempt.student_name || "دانش‌آموز نووا"}</strong></div><div><span>تاریخ و زمان آزمون</span><strong>{formatExamSchedule(exam.starts_at)}</strong></div><div><span>مدت آزمون</span><strong>{formatExamDuration(exam.duration_minutes)}</strong></div><div><span>تعداد کل سؤالات</span><strong>{toPersianDigits(total)}</strong></div></section>
      <section className="exam-report-total"><div><span>درست</span><strong>{toPersianDigits(attempt.correct_answers ?? 0)}</strong></div><div><span>غلط</span><strong>{toPersianDigits(attempt.incorrect_answers ?? 0)}</strong></div><div><span>نزده</span><strong>{toPersianDigits(attempt.unanswered_count ?? 0)}</strong></div><div className="primary"><span>درصد کل</span><strong>{percent(attempt.score ?? 0)}</strong></div></section>
      <section className="exam-report-section"><h2>تحلیل دروس</h2><div className="exam-report-table-wrap"><table className="exam-report-table"><thead><tr><th>درس</th><th>تعداد سؤال</th><th>درست</th><th>غلط</th><th>نزده</th><th>درصد</th></tr></thead><tbody>{rows.map((row) => <tr key={row.title}><th>{row.title}</th><td>{toPersianDigits(row.total)}</td><td>{toPersianDigits(row.correct)}</td><td>{toPersianDigits(row.incorrect)}</td><td>{toPersianDigits(row.unanswered)}</td><td>{percent(row.percentage)}</td></tr>)}<tr className="total-row"><th>جمع کل</th><td>{toPersianDigits(total)}</td><td>{toPersianDigits(attempt.correct_answers ?? 0)}</td><td>{toPersianDigits(attempt.incorrect_answers ?? 0)}</td><td>{toPersianDigits(attempt.unanswered_count ?? 0)}</td><td>{percent(attempt.score ?? 0)}</td></tr></tbody></table></div></section>
      <section className="exam-report-section"><h2>نمودار عملکرد درسی</h2><div className="exam-report-chart">{rows.map((row) => { const width = Math.max(0, Math.min(100, (row.percentage + 10) / 1.1)); return <div className="exam-report-chart-row" key={row.title}><strong>{row.title}</strong><div className="exam-report-chart-track"><span style={{ width: `${width}%` }} /></div><b>{percent(row.percentage)}</b></div>; })}</div><div className="exam-report-chart-scale"><span>۱۰−</span><span>۰</span><span>۲۵</span><span>۵۰</span><span>۷۵</span><span>۱۰۰</span></div></section>
      <footer>کارنامه اختصاصی دانش‌آموز · Nova</footer>
    </article>
  </main>;
}
