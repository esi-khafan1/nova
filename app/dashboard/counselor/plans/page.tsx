import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import Link from "next/link";
import {
  WeeklyPlanBuilder,
  type CounselorWeeklyPlan,
} from "@/components/dashboard/weekly-plan-builder";
import { StudentProgressSummary } from "@/components/dashboard/student-progress-summary";
import { selectStudent } from "@/app/dashboard/actions";
import { requireProfile } from "@/lib/auth";
import { studyFieldLabels, type StudyField } from "@/lib/study-catalog";
import {
  addDays,
  formatPersianWeekRange,
  parseIsoDate,
} from "@/lib/persian-date";
import { buildProgressScopes } from "@/lib/progress";

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
  const [{ data: directoryData }, { data: plans }] = await Promise.all([
    supabase.rpc("counselor_student_directory"),
    supabase
      .from("weekly_plans")
      .select(
        "id,student_id,week_start,title,notes,status,updated_at,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order)",
      )
      .eq("counselor_id", profile.id)
      .order("week_start", { ascending: false }),
  ]);

  const directory = (directoryData ?? []) as StudentDirectoryRow[];
  const selectedStudents = directory.filter((student) => student.is_selected);
  const availableStudents = directory.filter((student) => !student.is_selected);
  const counselorPlans = (plans ?? []) as CounselorWeeklyPlan[];
  const requestedProgressStudent = params.progress_student;
  const progressStudent =
    selectedStudents.find(
      (student) => student.student_id === requestedProgressStudent,
    ) ?? selectedStudents[0];
  const progressPlans = counselorPlans.filter(
    (plan) =>
      plan.student_id === progressStudent?.student_id &&
      plan.status === "published",
  );
  const progressItems = progressPlans.flatMap((plan) =>
    plan.weekly_plan_items.map((item) => ({
      id: item.id,
      planId: plan.id,
      plannedDate: addDays(parseIsoDate(plan.week_start), item.day_of_week),
      durationMinutes: item.duration_minutes,
      subject: item.subject,
      chapter: item.chapter,
      activityType: item.activity_type,
      targetTestCount: item.target_test_count,
    })),
  );
  const progressItemIds = progressItems.map((item) => item.id);
  const { data: progressCompletions } = progressItemIds.length
    ? await supabase
        .from("weekly_plan_item_completions")
        .select("item_id,completed_test_count")
        .in("item_id", progressItemIds)
    : { data: [] };
  const progressScopes = buildProgressScopes({
    items: progressItems,
    currentPlanId: progressPlans[0]?.id ?? null,
    completedIds: new Set(
      (progressCompletions ?? []).map((completion) => completion.item_id),
    ),
    completedTestCounts: new Map(
      (progressCompletions ?? []).map((completion) => [
        completion.item_id,
        completion.completed_test_count ?? 0,
      ]),
    ),
  });
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
          ذخیره انجام نشد. اطلاعات برنامه را بررسی و دوباره تلاش کن.
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

        {availableStudents.length > 0 ? (
          <form action={selectStudent} className="student-select-form">
            <label>
              افزودن دانش‌آموز جدید
              <select name="student_id" required defaultValue="">
                <option value="" disabled>
                  یک دانش‌آموز را انتخاب کن
                </option>
                {availableStudents.map((student) => (
                  <option key={student.student_id} value={student.student_id}>
                    {student.full_name || "دانش‌آموز نووا"}
                    {student.grade
                      ? ` — پایه ${student.grade.toLocaleString("fa-IR")}`
                      : ""}
                  </option>
                ))}
              </select>
            </label>
            <button className="button">افزودن به مشاوره</button>
          </form>
        ) : (
          <p className="all-students-selected">
            همه دانش‌آموزان موجود در فهرست مشاوره تو هستند.
          </p>
        )}
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
          <StudentProgressSummary
            scopes={progressScopes}
            eyebrow="گزارش دانش‌آموز"
            title={`پیشرفت ${progressStudent.full_name || "دانش‌آموز نووا"}`}
          />
        </section>
      )}

      <WeeklyPlanBuilder students={selectedStudents} plans={counselorPlans} />

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
