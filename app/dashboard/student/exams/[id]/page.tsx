import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentExamForm } from "@/components/dashboard/student-exam-form";
import { requireProfile } from "@/lib/auth";
import {
  formatExamDuration,
  formatExamSchedule,
  getExamTimeState,
  type ExamBooklet,
} from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";

export default async function StudentExamPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { id } = await params;
  const query = await searchParams;
  const { supabase, profile } = await requireProfile(["student"]);

  const [{ data: exam }, { data: attempt }] = await Promise.all([
    supabase
      .from("exams")
      .select(
        "id,title,description,mode,starts_at,duration_minutes,exam_booklets(id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order)",
      )
      .eq("id", id)
      .eq("status", "published")
      .single(),
    supabase
      .from("exam_attempts")
      .select(
        "score,correct_answers,incorrect_answers,unanswered_count,total_questions,answers,submitted_at",
      )
      .eq("exam_id", id)
      .eq("student_id", profile.id)
      .maybeSingle(),
  ]);

  if (!exam) notFound();

  const booklets = ((exam.exam_booklets ?? []) as ExamBooklet[]).sort(
    (a, b) => a.sort_order - b.sort_order,
  );
  const timeState = getExamTimeState(exam.starts_at, exam.duration_minutes);

  return (
    <DashboardShell role="student" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>آزمون دفترچه‌ای کنکوری</span>
          <h1>{exam.title}</h1>
          <p>{exam.description || "پاسخ‌ها را با دقت ثبت کن؛ هر آزمون فقط یک‌بار قابل ارسال است."}</p>
          <p className="exam-schedule">
            شروع: {formatExamSchedule(exam.starts_at)} · مدت کل: {formatExamDuration(exam.duration_minutes)}
            {booklets.length > 0 && ` (${toPersianDigits(booklets.length)} دفترچه)`}
          </p>
        </div>
        <Link className="button secondary" href="/dashboard/student/exams">
          بازگشت
        </Link>
      </section>

      {query.error && (
        <div className="portal-alert error">ارسال پاسخ‌ها انجام نشد. لطفاً مجدداً امتحان کنید.</div>
      )}

      {attempt ? (
        <section className="portal-card exam-submitted">
          <h2>پاسخ‌های شما با موفقیت ثبت شده است ✅</h2>
          {attempt.score !== null ? (
            <div className="exam-result-summary">
              <div className="exam-result-score-box">
                <span>درصد نهایی (با نمره منفی)</span>
                <strong>{toPersianDigits(attempt.score)}٪</strong>
              </div>

              <div className="exam-result-breakdown-grid">
                <div className="exam-stat-pill success">
                  <span>پاسخ‌های صحیح:</span>
                  <strong>{toPersianDigits(attempt.correct_answers ?? 0)}</strong>
                </div>
                <div className="exam-stat-pill error">
                  <span>پاسخ‌های نادرست:</span>
                  <strong>{toPersianDigits(attempt.incorrect_answers ?? 0)}</strong>
                </div>
                <div className="exam-stat-pill warning">
                  <span>بدون پاسخ:</span>
                  <strong>{toPersianDigits(attempt.unanswered_count ?? 0)}</strong>
                </div>
                <div className="exam-stat-pill info">
                  <span>کل سؤالات:</span>
                  <strong>{toPersianDigits(attempt.total_questions ?? 0)}</strong>
                </div>
              </div>
            </div>
          ) : (
            <p>پاسخ شما برای بررسی مشاور ثبت گردید.</p>
          )}
        </section>
      ) : timeState === "upcoming" ? (
        <section className="portal-card exam-gate">
          <h2>آزمون هنوز شروع نشده است</h2>
          <p>در زمان اعلام‌شده به همین صفحه برگرد تا دکمه شروع آزمون فعال شود.</p>
        </section>
      ) : timeState === "ended" ? (
        <section className="portal-card exam-gate">
          <h2>مهلت آزمون تمام شده است</h2>
          <p>دیگر امکان شروع یا ثبت پاسخ برای این آزمون وجود ندارد.</p>
        </section>
      ) : (
        <StudentExamForm
          examId={exam.id}
          examTitle={exam.title}
          booklets={booklets}
          studentName={profile.full_name}
        />
      )}
    </DashboardShell>
  );
}

