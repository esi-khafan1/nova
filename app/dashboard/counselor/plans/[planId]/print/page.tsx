import Link from "next/link";
import { notFound } from "next/navigation";
import { PrintPlanButton } from "@/components/dashboard/print-plan-button";
import { requireProfile } from "@/lib/auth";
import {
  addDays,
  formatPersianWeekRange,
  parseIsoDate,
  persianMonthNames,
  persianNumber,
  persianParts,
} from "@/lib/persian-date";
import {
  activityTypes,
  studyFieldLabels,
  weekDays,
  type StudyField,
} from "@/lib/study-catalog";

type PrintablePlan = {
  id: string;
  student_id: string;
  week_start: string;
  title: string;
  notes: string | null;
  status: "draft" | "published";
  weekly_plan_items: Array<{
    id: string;
    day_of_week: number;
    duration_minutes: number;
    subject: string;
    chapter: string | null;
    activity_type: string;
    target_test_count: number | null;
    details: string | null;
    sort_order: number;
  }>;
};

type StudentDirectoryRow = {
  student_id: string;
  full_name: string;
  grade: number | null;
  study_field: StudyField | null;
};

function formatPersianDay(date: Date) {
  const parts = persianParts(date);
  return `${persianNumber.format(parts.day)} ${persianMonthNames[parts.month - 1]}`;
}

export default async function PrintWeeklyPlanPage({
  params,
}: {
  params: Promise<{ planId: string }>;
}) {
  const { planId } = await params;
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data: planData }, { data: directoryData }] = await Promise.all([
    supabase
      .from("weekly_plans")
      .select(
        "id,student_id,week_start,title,notes,status,weekly_plan_items(id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order)",
      )
      .eq("id", planId)
      .eq("counselor_id", profile.id)
      .single(),
    supabase.rpc("counselor_student_directory"),
  ]);

  if (!planData) notFound();

  const plan = planData as PrintablePlan;
  const student = (directoryData as StudentDirectoryRow[] | null)?.find(
    (item) => item.student_id === plan.student_id,
  );
  const weekStart = parseIsoDate(plan.week_start);
  const activityLabels = new Map<string, string>(
    activityTypes.map((activity) => [activity.value, activity.label]),
  );
  const items = [...plan.weekly_plan_items].sort(
    (first, second) =>
      first.day_of_week - second.day_of_week ||
      first.sort_order - second.sort_order,
  );

  return (
    <main className="print-plan-page" dir="rtl">
      <div className="print-plan-toolbar">
        <Link
          className="button button-secondary"
          href="/dashboard/counselor/plans"
        >
          بازگشت به برنامه‌ریز
        </Link>
        <PrintPlanButton />
      </div>

      <article className="a4-weekly-plan">
        <header className="print-plan-header">
          <div>
            <span className="print-brand">نووا</span>
            <p>برنامه هفتگی مطالعه</p>
          </div>
          <div className="print-plan-title">
            <h1>{plan.title}</h1>
            <div>
              <strong>{formatPersianWeekRange(plan.week_start)}</strong>
              <span className={`print-plan-status ${plan.status}`}>
                {plan.status === "published" ? "منتشرشده" : "پیش‌نویس"}
              </span>
            </div>
          </div>
        </header>

        <section className="print-plan-meta">
          <div>
            <span>دانش‌آموز</span>
            <strong>{student?.full_name || "دانش‌آموز نووا"}</strong>
          </div>
          <div>
            <span>پایه</span>
            <strong>
              {student?.grade
                ? `پایه ${student.grade.toLocaleString("fa-IR")}`
                : "ثبت نشده"}
            </strong>
          </div>
          <div>
            <span>رشته</span>
            <strong>
              {student?.study_field
                ? studyFieldLabels[student.study_field]
                : "ثبت نشده"}
            </strong>
          </div>
          <div>
            <span>مشاور</span>
            <strong>{profile.full_name || "مشاور نووا"}</strong>
          </div>
        </section>

        {plan.notes && (
          <section className="print-plan-notes">
            <strong>یادداشت کلی مشاور</strong>
            <p>{plan.notes}</p>
          </section>
        )}

        <div className="print-week-grid">
          {weekDays.map((day, dayIndex) => {
            const dayItems = items.filter(
              (item) => item.day_of_week === dayIndex,
            );
            return (
              <section className="print-day-column" key={day}>
                <header>
                  <h2>{day}</h2>
                  <span>{formatPersianDay(addDays(weekStart, dayIndex))}</span>
                </header>
                <div className="print-day-items">
                  {dayItems.map((item) => (
                    <article className="print-activity" key={item.id}>
                      <div className="print-activity-title">
                        <span aria-hidden="true">□</span>
                        <strong>{item.subject}</strong>
                        <b>{item.duration_minutes.toLocaleString("fa-IR")} د</b>
                      </div>
                      <p className="print-activity-chapter">
                        {item.chapter || "مبحث آزاد"}
                      </p>
                      <p className="print-activity-summary">
                        {activityLabels.get(item.activity_type) ||
                          "فعالیت درسی"}
                        {item.activity_type === "practice_tests" &&
                          item.target_test_count &&
                          ` · هدف ${item.target_test_count.toLocaleString(
                            "fa-IR",
                          )} تست`}
                      </p>
                      {item.details && (
                        <p className="print-activity-details">{item.details}</p>
                      )}
                    </article>
                  ))}
                  {Array.from({
                    length: Math.max(0, 5 - dayItems.length),
                  }).map((_, index) => (
                    <div
                      className="print-activity print-activity-empty"
                      key={`empty-${index}`}
                    />
                  ))}
                </div>
              </section>
            );
          })}
        </div>

        <footer className="print-plan-footer">
          <span>Nova · مسیر روشن موفقیت تحصیلی</span>
          <span>امضای مشاور: ....................................</span>
        </footer>
      </article>
    </main>
  );
}
