import Link from "next/link";
import { Logo } from "@/components/logo";
import { signOut } from "@/app/dashboard/actions";
import type { AppRole } from "@/lib/auth";

const labels: Record<AppRole, string> = {
  student: "دانش‌آموز",
  counselor: "مشاور",
  admin: "مدیر",
};

function NavIcon({
  type,
}: {
  type: "home" | "exam" | "site" | "admin" | "plan" | "content" | "account";
}) {
  const paths = {
    home: (
      <>
        <path d="M3 11.5 12 4l9 7.5" />
        <path d="M5.5 10v9.5h13V10" />
      </>
    ),
    exam: (
      <>
        <path d="M4 5h16v4H4zM4 13h16v6H4z" />
        <path d="M8 9v4m4-4v4m4-4v4" />
      </>
    ),
    site: (
      <>
        <circle cx="12" cy="12" r="9" />
        <path d="M3 12h18M12 3c2.5 2.5 3.8 5.5 3.8 9S14.5 18.5 12 21M12 3C9.5 5.5 8.2 8.5 8.2 12S9.5 18.5 12 21" />
      </>
    ),
    admin: (
      <>
        <path d="M4 19v-7m6 7V5m6 14v-4m4 4H2" />
      </>
    ),
    plan: (
      <>
        <rect x="4" y="5" width="16" height="15" rx="2" />
        <path d="M8 3v4m8-4v4M4 10h16" />
      </>
    ),
    content: (
      <>
        <path d="M4 4h16v16H4z" />
        <path d="M8 8h8M8 12h8M8 16h5" />
      </>
    ),
    account: (
      <>
        <circle cx="12" cy="8" r="4" />
        <path d="M4.5 21a7.5 7.5 0 0 1 15 0" />
      </>
    ),
  };
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.8"
      aria-hidden="true"
    >
      {paths[type]}
    </svg>
  );
}

export function DashboardShell({
  role,
  name,
  children,
  variant = "default",
}: {
  role: AppRole;
  name: string;
  children: React.ReactNode;
  variant?: "default" | "student-focus";
}) {
  const links: {
    href: string;
    label: string;
    icon: "home" | "exam" | "site" | "admin" | "plan" | "content" | "account";
  }[] = [
    { href: `/dashboard/${role}`, label: "نمای کلی", icon: "home" },
    ...(role === "counselor"
      ? [
          {
            href: "/dashboard/counselor/plans",
            label: "برنامه‌های هفتگی",
            icon: "plan" as const,
          },
          {
            href: "/dashboard/counselor/exams",
            label: "آزمون‌ها",
            icon: "exam" as const,
          },
          {
            href: "/dashboard/counselor/content",
            label: "استودیوی محتوا",
            icon: "content" as const,
          },
        ]
      : []),
    ...(role === "student"
      ? [
          {
            href: "/dashboard/student/exams",
            label: "آزمون‌ها",
            icon: "exam" as const,
          },
          {
            href: "/dashboard/student/account",
            label: "حساب کاربری",
            icon: "account" as const,
          },
        ]
      : []),
    ...(role === "admin"
      ? [
          {
            href: "/dashboard/admin/users",
            label: "مدیریت کاربران",
            icon: "admin" as const,
          },
        ]
      : []),
    { href: "/", label: "مشاهده سایت", icon: "site" },
  ];
  const isStudentFocus = variant === "student-focus";

  return (
    <div
      className={`portal-shell${isStudentFocus ? " student-focus-shell" : ""}`}
    >
      <aside className="portal-sidebar">
        <Logo />
        <div className="portal-user">
          <div className="portal-avatar">{(name || "ن").slice(0, 1)}</div>
          <div>
            <strong>{name || "کاربر نووا"}</strong>
            <span>{labels[role]}</span>
          </div>
        </div>
        <nav className="portal-nav" aria-label="ناوبری پنل">
          {isStudentFocus && <span className="portal-nav-label">پنل</span>}
          {links.map((link, index) => (
            <Link
              className={isStudentFocus && index === 0 ? "active" : undefined}
              key={link.href}
              href={link.href}
            >
              {isStudentFocus && <NavIcon type={link.icon} />}
              {link.label}
            </Link>
          ))}
        </nav>
        <form action={signOut}>
          <button className="portal-signout">
            {isStudentFocus && (
              <svg
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.8"
                aria-hidden="true"
              >
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9" />
              </svg>
            )}
            خروج از حساب
          </button>
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
