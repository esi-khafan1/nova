import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";

export default async function AdminDashboard() {
  const { supabase, profile } = await requireProfile(["admin"]);
  const [{ data: counts, error: countsError }, {data:superAdmins}] = await Promise.all([
    supabase.rpc("admin_dashboard_counts").single<{users:number;students:number;counselors:number}>(),
    supabase.rpc("admin_list_super_admins"),
  ]);
  const isSuperAdmin = Boolean(superAdmins?.some((row: {user_id:string})=>row.user_id===profile.id));
  const {users,students,counselors}=counts??{};

  return (
    <DashboardShell role="admin" name={profile.full_name}>
      <section className="portal-card"><h2>خدمات دانش‌آموزان</h2><p>اطلاعات و فیش را بررسی کن و با اختصاص مشاور، حساب را فعال کن.</p><Link className="button" href="/dashboard/admin/registrations">ورود به خدمات دانش‌آموزان</Link></section>
      {isSuperAdmin && <section className="portal-card"><h2>دوره‌ها</h2><Link className="button" href="/dashboard/admin/courses">مدیریت دوره‌ها</Link></section>}
      <section className="portal-heading">
        <div>
          <span>مدیریت نووا</span>
          <h1>نمای کلی سیستم</h1>
          <p>تعداد حساب‌ها و نقش‌های فعال نووا را بررسی کن.</p>
        </div>
      </section>

      {countsError&&<p className="portal-alert error" role="alert">آمار فعلاً دریافت نشد؛ صفحه را دوباره باز کن.</p>}
      <div className="portal-stats">
        <article>
          <span>کل کاربران</span>
          <strong>{users ?? "—"}</strong>
        </article>
        <article>
          <span>دانش‌آموزان</span>
          <strong>{students ?? "—"}</strong>
        </article>
        <article>
          <span>مشاوران</span>
          <strong>{counselors ?? "—"}</strong>
        </article>
      </div>

      <section className="portal-card admin-role-card">
        <div>
          <span>نقش‌ها و پنل‌ها</span>
          <h2>انتخاب مشاوران با مدیر نوواست</h2>
          <p>
            در بخش نقش‌ها و پنل‌ها می‌توانی نقش هر حساب را تغییر بدهی و پنل متناسب با آن را تعیین کنی.
          </p>
        </div>
        <Link className="button button-small" href="/dashboard/admin/users">
          نقش‌ها و پنل‌ها
        </Link>
      </section>
    </DashboardShell>
  );
}