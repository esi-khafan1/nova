import Link from "next/link";
import { Logo } from "@/components/logo";
import { signOut } from "@/app/dashboard/actions";
import type { AppRole } from "@/lib/auth";
const labels: Record<AppRole, string> = {
  student: "دانش‌آموز",
  counselor: "مشاور",
  admin: "مدیر",
};
export function DashboardShell({
  role,
  name,
  children,
}: {
  role: AppRole;
  name: string;
  children: React.ReactNode;
}) {
  return (
    <div className="portal-shell">
      <aside className="portal-sidebar">
        <Logo />
        <div className="portal-user">
          <div className="portal-avatar">{(name || "ن").slice(0, 1)}</div>
          <div>
            <strong>{name || "کاربر نووا"}</strong>
            <span>{labels[role]}</span>
          </div>
        </div>
        <nav className="portal-nav">
          <Link href={`/dashboard/${role}`}>نمای کلی</Link>
          {role === "student" && (
            <Link href="/dashboard/apply-counselor">درخواست مشاورشدن</Link>
          )}
          {role === "admin" && (
            <Link href="/dashboard/admin/users">مدیریت کاربران</Link>
          )}
          <Link href="/">مشاهده سایت</Link>
        </nav>
        <form action={signOut}>
          <button className="portal-signout">خروج از حساب</button>
        </form>
      </aside>
      <main className="portal-main">
        <header className="portal-mobile-header">
          <Logo />
          <span>{labels[role]}</span>
        </header>
        {children}
      </main>
    </div>
  );
}
