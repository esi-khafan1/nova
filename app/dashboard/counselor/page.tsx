import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import Link from "next/link";
export default async function CounselorDashboard() {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [
    { data: c },
    { count: resources },
    { count: requests },
    { count: students },
    { count: plans },
  ] = await Promise.all([
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
    supabase
      .from("counselor_students")
      .select("id", { count: "exact", head: true })
      .eq("counselor_id", profile.id),
    supabase
      .from("weekly_plans")
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
          <span>دانش‌آموزان من</span>
          <strong>{students ?? 0}</strong>
        </article>
        <article>
          <span>برنامه‌های ساخته‌شده</span>
          <strong>{plans ?? 0}</strong>
        </article>
      </div>
      <section className="portal-card admin-role-card">
        <div>
          <span>ابزار اصلی مشاور</span>
          <h2>برنامه هفتگی دانش‌آموز را بساز</h2>
          <p>
            دانش‌آموز را انتخاب کن و برای هر روز، ساعت، درس، فصل و نوع فعالیت را
            مشخص کن.
          </p>
        </div>
        <Link className="button" href="/dashboard/counselor/plans">
          ورود به برنامه‌ریز
        </Link>
      </section>
      <section className="portal-card portal-wide portal-empty counselor-secondary">
        <div className="portal-empty-icon">✦</div>
        <h2>{resources ?? 0} محتوای آموزشی</h2>
        <p>
          مقاله آموزشی بنویس، تصویر اضافه کن و مستقیم برای دانش‌آموزان منتشر کن.
        </p>
        <Link
          className="button button-secondary"
          href="/dashboard/counselor/content"
        >
          ورود به استودیوی محتوا
        </Link>
      </section>
    </DashboardShell>
  );
}
