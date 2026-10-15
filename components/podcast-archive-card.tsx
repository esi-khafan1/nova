import Link from "next/link";
import Image from "next/image";
import { findFirstImage, parseContent, formatPersianDate, resourceTypeLabels } from "@/lib/content";
import { formatAudioDuration } from "@/lib/podcast-media";
import type { Podcast } from "@/lib/podcasts";

export function PodcastArchiveCard({ podcast }: { podcast: Podcast }) {
  const image = findFirstImage(parseContent(podcast.body));
  return (
    <Link className="mag-card" href={`/podcasts/${podcast.id}`} prefetch={false}>
      <div className="podcast-archive-cover">
        {image ? <Image src={image} alt="" fill unoptimized sizes="(max-width:1000px) 50vw, 33vw" /> : <div className="mag-card-placeholder" aria-hidden="true">♫</div>}
        <span className="podcast-cover-badge" aria-hidden="true">▶</span>
      </div>
      <div className="mag-card-body">
        <div className="mag-card-meta"><span>{resourceTypeLabels[podcast.resource_type]}</span><span>{formatAudioDuration(podcast.audio_seconds)}</span></div>
        <h2>{podcast.title}</h2>
        {podcast.summary && <p className="mag-card-summary">{podcast.summary}</p>}
        <div className="mag-card-footer">
          <time dateTime={podcast.published_at ?? undefined}>{formatPersianDate(podcast.published_at)}</time>
          <span className="mag-card-readmore">شنیدن پادکست <span aria-hidden="true">←</span></span>
        </div>
      </div>
    </Link>
  );
}
