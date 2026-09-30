import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { updateStudentProfile } from "@/app/dashboard/actions";
import {
  activityTypes,
  studyFieldLabels,
  weekDays,
} from "@/lib/study-catalog";
export default async function StudentDashboard({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["student"]),
    params = await searchParams;
  const [{ count: requests }, { data: currentPlan }] = await Promise.all([
    supabase
      .from("consultation_requests")
      .select("id", { count: "exact", head: true })
      .eq("student_id", profile.id),
    supabase
      .from("weekly_plans")
      .select("id,title,week_start,notes")
      .eq("student_id", profile.id)
      .eq("status", "published")
      .order("week_start", { ascending: false })
      .limit(1)
      .maybeSingle(),
  ]);
  const { data: planItems } = currentPlan
    ? await supabase
        .from("weekly_plan_items")
        .select(
          "id,day_of_week,start_time,duration_minutes,subject,chapter,activity_type,details,sort_order",
        )
        .eq("plan_id", currentPlan.id)
        .order("day_of_week")
        .order("sort_order")
    : { data: [] };
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
            <strong>هفته {currentPlan.week_start}</strong>
          </header>
          {currentPlan.notes && <p>{currentPlan.notes}</p>}
          <div className="student-week-grid">
            {weekDays.map((day, dayIndex) => {
              const dayItems = (planItems ?? []).filter(
                (item) => item.day_of_week === dayIndex,
              );
              return (
                <article key={day}>
                  <h3>{day}</h3>
                  {dayItems.length ? (
                    dayItems.map((item) => (
                      <div className="student-plan-item" key={item.id}>
                        <div>
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
                          {item.start_time?.slice(0, 5) || "شناور"} ·{" "}
                          {item.duration_minutes} دقیقه
                        </small>
                        {item.details && <p>{item.details}</p>}
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
    </DashboardShell>
  );
}
