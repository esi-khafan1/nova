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
      <section className="portal-card cp-report-cta"><div><span className="sp-eyebrow">تصویر کامل مسیر دانش‌آموز</span><h2>برنامه، گزارش و مسیر مطالعه</h2><p>گزارش روزها و هفته‌های قبل، میزان تحقق فعالیت‌ها، ساعت مطالعه و تعداد تست هر درس و فصل را ببین.</p></div><Link className="button" href="/dashboard/counselor/students">دانش‌آموزان و گزارش‌ها</Link></section>
      <div className="portal-stats">
        <article>
          <span>درخواست‌های مشاوره</span>
          <strong>{(requests ?? 0).toLocaleString("fa-IR")}</strong>
        </article>
        <article>
          <span>دانش‌آموزان من</span>
          <strong>{(students ?? 0).toLocaleString("fa-IR")}</strong>
        </article>
        <article>
          <span>برنامه‌های ساخته‌شده</span>
          <strong>{(plans ?? 0).toLocaleString("fa-IR")}</strong>
        </article>
      </div>
      <section className="portal-card admin-role-card">
        <div>
          <span>ابزار اصلی مشاور</span>
          <h2>برنامه هفتگی دانش‌آموز را بساز</h2>
          <p>
            دانش‌آموز را انتخاب کن و برای هر روز، مدت، درس، فصل و نوع فعالیت را
            مشخص کن.
          </p>
        </div>
        <Link className="button" href="/dashboard/counselor/plans">
          ورود به برنامه‌ریز
        </Link>
      </section>
      <section className="portal-card portal-wide portal-empty counselor-secondary">
        <div className="portal-empty-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6"><path d="M5 3h14v18H5zM8 7h8M8 11h8M8 15h5"/></svg></div>
        <h2>{(resources ?? 0).toLocaleString("fa-IR")} محتوای آموزشی</h2>
        <p>
          مقاله آموزشی بنویس، تصویر اضافه کن و برای بررسی مدیر محتوا بفرست.
        </p>
        <Link
          className="button button-secondary"
          href="/dashboard/counselor/content"
        >
          ورود به استودیوی محتوا
        </Link>
      </section>
      <section className="portal-card portal-empty counselor-secondary">
        <div className="portal-empty-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6"><path d="M5 3h14v18H5zM8 7h8M8 11h8M8 15h8M8 18h4"/></svg></div>
        <h2>اخبار کنکور</h2>
        <p>خبر معتبر را همراه با لینک منبع و تاریخ انتشار برای دانش‌آموزان بنویس.</p>
        <Link className="button button-secondary" href="/dashboard/counselor/news">مدیریت و نوشتن اخبار کنکور</Link>
      </section>
    <section className="portal-card portal-empty counselor-secondary"><div className="portal-empty-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6"><rect x="9" y="3" width="6" height="12" rx="3"/><path d="M5 11v1a7 7 0 0 0 14 0v-1M12 19v3M8 22h8"/></svg></div><h2>پادکست‌های نووا</h2><p>محتوای آموزشی را با تصویر، متن و ویس برای بررسی مدیر محتوا بفرست.</p><Link className="button button-secondary" href="/dashboard/counselor/podcasts">مدیریت و ساخت پادکست</Link></section>
    </DashboardShell>
  );
}
