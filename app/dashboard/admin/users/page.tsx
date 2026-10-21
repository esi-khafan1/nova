import { UserRoleForm } from "@/components/dashboard/user-role-form";
import "./users.css";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";

type UserRow = {
  id: string;
  full_name: string;
  role: "student" | "counselor" | "exam_designer" | "admin" | "content_manager";
  grade: number | null;
  created_at: string;
  email: string | null;
};

const roleLabels = {
  student: "دانش‌آموز",
  counselor: "مشاور",
  admin: "مدیر",
  exam_designer: "طراح آزمون",
  content_manager: "مدیر محتوا",
};

export default async function AdminUsersPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["admin"]);
  const params = await searchParams;
  const { data } = await supabase.rpc("admin_list_users");
  const users = (data ?? []) as UserRow[];
  const { data: superAdmins } = await supabase.rpc("admin_list_super_admins");
  const superAdminIds = new Set<string>((superAdmins ?? []).map((row: { user_id: string }) => row.user_id));
  const canGrantAdmin = superAdminIds.has(profile.id);

  return (
    <DashboardShell role="admin" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>مدیریت نووا</span>
          <h1>مدیریت کاربران</h1>
          <p>{canGrantAdmin ? "دسترسی سوپرادمین: تغییر نقش مدیرها و تعیین مدیر یا مدیر محتوا." : "نقش هر حساب را مستقیماً بین دانش‌آموز، مشاور و طراح آزمون تغییر بده."}</p>
        </div>
      </section>

      {params.updated && (
        <div className="portal-alert success">
          نقش حساب با موفقیت تغییر کرد.
        </div>
      )}
      {params.error && (
        <div className="portal-alert error">تغییر نقش حساب انجام نشد.</div>
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
                  {superAdminIds.has(user.id) ? "سوپرادمین" : roleLabels[user.role]}
                </span>
                <div>
                  <strong>{user.full_name || "کاربر نووا"}</strong>
                  <small>
                    {user.grade ? `پایه ${user.grade}` : "پایه ثبت نشده"}
                  </small>
                </div>
              </div>
              <span className="users-list-email" dir="ltr">
                {user.email || "ایمیل ثبت نشده"}
              </span>

              {!superAdminIds.has(user.id) && (canGrantAdmin || !["admin", "content_manager"].includes(user.role)) ? (
                <UserRoleForm canGrantAdmin={canGrantAdmin} user={{id:user.id,full_name:user.full_name,role:user.role}} />
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