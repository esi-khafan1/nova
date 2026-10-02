import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Logo } from "@/components/logo";
import { RichContent } from "@/components/content/rich-content";
import { createClient } from "@/lib/supabase/server";
import {
  formatPersianDate,
  parseContent,
  resourceTypeLabels,
  type ResourceType,
} from "@/lib/content";

type Article = {
  id: string;
  author_id: string;
  title: string;
  summary: string | null;
  body: string;
  resource_type: ResourceType;
  grade: number | null;
  subject: string | null;
  published_at: string | null;
};

async function getArticle(id: string) {
  const supabase = await createClient();
  const { data } = await supabase
    .from("resources")
    .select(
      "id,author_id,title,summary,body,resource_type,grade,subject,published_at",
    )
    .eq("id", id)
    .eq("status", "published")
    .single();
  if (!data) return null;

  const { data: author } = await supabase
    .from("profiles")
    .select("full_name,bio")
    .eq("id", data.author_id)
    .single();

  return { article: data as Article, author };
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const result = await getArticle(id);
  if (!result) return { title: "محتوا پیدا نشد | نووا" };
  return {
    title: `${result.article.title} | مجله نووا`,
    description: result.article.summary ?? "مقاله آموزشی از مشاوران نووا",
  };
}

export default async function ArticlePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const result = await getArticle(id);
  if (!result) notFound();

  const { article, author } = result;
  return (
    <main className="mag-shell article-shell">
      <header className="mag-header">
        <div className="container mag-nav">
          <Logo />
          <nav aria-label="ناوبری مجله">
            <Link href="/">صفحه اصلی</Link>
            <Link href="/mag">مجله نووا</Link>
            <Link className="button button-small" href="/auth">
              ورود
            </Link>
          </nav>
        </div>
      </header>

      <article className="container article-page">
        <Link className="article-back" href="/mag">
          بازگشت به مجله
        </Link>
        <header>
          <div className="article-meta">
            <span>{resourceTypeLabels[article.resource_type]}</span>
            {article.grade && <span>پایه {article.grade}</span>}
            {article.subject && <span>{article.subject}</span>}
          </div>
          <h1>{article.title}</h1>
          {article.summary && <p>{article.summary}</p>}
          <div className="article-byline">
            <div>{(author?.full_name || "ن").slice(0, 1)}</div>
            <span>
              <strong>{author?.full_name || "مشاور نووا"}</strong>
              <small>{formatPersianDate(article.published_at)}</small>
            </span>
          </div>
        </header>

        <RichContent document={parseContent(article.body)} />

        <aside className="article-author">
          <div>{(author?.full_name || "ن").slice(0, 1)}</div>
          <div>
            <span>نویسنده</span>
            <h2>{author?.full_name || "مشاور نووا"}</h2>
            <p>
              {author?.bio ||
                "مشاور تحصیلی نووا؛ همراه دانش‌آموزان برای ساختن مسیر روشن‌تر."}
            </p>
          </div>
        </aside>
      </article>
    </main>
  );
}
