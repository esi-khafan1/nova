import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentExamReview } from "@/components/dashboard/student-exam-review";
import { requireProfile } from "@/lib/auth";
import type { ExamReviewQuestion } from "@/lib/exam-review";
import { toPersianDigits } from "@/lib/persian-date";

type Attempt = { attempt_id: string; student_name: string; score: number | null; correct_answers: number | null; incorrect_answers: number | null; unanswered_count: number | null; total_questions: number | null };

export default async function DesignerAttemptPage({ params }: { params: Promise<{ id: string; attemptId: string }> }) {
  const { id, attemptId } = await params;
  const { supabase, profile } = await requireProfile(["exam_designer"]);
  const [{ data: exam }, { data: attempt, error: attemptError }, { data: review, error: reviewError }] = await Promise.all([
    supabase.from("exams").select("id,title,mode").eq("id", id).eq("counselor_id", profile.id).single(),
    supabase.rpc("designer_exam_attempts", { target_exam_id: id }).eq("attempt_id", attemptId).maybeSingle(),
    supabase.rpc("designer_exam_attempt_review", { target_exam_id: id, target_attempt_id: attemptId }),
  ]);
  if (!exam || exam.mode !== "booklet" || attemptError || reviewError || !attempt || !Array.isArray(review)) notFound();
  const result = attempt as Attempt;

  return <DashboardShell role="exam_designer" name={profile.full_name}>
    <section className="portal-heading"><div><span>پاسخنامهٔ شرکت‌کننده</span><h1>{exam.title} · {result.student_name}</h1><p>انتخاب هر سؤال، گزینهٔ صحیح و PDF دفترچه‌ها؛ فقط برای طراح این آزمون قابل مشاهده است.</p></div><Link className="button secondary" href={`/dashboard/exam_designer/${id}`}>بازگشت به شرکت‌کنندگان</Link></section>
    <section className="portal-card exam-submitted"><h2>نتیجهٔ {result.student_name}</h2><div className="exam-result-summary"><div className="exam-result-score-box"><span>درصد نهایی (با نمره منفی)</span><strong>{result.score === null ? "—" : `${toPersianDigits(result.score)}٪`}</strong></div><div className="exam-result-breakdown-grid"><div className="exam-stat-pill success"><span>درست:</span><strong>{toPersianDigits(result.correct_answers ?? 0)}</strong></div><div className="exam-stat-pill error"><span>نادرست:</span><strong>{toPersianDigits(result.incorrect_answers ?? 0)}</strong></div><div className="exam-stat-pill warning"><span>نزده:</span><strong>{toPersianDigits(result.unanswered_count ?? 0)}</strong></div><div className="exam-stat-pill info"><span>کل:</span><strong>{toPersianDigits(result.total_questions ?? 0)}</strong></div></div></div></section>
    {review.length ? <StudentExamReview questions={review as ExamReviewQuestion[]} viewerName={result.student_name} /> : <p className="portal-card">برای این آزمون سؤال قابل بررسی وجود ندارد.</p>}
  </DashboardShell>;
}
