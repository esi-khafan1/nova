import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { RichContent } from "@/components/content/rich-content";
import { PodcastPlayer } from "@/components/podcast-player";
import { getPublishedPodcast } from "@/lib/podcasts";
import {
  formatPersianDate,
  parseContent,
  resourceTypeLabels,
} from "@/lib/content";
import { formatAudioDuration } from "@/lib/podcast-media";
type Props = { params: Promise<{ id: string }> };

export const revalidate = 300;
export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const p = await getPublishedPodcast((await params).id);
  return p
    ? { title: `${p.title} | پادکست نووا`, description: p.summary ?? undefined }
    : { title: "پادکست پیدا نشد | نووا" };
}
export default async function PodcastPage({ params }: Props) {
  const p = await getPublishedPodcast((await params).id);
  if (!p || !p.audio_url) notFound();
  return (
    <main className="mag-shell article-shell">
      <nav className="container mag-breadcrumb" aria-label="مسیر صفحه"><Link href="/">صفحه اصلی</Link><span aria-hidden="true">/</span><Link href="/podcasts">پادکست‌های نووا</Link></nav>
      <article className="container article-page">
        <header>
          <div className="article-topline">
          <div className="article-meta">
            <span>{resourceTypeLabels[p.resource_type]}</span>
            <span>{formatAudioDuration(p.audio_seconds)}</span>
            {p.subject && <span>{p.subject}</span>}
          </div>
          <Link className="article-back" href="/podcasts"><span aria-hidden="true">←</span><span className="mag-desktop-label">بازگشت به پادکست‌ها</span><span className="mag-mobile-label">بازگشت</span></Link>
          </div>
          <h1>{p.title}</h1>
          {p.summary && <p>{p.summary}</p>}
          <time dateTime={p.published_at ?? undefined}>
            {formatPersianDate(p.published_at)}
          </time>
        </header>
        <PodcastPlayer url={p.audio_url} title={p.title} />
        {p.is_sample && (
          <p className="podcast-sample-notice">
            این قسمت نمونه با صدای مصنوعی و تصویرسازی اختصاصی هوش مصنوعی تهیه
            شده است؛ صدای یک مشاور واقعی نیست.
          </p>
        )}
        <RichContent document={parseContent(p.body)} />
      </article>
    </main>
  );
}
