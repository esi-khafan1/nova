import Link from "next/link";
import Image from "next/image";
import { findFirstImage, formatPersianDate, parseContent } from "@/lib/content";
import type { KonkurNews } from "@/lib/news";

export function NewsCard({ news }: { news: KonkurNews }) {
  const image = findFirstImage(parseContent(news.body));
  return (
    <article className="nova-mag-article">
      <Link
        className="nova-mag-card"
        href={`/news/${news.id}`}
        prefetch={false}
      >
        <div className="nova-mag-cover">
          {image ? (
            <Image
              src={image}
              alt=""
              fill
              unoptimized
              sizes="(max-width:700px) 100vw, 360px"
            />
          ) : (
            <div className="nova-mag-cover-fallback" aria-hidden="true">
              <svg
                viewBox="0 0 64 64"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <rect x="10" y="10" width="44" height="44" rx="4" />
                <path d="M18 20h28M18 28h12v12H18zM36 28h10M36 36h10M18 46h28" />
              </svg>
            </div>
          )}
        </div>
        <div className="nova-mag-body">
          <div className="nova-mag-meta">
            <span className="nova-mag-category">خبر کنکور</span>
            <span className="nova-news-source">{news.source_name}</span>
          </div>
          <h3>{news.title}</h3>
          {news.summary && <p className="nova-mag-summary">{news.summary}</p>}
          <div className="nova-mag-card-footer">
            <time dateTime={news.source_published_at}>
              {formatPersianDate(news.source_published_at)}
            </time>
            <span className="nova-mag-read">
              متن خبر <span aria-hidden="true">←</span>
            </span>
          </div>
        </div>
      </Link>
    </article>
  );
}

export function KonkurNewsLatest({
  news,
  unavailable = false,
}: {
  news: KonkurNews[];
  unavailable?: boolean;
}) {
  return (
    <section
      id="konkur-news"
      className="nova-magazine nova-magazine--warm nova-konkur-news"
      aria-labelledby="nova-news-title"
    >
      <div className="nova-mag-container">
        <header className="nova-mag-header">
          <div>
            <p className="nova-mag-eyebrow">خبرهای مهم، از منابع معتبر</p>
            <h2 id="nova-news-title">
              آخرین <span>خبرهای کنکور</span>
            </h2>
            <p className="nova-mag-description">
              اطلاعیه‌ها و تغییرات کنکور؛ با تاریخ انتشار و لینک منبع هر خبر.
            </p>
          </div>
          <Link href="/news" className="nova-mag-all">
            همهٔ خبرها <span aria-hidden="true">←</span>
          </Link>
        </header>
        {news.length ? (
          <div className="nova-mag-layout">
            {news.map((item) => (
              <NewsCard key={item.id} news={item} />
            ))}
          </div>
        ) : (
          <div className="nova-mag-empty">
            <p>
              {unavailable
                ? "دریافت خبرها موقتاً ممکن نیست. کمی بعد دوباره سر بزن."
                : "خبرهای تازه کنکور به‌زودی اینجا منتشر می‌شوند."}
            </p>
          </div>
        )}
      </div>
    </section>
  );
}
