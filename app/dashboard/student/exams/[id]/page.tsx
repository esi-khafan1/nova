import Link from "next/link";
import { beginFloatingExam, submitSavedFloatingExam } from "@/app/dashboard/exams/actions";
import { getFloatingExamEntryState, floatingSessionDeadline, floatingExamErrorMessage, type FloatingExamSession } from "@/lib/floating-exams";
import { notFound, redirect } from "next/navigation";
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
  const { supabase, profile } = await requireProfile(["student"], true);
  if (profile.registration_status !== "active") redirect("/dashboard/student/exams");

  const [{ data: exam }, { data: attempt }] = await Promise.all([
    supabase
      .from("exams")
      .select(
        "id,title,description,mode,starts_at,start_window_ends_at,duration_minutes,exam_booklets(id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order)",
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
  // Old in-flight forms may still land on the former ?submitted=1 URL.
  if (attempt && query.submitted === "1") redirect(`/dashboard/student/exams/${id}/review`);

  const booklets = ((exam.exam_booklets ?? []) as ExamBooklet[]).sort(
    (a, b) => a.sort_order - b.sort_order,
  );
  const timeState = getExamTimeState(exam.starts_at, exam.duration_minutes,new Date(),exam.start_window_ends_at);
  const {data:sessionData}=exam.start_window_ends_at && !attempt ? await supabase.rpc("get_floating_exam_session",{target_exam_id:id}) : {data:null};
  const session=(sessionData?.[0] ?? undefined) as FloatingExamSession | undefined;
  const floatingEntry=exam.start_window_ends_at ? getFloatingExamEntryState(exam.starts_at,exam.start_window_ends_at,session ? {expires_at:new Date(floatingSessionDeadline(session,booklets)).toISOString()}:null):null;

  return (
    <DashboardShell role="student" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>آزمون دفترچه‌ای کنکوری</span>
          <h1>{exam.title}</h1>
          <p>{exam.description || "پاسخ‌ها را با دقت ثبت کن؛ هر آزمون فقط یک‌بار قابل ارسال است."}</p>
          <p className="exam-schedule">
            شروع: {formatExamSchedule(exam.starts_at)} · مدت کل: {formatExamDuration(exam.duration_minutes)}
            {exam.start_window_ends_at && <><br/>مهلت شروع تا: {formatExamSchedule(exam.start_window_ends_at)}؛ پس از شروع، مدت کامل آزمون را داری.</>}
            {booklets.length > 0 && ` (${toPersianDigits(booklets.length)} دفترچه)`}
          </p>
        </div>
        <Link className="button secondary" href="/dashboard/student/exams">
          بازگشت
        </Link>
      </section>

      {query.error && (
        <div className="portal-alert error">{query.error === "submit" ? "ارسال پاسخ‌ها انجام نشد. پاسخ‌های ذخیره‌شده محفوظ‌اند؛ دوباره تلاش کن." : floatingExamErrorMessage(query.error)}</div>
      )}

      {attempt ? (
        <>
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
            <p>پاسخ‌ها ثبت شدند؛ برای مشاهدهٔ پاسخنامه وارد صفحهٔ بررسی شو.</p>
          )}
        </section>
        {exam.mode === "booklet" && <section className="portal-card"><h2>پاسخنامهٔ آزمون</h2><p>گزینه‌های ثبت‌شده، پاسخ‌های صحیح و پاسخنامهٔ تشریحی هر دفترچه را ببین. این صفحه بعداً هم از «آزمون‌های من» در دسترس است.</p><Link className="button" href={`/dashboard/student/exams/${id}/review`}>مشاهدهٔ پاسخنامه</Link> <Link className="button secondary" href={`/dashboard/student/exams/${id}/report`}>مشاهده و چاپ کارنامه</Link></section>}
        </>
      ) : exam.start_window_ends_at ? (
        floatingEntry === "expired" ? <section className="portal-card exam-gate"><h2>زمان پاسخ‌گویی شما تمام شده است</h2><p>زمان شروع قبلی تغییر نمی‌کند. پاسخ‌هایی که روی سرور ذخیره شده‌اند را ثبت کن؛ پاسخ جدید پس از پایان زمان پذیرفته نمی‌شود.</p><form action={submitSavedFloatingExam}><input type="hidden" name="exam_id" value={id}/><button className="button" type="submit">ثبت پاسخ‌های ذخیره‌شده</button></form></section>
        : session ? <StudentExamForm examId={exam.id} examTitle={exam.title} booklets={booklets} studentName={profile.full_name} floatingSession={session}/>
        : floatingEntry === "startable" ? <section className="portal-card exam-gate"><h2>آمادهٔ شروع آزمون هستی؟</h2><p>با زدن شروع، زمان اختصاصی تو ثبت می‌شود و تایمر شروع خواهد شد. بازکردن این صفحه به‌تنهایی آزمون را شروع نمی‌کند.</p><form action={beginFloatingExam}><input type="hidden" name="exam_id" value={id}/><button className="button" type="submit">شروع آزمون</button></form></section>
        : <section className="portal-card exam-gate"><h2>{floatingEntry === "upcoming" ? "بازهٔ شروع هنوز باز نشده است" : "مهلت شروع آزمون تمام شده است"}</h2><p>{floatingEntry === "upcoming" ? "در ساعت آغاز بازه به این صفحه برگرد." : "شروع جدید از ساعت پایان بازه به بعد ممکن نیست."}</p></section>
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

