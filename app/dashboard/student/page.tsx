import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentDashboardRefresh } from "@/components/dashboard/student-dashboard-refresh";
import { StudentPlanCheckbox } from "@/components/dashboard/student-plan-checkbox";
import { StudentProgressSummary } from "@/components/dashboard/student-progress-summary";
import { requireProfile } from "@/lib/auth";
import { updateStudentProfile } from "@/app/dashboard/actions";
import { activityTypes, studyFieldLabels, weekDays } from "@/lib/study-catalog";
import {
  addDays,
  formatPersianFullDate,
  parseIsoDate,
  toIsoDate,
} from "@/lib/persian-date";
import { buildProgressScopes } from "@/lib/progress";

function tehranTodayIso() {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone: "Asia/Tehran",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date());
  const part = (type: Intl.DateTimeFormatPartTypes) =>
    parts.find((item) => item.type === type)?.value ?? "";
  return `${part("year")}-${part("month")}-${part("day")}`;
}

export default async function StudentDashboard({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["student"]),
    params = await searchParams;
  const todayIso = tehranTodayIso();
  const todayDate = parseIsoDate(todayIso);
  const { data: publishedPlans } = await supabase
    .from("weekly_plans")
    .select("id,title,week_start,notes")
    .eq("student_id", profile.id)
    .eq("status", "published")
    .order("week_start", { ascending: false });
  const currentPlan =
    (publishedPlans ?? []).find((plan) => {
      const planEnd = toIsoDate(addDays(parseIsoDate(plan.week_start), 6));
      return plan.week_start <= todayIso && todayIso <= planEnd;
    }) ?? null;
  const planIds = (publishedPlans ?? []).map((plan) => plan.id);
  const { data: allPlanItems } = planIds.length
    ? await supabase
        .from("weekly_plan_items")
        .select(
          "id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,details,sort_order",
        )
        .in("plan_id", planIds)
        .order("day_of_week")
        .order("sort_order")
    : { data: [] };
  const itemIds = (allPlanItems ?? []).map((item) => item.id);
  const { data: completions } = itemIds.length
    ? await supabase
        .from("weekly_plan_item_completions")
        .select("item_id,completed_at,completed_test_count")
        .in("item_id", itemIds)
    : { data: [] };
  const completionMap = new Map(
    (completions ?? []).map((completion) => [
      completion.item_id,
      completion.completed_at,
    ]),
  );
  const completedTestCountMap = new Map(
    (completions ?? []).map((completion) => [
      completion.item_id,
      completion.completed_test_count,
    ]),
  );
  const currentPlanStart = currentPlan
    ? parseIsoDate(currentPlan.week_start)
    : null;
  const currentDayIndex = currentPlanStart
    ? Math.round(
        (todayDate.getTime() - currentPlanStart.getTime()) /
          (24 * 60 * 60 * 1000),
      )
    : null;
  const todayPlanItems = (allPlanItems ?? []).filter(
    (item) =>
      item.plan_id === currentPlan?.id &&
      item.day_of_week === currentDayIndex,
  );
  const planStartDates = new Map(
    (publishedPlans ?? []).map((plan) => [
      plan.id,
      parseIsoDate(plan.week_start),
    ]),
  );
  const allItemsWithDates = (allPlanItems ?? []).flatMap((item) => {
    const planStart = planStartDates.get(item.plan_id);
    return planStart
      ? [
          {
            id: item.id,
            planId: item.plan_id,
            plannedDate: addDays(planStart, item.day_of_week),
            durationMinutes: item.duration_minutes,
            subject: item.subject,
            chapter: item.chapter,
            activityType: item.activity_type,
            targetTestCount: item.target_test_count,
          },
        ]
      : [];
  });
  const completedItemIds = new Set(completionMap.keys());
  const progressScopes = buildProgressScopes({
    items: allItemsWithDates,
    currentPlanId: currentPlan?.id ?? null,
    completedIds: completedItemIds,
    completedTestCounts: new Map(
      [...completedTestCountMap.entries()].map(([id, count]) => [
        id,
        count ?? 0,
      ]),
    ),
    now: todayDate,
    includeDaily: true,
  });
  return (
    <DashboardShell role="student" name={profile.full_name}>
      <StudentDashboardRefresh currentDate={todayIso} />
      <section className="portal-heading">
        <div>
          <span>پنل دانش‌آموز</span>
          <h1>سلام {profile.full_name || "دوست نووا"} 👋</h1>
          <p>اطلاعات و مسیر تحصیلی‌ات را از اینجا مدیریت کن.</p>
        </div>
      </section>
      {params.saved && (
        <div className="portal-alert success">اطلاعات پروفایل ذخیره شد.</div>
      )}
      {params.error && (
        <div className="portal-alert error">ذخیره اطلاعات انجام نشد.</div>
      )}
      <section className="portal-card student-profile-card">
        <div className="portal-card-title">
          <div>
            <span>پروفایل تحصیلی</span>
            <h2>اطلاعات پایه</h2>
          </div>
        </div>
        <form action={updateStudentProfile} className="portal-form">
          <label>
            نام و نام خانوادگی
            <input
              name="full_name"
              defaultValue={profile.full_name}
              required
              minLength={2}
            />
          </label>
          <label>
            پایه تحصیلی
            <select name="grade" defaultValue={profile.grade ?? ""}>
              <option value="">انتخاب کن</option>
              <option value="10">دهم</option>
              <option value="11">یازدهم</option>
              <option value="12">دوازدهم</option>
            </select>
          </label>
          <label>
            رشته تحصیلی
            <select
              name="study_field"
              defaultValue={profile.study_field ?? ""}
            >
              <option value="">انتخاب کن</option>
              {Object.entries(studyFieldLabels).map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </select>
          </label>
          <button className="button">ذخیره تغییرات</button>
        </form>
      </section>

      {currentPlan ? (
        <section className="student-weekly-plan student-daily-plan">
          <header>
            <div>
              <span>برنامه امروز</span>
              <h2>برنامه روزانه</h2>
            </div>
            <strong>{formatPersianFullDate(todayDate)}</strong>
          </header>
          {currentPlan.notes && <p>{currentPlan.notes}</p>}
          <div className="student-day-focus">
            <article>
              <h3>{weekDays[currentDayIndex ?? 0]}</h3>
              {todayPlanItems.length ? (
                todayPlanItems.map((item) => (
                  <div
                    className={`student-plan-item${completionMap.has(item.id) ? " completed" : ""}`}
                    key={item.id}
                  >
                    <div className="student-plan-item-main">
                      <strong>{item.subject}</strong>
                      <span>
                        {item.chapter || "مبحث آزاد"} ·{" "}
                        {activityTypes.find(
                          (activity) => activity.value === item.activity_type,
                        )?.label || "فعالیت درسی"}
                      </span>
                    </div>
                    <small>
                      {item.duration_minutes.toLocaleString("fa-IR")} دقیقه
                    </small>
                    {item.details && <p>{item.details}</p>}
                    <StudentPlanCheckbox
                      itemId={item.id}
                      defaultChecked={completionMap.has(item.id)}
                      canToggle
                      activityType={item.activity_type}
                      targetTestCount={item.target_test_count}
                      defaultCompletedTestCount={
                        completedTestCountMap.get(item.id) ?? null
                      }
                    />
                  </div>
                ))
              ) : (
                <span className="student-day-off">
                  برای امروز فعالیتی تعیین نشده است.
                </span>
              )}
            </article>
          </div>
        </section>
      ) : (
        <section className="portal-card portal-empty student-daily-empty">
          <span>برنامه امروز</span>
          <h2>برای امروز برنامه‌ای منتشر نشده</h2>
          <p>
            وقتی مشاور برای امروز فعالیتی تعیین و منتشر کند، همین‌جا نمایش داده
            می‌شود.
          </p>
        </section>
      )}

      <StudentProgressSummary
        scopes={progressScopes}
        initialScopeKey="daily"
        title="گزارش پیشرفت"
      />
    </DashboardShell>
  );
}
