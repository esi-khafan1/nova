import { removeCounselor } from "@/app/dashboard/actions";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";

type UserRow = {
  id: string;
  full_name: string;
  role: "student" | "counselor" | "admin";
  grade: number | null;
  created_at: string;
};

const roleLabels = {
  student: "دانش‌آموز",
  counselor: "مشاور",
  admin: "مدیر",
};

export default async function AdminUsersPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["admin"]);
  const params = await searchParams;
  const { data } = await supabase
    .from("profiles")
    .select("id,full_name,role,grade,created_at")
    .order("created_at", { ascending: false });
  const users = (data ?? []) as UserRow[];

  return (
    <DashboardShell role="admin" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>مدیریت نووا</span>
          <h1>مدیریت کاربران</h1>
          <p>
            نقش کاربران را ببین و در صورت نیاز دسترسی مشاور را لغو کن.
          </p>
        </div>
      </section>

      {params.removed && (
        <div className="portal-alert success">
          دسترسی مشاور حذف شد و حساب کاربر به دانش‌آموز تغییر کرد.
        </div>
      )}
      {params.error && (
        <div className="portal-alert error">
          حذف دسترسی مشاور انجام نشد.
        </div>
      )}

      <section className="portal-card portal-wide">
        <div className="portal-card-title">
          <div>
            <span>کاربران</span>
            <h2>همه حساب‌ها</h2>
          </div>
          <strong className="users-count">{users.length} حساب</strong>
        </div>

        <div className="users-list">
          {users.map((user) => (
            <article key={user.id}>
              <div className="users-list-main">
                <span className={`role-badge ${user.role}`}>
                  {roleLabels[user.role]}
                </span>
                <div>
                  <strong>{user.full_name || "کاربر نووا"}</strong>
                  <small>
                    {user.grade ? `پایه ${user.grade}` : "پایه ثبت نشده"}
                  </small>
                </div>
              </div>

              {user.role === "counselor" ? (
                <form action={removeCounselor}>
                  <input type="hidden" name="user_id" value={user.id} />
                  <button className="remove-counselor">
                    حذف دسترسی مشاور
                  </button>
                </form>
              ) : (
                <span className="no-action">—</span>
              )}
            </article>
          ))}
        </div>
      </section>
    </DashboardShell>
  );
}