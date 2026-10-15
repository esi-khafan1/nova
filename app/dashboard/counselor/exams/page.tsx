import Link from "next/link";
import { examSaveErrorMessage } from "@/lib/exam-save-errors";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";

import { requireProfile } from "@/lib/auth";
import { formatExamDuration, formatExamSchedule } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";

type CounselorExam = {
  id: string;
  title: string;
  description: string | null;
  mode: string;
  audience: "own_students" | "all_assigned_students";
  status: "draft" | "published" | "archived";
  starts_at: string;
  start_window_ends_at: string | null;
  duration_minutes: number;
  created_at: string;
  exam_booklets: { id: string; question_count: number }[];
  exam_attempts: { id: string }[];
};

export default async function CounselorExamsPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const params = await searchParams;

  const { data } = await supabase
    .from("exams")
    .select(
      "id,title,description,mode,audience,status,starts_at,start_window_ends_at,duration_minutes,created_at,exam_booklets(id,question_count),exam_attempts(id)",
    )
    .order("created_at", { ascending: false });

  const exams = (data ?? []) as CounselorExam[];

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>مرکز آزمون</span>
          <h1>آزمون‌های کنکوری دفترچه‌ای</h1>
          <p>
            نتایج و کارنامهٔ دانش‌آموزان خودت را ببین؛ طراحی و تخصیص آزمون در پنل طراح آزمون انجام می‌شود.
          </p>
        </div>
      </section>

      {params.saved && (
        <div className="portal-alert success">
          {params.saved === "published"
            ? "آزمون کنکوری با موفقیت منتشر شد."
            : "پیش‌نویس آزمون ذخیره شد."}
        </div>
      )}

      {params.error && (
        <div className="portal-alert error">
          {examSaveErrorMessage(params.error)}
        </div>
      )}



      <section className="portal-card exam-list-section">
        <div className="portal-card-title">
          <div>
            <span>آزمون‌های من</span>
            <h2>سوابق آزمون‌ها</h2>
          </div>
          <strong>{toPersianDigits(exams.length)} آزمون</strong>
        </div>

        {exams.length ? (
          <div className="exam-list">
            {exams.map((exam) => {
              const bCount = exam.exam_booklets?.length || 0;
              const qCount =
                exam.exam_booklets?.reduce(
                  (acc, b) => acc + (b.question_count || 0),
                  0,
                ) || 0;

              return (
                <article key={exam.id}>
                  <div>
                    <span className={`content-status ${exam.status}`}>
                      {exam.status === "published"
                        ? "منتشرشده"
                        : exam.status === "draft"
                          ? "پیش‌نویس"
                          : "بایگانی"}
                    </span>
                    <h3>{exam.title}</h3>
                    <p>
                      {bCount > 0 ? `${toPersianDigits(bCount)} دفترچه` : "کنکوری"}
                      {qCount > 0 ? ` · ${toPersianDigits(qCount)} سؤال` : ""} ·{" "}
                      کارنامهٔ دانش‌آموزان من
                    </p>
                    <p className="exam-schedule">
                      شروع: {formatExamSchedule(exam.starts_at)} {exam.start_window_ends_at && `· مهلت شروع تا: ${formatExamSchedule(exam.start_window_ends_at)}`} · مدت:{" "}
                      {formatExamDuration(exam.duration_minutes)}
                    </p>
                  </div>
                  <div className="exam-list-actions">
                    <span>
                      {toPersianDigits(exam.exam_attempts?.length || 0)} شرکت‌کننده
                    </span>
                    <Link
                      className="button secondary"
                      href={`/dashboard/counselor/exams/${exam.id}`}
                    >
                      مشاهده کارنامه‌ها
                    </Link>
                  </div>
                </article>
              );
            })}
          </div>
        ) : (
          <p className="portal-empty">هنوز آزمونی ساخته نشده است.</p>
        )}
      </section>
    </DashboardShell>
  );
}

