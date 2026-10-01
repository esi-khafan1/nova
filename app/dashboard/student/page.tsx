import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { StudentPlanCheckbox } from "@/components/dashboard/student-plan-checkbox";
import {
  StudentProgressSummary,
  type ProgressScope,
} from "@/components/dashboard/student-progress-summary";
import { requireProfile } from "@/lib/auth";
import { updateStudentProfile } from "@/app/dashboard/actions";
import {
  activityTypes,
  studyFieldLabels,
  weekDays,
} from "@/lib/study-catalog";
import {
  addDays,
  formatPersianWeekRange,
  parseIsoDate,
  samePersianMonth,
} from "@/lib/persian-date";

type AnalyticsItem = {
  id: string;
  plan_id: string;
  day_of_week: number;
  duration_minutes: number;
  subject: string;
  chapter: string | null;
  activity_type: string;
};

const studyActivities = new Set([
  "lesson",
  "notes",
  "review",
  "homework",
  "summary",
]);

function summarizeProgress(
  key: ProgressScope["key"],
  label: string,
  items: AnalyticsItem[],
): ProgressScope {
  const subjects = new Map<
    string,
    { minutes: number; chapters: Set<string> }
  >();
  let totalMinutes = 0;
  let studyMinutes = 0;
  let testMinutes = 0;

  for (const item of items) {
    totalMinutes += item.duration_minutes;
    if (studyActivities.has(item.activity_type))
      studyMinutes += item.duration_minutes;
    if (item.activity_type === "practice_tests")
      testMinutes += item.duration_minutes;

    const subject = subjects.get(item.subject) ?? {
      minutes: 0,
      chapters: new Set<string>(),
    };
    subject.minutes += item.duration_minutes;
    if (item.chapter) subject.chapters.add(item.chapter);
    subjects.set(item.subject, subject);
  }

  return {
    key,
    label,
    completedCount: items.length,
    totalMinutes,
    studyMinutes,
    testMinutes,
    subjects: [...subjects.entries()]
      .map(([subject, data]) => ({
        subject,
        minutes: data.minutes,
        chapters: [...data.chapters],
      }))
      .sort((first, second) => second.minutes - first.minutes),
  };
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
          "id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,details,sort_order",
        )
        .in("plan_id", planIds)
        .order("day_of_week")
        .order("sort_order")
    : { data: [] };
  const itemIds = (allPlanItems ?? []).map((item) => item.id);
  const { data: completions } = itemIds.length
    ? await supabase
        .from("weekly_plan_item_completions")
        .select("item_id,completed_at")
        .in("item_id", itemIds)
    : { data: [] };
  const completionMap = new Map(
    (completions ?? []).map((completion) => [
      completion.item_id,
      completion.completed_at,
    ]),
  );
  const currentPlanItems = (allPlanItems ?? []).filter(
    (item) => item.plan_id === currentPlan?.id,
  );
  const planStartDates = new Map(
    (publishedPlans ?? []).map((plan) => [
      plan.id,
      parseIsoDate(plan.week_start),
    ]),
  );
  const completedItems = (allPlanItems ?? []).filter((item) =>
    completionMap.has(item.id),
  ) as AnalyticsItem[];
  const now = new Date();
  const monthlyCompletedItems = completedItems.filter((item) => {
    const planStart = planStartDates.get(item.plan_id);
    if (!planStart) return false;
    return samePersianMonth(addDays(planStart, item.day_of_week), now);
  });
  const weeklyCompletedItems = completedItems.filter(
    (item) => item.plan_id === currentPlan?.id,
  );
  const progressScopes: ProgressScope[] = [
    summarizeProgress("weekly", "هفتگی", weeklyCompletedItems),
    summarizeProgress("monthly", "ماهانه", monthlyCompletedItems),
    summarizeProgress("all", "کلی", completedItems),
  ];
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
                        />
                      </div>
                    ))
                  ) : (
                    <span className="student-day-off">استراحت / برنامه آزاد</span>
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
