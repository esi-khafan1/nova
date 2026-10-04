import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { formatExamDuration, formatExamSchedule, type ExamBooklet } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";

type Attempt = {
  attempt_id: string;
  student_id: string;
  student_name: string;
  score: number | null;
  correct_answers: number | null;
  incorrect_answers: number | null;
  unanswered_count: number | null;
  total_questions: number | null;
  answers: Record<string, number> | null;
  answer_pdf_url: string | null;
  submitted_at: string;
};

export default async function CounselorExamResultsPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const { supabase, profile } = await requireProfile(["counselor"]);

  const [{ data: exam }, { data: attemptsData }] = await Promise.all([
    supabase
      .from("exams")
      .select(
        "id,title,mode,audience,status,description,starts_at,duration_minutes,exam_booklets(id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order,key_answers)",
      )
      .eq("id", id)
      .eq("counselor_id", profile.id)
      .single(),
    supabase.rpc("exam_attempts_for_counselor", { target_exam_id: id }),
  ]);

  if (!exam) notFound();

  const booklets = ((exam.exam_booklets ?? []) as ExamBooklet[]).sort(
    (a, b) => a.sort_order - b.sort_order,
  );
  const attempts = (attemptsData ?? []) as Attempt[];

  const totalQuestions = booklets.reduce(
    (acc, b) => acc + (b.question_count || 0),
    0,
  );

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>کارنامه و نتایج آزمون کنکوری</span>
          <h1>{exam.title}</h1>
          <p>{exam.description || "پاسخ‌ها و کارنامه داوطلبان شرکت‌کننده"}</p>
          <p className="exam-schedule">
            شروع: {formatExamSchedule(exam.starts_at)} · مدت کل:{" "}
            {formatExamDuration(exam.duration_minutes)}
            {booklets.length > 0 &&
              ` (${toPersianDigits(booklets.length)} دفترچه · ${toPersianDigits(totalQuestions)} سؤال)`}
          </p>
        </div>
        <Link className="button secondary" href="/dashboard/counselor/exams">
          بازگشت به آزمون‌ها
        </Link>
      </section>

      {/* Booklets Overview */}
      {booklets.length > 0 && (
        <section className="portal-card exam-booklets-overview">
          <div className="portal-card-title">
            <div>
              <span>دفترچه‌های این آزمون</span>
              <h2>اطلاعات دفترچه‌ها</h2>
            </div>
          </div>
          <div className="exam-booklets-summary-grid">
            {booklets.map((b, i) => (
              <div key={b.id} className="exam-booklet-summary-pill">
                <strong>دفترچه {toPersianDigits(i + 1)}: {b.title}</strong>
                <span>
                  سؤالات {toPersianDigits(b.start_question_number)} تا{" "}
                  {toPersianDigits(b.end_question_number)} ({toPersianDigits(b.question_count)} سؤال) ·{" "}
                  {toPersianDigits(b.duration_minutes)} دقیقه
                </span>
                {b.pdf_url && (
                  <a
                    href={b.pdf_url}
                    target="_blank"
                    rel="noreferrer"
                    className="exam-pdf-link"
                  >
                    مشاهده فایل PDF سؤالات
                  </a>
                )}
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Results List */}
      <section className="portal-card exam-results">
        <div className="portal-card-title">
          <div>
            <span>شرکت‌کنندگان</span>
            <h2>پاسخ‌ها و درصدهای کسب‌شده</h2>
          </div>
          <strong>{toPersianDigits(attempts.length)} داوطلب</strong>
        </div>

        {attempts.length ? (
          <div className="exam-result-list">
            {attempts.map((attempt) => (
              <article key={attempt.attempt_id} className="exam-result-card">
                <div className="exam-result-header">
                  <div>
                    <strong>{attempt.student_name || "دانش‌آموز نووا"}</strong>
                    <span>
                      {new Intl.DateTimeFormat("fa-IR", {
                        dateStyle: "medium",
                        timeStyle: "short",
                        timeZone: "Asia/Tehran",
                      }).format(new Date(attempt.submitted_at))}
                    </span>
                  </div>

                  <div className="exam-result-score-tag">
                    <span>درصد کنکوری:</span>
                    <strong>{toPersianDigits(attempt.score ?? 0)}٪</strong>
                  </div>
                </div>

                <div className="exam-result-stats-row">
                  <span className="exam-stat-pill success">
                    درست: {toPersianDigits(attempt.correct_answers ?? 0)}
                  </span>
                  <span className="exam-stat-pill error">
                    نادرست: {toPersianDigits(attempt.incorrect_answers ?? 0)}
                  </span>
                  <span className="exam-stat-pill warning">
                    نزده: {toPersianDigits(attempt.unanswered_count ?? 0)}
                  </span>
                  <span className="exam-stat-pill info">
                    کل: {toPersianDigits(attempt.total_questions ?? totalQuestions)}
                  </span>
                </div>

                {/* Question by question mini breakdown */}
                {attempt.answers && (
                  <details className="exam-student-answers-details">
                    <summary>مشاهده پاسخ‌های تستی داوطلب</summary>
                    <div className="exam-student-answers-grid">
                      {booklets.flatMap((b) =>
                        Array.from(
                          {
                            length:
                              b.end_question_number -
                              b.start_question_number +
                              1,
                          },
                          (_, idx) => {
                            const q = b.start_question_number + idx;
                            const studentAns = attempt.answers?.[String(q)];
                            const keyAns = b.key_answers?.[String(q)];
                            const isCorrect =
                              studentAns && keyAns && studentAns === keyAns;
                            const isIncorrect =
                              studentAns && keyAns && studentAns !== keyAns;

                            return (
                              <div
                                key={q}
                                className={`exam-answer-chip ${isCorrect ? "correct" : isIncorrect ? "wrong" : "blank"}`}
                                title={`سؤال ${q} | انتخاب دانش‌آموز: ${studentAns || "نزده"} | کلید: ${keyAns || "نامشخص"}`}
                              >
                                <span className="chip-num">{toPersianDigits(q)}</span>
                                <span className="chip-val">
                                  {studentAns ? toPersianDigits(studentAns) : "—"}
                                </span>
                              </div>
                            );
                          },
                        ),
                      )}
                    </div>
                  </details>
                )}
              </article>
            ))}
          </div>
        ) : (
          <p className="portal-empty">هنوز داوطلبی در این آزمون شرکت نکرده است.</p>
        )}
      </section>
    </DashboardShell>
  );
}

