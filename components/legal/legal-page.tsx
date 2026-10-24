import Link from "next/link";
import { LandingHeader } from "@/components/landing-header";
import "@/app/landing-approved.css";
import "./legal-page.css";

export function LegalPage({
  title,
  eyebrow,
  updated = "۱۵ مهر ۱۴۰۵",
  children,
}: {
  title: string;
  eyebrow: string;
  updated?: string;
  children: React.ReactNode;
}) {
  return (
    <div className="nova-info-page">
      <LandingHeader isAuthenticated={false} />
      <main className="legal-page">
      <nav className="legal-breadcrumb" aria-label="مسیر صفحه"><Link href="/">صفحه اصلی</Link><span aria-hidden="true">/</span><span>{title}</span></nav>
      <article className="legal-card">
        <span className="legal-eyebrow">{eyebrow}</span>
        <h1>{title}</h1>
        <p className="legal-updated">آخرین به‌روزرسانی: {updated}</p>
        <div className="legal-content">{children}</div>
      </article>
      <nav className="legal-nav" aria-label="صفحات قانونی">
        <Link href="/about">درباره ما</Link>
        <Link href="/contact">تماس با ما</Link>
        <Link href="/faq">سؤالات متداول</Link>
        <Link href="/terms">شرایط استفاده</Link>
        <Link href="/privacy">حریم خصوصی</Link>
        <Link href="/refund">لغو و بازگشت وجه</Link>
      </nav>
    </main>
    </div>
  );
}
