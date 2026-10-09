import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Logo } from "@/components/logo";
import { RichContent } from "@/components/content/rich-content";
import { getPublishedNewsItem } from "@/lib/news";
import { formatPersianDate, parseContent } from "@/lib/content";

type Props = { params: Promise<{ id: string }> };
export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const item = await getPublishedNewsItem((await params).id);
  return item
    ? {
        title: `${item.title} | اخبار کنکور نووا`,
        description: item.summary ?? undefined,
      }
    : { title: "خبر پیدا نشد | نووا" };
}
export default async function NewsItemPage({ params }: Props) {
  const item = await getPublishedNewsItem((await params).id);
  if (!item) notFound();
  return (
    <main className="mag-shell article-shell">
      <header className="mag-header">
        <div className="container mag-nav">
          <Logo />
          <nav aria-label="ناوبری اخبار">
            <Link href="/">صفحه اصلی</Link>
            <Link href="/news">اخبار کنکور</Link>
            <Link href="/mag">مجله نووا</Link>
          </nav>
        </div>
      </header>
      <article className="container article-page">
        <Link className="article-back" href="/news">
          بازگشت به خبرها
        </Link>
        <header>
          <div className="article-meta">
            <span>خبر کنکور</span>
            <span>{item.source_name}</span>
          </div>
          <h1>{item.title}</h1>
          {item.summary && <p>{item.summary}</p>}
          <p>
            تاریخ انتشار در منبع:{" "}
            <time dateTime={item.source_published_at}>
              {formatPersianDate(item.source_published_at)}
            </time>
          </p>
        </header>
        <RichContent document={parseContent(item.body)} />
        <aside className="article-author">
          <div aria-hidden="true">↗</div>
          <div>
            <span>منبع خبر</span>
            <h2>{item.source_name}</h2>
            <p>
              <a
                href={item.source_url}
                target="_blank"
                rel="noopener noreferrer"
              >
                خواندن خبر در منبع اصلی ←
              </a>
            </p>
            <p>
              این خبر مربوط به تاریخ درج‌شده است؛ پیش از اقدام، آخرین اطلاعیه
              سازمان سنجش یا مرجع رسمی را بررسی کن.
            </p>
          </div>
        </aside>
      </article>
    </main>
  );
}
