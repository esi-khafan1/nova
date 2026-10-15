import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import { PodcastArchiveCard } from "@/components/podcast-archive-card";
import { getPublishedPodcasts } from "@/lib/podcasts";

export const metadata: Metadata = {
  title: "همهٔ پادکست‌های نووا | نووا",
  description: "پادکست‌های آموزشی نووا؛ همراه با ویس، تصویر و متن.",
};

export default async function PodcastsPage({ searchParams }: { searchParams: Promise<{ page?: string }> }) {
  const params = await searchParams;
  const parsedPage = Number(params.page ?? "1");
  const page = Number.isInteger(parsedPage) && parsedPage > 0 ? parsedPage : 1;
  const pageSize = 24;
  const { podcasts, hasMore, error } = await getPublishedPodcasts(pageSize, (page - 1) * pageSize);
  return (
    <main className="mag-shell">
      <section
        className="mag-hero"
        aria-labelledby="news-archive-title"
      >
        <div className="container">
          <div className="mag-hero-topline">
            <span className="mag-eyebrow">صدای نووا</span>
            <Link className="mag-home" href="/#podcasts"><span aria-hidden="true">←</span><span className="mag-desktop-label">بازگشت به خانه</span><span className="mag-mobile-label">بازگشت</span></Link>
          </div>
          <h1 id="news-archive-title">همهٔ پادکست‌های نووا</h1>
          <p>
            پادکست‌های کوتاه آموزشی را بشنو؛ همراه با متن، تصویر و ایده‌های
            کاربردی برای مسیر مطالعه.
          </p>
        </div>
      </section>
      <section
        className="container mag-content"
        aria-labelledby="news-archive-list-title"
      >
        <div className="mag-list-heading">
          <h2 id="news-archive-list-title">جدیدترین پادکست‌ها</h2>
          {!error && (
            <span>
              {podcasts.length.toLocaleString("fa-IR")} پادکست در این صفحه{" "}
              <span aria-hidden="true">·</span> جدیدترین در ابتدا
            </span>
          )}
        </div>
        {error ? (
          <div className="mag-empty" role="status">
            <h2>پادکست‌ها فعلاً در دسترس نیستند</h2>
            <p>دریافت پادکست‌ها موقتاً ممکن نیست. کمی بعد دوباره سر بزن.</p>
          </div>
        ) : podcasts.length ? (
          <div className="mag-grid">
            {podcasts.map((item) => (
              <PodcastArchiveCard key={item.id} podcast={item} />
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
          <Link href="/" className="mag-footer-brand" aria-label="صفحه اصلی نووا"><Image src="/nova/mark.svg" alt="لوگوی N نووا" width={68} height={68} unoptimized /></Link>
          <p>چند دقیقه برای برنامه‌ریزی، تمرکز و یادگیری بهتر.</p>
          <Link href="/#podcasts">صفحه اصلی ←</Link>
        </div>
      </footer>
    </main>
  );
}
