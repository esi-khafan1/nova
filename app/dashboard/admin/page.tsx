import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { reviewCounselor } from "@/app/dashboard/actions";
import { requireProfile } from "@/lib/auth";
type Application = {
  user_id: string;
  headline: string | null;
  specialty: string | null;
  experience_years: number;
  approval_status: string;
  profiles: { full_name: string } | { full_name: string }[] | null;
};
export default async function AdminDashboard({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["admin"]),
    params = await searchParams;
  const [{ count: users }, { count: counselors }, { data }] = await Promise.all(
    [
      supabase.from("profiles").select("id", { count: "exact", head: true }),
      supabase
        .from("profiles")
        .select("id", { count: "exact", head: true })
        .eq("role", "counselor"),
      supabase
        .from("counselor_profiles")
        .select(
          "user_id,headline,specialty,experience_years,approval_status,profiles!inner(full_name)",
        )
        .order("created_at", { ascending: false }),
    ],
  );
  const pending = ((data ?? []) as unknown as Application[]).filter(
    (x) => x.approval_status === "pending",
  );
  return (
    <DashboardShell role="admin" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>مدیریت نووا</span>
          <h1>نمای کلی سیستم</h1>
          <p>کاربران و درخواست‌های همکاری را مدیریت کن.</p>
        </div>
      </section>
      {params.reviewed && (
        <div className="portal-alert success">
          وضعیت درخواست به‌روزرسانی شد.
        </div>
      )}
      {params.error && (
        <div className="portal-alert error">تغییر وضعیت انجام نشد.</div>
      )}
      <div className="portal-stats">
        <article>
          <span>کل کاربران</span>
          <strong>{users ?? 0}</strong>
        </article>
        <article>
          <span>مشاوران تأییدشده</span>
          <strong>{counselors ?? 0}</strong>
        </article>
        <article>
          <span>درخواست‌های در انتظار</span>
          <strong>{pending.length}</strong>
        </article>
      </div>
      <section className="portal-card portal-wide">
        <div className="portal-card-title">
          <div>
            <span>درخواست‌ها</span>
            <h2>متقاضیان مشاوره</h2>
          </div>
        </div>
        {pending.length === 0 ? (
          <div className="portal-table-empty">
            درخواستی برای بررسی وجود ندارد.
          </div>
        ) : (
          <div className="application-list">
            {pending.map((x) => {
              const p = Array.isArray(x.profiles) ? x.profiles[0] : x.profiles;
              return (
                <article key={x.user_id}>
                  <div>
                    <strong>{p?.full_name || "کاربر نووا"}</strong>
                    <span>{x.headline}</span>
                    <small>
                      {x.specialty} · {x.experience_years} سال سابقه
                    </small>
                  </div>
                  <form action={reviewCounselor}>
                    <input type="hidden" name="user_id" value={x.user_id} />
                    <button
                      name="decision"
                      value="approved"
                      className="review-approve"
                    >
                      تأیید
                    </button>
                    <button
                      name="decision"
                      value="rejected"
                      className="review-reject"
                    >
                      رد
                    </button>
                  </form>
                </article>
              );
            })}
          </div>
        )}
      </section>
    </DashboardShell>
  );
}
