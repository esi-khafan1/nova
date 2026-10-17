import Link from "next/link";
import Image from "next/image";
import { createClient } from "@/lib/supabase/server";
import {
  extractContentText,
  findFirstImage,
  formatPersianDate,
  parseContent,
  resourceTypeLabels,
  type ResourceType,
} from "@/lib/content";

type PublishedResource = {
  id: string;
  author_id: string;
  title: string;
  summary: string | null;
  body: string;
  resource_type: ResourceType;
  subject: string | null;
  published_at: string | null;
};

export const revalidate = 300;

export default async function MagazinePage() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("resources")
    .select(
      "id,author_id,title,summary,body,resource_type,subject,published_at",
    )
    .eq("status", "published")
    .order("published_at", { ascending: false });

  const resources = (data ?? []) as PublishedResource[];

  return (
    <main className="mag-shell mag-articles-archive">
      <section className="mag-hero">
        <div className="container">
          <div className="mag-hero-topline">
            <span className="mag-eyebrow">مجله آموزشی نووا</span>
            <Link className="mag-home" href="/"><span aria-hidden="true">←</span><span className="mag-desktop-label">بازگشت به خانه</span><span className="mag-mobile-label">بازگشت</span></Link>
          </div>
          <h1>تجربه مشاورها، برای مسیر روشن‌تر تو</h1>
          <p>
            تحلیل آزمون، روش مطالعه و نکته‌های کاربردی را مستقیم از مشاوران نووا
            بخوان.
          </p>
        </div>
      </section>

      <section className="container mag-content" aria-labelledby="mag-all-title">
        <div className="mag-list-heading"><h2 id="mag-all-title">همه مقاله‌ها</h2><span>{resources.length.toLocaleString("fa-IR")} مقاله</span></div>
        {resources.length ? (
          <div className="mag-grid">
            {resources.map((resource) => {
              const document = parseContent(resource.body);
              const image = findFirstImage(document);
              const summary =
                resource.summary ||
                `${extractContentText(document).slice(0, 150)}…`;
              return (
                <Link
                  className="mag-card"
                  href={`/mag/${resource.id}`}
                  key={resource.id}
                >
                  {image ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img alt="" loading="lazy" src={image} />
                  ) : (
                    <div className="mag-card-placeholder" aria-hidden="true">
                      <svg viewBox="0 0 64 64" fill="none" stroke="currentColor" strokeWidth="2"><path d="M32 14C22 9 12 9 6 12v40c10-3 19-1 26 4 7-5 16-7 26-4V12c-7-3-17-3-26 2ZM32 14v42M14 22l10 2M14 31l10 2M40 24l10-2M40 33l10-2" /></svg>
                    </div>
                  )}
                  <div className="mag-card-body">
                    <div className="mag-card-meta">
                      <span className={resource.resource_type === "final_exam" ? "is-school" : undefined}>{resourceTypeLabels[resource.resource_type]}</span>
                      {resource.subject && <span>{resource.subject}</span>}
                    </div>
                    <h2>{resource.title}</h2>
                    <p className="mag-card-summary">{summary}</p>
                    <div className="mag-card-footer"><time dateTime={resource.published_at ?? undefined}>{formatPersianDate(resource.published_at)}</time><span className="mag-card-readmore"><span className="mag-desktop-label">خواندن مقاله</span><span className="mag-mobile-label">بخوان</span><span aria-hidden="true"> ←</span></span></div>
                  </div>
                </Link>
              );
            })}
          </div>
        ) : (
          <div className="mag-empty">
            <Image src="/nova/mark.svg" alt="لوگوی N نووا" width={68} height={68} unoptimized />
            <h2>اولین مقاله‌ها به‌زودی منتشر می‌شوند</h2>
            <p>
              مشاوران نووا در حال آماده‌کردن محتواهای کاربردی برای تو هستند.
            </p>
          </div>
        )}
      </section>

      <footer className="mag-footer">
        <div className="container">
          <Link href="/" className="mag-footer-brand" aria-label="صفحه اصلی نووا"><Image src="/nova/mark.svg" alt="لوگوی N نووا" width={68} height={68} unoptimized /></Link>
          <p>محتوای آموزشی مستقیم از مشاوران نووا</p>
        </div>
      </footer>
    </main>
  );
}
