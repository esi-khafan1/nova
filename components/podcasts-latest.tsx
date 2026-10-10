import Link from "next/link";
import Image from "next/image";
import {
  findFirstImage,
  parseContent,
  formatPersianDate,
  resourceTypeLabels,
} from "@/lib/content";
import { formatAudioDuration } from "@/lib/podcast-media";
import type { Podcast } from "@/lib/podcasts";
export function PodcastCard({
  podcast,
  archive = false,
}: {
  podcast: Podcast;
  archive?: boolean;
}) {
  const image = findFirstImage(parseContent(podcast.body));
  return (
    <article className={archive ? "podcast-archive-item" : "nova-mag-article"}>
      <Link
        className="nova-mag-card"
        href={`/podcasts/${podcast.id}`}
        prefetch={false}
      >
        <div className="nova-mag-cover">
          {image ? (
            <Image
              src={image}
              alt=""
              fill
              unoptimized
              sizes="(max-width:700px) 100vw, 33vw"
            />
          ) : (
            <div className="nova-mag-cover-fallback" aria-hidden="true">
              ♫
            </div>
          )}
          <span className="podcast-cover-badge" aria-hidden="true">
            ▶
          </span>
        </div>
        <div className="nova-mag-body">
          <div className="nova-mag-meta">
            <span className="nova-mag-category">
              {resourceTypeLabels[podcast.resource_type]}
            </span>
            <span>{formatAudioDuration(podcast.audio_seconds)}</span>
          </div>
          <h3>{podcast.title}</h3>
          {podcast.summary && (
            <p className="nova-mag-summary">{podcast.summary}</p>
          )}
          <div className="nova-mag-card-footer">
            <time dateTime={podcast.published_at ?? undefined}>
              {formatPersianDate(podcast.published_at)}
            </time>
            <span className="nova-mag-read">
              شنیدن پادکست <span aria-hidden="true">←</span>
            </span>
          </div>
        </div>
      </Link>
    </article>
  );
}
export function PodcastsLatest({
  podcasts,
  unavailable = false,
}: {
  podcasts: Podcast[];
  unavailable?: boolean;
}) {
  return (
    <section
      id="podcasts"
      className="nova-magazine nova-magazine--warm nova-podcasts"
      aria-labelledby="nova-podcasts-title"
    >
      <div className="nova-mag-container">
        <header className="nova-mag-header">
          <div>
            <p className="nova-mag-eyebrow">چند دقیقه برای یک قدم روشن‌تر</p>
            <h2 id="nova-podcasts-title">
              آخرین <span>پادکست‌های نووا</span>
            </h2>
            <p className="nova-mag-description">
              برنامه‌ریزی، تمرکز و یادگیری؛ این بار با صدا، تصویر و متن همراه.
            </p>
          </div>
          <Link href="/podcasts" className="nova-mag-all">
            همهٔ پادکست‌ها <span aria-hidden="true">←</span>
          </Link>
        </header>
        {podcasts.length ? (
          <div className="nova-mag-layout">
            {podcasts.map((p) => (
              <PodcastCard key={p.id} podcast={p} />
            ))}
          </div>
        ) : (
          <div className="nova-mag-empty" role="status">
            <p>
              {unavailable
                ? "دریافت پادکست‌ها موقتاً ممکن نیست. کمی بعد دوباره سر بزن."
                : "اولین پادکست‌های نووا به‌زودی منتشر می‌شوند."}
            </p>
          </div>
        )}
      </div>
    </section>
  );
}
