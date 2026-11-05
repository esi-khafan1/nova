import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { ExamExtensionForm } from "@/components/dashboard/exam-extension-form";
import { formatExamSchedule } from "@/lib/exams";
import { toPersianDigits } from "@/lib/persian-date";

type Student = { student_id: string; full_name: string; is_selected: boolean };
type ExamHistory = {
  exam_id: string; title: string; starts_at: string;
  duration_minutes: number; start_window_ends_at: string | null;
  attempt_id: string | null; submitted_at: string | null; score: number | null;
  extension_id: string | null; extension_starts_at: string | null;
  extension_ends_at: string | null; can_extend: boolean;
};
const pageSize = 5;

export default async function CounselorExamsPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const params = await searchParams;
  const { data: directoryData, error: directoryError } = await supabase.rpc("counselor_student_directory");
  if (directoryError) throw new Error("Student directory unavailable");
  const students = ((directoryData ?? []) as Student[]).filter(student => student.is_selected);
  const student = students.find(row => row.student_id === params.student) ?? students[0];
  const requestedPage = Number(params.page);
  const page = Number.isSafeInteger(requestedPage) && requestedPage >= 1 && requestedPage <= 2000 ? requestedPage : 1;
  const { data, error } = student
    ? await supabase.rpc("counselor_student_exam_history", {
        target_student_id: student.student_id,
        page_offset: (page - 1) * pageSize,
        page_size: pageSize + 1,
      })
    : { data: [], error: null };
  const history = ((data ?? []) as ExamHistory[]).slice(0, pageSize);
  const hasNext = (data?.length ?? 0) > pageSize;
  const hrefFor = (number: number) => `/dashboard/counselor/exams?student=${encodeURIComponent(student.student_id)}&page=${number}`;

  return <DashboardShell role="counselor" name={profile.full_name}>
    <section className="portal-heading"><div><span>گزارش آزمون</span><h1>آزمون‌ها و کارنامهٔ هر دانش‌آموز</h1><p>دانش‌آموز را انتخاب کن تا پنج آزمون اخیر و وضعیت شرکت او را ببینی.</p></div></section>
    <section className="portal-card exam-list-section">
      {params.extension === "saved" && <p className="portal-alert success" role="status">تمدید آزمون ثبت شد؛ دانش‌آموز می‌تواند در بازهٔ انتخاب‌شده آزمون را شروع کند.</p>}
      {params.extension === "canceled" && <p className="portal-alert success" role="status">تمدید آزمون لغو شد.</p>}
      {params.extension === "error" && <p className="portal-alert error" role="alert">ثبت یا لغو تمدید انجام نشد؛ ممکن است دانش‌آموز آزمون را شروع کرده باشد یا بازهٔ انتخاب‌شده معتبر نباشد. صفحه را تازه کن و دوباره تلاش کن.</p>}
      <form className="counselor-exam-student-picker" method="get" action="/dashboard/counselor/exams">
        <label>گزارش کدام دانش‌آموز؟
          <select name="student" defaultValue={student?.student_id ?? ""} disabled={!student}>
            {students.map(row=><option key={row.student_id} value={row.student_id}>{row.full_name || "دانش‌آموز نووا"}</option>)}
          </select>
        </label>
        <button type="submit" className="button secondary" disabled={!student}>نمایش آزمون‌ها</button>
      </form>
      {!student ? <p className="portal-empty">هنوز دانش‌آموزی تحت مشاورهٔ شما نیست.</p>
        : error ? <p className="portal-alert error" role="alert">گزارش آزمون‌های این دانش‌آموز دریافت نشد؛ دوباره تلاش کن.</p>
        : <>
          <div className="portal-card-title"><div><span>آزمون‌های برگزارشده</span><h2>پنج آزمون اخیر {student.full_name}</h2></div><span>صفحهٔ {toPersianDigits(page)}</span></div>
          {history.length ? <div className="exam-list">
            {history.map(exam=><article key={exam.exam_id} className="counselor-exam-history-item">
              <div className="counselor-exam-history-main">
                <div><h3>{exam.title}</h3><p className="exam-schedule">شروع: {formatExamSchedule(exam.starts_at)}</p>
                  <p>{exam.attempt_id ? "در این آزمون شرکت کرده است" : "در این آزمون شرکت نکرده است"}</p>
                  {!exam.attempt_id && exam.extension_id && exam.extension_starts_at && exam.extension_ends_at && !exam.can_extend && (
                    <p className="exam-extension-current">تمدید ثبت‌شده: شروع از {formatExamSchedule(exam.extension_starts_at)} تا {formatExamSchedule(exam.extension_ends_at)}</p>
                  )}
                </div>
                <div className="exam-list-actions">
                  {exam.attempt_id ? <><span>{exam.score === null ? "نمره در دسترس نیست" : `درصد: ${toPersianDigits(exam.score)}٪`}</span>
                    <Link className="button secondary" href={`/dashboard/counselor/exams/${exam.exam_id}/report/${exam.attempt_id}`}>مشاهده و چاپ کارنامه</Link></>
                    : <span>کارنامه‌ای ثبت نشده</span>}
                </div>
              </div>
              {!exam.attempt_id && exam.can_extend && student && (
                <ExamExtensionForm
                  examId={exam.exam_id}
                  studentId={student.student_id}
                  page={page}
                  extension={exam.extension_id && exam.extension_starts_at && exam.extension_ends_at
                    ? { starts_at: exam.extension_starts_at, ends_at: exam.extension_ends_at }
                    : null}
                />
              )}
            </article>)}
          </div> : <p className="portal-empty">آزمون برگزارشده‌ای برای این دانش‌آموز پیدا نشد.</p>}
          {(page > 1 || hasNext) && <nav className="counselor-exam-pages" aria-label="صفحه‌های آزمون‌ها">
            {page > 1 && <Link className="button secondary" href={hrefFor(page - 1)}>صفحهٔ قبل</Link>}
            {hasNext && <Link className="button secondary" href={hrefFor(page + 1)}>صفحهٔ بعد</Link>}
          </nav>}
        </>}
    </section>
  </DashboardShell>;
}
