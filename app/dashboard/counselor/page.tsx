import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
export default async function CounselorDashboard() {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data: c }, { count: resources }, { count: requests }] =
    await Promise.all([
      supabase
        .from("counselor_profiles")
        .select("headline,specialty,is_accepting")
        .eq("user_id", profile.id)
        .single(),
      supabase
        .from("resources")
        .select("id", { count: "exact", head: true })
        .eq("author_id", profile.id),
      supabase
        .from("consultation_requests")
        .select("id", { count: "exact", head: true })
        .eq("counselor_id", profile.id),
    ]);
  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>پنل مشاور</span>
          <h1>{c?.headline || "مشاور نووا"}</h1>
          <p>{c?.specialty || "تخصص هنوز تکمیل نشده"}</p>
        </div>
        <span className={`availability ${c?.is_accepting ? "active" : ""}`}>
          {c?.is_accepting ? "پذیرش فعال" : "پذیرش غیرفعال"}
        </span>
      </section>
      <div className="portal-stats">
        <article>
          <span>درخواست‌های مشاوره</span>
          <strong>{requests ?? 0}</strong>
        </article>
        <article>
          <span>محتوای منتشرشده</span>
          <strong>{resources ?? 0}</strong>
        </article>
        <article>
          <span>وضعیت حساب</span>
          <strong>تأییدشده</strong>
        </article>
      </div>
      <section className="portal-card portal-wide portal-empty">
        <div className="portal-empty-icon">✦</div>
        <h2>پنل مشاور آماده است</h2>
        <p>مدیریت منابع و درخواست‌های دانش‌آموزان در مرحله بعد اضافه می‌شود.</p>
      </section>
    </DashboardShell>
  );
}
