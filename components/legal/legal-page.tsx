import Link from "next/link";
import { Logo } from "@/components/logo";

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
    <main className="legal-page">
      <header className="legal-header">
        <Logo />
        <Link href="/">بازگشت به صفحه اصلی ←</Link>
      </header>
      <article className="legal-card">
        <span className="legal-eyebrow">{eyebrow}</span>
        <h1>{title}</h1>
        <p className="legal-updated">آخرین به‌روزرسانی: {updated}</p>
        <div className="legal-content">{children}</div>
      </article>
      <nav className="legal-nav" aria-label="صفحات قانونی">
        <Link href="/about">درباره ما</Link>
        <Link href="/contact">تماس با ما</Link>
        <Link href="/terms">شرایط استفاده</Link>
        <Link href="/privacy">حریم خصوصی</Link>
        <Link href="/refund">لغو و بازگشت وجه</Link>
      </nav>
    </main>
  );
}
