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
  priority = false,
}: {
  news: KonkurNews;
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
          sizes="(max-width:700px) 100vw, (max-width:1000px) 50vw, 33vw"
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
