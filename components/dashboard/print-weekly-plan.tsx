import { makeupActivity } from "@/lib/makeup-plan-box";
import { externalSimulationActivity, externalSimulationTitle, simulationProvider } from "@/lib/external-simulation";
import Link from "next/link";
import { PrintPlanButton } from "@/components/dashboard/print-plan-button";
import { FitText } from "@/components/dashboard/print-fit-text";
import {
  addDays,
  formatPersianWeekday,
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

export type PrintablePlanRoutine = {
  dayOfWeek?: number | string | null;
  subject?: string | null;
  details?: string | null;
  secondSubject?: string | null;
  secondDetails?: string | null;
};

export type PrintablePlan = {
  id: string;
  student_id: string;
  week_start: string;
  title: string;
  notes: string | null;
  status: "draft" | "published";
  routines?: PrintablePlanRoutine[] | null;
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

function formatPersianDay(date: Date) {
  const parts = persianParts(date);
  return `${persianNumber.format(parts.day)} ${persianMonthNames[parts.month - 1]}`;
}

function normalizeRoutines(routines: PrintablePlan["routines"]) {
  const source = Array.isArray(routines) ? routines : [];
  return weekDays.map((_, index) => {
    const match = source.find((routine) => Number(routine?.dayOfWeek) === index);
    return {
      subject: typeof match?.subject === "string" ? match.subject : "",
      details: typeof match?.details === "string" ? match.details : "",
      secondSubject: typeof match?.secondSubject === "string" ? match.secondSubject : "",
      secondDetails: typeof match?.secondDetails === "string" ? match.secondDetails : "",
    };
  });
}

export function PrintWeeklyPlan({plan,student,counselorName,backHref,visibleDays=7}:{plan:PrintablePlan;student:{full_name:string;grade:number|null;study_field:StudyField|null}|undefined;counselorName:string;backHref:string;visibleDays?:number}){
  const weekStart = parseIsoDate(plan.week_start);
  const activityLabels = new Map<string, string>(
    activityTypes.map((activity) => [activity.value, activity.label]),
  );
  const items = [...plan.weekly_plan_items].sort(
    (first, second) =>
      first.day_of_week - second.day_of_week ||
      first.sort_order - second.sort_order,
  );
  const routines = normalizeRoutines(plan.routines);

  return (
    <main className="print-plan-page" dir="rtl">
      <div className="print-plan-toolbar">
        <Link
          className="button button-secondary"
          href={backHref}
        >
          بازگشت به برنامه
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
              <strong>{formatPersianWeekRange(plan.week_start, visibleDays)}</strong>
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
            <strong>{counselorName || "مشاور نووا"}</strong>
          </div>
        </section>

        {plan.notes && (
          <section className="print-plan-notes">
            <strong>یادداشت کلی مشاور</strong>
            <p>{plan.notes}</p>
          </section>
        )}

        <div className="print-week-grid">
          {weekDays.slice(0, visibleDays).map((_, dayIndex) => {
            const dayItems = items.filter(
              (item) => item.day_of_week === dayIndex,
            );
            const dayDate = addDays(weekStart, dayIndex);
            const weekday = formatPersianWeekday(dayDate);
            return (
              <section className="print-day-column" key={dayIndex}>
                <header>
                  <h2>{weekday}</h2>
                  <span>{formatPersianDay(dayDate)}</span>
                </header>
                <div className="print-day-items">
                  {dayItems.map((item) => {
                    const activityLabel =
                      item.activity_type === externalSimulationActivity ? externalSimulationTitle : activityLabels.get(item.activity_type) || "فعالیت درسی";
                    const isTest = item.activity_type === "practice_tests";
                    const testTarget = item.target_test_count ?? 0;
                    const durationText = `${item.duration_minutes.toLocaleString(
                      "fa-IR",
                    )} دقیقه ${activityLabel}`;
                    const lastText = isTest
                      ? `ــــــــ زده شده از ${testTarget.toLocaleString("fa-IR")} تست`
                      : item.activity_type === "exam" ? "" : item.details || "";
                    return (
                      <article className="print-activity" key={item.id}>
                        <div className="print-activity-title">
                          <span aria-hidden="true">□</span>
                          <FitText basePt={10.5} className="print-activity-subject">
                            {item.activity_type === externalSimulationActivity ? externalSimulationTitle : item.subject}
                          </FitText>
                        </div>
                        <FitText basePt={8.5} className="print-activity-chapter">
                          {item.activity_type === makeupActivity ? "" : item.activity_type === externalSimulationActivity ? `برگزارکننده: ${simulationProvider(item.subject) ?? "نامشخص"}` : item.chapter || "مبحث آزاد"}
                        </FitText>
                        <FitText basePt={8.5} className="print-activity-summary">
                          {item.activity_type === externalSimulationActivity || item.activity_type === makeupActivity ? `${item.duration_minutes.toLocaleString("fa-IR")} دقیقه` : durationText}
                        </FitText>
                        <FitText
                          basePt={7.5}
                          className={`print-activity-last${isTest ? " is-test" : ""}`}
                        >
                          {lastText}
                        </FitText>
                      </article>
                    );
                  })}
                  {Array.from({
                    length: Math.max(0, 5 - dayItems.length),
                  }).map((_, index) => (
                    <div
                      className="print-activity print-activity-empty"
                      key={`empty-${index}`}
                    />
                  ))}
                  <article className="print-activity print-routine" key={`routine-${dayIndex}`} data-weekday={weekday}>
                    {[
                      {subject: routines[dayIndex].subject, details: routines[dayIndex].details},
                      {subject: routines[dayIndex].secondSubject, details: routines[dayIndex].secondDetails},
                    ].map((routine, index) => (
                      <div className={`print-routine-entry${index ? " print-routine-entry--second" : ""}`} key={index}>
                        <div className="print-routine-heading">
                          <span aria-hidden="true">□</span>
                          <FitText basePt={9} className="print-activity-subject">روتین {index === 0 ? "۱" : "۲"}</FitText>
                        </div>
                        <FitText basePt={7.5} className="print-activity-chapter">
                          {routine.subject ? `درس: ${routine.subject}` : "درس: انتخاب نشده"}
                        </FitText>
                        <FitText basePt={7} className="print-activity-last">
                          {routine.details || "توضیحی ثبت نشده"}
                        </FitText>
                      </div>
                    ))}
                  </article>
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
