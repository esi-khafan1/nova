import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { formatExamDuration, formatExamSchedule, getExamTimeState } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";

type StudentExam = {
  id: string;
  title: string;
  description: string | null;
  mode: string;
  audience: string;
  starts_at: string;
  duration_minutes: number;
  created_at: string;
  exam_booklets?: { id: string; question_count: number }[];
};

type Attempt = {
  exam_id: string;
  score: number | null;
  correct_answers: number | null;
  total_questions: number | null;
  submitted_at: string;
};

export default async function StudentExamsPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["student"]);
  const params = await searchParams;

  const [{ data: assignment }, { data: examsData }, { data: attemptsData }] =
    await Promise.all([
      supabase
        .from("counselor_students")
        .select("id")
        .eq("student_id", profile.id)
        .limit(1),
      supabase
        .from("exams")
        .select(
          "id,title,description,mode,audience,starts_at,duration_minutes,created_at,exam_booklets(id,question_count)",
        )
        .eq("status", "published")
        .order("starts_at", { ascending: true }),
      supabase
        .from("exam_attempts")
        .select("exam_id,score,correct_answers,total_questions,submitted_at")
        .eq("student_id", profile.id),
    ]);

  const hasCounselor = Boolean(assignment?.length);
  const exams = (examsData ?? []) as StudentExam[];
  const attempts = new Map(
    ((attemptsData ?? []) as Attempt[]).map((attempt) => [
      attempt.exam_id,
      attempt,
    ]),
  );

  return (
    <DashboardShell role="student" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>آزمون‌های من</span>
          <h1>آزمون‌های کنکوری قابل شرکت</h1>
          <p>فقط آزمون‌هایی را می‌بینی که مشاور برای تو منتشر کرده است.</p>
        </div>
      </section>

      {params.error && (
        <div className="portal-alert error">آزمون در دسترس نیست.</div>
      )}

      {!hasCounselor ? (
        <section className="portal-card exam-gate">
          <h2>برای شرکت در آزمون به مشاور نیاز داری</h2>
          <p>بعد از انتخاب مشاور، آزمون‌های مجاز اینجا نمایش داده می‌شوند.</p>
          <Link className="button" href="/dashboard/apply-counselor">
            درخواست مشاور
          </Link>
        </section>
      ) : (
        <section className="exam-student-grid">
          {exams.length ? (
            exams.map((exam) => {
              const attempt = attempts.get(exam.id);
              const timeState = getExamTimeState(
                exam.starts_at,
                exam.duration_minutes,
              );
              const bookletCount = exam.exam_booklets?.length ?? 0;
              const totalQuestions =
                exam.exam_booklets?.reduce(
                  (acc, b) => acc + (b.question_count || 0),
                  0,
                ) ?? 0;

              return (
                <article
                  className="portal-card exam-student-card"
                  key={exam.id}
                >
                  <span className="exam-card-type-tag">آزمون دفترچه‌ای کنکوری</span>
                  <h2>{exam.title}</h2>
                  <p>{exam.description || "آماده‌ای؟ دفترچه‌ها را مرحله‌به‌مرحله پاسخ بده."}</p>
                  <div className="exam-card-specs">
                    <span>
                      {bookletCount > 0 ? `${toPersianDigits(bookletCount)} دفترچه` : "کنکوری"}
                      {totalQuestions > 0 ? ` · ${toPersianDigits(totalQuestions)} سؤال` : ""}
                    </span>
                  </div>
                  <p className="exam-schedule">
                    شروع: {formatExamSchedule(exam.starts_at)}
                    <br />
                    مدت: {formatExamDuration(exam.duration_minutes)}
                  </p>

                  {attempt ? (
                    <div className="exam-completed">
                      <strong>آزمون داده شد ✅</strong>
                      {attempt.score !== null && (
                        <span>
                          درصد کنکوری: {toPersianDigits(attempt.score)}٪
                        </span>
                      )}
                    </div>
                  ) : timeState === "active" ? (
                    <Link
                      className="button"
                      href={`/dashboard/student/exams/${exam.id}`}
                    >
                      ورود به آزمون و شروع
                    </Link>
                  ) : timeState === "upcoming" ? (
                    <div className="exam-time-notice">
                      آزمون هنوز شروع نشده است.
                    </div>
                  ) : (
                    <div className="exam-time-notice ended">
                      مهلت شرکت در آزمون تمام شده است.
                    </div>
                  )}
                </article>
              );
            })
          ) : (
            <section className="portal-card portal-empty">
              فعلاً آزمونی برای تو منتشر نشده است.
            </section>
          )}
        </section>
      )}
    </DashboardShell>
  );
}

