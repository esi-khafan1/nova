import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import { NewsArchiveCard } from "@/components/news-archive-card";
import { getPublishedNews } from "@/lib/news";

export const metadata: Metadata = {
  title: "همهٔ خبرهای کنکور | نووا",
  description:
    "آرشیو خبرهای کنکور، اطلاعیه‌ها و تغییرات آزمون؛ همراه با تاریخ انتشار و لینک منبع.",
};

export default async function NewsPage() {
  const { news, error } = await getPublishedNews();
  return (
    <main className="mag-shell news-archive">
      <section
        className="mag-hero"
        aria-labelledby="news-archive-title"
      >
        <div className="container">
          <div className="mag-hero-topline">
            <span className="mag-eyebrow">اتاق خبر نووا</span>
            <Link className="mag-home" href="/#konkur-news"><span aria-hidden="true">←</span><span className="mag-desktop-label">بازگشت به خانه</span><span className="mag-mobile-label">بازگشت</span></Link>
          </div>
          <h1 id="news-archive-title">همهٔ خبرهای کنکور</h1>
          <p>
            از اطلاعیه‌های آزمون تا تغییرات سوابق تحصیلی؛ خبرهای مهم را اینجا،
            همراه با تاریخ انتشار و منبع اصلی بخوان.
          </p>
        </div>
      </section>
      <section
        className="container mag-content"
        aria-labelledby="news-archive-list-title"
      >
        <div className="mag-list-heading">
          <h2 id="news-archive-list-title">جدیدترین خبرها</h2>
          {!error && (
            <span>
              {news.length.toLocaleString("fa-IR")} خبر منتشرشده{" "}
              <span aria-hidden="true">·</span> جدیدترین در ابتدا
            </span>
          )}
        </div>
        {error ? (
          <div className="mag-empty" role="status">
            <h2>خبرها فعلاً در دسترس نیستند</h2>
            <p>دریافت خبرها موقتاً ممکن نیست. کمی بعد دوباره سر بزن.</p>
          </div>
        ) : news.length ? (
          <div className="mag-grid">
            {news.map((item, index) => (
              <NewsArchiveCard
                key={item.id}
                news={item}
                priority={index === 0}
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
          <Link href="/" className="mag-footer-brand" aria-label="صفحه اصلی نووا"><Image src="/nova/mark.svg" alt="لوگوی N نووا" width={68} height={68} unoptimized /></Link>
          <p>پیش از اقدام، آخرین اطلاعیه مرجع رسمی را بررسی کن.</p>
          <Link href="/#konkur-news">صفحه اصلی ←</Link>
        </div>
      </footer>
    </main>
  );
}
