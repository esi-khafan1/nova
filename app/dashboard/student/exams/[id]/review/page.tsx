import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentExamReview } from "@/components/dashboard/student-exam-review";
import { requireProfile } from "@/lib/auth";
import type { ExamReviewQuestion } from "@/lib/exam-review";
import { toPersianDigits } from "@/lib/persian-date";

export default async function StudentExamAnswerSheet({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const { supabase, profile } = await requireProfile(["student"], true);
  // An attempt is the only release gate. Never trust query params or the client
  // to decide whether answer keys and explanatory PDFs can be displayed.
  const { data: attempt } = await supabase.from("exam_attempts")
    .select("score,correct_answers,incorrect_answers,unanswered_count,total_questions,submitted_at")
    .eq("exam_id", id).eq("student_id", profile.id).not("submitted_at", "is", null).maybeSingle();
  if (!attempt) notFound();
  const [{ data: exam }, { data: review, error }] = await Promise.all([
    supabase.from("exams").select("id,title,mode").eq("id", id).eq("status", "published").single(),
    supabase.rpc("student_exam_review", { target_exam_id: id }),
  ]);
  if (!exam || exam.mode !== "booklet") notFound();
  return <DashboardShell role="student" name={profile.full_name}>
    <section className="portal-heading"><div><span>پاسخنامهٔ آزمون</span><h1>{exam.title}</h1><p>پاسخ‌های ثبت‌شدهٔ تو و گزینه‌های درست؛ این پاسخنامه همیشه از «آزمون‌های من» در دسترس است.</p></div><Link className="button secondary" href="/dashboard/student/exams">بازگشت به آزمون‌های من</Link></section>
    <section className="portal-card exam-submitted"><h2>آزمون با موفقیت ثبت شد ✅</h2><div className="exam-result-summary"><div className="exam-result-score-box"><span>درصد نهایی (با نمره منفی)</span><strong>{attempt.score === null ? "—" : `${toPersianDigits(attempt.score)}٪`}</strong></div><div className="exam-result-breakdown-grid"><div className="exam-stat-pill success"><span>درست:</span><strong>{toPersianDigits(attempt.correct_answers ?? 0)}</strong></div><div className="exam-stat-pill error"><span>نادرست:</span><strong>{toPersianDigits(attempt.incorrect_answers ?? 0)}</strong></div><div className="exam-stat-pill warning"><span>نزده:</span><strong>{toPersianDigits(attempt.unanswered_count ?? 0)}</strong></div><div className="exam-stat-pill info"><span>کل:</span><strong>{toPersianDigits(attempt.total_questions ?? 0)}</strong></div></div></div><Link className="button secondary" href={`/dashboard/student/exams/${id}/report`}>مشاهده و چاپ کارنامه</Link></section>
    {error ? <div className="portal-alert error" role="alert">دریافت پاسخنامه انجام نشد؛ پاسخ‌های ثبت‌شده محفوظ‌اند. دوباره صفحه را باز کن.</div>
      : Array.isArray(review) && review.length > 0 ? <StudentExamReview questions={review as ExamReviewQuestion[]} />
      : <p className="portal-card">برای این آزمون سؤال قابل بررسی وجود ندارد.</p>}
  </DashboardShell>;
}
