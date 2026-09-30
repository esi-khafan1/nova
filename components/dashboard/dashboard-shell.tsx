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
  const links = [
    { href: `/dashboard/${role}`, label: "نمای کلی" },
    ...(role === "counselor"
      ? [
          {
            href: "/dashboard/counselor/plans",
            label: "برنامه‌های هفتگی",
          },
        ]
      : []),
    ...(role === "admin"
      ? [{ href: "/dashboard/admin/users", label: "مدیریت کاربران" }]
      : []),
    { href: "/", label: "مشاهده سایت" },
  ];

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
          {links.map((link) => (
            <Link key={link.href} href={link.href}>
              {link.label}
            </Link>
          ))}
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
        <nav className="portal-mobile-nav" aria-label="ناوبری پنل">
          {links.map((link) => (
            <Link key={link.href} href={link.href}>
              {link.label}
            </Link>
          ))}
          <form action={signOut}>
            <button>خروج</button>
          </form>
        </nav>
        {children}
      </main>
    </div>
  );
}
