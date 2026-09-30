import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";

export default async function AdminDashboard() {
  const { supabase, profile } = await requireProfile(["admin"]);
  const [{ count: users }, { count: students }, { count: counselors }] =
    await Promise.all([
      supabase.from("profiles").select("id", { count: "exact", head: true }),
      supabase
        .from("profiles")
        .select("id", { count: "exact", head: true })
        .eq("role", "student"),
      supabase
        .from("profiles")
        .select("id", { count: "exact", head: true })
        .eq("role", "counselor"),
    ]);

  return (
    <DashboardShell role="admin" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>مدیریت نووا</span>
          <h1>نمای کلی سیستم</h1>
          <p>تعداد حساب‌ها و نقش‌های فعال نووا را بررسی کن.</p>
        </div>
      </section>

      <div className="portal-stats">
        <article>
          <span>کل کاربران</span>
          <strong>{users ?? 0}</strong>
        </article>
        <article>
          <span>دانش‌آموزان</span>
          <strong>{students ?? 0}</strong>
        </article>
        <article>
          <span>مشاوران</span>
          <strong>{counselors ?? 0}</strong>
        </article>
      </div>

      <section className="portal-card admin-role-card">
        <div>
          <span>مدیریت نقش‌ها</span>
          <h2>انتخاب مشاوران با مدیر نوواست</h2>
          <p>
            در صفحه مدیریت کاربران می‌توانی هر حساب را مستقیماً به مشاور یا
            دانش‌آموز تبدیل کنی.
          </p>
        </div>
        <Link className="button button-small" href="/dashboard/admin/users">
          مدیریت کاربران
        </Link>
      </section>
    </DashboardShell>
  );
}