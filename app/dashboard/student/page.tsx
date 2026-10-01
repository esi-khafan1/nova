import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentPlanCheckbox } from "@/components/dashboard/student-plan-checkbox";
import { StudentProgressSummary } from "@/components/dashboard/student-progress-summary";
import { requireProfile } from "@/lib/auth";
import { updateStudentProfile } from "@/app/dashboard/actions";
import { activityTypes, studyFieldLabels, weekDays } from "@/lib/study-catalog";
import {
  addDays,
  formatPersianWeekRange,
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
  const [{ count: requests }, { data: publishedPlans }] = await Promise.all([
    supabase
      .from("consultation_requests")
      .select("id", { count: "exact", head: true })
      .eq("student_id", profile.id),
    supabase
      .from("weekly_plans")
      .select("id,title,week_start,notes")
      .eq("student_id", profile.id)
      .eq("status", "published")
      .order("week_start", { ascending: false }),
  ]);
  const currentPlan = publishedPlans?.[0] ?? null;
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
  const currentPlanItems = (allPlanItems ?? []).filter(
    (item) => item.plan_id === currentPlan?.id,
  );
  const todayIso = tehranTodayIso();
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
  });
  const grade = profile.grade
    ? `پایه ${profile.grade === 10 ? "دهم" : profile.grade === 11 ? "یازدهم" : "دوازدهم"}`
    : "پایه مشخص نشده";
  return (
    <DashboardShell role="student" name={profile.full_name}>
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
      <div className="portal-stats">
        <article>
          <span>پایه تحصیلی</span>
          <strong>{grade}</strong>
        </article>
        <article>
          <span>درخواست‌های مشاوره</span>
          <strong>{requests ?? 0}</strong>
        </article>
        <article>
          <span>نوع حساب</span>
          <strong>دانش‌آموز</strong>
        </article>
      </div>
      <div className="portal-grid">
        <section className="portal-card">
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
              شماره تماس
              <input
                name="phone"
                dir="ltr"
                defaultValue={profile.phone ?? ""}
                placeholder="09..."
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
        {!currentPlan && (
          <section className="portal-card portal-empty">
            <div className="portal-empty-icon">✦</div>
            <h2>هنوز برنامه‌ای منتشر نشده</h2>
            <p>
              وقتی مشاور برنامه هفتگی را منتشر کند، زمان درس‌ها و فعالیت‌ها
              همین‌جا نمایش داده می‌شوند.
            </p>
          </section>
        )}
      </div>

      {currentPlan && (
        <section className="student-weekly-plan">
          <header>
            <div>
              <span>برنامه فعال</span>
              <h2>{currentPlan.title}</h2>
            </div>
            <strong>{formatPersianWeekRange(currentPlan.week_start)}</strong>
          </header>
          {currentPlan.notes && <p>{currentPlan.notes}</p>}
          <div className="student-week-grid">
            {weekDays.map((day, dayIndex) => {
              const dayItems = currentPlanItems.filter(
                (item) => item.day_of_week === dayIndex,
              );
              return (
                <article key={day}>
                  <h3>{day}</h3>
                  {dayItems.length ? (
                    dayItems.map((item) => (
                      <div
                        className={`student-plan-item${completionMap.has(item.id) ? " completed" : ""}`}
                        key={item.id}
                      >
                        <div className="student-plan-item-main">
                          <strong>{item.subject}</strong>
                          <span>
                            {item.chapter || "مبحث آزاد"} ·{" "}
                            {activityTypes.find(
                              (activity) =>
                                activity.value === item.activity_type,
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
                          canToggle={
                            toIsoDate(
                              addDays(
                                parseIsoDate(currentPlan.week_start),
                                item.day_of_week,
                              ),
                            ) === todayIso
                          }
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
                      استراحت / برنامه آزاد
                    </span>
                  )}
                </article>
              );
            })}
          </div>
        </section>
      )}

      {currentPlan && <StudentProgressSummary scopes={progressScopes} />}
    </DashboardShell>
  );
}
