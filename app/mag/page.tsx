import Link from "next/link";
import { Logo } from "@/components/logo";
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
    <main className="mag-shell">
      <header className="mag-header">
        <div className="container mag-nav">
          <Logo />
          <nav aria-label="ناوبری مجله">
            <Link href="/">صفحه اصلی</Link>
            <Link aria-current="page" href="/mag">
              مجله نووا
            </Link>
            <Link className="button button-small" href="/auth">
              ورود
            </Link>
          </nav>
        </div>
      </header>

      <section className="mag-hero">
        <div className="container">
          <span>مجله آموزشی نووا</span>
          <h1>تجربه مشاورها، برای مسیر روشن‌تر تو</h1>
          <p>
            تحلیل آزمون، روش مطالعه و نکته‌های کاربردی را مستقیم از مشاوران نووا
            بخوان.
          </p>
        </div>
      </section>

      <section className="container mag-content">
        {resources.length ? (
          <div className="mag-grid">
            {resources.map((resource, index) => {
              const document = parseContent(resource.body);
              const image = findFirstImage(document);
              const summary =
                resource.summary ||
                `${extractContentText(document).slice(0, 150)}…`;
              return (
                <article
                  className={`mag-card ${index === 0 ? "featured" : ""}`}
                  key={resource.id}
                >
                  {image ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img alt="" loading="lazy" src={image} />
                  ) : (
                    <div className="mag-card-placeholder" aria-hidden="true">
                      ن
                    </div>
                  )}
                  <div>
                    <div className="mag-card-meta">
                      <span>{resourceTypeLabels[resource.resource_type]}</span>
                      {resource.subject && <span>{resource.subject}</span>}
                      <time>{formatPersianDate(resource.published_at)}</time>
                    </div>
                    <h2>{resource.title}</h2>
                    <p>{summary}</p>
                    <Link href={`/mag/${resource.id}`}>خواندن مقاله ←</Link>
                  </div>
                </article>
              );
            })}
          </div>
        ) : (
          <div className="mag-empty">
            <span>ن</span>
            <h2>اولین مقاله‌ها به‌زودی منتشر می‌شوند</h2>
            <p>
              مشاوران نووا در حال آماده‌کردن محتواهای کاربردی برای تو هستند.
            </p>
          </div>
        )}
      </section>

      <footer className="mag-footer">
        <div className="container">
          <Logo />
          <p>محتوای آموزشی مستقیم از مشاوران نووا</p>
        </div>
      </footer>
    </main>
  );
}
