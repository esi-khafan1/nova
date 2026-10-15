import Image from "next/image";
import Link from "next/link";
import {
  extractContentText,
  findFirstImage,
  formatPersianDate,
  parseContent,
} from "@/lib/content";
import type { PublishedNewsListItem } from "@/lib/news";

export function NewsArchiveCard({
  news,
  priority = false,
}: {
  news: PublishedNewsListItem;
  priority?: boolean;
}) {
  const document = parseContent(news.body);
  const image = findFirstImage(document);
  const summary =
    news.summary || `${extractContentText(document).slice(0, 180)}…`;
  return (
    <Link
      className="mag-card news-archive-card"
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
          priority={priority}
          sizes="(max-width:1000px) 50vw, 33vw"
        />
      ) : (
        <div
          className="mag-card-placeholder news-archive-placeholder"
          aria-hidden="true"
        >
          اخبار نووا
        </div>
      )}
      <div className="mag-card-body">
        <div className="mag-card-meta news-archive-meta">
          <span>{news.source_name}</span>
        </div>
        <h2>{news.title}</h2>
        <p className="mag-card-summary">{summary}</p>
        <div className="mag-card-footer">
          <time dateTime={news.source_published_at}>
            {formatPersianDate(news.source_published_at)}
          </time>
          <span className="mag-card-readmore"><span className="mag-desktop-label">خواندن خبر</span><span className="mag-mobile-label">متن خبر</span><span aria-hidden="true"> ←</span></span>
        </div>
      </div>
    </Link>
  );
}
