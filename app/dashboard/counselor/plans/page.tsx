import {loadCounselorPlans} from "@/lib/load-counselor-plans";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import Link from "next/link";
import {
  WeeklyPlanBuilder,
  type CounselorWeeklyPlan,
} from "@/components/dashboard/weekly-plan-builder";
import { requireProfile } from "@/lib/auth";
import { studyFieldLabels, type StudyField } from "@/lib/study-catalog";
import {
  formatPersianWeekRange,
} from "@/lib/persian-date";

type StudentDirectoryRow = {
  student_id: string;
  full_name: string;
  grade: number | null;
  study_field: StudyField | null;
  is_selected: boolean;
};

export default async function CounselorPlansPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const params = await searchParams;
  const [{data:directoryData,error:directoryError},loadedPlans]=await Promise.all([
    supabase.rpc("counselor_student_directory"),
    loadCounselorPlans(supabase,profile.id).then(data=>({data,failed:false}),()=>({data:[],failed:true})),
  ]);
  const plans=loadedPlans.data,plansFailed=loadedPlans.failed;
  if(directoryError||plansFailed)return <DashboardShell role="counselor" name={profile.full_name}><section className="portal-card portal-alert error" role="alert"><h1>اطلاعات برنامه‌ها دریافت نشد</h1><p>برای جلوگیری از ذخیرهٔ ناقص، فرم فعلاً نمایش داده نمی‌شود. دوباره صفحه را باز کن.</p></section></DashboardShell>;

  const directory = (directoryData ?? []) as StudentDirectoryRow[];
  const selectedStudents = directory.filter((student) => student.is_selected);
  const counselorPlans = (plans ?? []) as CounselorWeeklyPlan[];
  const requestedProgressStudent = params.progress_student;
  const progressStudent =
    selectedStudents.find(
      (student) => student.student_id === requestedProgressStudent,
    ) ?? selectedStudents[0];
  const studentNames = new Map(
    directory.map((student) => [
      student.student_id,
      student.full_name || "دانش‌آموز نووا",
    ]),
  );

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>برنامه‌ریزی هفتگی</span>
          <h1>برنامه هر دانش‌آموز را دقیق بچین</h1>
          <p>
            زمان، درس، فصل و نوع فعالیت را مثل برگه برنامه هفتگی در یک مسیر روشن
            ثبت کن.
          </p>
        </div>
      </section>

      {params.selected && (
        <div className="portal-alert success">
          دانش‌آموز به فهرست مشاوره تو اضافه شد.
        </div>
      )}
      {params.saved && (
        <div className="portal-alert success">
          {params.saved === "published"
            ? "برنامه منتشر شد و دانش‌آموز می‌تواند آن را ببیند."
            : "پیش‌نویس برنامه ذخیره شد."}
        </div>
      )}
      {params.error && (
        <div className="portal-alert error">
          {params.error === "overlap" ? "این بازه با برنامهٔ دیگری برای دانش‌آموز هم‌پوشانی دارد. شروع را بعد از پایان برنامهٔ قبلی انتخاب کن." : params.error === "week" ? "برای برنامهٔ جدید، امروز یا یک روز آینده را انتخاب کن؛ برنامهٔ تمام‌شده قابل تغییر نیست." : params.error === "routines" ? "روتین هر هفت روز باید کامل و یکتا باشد و درس روتین باید مربوط به رشتهٔ دانشآموز باشد." : "ذخیره انجام نشد. اطلاعات برنامه را بررسی و دوباره تلاش کن."}
        </div>
      )}

      <section className="portal-card student-picker">
        <div className="portal-card-title">
          <div>
            <span>انتخاب دانش‌آموز</span>
            <h2>دانش‌آموزان تحت مشاوره</h2>
          </div>
          <strong>{selectedStudents.length} نفر</strong>
        </div>

        {selectedStudents.length > 0 && (
          <div className="selected-students">
            {selectedStudents.map((student) => (
              <article key={student.student_id}>
                <span>{(student.full_name || "ن").slice(0, 1)}</span>
                <div>
                  <strong>{student.full_name || "دانش‌آموز نووا"}</strong>
                  <small>
                    {student.grade
                      ? `پایه ${student.grade.toLocaleString("fa-IR")}`
                      : "پایه نامشخص"}
                    {" · "}
                    {student.study_field
                      ? studyFieldLabels[student.study_field]
                      : "رشته نامشخص"}
                  </small>
                </div>
              </article>
            ))}
          </div>
        )}

        {!selectedStudents.length&&<p className="all-students-selected">هنوز دانش‌آموزی توسط ادمین به شما اختصاص داده نشده است.</p>}
      </section>

      {progressStudent && (
        <section className="counselor-progress-section">
          <form className="counselor-progress-picker">
            <label>
              گزارش کدام دانش‌آموز؟
              <select
                name="progress_student"
                defaultValue={progressStudent.student_id}
              >
                {selectedStudents.map((student) => (
                  <option key={student.student_id} value={student.student_id}>
                    {student.full_name || "دانش‌آموز نووا"}
                  </option>
                ))}
              </select>
            </label>
            <button className="button">نمایش گزارش</button>
          </form>
          <div className="portal-card cp-report-cta"><div><h2>گزارش {progressStudent.full_name}</h2><p>روزانه، هفتگی، سوابق هفته‌ها و مسیر مطالعه به تفکیک درس و فصل</p></div><Link className="button" href={`/dashboard/counselor/students/${progressStudent.student_id}`}>نمایش گزارش کامل</Link></div>
        </section>
      )}

      <WeeklyPlanBuilder students={selectedStudents} plans={counselorPlans} initialStudentId={params.student} />

      {counselorPlans.length > 0 && (
        <section className="portal-card recent-plans">
          <div className="portal-card-title">
            <div>
              <span>سوابق</span>
              <h2>برنامه‌های اخیر</h2>
            </div>
          </div>
          <div>
            {counselorPlans.slice(0, 8).map((plan) => (
              <article key={plan.id}>
                <div>
                  <strong>
                    {studentNames.get(plan.student_id) || "دانش‌آموز نووا"}
                  </strong>
                  <span>
                    {plan.title} · {formatPersianWeekRange(plan.week_start)}
                  </span>
                </div>
                <div className="recent-plan-actions">
                  <span className={`plan-status ${plan.status}`}>
                    {plan.status === "published" ? "منتشرشده" : "پیش‌نویس"}
                  </span>
                  <Link
                    className="print-plan-link"
                    href={`/dashboard/counselor/plans/${plan.id}/print`}
                  >
                    چاپ A4
                  </Link>
                </div>
              </article>
            ))}
          </div>
        </section>
      )}
    </DashboardShell>
  );
}
