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
  const dailyProgress = progressScopes.find((scope) => scope.key === "daily") ?? progressScopes[0];
  const weeklyProgress = progressScopes.find((scope) => scope.key === "weekly") ?? progressScopes[0];
  const todayPlannedMinutes = todayPlanItems.reduce(
    (sum, item) => sum + item.duration_minutes,
    0,
  );
  const todayCompletedCount = todayPlanItems.filter((item) =>
    completionMap.has(item.id),
  ).length;
  const todayProgressPercent = todayPlanItems.length
    ? Math.round((todayCompletedCount / todayPlanItems.length) * 100)
    : 0;
  const weeklyPlannedMinutes = (allPlanItems ?? [])
    .filter((item) => item.plan_id === currentPlan?.id)
    .reduce((sum, item) => sum + item.duration_minutes, 0);
  const subjectProgress = weeklyProgress.subjects.slice(0, 5).map((subject) => {
    const planned = subject.chapters.reduce(
      (sum, chapter) => sum + chapter.plannedMinutes,
      0,
    );
    const completed = subject.chapters.reduce(
      (sum, chapter) => sum + chapter.completedMinutes,
      0,
    );
    return {
      name: subject.subject,
      percent: planned ? Math.min(100, Math.round((completed / planned) * 100)) : 0,
    };
  });
  const formatMinutes = (minutes: number) => {
    const hours = Math.floor(minutes / 60);
    const rest = minutes % 60;
    if (!hours) return `${rest.toLocaleString("fa-IR")} دقیقه`;
    if (!rest) return `${hours.toLocaleString("fa-IR")} ساعت`;
    return `${hours.toLocaleString("fa-IR")} ساعت و ${rest.toLocaleString("fa-IR")} دقیقه`;
  };
  const gradeLabel = profile.grade
    ? `${Number(profile.grade).toLocaleString("fa-IR")}م`
    : "پایه ثبت نشده";

  return (
    <DashboardShell role="student" name={profile.full_name} variant="student-focus">
      <StudentDashboardRefresh currentDate={todayIso} />
      <div className="student-focus-dashboard">
        <section className="portal-heading student-focus-heading">
          <div>
            <span>پنل دانش‌آموز</span>
            <h1>سلام {profile.full_name || "دوست نووا"} <b aria-hidden="true">👋</b></h1>
            <p>{formatPersianFullDate(todayDate)} · بیا با هم برنامه امروز را جلو ببریم.</p>
          </div>
        </section>
        {params.saved && (
          <div className="portal-alert success">اطلاعات پروفایل ذخیره شد.</div>
        )}
        {params.error && (
          <div className="portal-alert error">ذخیره اطلاعات انجام نشد.</div>
        )}

        <section className="student-focus-stats" aria-label="خلاصه عملکرد">
          <article className="student-today-focus">
            <span>● تمرکز امروز</span>
            <h2>{todayPlanItems.length.toLocaleString("fa-IR")} فعالیت · {formatMinutes(todayPlannedMinutes)}</h2>
            <div>
              <p><strong>{todayCompletedCount.toLocaleString("fa-IR")} <small>/ {todayPlanItems.length.toLocaleString("fa-IR")}</small></strong><span>انجام‌شده</span></p>
              <p><strong>{todayProgressPercent.toLocaleString("fa-IR")}٪</strong><span>پیشرفت روز</span></p>
              <p><strong>{dailyProgress.targetTests.toLocaleString("fa-IR")} <small>تست</small></strong><span>هدف تست‌زنی</span></p>
            </div>
          </article>
          <article className="student-compact-stat">
            <i aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M3 12l2 2 4-4M3 6l2 2 4-4M3 18l2 2 4-4M13 6h8M13 12h8M13 18h8"/></svg></i>
            <span>زمان مطالعه این هفته</span>
            <strong>{formatMinutes(weeklyProgress.totalMinutes)}</strong>
            <small>از {formatMinutes(weeklyPlannedMinutes)} برنامه‌ریزی‌شده</small>
          </article>
          <article className="student-compact-stat">
            <i aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M9 11l3 3L22 4M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg></i>
            <span>تست‌های انجام‌شده</span>
            <strong>{weeklyProgress.completedTests.toLocaleString("fa-IR")} تست</strong>
            <small>هدف هفته: {weeklyProgress.targetTests.toLocaleString("fa-IR")} تست</small>
          </article>
          <article className="student-compact-stat">
            <i aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-7 8-7s8 3 8 7"/></svg></i>
            <span>فعالیت‌های کامل‌شده</span>
            <strong>{weeklyProgress.completedCount.toLocaleString("fa-IR")}</strong>
            <small>در برنامه هفتگی جاری</small>
          </article>
        </section>

        <section className="student-focus-main-grid">
          {currentPlan ? (
            <section className="student-weekly-plan student-daily-plan">
              <header>
                <div><span>برنامه امروز</span><h2>برنامه روزانه</h2></div>
                <strong>{formatPersianFullDate(todayDate)}</strong>
              </header>
              {currentPlan.notes && <p>{currentPlan.notes}</p>}
              <div className="student-day-focus">
                <article>
                  <h3>{weekDays[currentDayIndex ?? 0]}</h3>
                  {todayPlanItems.length ? todayPlanItems.map((item) => (
                    <div className={`student-plan-item${completionMap.has(item.id) ? " completed" : ""}`} key={item.id}>
                      <div className="student-plan-item-main">
                        <strong>{item.subject}</strong>
                        <span>{item.chapter || "مبحث آزاد"} · {activityTypes.find((activity) => activity.value === item.activity_type)?.label || "فعالیت درسی"}</span>
                      </div>
                      <small>{item.duration_minutes.toLocaleString("fa-IR")} دقیقه</small>
                      {item.details && <p>{item.details}</p>}
                      <StudentPlanCheckbox itemId={item.id} defaultChecked={completionMap.has(item.id)} canToggle activityType={item.activity_type} targetTestCount={item.target_test_count} defaultCompletedTestCount={completedTestCountMap.get(item.id) ?? null} />
                    </div>
                  )) : <span className="student-day-off">برای امروز فعالیتی تعیین نشده است.</span>}
                </article>
              </div>
            </section>
          ) : (
            <section className="portal-card portal-empty student-daily-empty">
              <span>برنامه امروز</span><h2>برای امروز برنامه‌ای منتشر نشده</h2>
              <p>وقتی مشاور برای امروز فعالیتی تعیین و منتشر کند، همین‌جا نمایش داده می‌شود.</p>
            </section>
          )}

          <aside className="student-focus-side">
            <section className="portal-card student-week-progress-card">
              <div className="portal-card-title"><div><span>گزارش پیشرفت</span><h2>پیشرفت این هفته</h2></div></div>
              <div className="student-progress-overview">
                <p><span>فعالیت‌های انجام‌شده</span><strong>{weeklyProgress.completedCount.toLocaleString("fa-IR")}</strong></p>
                <div><i style={{ width: `${weeklyPlannedMinutes ? Math.min(100, Math.round((weeklyProgress.totalMinutes / weeklyPlannedMinutes) * 100)) : 0}%` }} /></div>
              </div>
              <div className="student-subject-progress">
                {subjectProgress.length ? subjectProgress.map((subject) => (
                  <div key={subject.name}><strong>{subject.name}</strong><span><i style={{ width: `${subject.percent}%` }} /></span><small>{subject.percent.toLocaleString("fa-IR")}٪</small></div>
                )) : <p>هنوز گزارشی برای این هفته ثبت نشده است.</p>}
              </div>
            </section>

            <section className="portal-card student-profile-card">
              <div className="portal-card-title"><div><span>پروفایل تحصیلی</span><h2>اطلاعات پایه</h2></div><small>{gradeLabel}</small></div>
              <form action={updateStudentProfile} className="portal-form">
                <label>نام و نام خانوادگی<input name="full_name" defaultValue={profile.full_name} required minLength={2} /></label>
                <label>پایه تحصیلی<select name="grade" defaultValue={profile.grade ?? ""}><option value="">انتخاب کن</option><option value="10">دهم</option><option value="11">یازدهم</option><option value="12">دوازدهم</option></select></label>
                <label>رشته تحصیلی<select name="study_field" defaultValue={profile.study_field ?? ""}><option value="">انتخاب کن</option>{Object.entries(studyFieldLabels).map(([value, label]) => <option key={value} value={value}>{label}</option>)}</select></label>
                <button className="button">ذخیره تغییرات</button>
              </form>
            </section>
          </aside>
        </section>
      <StudentProgressSummary
        scopes={progressScopes}
        initialScopeKey="daily"
        title="گزارش پیشرفت"
      />
      </div>
    </DashboardShell>
  );
}
