import Link from "next/link";
import { getFloatingExamEntryState, type FloatingExamSession } from "@/lib/floating-exams";
import { formatExamDuration, formatExamSchedule, getExamTimeState } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";

export type StudentExam = {
  id: string; title: string; description: string | null; mode: string; audience: string;
  starts_at: string; start_window_ends_at: string | null; duration_minutes: number;
  created_at: string; exam_booklets?: { id: string; question_count: number }[];
};
export type StudentExamAttempt = {
  exam_id: string; score: number | null; correct_answers: number | null;
  total_questions: number | null; submitted_at: string;
};

export function StudentExamCard({ exam, attempt, session, now = new Date() }: {
  exam: StudentExam; attempt?: StudentExamAttempt;
  session?: Pick<FloatingExamSession, "exam_id" | "expires_at">; now?: Date;
}) {
  const timeState = getExamTimeState(exam.starts_at, exam.duration_minutes, now, exam.start_window_ends_at);
  const floatingEntry = exam.start_window_ends_at
    ? getFloatingExamEntryState(exam.starts_at, exam.start_window_ends_at, session, now) : null;
  const bookletCount = exam.exam_booklets?.length ?? 0;
  const totalQuestions = exam.exam_booklets?.reduce((sum, booklet) => sum + (booklet.question_count || 0), 0) ?? 0;
  const entryAvailable = floatingEntry ? ["startable", "resumable", "expired"].includes(floatingEntry) : timeState === "active";
  const status = attempt ? "completed" : entryAvailable ? "available" : (floatingEntry === "upcoming" || (!floatingEntry && timeState === "upcoming")) ? "upcoming" : "ended";
  const labels = { completed: "ثبت‌شده", available: "قابل شرکت", upcoming: "پیش رو", ended: "پایان‌یافته" };
  return (
    <article className={`se-card se-card--${status}`}>
      <div className="se-card-cover">
        <div className="se-card-cover-top"><span className="se-category">آزمون دفترچه‌ای کنکوری</span><span className="se-status"><i aria-hidden="true" />{!attempt && floatingEntry === "expired" ? "نیاز به ثبت پاسخ‌ها" : labels[status]}</span></div>
        <div className="se-card-cover-bottom">
          <svg className="se-booklet-icon" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true"><rect x="12" y="7" width="27" height="35" rx="4"/><path d="M30 7V4H9a3 3 0 0 0-3 3v29h6M19 16h13M19 23h13M19 30h8"/><path d="m29 35 3 3 5-6" stroke="#aa4307"/></svg>
          <div className="se-card-specs"><strong>{bookletCount > 0 ? `${toPersianDigits(bookletCount)} دفترچه` : "کنکوری"}</strong>{totalQuestions > 0 && <span>{toPersianDigits(totalQuestions)} سؤال</span>}</div>
        </div>
      </div>
      <div className="se-card-body">
        <h2>{exam.title}</h2>
        <p className="se-description">{exam.description || "آماده‌ای؟ دفترچه‌ها را مرحله‌به‌مرحله پاسخ بده."}</p>
        <div className="se-schedule">
          <div><span>شروع:</span><time dateTime={exam.starts_at}>{formatExamSchedule(exam.starts_at)}</time></div>
          <div><span>مدت:</span><strong>{formatExamDuration(exam.duration_minutes)}</strong></div>
          {exam.start_window_ends_at && <div><span>مهلت شروع تا:</span><time dateTime={exam.start_window_ends_at}>{formatExamSchedule(exam.start_window_ends_at)}</time></div>}
        </div>
        <div className="se-card-footer">
          {attempt ? <div className="se-completed"><strong>آزمون داده شد ✅</strong>
            {timeState === "ended" && attempt.score !== null && <span className="se-score">درصد کنکوری: {toPersianDigits(attempt.score)}٪</span>}
            <Link className="se-action se-action--secondary" href={`/dashboard/student/exams/${exam.id}#exam-review`}>{timeState === "ended" ? "بررسی دفترچه و پاسخ‌برگ" : "مشاهدهٔ وضعیت ثبت آزمون"}<span aria-hidden="true">←</span></Link>
          </div> : exam.start_window_ends_at ? (
            floatingEntry === "startable" || floatingEntry === "resumable" || floatingEntry === "expired"
              ? <Link className="se-action" href={`/dashboard/student/exams/${exam.id}`}>{floatingEntry === "resumable" ? "ادامهٔ آزمون" : floatingEntry === "expired" ? "ثبت پاسخ‌های ذخیره‌شده" : "مشاهده و شروع آزمون"}<span aria-hidden="true">←</span></Link>
              : <div className="se-notice">{floatingEntry === "upcoming" ? "بازهٔ شروع هنوز باز نشده است." : "مهلت شروع آزمون تمام شده است."}</div>
          ) : timeState === "active" ? <Link className="se-action" href={`/dashboard/student/exams/${exam.id}`}>ورود به آزمون و شروع<span aria-hidden="true">←</span></Link>
            : <div className="se-notice">{timeState === "upcoming" ? "آزمون هنوز شروع نشده است." : "مهلت شرکت در آزمون تمام شده است."}</div>}
        </div>
      </div>
    </article>
  );
}

export function StudentExamsOverview({ exams, attempts, sessions, error = false, now }: {
  exams: StudentExam[]; attempts: Map<string, StudentExamAttempt>;
  sessions: Map<string, Pick<FloatingExamSession, "exam_id" | "expires_at">>;
  error?: boolean; now?: Date;
}) {
  return (
      <section className="student-exams-page" aria-labelledby="student-exams-title">
      <header className="se-page-heading">
        <div>
          <span className="se-eyebrow">آزمون‌های من</span>
          <h1 id="student-exams-title">آزمون‌های کنکوری <span>قابل شرکت</span></h1>
          <p>آزمون‌هایی که برای تو انتخاب و منتشر شده‌اند اینجا نمایش داده می‌شوند.</p>
        </div>
        <span className="se-total">{toPersianDigits(exams.length)} آزمون</span>
      </header>

      {error && (
        <div className="portal-alert error" role="alert">آزمون در دسترس نیست.</div>
      )}

      <div className="se-exam-grid">
        {exams.length ? exams.map(exam => (
          <StudentExamCard now={now} key={exam.id} exam={exam} attempt={attempts.get(exam.id)} session={sessions.get(exam.id)} />
        )) : <section className="se-empty" role="status"><span className="se-empty-icon" aria-hidden="true"><svg viewBox="0 0 32 32" width="32" height="32" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="7" y="5" width="20" height="24" rx="3"/><path d="M12 5V3H5a2 2 0 0 0-2 2v19h4M12 12h10M12 18h10M12 24h6"/></svg></span><h2>آزمون بعدی، قدم بعدی تو</h2><p>فعلاً آزمونی برای تو منتشر نشده است.</p></section>}
      </div>
      </section>
  );
}
