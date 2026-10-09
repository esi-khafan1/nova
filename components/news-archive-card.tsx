import Image from "next/image";
import Link from "next/link";
import {
  extractContentText,
  findFirstImage,
  formatPersianDate,
  parseContent,
} from "@/lib/content";
import type { KonkurNews } from "@/lib/news";

export function NewsArchiveCard({
  news,
  featured = false,
}: {
  news: KonkurNews;
  featured?: boolean;
}) {
  const document = parseContent(news.body);
  const image = findFirstImage(document);
  const summary =
    news.summary || `${extractContentText(document).slice(0, 180)}…`;
  return (
    <Link
      className={`mag-card news-archive-card${featured ? " is-lead" : ""}`}
      href={`/news/${news.id}`}
      prefetch={false}
    >
      {image ? (
        <Image
          className="news-archive-cover"
          src={image}
          alt=""
          width={1280}
          height={853}
          unoptimized
          priority={featured}
          sizes={
            featured
              ? "(max-width:700px) 100vw, 560px"
              : "(max-width:700px) 100vw, 540px"
          }
        />
      ) : (
        <div
          className="mag-card-placeholder news-archive-placeholder"
          aria-hidden="true"
        >
          اخبار نووا
        </div>
      )}
      <div className="news-archive-card-body">
        <div className="mag-card-meta news-archive-meta">
          {featured && (
            <span className="news-archive-featured-label">تازه‌ترین خبر</span>
          )}
          <span>{news.source_name}</span>
          <time dateTime={news.source_published_at}>
            {formatPersianDate(news.source_published_at)}
          </time>
        </div>
        <h2>{news.title}</h2>
        <p>{summary}</p>
        <span className="mag-card-readmore news-archive-readmore">
          خواندن خبر <span aria-hidden="true">←</span>
        </span>
      </div>
    </Link>
  );
}
