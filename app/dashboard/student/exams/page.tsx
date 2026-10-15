import Link from "next/link";
import { getFloatingExamEntryState, type FloatingExamSession } from "@/lib/floating-exams";
import { StudentServiceNotice } from "@/components/dashboard/student-service-notice";
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
  start_window_ends_at: string | null;
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
  const { supabase, profile } = await requireProfile(["student"], true);
  const params = await searchParams;
  if (profile.registration_status !== "active") return <DashboardShell role="student" name={profile.full_name}><section className="portal-heading"><div><span>آزمون‌های من</span><h1>آزمون‌های کنکوری</h1><p>آزمون‌های اختصاصی پس از فعال‌شدن خدمات و تخصیص طراح آزمون در این بخش نمایش داده می‌شوند.</p></div></section><StudentServiceNotice status={profile.registration_status}/></DashboardShell>;


  const [{ data: examsData }, { data: attemptsData }, {data:sessionsData}] =
    await Promise.all([
      supabase
        .from("exams")
        .select(
          "id,title,description,mode,audience,starts_at,start_window_ends_at,duration_minutes,created_at,exam_booklets(id,question_count)",
        )
        .eq("status", "published")
        .order("starts_at", { ascending: true }),
      supabase
        .from("exam_attempts")
        .select("exam_id,score,correct_answers,total_questions,submitted_at")
        .eq("student_id", profile.id),
      supabase.from("exam_sessions").select("exam_id,expires_at").eq("student_id",profile.id),
    ]);

  const sessions = new Map(((sessionsData ?? []) as Pick<FloatingExamSession,"exam_id"|"expires_at">[]).map(session=>[session.exam_id,session]));
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
          <p>آزمون‌هایی که برای تو انتخاب و منتشر شده‌اند اینجا نمایش داده می‌شوند.</p>
        </div>
      </section>

      {params.error && (
        <div className="portal-alert error">آزمون در دسترس نیست.</div>
      )}

        <section className="exam-student-grid">
          {exams.length ? (
            exams.map((exam) => {
              const attempt = attempts.get(exam.id);
              const timeState = getExamTimeState(
                exam.starts_at,
                exam.duration_minutes,new Date(),exam.start_window_ends_at,
              );
              const floatingEntry=exam.start_window_ends_at ? getFloatingExamEntryState(exam.starts_at,exam.start_window_ends_at,sessions.get(exam.id)) : null;
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
                    {exam.start_window_ends_at && <><br/>مهلت شروع تا: {formatExamSchedule(exam.start_window_ends_at)}</>}
                  </p>

                  {attempt ? (
                    <div className="exam-completed">
                      <strong>آزمون داده شد ✅</strong>
                      <Link className="button secondary" href={`/dashboard/student/exams/${exam.id}#exam-review`}>{timeState === "ended" ? "بررسی دفترچه و پاسخ‌برگ" : "مشاهدهٔ وضعیت ثبت آزمون"}</Link>
                      {timeState === "ended" && attempt.score !== null && (
                        <span>
                          درصد کنکوری: {toPersianDigits(attempt.score)}٪
                        </span>
                      )}
                    </div>
                  ) : exam.start_window_ends_at ? (
                    floatingEntry === "startable" || floatingEntry === "resumable" || floatingEntry === "expired"
                      ? <Link className="button" href={`/dashboard/student/exams/${exam.id}`}>{floatingEntry === "resumable" ? "ادامهٔ آزمون" : floatingEntry === "expired" ? "ثبت پاسخ‌های ذخیره‌شده" : "مشاهده و شروع آزمون"}</Link>
                      : <div className="exam-time-notice">{floatingEntry === "upcoming" ? "بازهٔ شروع هنوز باز نشده است." : "مهلت شروع آزمون تمام شده است."}</div>
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
    </DashboardShell>
  );
}

