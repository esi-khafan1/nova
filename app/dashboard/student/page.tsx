import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { updateStudentProfile } from "@/app/dashboard/actions";
export default async function StudentDashboard({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["student"]),
    params = await searchParams;
  const [{ count: requests }, { data: application }] = await Promise.all([
    supabase
      .from("consultation_requests")
      .select("id", { count: "exact", head: true })
      .eq("student_id", profile.id),
    supabase
      .from("counselor_profiles")
      .select("approval_status")
      .eq("user_id", profile.id)
      .maybeSingle(),
  ]);
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
        <Link className="button button-small" href="/dashboard/apply-counselor">
          درخواست مشاورشدن
        </Link>
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
          <span>وضعیت مشاورشدن</span>
          <strong>
            {application?.approval_status === "pending"
              ? "در انتظار بررسی"
              : application?.approval_status === "rejected"
                ? "نیازمند اصلاح"
                : "ارسال نشده"}
          </strong>
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
            <button className="button">ذخیره تغییرات</button>
          </form>
        </section>
        <section className="portal-card portal-empty">
          <div className="portal-empty-icon">✦</div>
          <h2>هنوز برنامه‌ای ثبت نشده</h2>
          <p>
            در مرحله بعد، درخواست مشاوره و برنامه‌های هفتگی تو اینجا نمایش داده
            می‌شوند.
          </p>
        </section>
      </div>
    </DashboardShell>
  );
}
