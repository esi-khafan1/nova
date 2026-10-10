import type { Metadata } from "next";
import Link from "next/link";
import { Logo } from "@/components/logo";
import { PodcastCard } from "@/components/podcasts-latest";
import { getPublishedPodcasts } from "@/lib/podcasts";
import "../news/news-archive.css";
import "../magazine-latest.css";
import "./podcasts.css";

export const metadata: Metadata = {
  title: "همهٔ پادکست‌های نووا | نووا",
  description: "پادکست‌های آموزشی نووا؛ همراه با ویس، تصویر و متن.",
};

export default async function PodcastsPage() {
  const { podcasts, error } = await getPublishedPodcasts();
  return (
    <main className="mag-shell news-archive podcast-archive nova-magazine--warm">
      <header className="mag-header">
        <div className="container mag-nav">
          <Logo />
          <nav aria-label="ناوبری پادکست">
            <Link href="/">صفحه اصلی</Link>
            <Link href="/mag">مجله نووا</Link>
            <Link href="/podcasts" aria-current="page">
              پادکست‌های نووا
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
            <Link href="/#podcasts">صفحه اصلی</Link>
            <span aria-hidden="true">/</span>
            <span aria-current="page">پادکست‌های نووا</span>
          </nav>
          <span>صدای نووا</span>
          <h1 id="news-archive-title">همهٔ پادکست‌های نووا</h1>
          <p>
            پادکست‌های کوتاه آموزشی را بشنو؛ همراه با متن، تصویر و ایده‌های
            کاربردی برای مسیر مطالعه.
          </p>
          <Link className="news-archive-back" href="/#podcasts">
            <span aria-hidden="true">→</span> بازگشت به صفحه اصلی
          </Link>
        </div>
      </section>
      <section
        className="container mag-content"
        aria-labelledby="news-archive-list-title"
      >
        <div className="news-archive-list-heading">
          <h2 id="news-archive-list-title">جدیدترین پادکست‌ها</h2>
          {!error && (
            <p>
              {podcasts.length.toLocaleString("fa-IR")} پادکست منتشرشده{" "}
              <span aria-hidden="true">·</span> جدیدترین در ابتدا
            </p>
          )}
        </div>
        {error ? (
          <div className="mag-empty" role="status">
            <h2>پادکست‌ها فعلاً در دسترس نیستند</h2>
            <p>دریافت پادکست‌ها موقتاً ممکن نیست. کمی بعد دوباره سر بزن.</p>
          </div>
        ) : podcasts.length ? (
          <div className="podcast-archive-grid">
            {podcasts.map((item) => (
              <PodcastCard key={item.id} podcast={item} archive />
            ))}
          </div>
        ) : (
          <div className="mag-empty">
            <h2>اولین پادکست‌ها به‌زودی منتشر می‌شوند</h2>
            <p>پادکست‌های آموزشی پس از انتشار اینجا قرار می‌گیرند.</p>
          </div>
        )}
      </section>
      <footer className="mag-footer">
        <div className="container">
          <Logo />
          <p>چند دقیقه برای برنامه‌ریزی، تمرکز و یادگیری بهتر.</p>
          <Link href="/#podcasts">صفحه اصلی ←</Link>
        </div>
      </footer>
    </main>
  );
}
