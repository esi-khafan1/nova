import Link from "next/link";
import Image from "next/image";
import { findFirstImage, formatPersianDate, parseContent, resourceTypeLabels, type ResourceType } from "@/lib/content";

export type MagazineDesign = "cards" | "sky" | "warm" | "navy";
export type LatestResource = { id: string; title: string; summary: string | null; body: string; resource_type: ResourceType; subject: string | null; published_at: string | null };

function Cover({ resource }: { resource: LatestResource }) {
  const image = findFirstImage(parseContent(resource.body));
  return <div className="nova-mag-cover">{image ? <Image src={image} alt="" fill unoptimized sizes="(max-width:700px) 100vw, (max-width:1100px) 50vw, 600px" /> : <div className="nova-mag-cover-fallback" aria-hidden="true"><svg viewBox="0 0 64 64" fill="none" stroke="currentColor" strokeWidth="2"><path d="M32 14C22 9 12 9 6 12v40c10-3 19-1 26 4 7-5 16-7 26-4V12c-7-3-17-3-26 2ZM32 14v42M14 22l10 2M14 31l10 2M40 24l10-2M40 33l10-2" /></svg></div>}</div>;
}

function ResourceCard({ resource }: { resource: LatestResource }) {
  const date = formatPersianDate(resource.published_at);
  return <article className="nova-mag-article">
    <Link className="nova-mag-card" href={`/mag/${resource.id}`} prefetch={false}>
      <Cover resource={resource} />
      <div className="nova-mag-body">
        <div className="nova-mag-meta"><span className={`nova-mag-category ${resource.resource_type === "final_exam" ? "is-exam" : ""}`}>{resourceTypeLabels[resource.resource_type]}</span></div>
        <h3>{resource.title}</h3>
        {resource.summary && <p className="nova-mag-summary">{resource.summary}</p>}
        <div className="nova-mag-card-footer">{date ? <time dateTime={resource.published_at ?? undefined}>{date}</time> : <span>مجله نووا</span>}<span className="nova-mag-read">بخوان <span aria-hidden="true">←</span></span></div>
      </div>
    </Link>
  </article>;
}

export function MagazineLatest({ resources, design = "cards" }: { resources: LatestResource[]; design?: MagazineDesign }) {
  return <section id="mag" className={`nova-magazine nova-magazine--${design}`} data-design={design} aria-labelledby="nova-magazine-title">
    <div className="nova-mag-container">
      <header className="nova-mag-header"><div><p className="nova-mag-eyebrow">برای روزهای درس و رشد</p><h2 id="nova-magazine-title">تازه‌های <span>مجله نووا</span></h2><p className="nova-mag-description">راهنماهای کاربردی برای مطالعه، برنامه‌ریزی و آمادگی آزمون.</p></div><Link href="/mag" className="nova-mag-all">همهٔ مقاله‌ها <span aria-hidden="true">←</span></Link></header>
      {resources.length ? <div className="nova-mag-layout">{resources.map(resource=><ResourceCard key={resource.id} resource={resource} />)}</div> : <div className="nova-mag-empty"><p>مقاله‌های تازه نووا به‌زودی اینجا منتشر می‌شوند.</p><Link href="/mag">رفتن به مجله <span aria-hidden="true">←</span></Link></div>}
    </div>
  </section>;
}
