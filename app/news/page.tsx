import type { Metadata } from "next";
import Link from "next/link";
import { Logo } from "@/components/logo";
import { NewsArchiveCard } from "@/components/news-archive-card";
import { getPublishedNews } from "@/lib/news";
import "./news-archive.css";

export const metadata: Metadata = {
  title: "همهٔ خبرهای کنکور | نووا",
  description:
    "آرشیو خبرهای کنکور، اطلاعیه‌ها و تغییرات آزمون؛ همراه با تاریخ انتشار و لینک منبع.",
};

export default async function NewsPage() {
  const { news, error } = await getPublishedNews();
  return (
    <main className="mag-shell news-archive">
      <header className="mag-header">
        <div className="container mag-nav">
          <Logo />
          <nav aria-label="ناوبری اخبار">
            <Link href="/">صفحه اصلی</Link>
            <Link href="/mag">مجله نووا</Link>
            <Link href="/news" aria-current="page">
              اخبار کنکور
            </Link>
            <Link className="button button-small" href="/auth">
              ورود
            </Link>
          </nav>
        </div>
      </header>
      <section
        className="mag-hero news-archive-hero"
        aria-labelledby="news-archive-title"
      >
        <div className="container">
          <nav className="news-archive-breadcrumb" aria-label="مسیر صفحه">
            <Link href="/#konkur-news">صفحه اصلی</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">اخبار کنکور</span>
          </nav>
          <span>اتاق خبر نووا</span>
          <h1 id="news-archive-title">همهٔ خبرهای کنکور</h1>
          <p>
            از اطلاعیه‌های آزمون تا تغییرات سوابق تحصیلی؛ خبرهای مهم را اینجا،
            همراه با تاریخ انتشار و منبع اصلی بخوان.
          </p>
          <Link className="news-archive-back" href="/#konkur-news">
            <span aria-hidden="true">→</span> بازگشت به صفحه اصلی
          </Link>
        </div>
      </section>
      <section
        className="container mag-content"
        aria-labelledby="news-archive-list-title"
      >
        <div className="news-archive-list-heading">
          <h2 id="news-archive-list-title">جدیدترین خبرها</h2>
          {!error && (
            <p>
              {news.length.toLocaleString("fa-IR")} خبر منتشرشده{" "}
              <span aria-hidden="true">·</span> جدیدترین در ابتدا
            </p>
          )}
        </div>
        {error ? (
          <div className="mag-empty" role="status">
            <h2>خبرها فعلاً در دسترس نیستند</h2>
            <p>دریافت خبرها موقتاً ممکن نیست. کمی بعد دوباره سر بزن.</p>
          </div>
        ) : news.length ? (
          <div className="mag-grid news-archive-grid">
            {news.map((item, index) => (
              <NewsArchiveCard
                key={item.id}
                news={item}
                featured={index === 0}
              />
            ))}
          </div>
        ) : (
          <div className="mag-empty">
            <h2>اولین خبرها به‌زودی منتشر می‌شوند</h2>
            <p>خبرهای معتبر کنکور پس از انتشار در این صفحه قرار می‌گیرند.</p>
          </div>
        )}
      </section>
      <footer className="mag-footer">
        <div className="container">
          <Logo />
          <p>پیش از اقدام، آخرین اطلاعیه مرجع رسمی را بررسی کن.</p>
          <Link href="/#konkur-news">صفحه اصلی ←</Link>
        </div>
      </footer>
    </main>
  );
}
