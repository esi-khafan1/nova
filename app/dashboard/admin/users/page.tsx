import Link from "next/link";
import { UserRoleForm } from "@/components/dashboard/user-role-form";
import { StudentAccountBlockForm } from "@/components/dashboard/student-account-block-form";
import { changeStudentAccountBlock } from "@/app/dashboard/actions";
import "./users.css";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile, type AppRole } from "@/lib/auth";
import { adminUserDirectoryUrl, adminUserFilter, adminUserPageNumbers, adminUserSearch, loadAdminUserPage, parseAdminUserPage } from "@/lib/admin-user-pagination";

const roleLabels: Record<AppRole, string> = {
  student: "دانش‌آموز",
  counselor: "مشاور",
  admin: "مدیر",
  exam_designer: "طراح آزمون",
  content_manager: "مدیر محتوا",
  support_agent: "پشتیبان سایت",
};

export default async function AdminUsersPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["admin"]);
  const params = await searchParams;
  const search = adminUserSearch(params.q);
  const filter = adminUserFilter(params.filter);
  const requestedPage = parseAdminUserPage(params.page);
  const [directoryResult, {data:superAdmins,error:superAdminError}] = await Promise.all([
    loadAdminUserPage(supabase, search, requestedPage, filter).then(data => ({data, failed:false}), () => ({data:null, failed:true})),
    supabase.rpc("admin_list_super_admins"),
  ]);
  const directory = directoryResult.data;
  const superAdminIds = new Set<string>((superAdmins ?? []).map((row: { user_id: string }) => row.user_id));
  const canGrantAdmin = !superAdminError && superAdminIds.has(profile.id);

  return (
    <DashboardShell role="admin" name={profile.full_name} isSuperAdmin={canGrantAdmin}>
      <section className="portal-heading">
        <div>
          <span>مدیریت نووا</span>
          <h1>نقش‌ها و پنل‌ها</h1>
          <p>{canGrantAdmin ? "دسترسی سوپرادمین: تغییر نقش مدیرها و تعیین مدیر یا مدیر محتوا." : "نقش هر حساب را مستقیماً بین دانش‌آموز، مشاور و طراح آزمون تغییر بده."}</p>
        </div>
      </section>

      {params.updated && <div className="portal-alert success" role="status">نقش حساب با موفقیت تغییر کرد.</div>}
      {params.block && <div className="portal-alert success" role="status">{params.block === "blocked" ? "حساب مسدود شد." : "مسدودی حساب رفع شد."}</div>}
      {params.error && <div className="portal-alert error" role="alert">{params.error === "block" ? "نتیجهٔ عملیات قطعی نیست. وضعیت حساب را بررسی کن؛ اگر نیاز به بررسی دارد، دوباره عملیات را تکرار نکن." : "تغییر نقش حساب انجام نشد."}</div>}

      <section className="portal-card portal-wide">
        <div className="portal-card-title">
          <div><span>کاربران</span><h2>همه حساب‌ها</h2></div>
          {directory && <strong className="users-count">{directory.total.toLocaleString("fa-IR")} حساب</strong>}
        </div>
        <form className="users-search" method="get" action="/dashboard/admin/users">
          <label htmlFor="users-search">جست‌وجوی حساب</label>
          <div>
            <input id="users-search" type="search" name="q" maxLength={120} defaultValue={search} placeholder="نام، شماره موبایل یا ایمیل" />
            {directory?.blockControlsAvailable && <><label htmlFor="users-filter">وضعیت حساب</label>
            <select id="users-filter" name="filter" defaultValue={filter}>
              <option value="all">همهٔ حساب‌ها</option><option value="active">فعال</option><option value="blocked">مسدودشده</option>
            </select></>}
            <button className="button button-secondary" type="submit">جست‌وجو</button>
            {search && <Link href="/dashboard/admin/users" prefetch={false}>پاک کردن جست‌وجو</Link>}
          </div>
        </form>
        {directoryResult.failed || !directory ? (
          <p className="portal-alert error" role="alert">فهرست حساب‌ها دریافت نشد؛ دوباره تلاش کن.</p>
        ) : directory.total === 0 ? (
          <p className="users-empty">{search || filter !== "all" ? "حسابی با این جست‌وجو پیدا نشد." : "حسابی در این فهرست وجود ندارد."}</p>
        ) : <>
          <div className="users-list">
            {directory.rows.map((user) => (
              <article key={user.id}>
                <div className="users-list-main">
                  <span className={`role-badge ${user.role}`}>
                    {superAdminIds.has(user.id) ? "سوپرادمین" : roleLabels[user.role]}
                  </span>
                  <div>
                    <strong>{user.full_name || "کاربر نووا"}</strong> {user.blocked && <span className="user-blocked-badge">{user.block_state === "blocked" ? "مسدودشده" : "نیاز به بررسی"}</span>}
                    <small>{user.grade ? `پایه ${user.grade}` : "پایه ثبت نشده"}</small>
                  </div>
                </div>
                <span className="users-list-email" dir="ltr">{user.email || "ایمیل ثبت نشده"}</span>
                {!superAdminIds.has(user.id) && (canGrantAdmin || !["admin", "content_manager"].includes(user.role)) ? (
                  <div className="user-actions">
                    <UserRoleForm canGrantAdmin={canGrantAdmin} user={{id:user.id,full_name:user.full_name,role:user.role}} search={search} page={directory.page} filter={filter} blocked={user.blocked} />
                    {directory.blockControlsAvailable && user.role === "student" && (user.block_state === null || user.block_state === "blocked") && <StudentAccountBlockForm studentId={user.id} studentName={user.full_name} blocked={user.blocked} search={search} page={directory.page} filter={filter} action={changeStudentAccountBlock} />}
                    {directory.blockControlsAvailable && user.role === "student" && user.block_state !== null && user.block_state !== "blocked" && <small>وضعیت حساب نیاز به بررسی دارد.</small>}
                  </div>
                ) : <span className="no-action">—</span>}
              </article>
            ))}
          </div>
          <nav className="users-pagination" aria-label="صفحه‌های حساب‌ها">
            <span>نمایش {((directory.page - 1) * 10 + 1).toLocaleString("fa-IR")} تا {((directory.page - 1) * 10 + directory.rows.length).toLocaleString("fa-IR")} از {directory.total.toLocaleString("fa-IR")} حساب</span>
            <div>
              {directory.page > 1 && <Link prefetch={false} href={adminUserDirectoryUrl(search,directory.page-1,undefined,filter)}>قبلی</Link>}
              {adminUserPageNumbers(directory.page,directory.pages).map((n,i) => n === "ellipsis" ? <span key={`ellipsis-${i}`}>…</span> : <Link key={n} prefetch={false} href={adminUserDirectoryUrl(search,n,undefined,filter)} aria-current={n === directory.page ? "page" : undefined}>{n.toLocaleString("fa-IR")}</Link>)}
              {directory.page < directory.pages && <Link prefetch={false} href={adminUserDirectoryUrl(search,directory.page+1,undefined,filter)}>بعدی</Link>}
            </div>
          </nav>
        </>}
      </section>
    </DashboardShell>
  );
}
