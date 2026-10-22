import {performanceEnabled} from "@/lib/performance/access";
import {measurePerformance} from "@/lib/performance/trace";
import {ServerPerformanceReport} from "@/components/performance/server-performance-report";
import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";

export default async function AdminDashboard() {
  const { supabase, profile } = await requireProfile(["admin"]);
  const [{ count: users }, { count: students }, { count: counselors }] =
    await measurePerformance("admin_counts_parallel",()=>Promise.all([
      supabase.from("profiles").select("id", { count: "exact", head: true }),
      supabase
        .from("profiles")
        .select("id", { count: "exact", head: true })
        .eq("role", "student"),
      supabase
        .from("profiles")
        .select("id", { count: "exact", head: true })
        .eq("role", "counselor"),
    ]));

  const diagnostic=await measurePerformance("debug_access",()=>performanceEnabled(supabase));
  return (
    <DashboardShell role="admin" name={profile.full_name}>
      <section className="portal-card"><h2>ثبت‌نام و فعال‌سازی دانش‌آموزها</h2><p>اطلاعات و فیش را بررسی کن و با اختصاص مشاور، حساب را فعال کن.</p><Link className="button" href="/dashboard/admin/registrations">بررسی ثبت‌نام‌ها و تخصیص مشاور</Link></section>
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
      <p><Link href="/dashboard/performance" prefetch={false}>تشخیص موقت کندی</Link></p>
      {diagnostic&&<ServerPerformanceReport route="/dashboard/admin"/>}
    </DashboardShell>
  );
}