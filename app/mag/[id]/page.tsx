import { cache } from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
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

const getArticle = cache(async (id: string) => {
  if (!/^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i.test(id)) return null;
  const supabase = await createClient();
  // Both operations are public-only and derive visibility from the article ID.
  // Metadata and the page reuse this result within the same React request.
  const [{data},{data:authors}]=await Promise.all([
    supabase.from("resources")
      .select("id,author_id,title,summary,body,resource_type,grade,subject,published_at")
      .eq("id",id).eq("status","published").single(),
    supabase.rpc("published_article_author",{target_resource_id:id}),
  ]);
  if (!data) return null;
  // Profiles stay private; the RPC exposes only the published author name.
  const author = (authors as { full_name: string | null }[] | null)?.[0] ?? null;

  return { article: data as Article, author };
});

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
      <nav className="container mag-breadcrumb" aria-label="مسیر صفحه"><Link href="/">صفحه اصلی</Link><span aria-hidden="true">/</span><Link href="/mag">مجله نووا</Link></nav>

      <article className="container article-page">
        <header>
          <div className="article-topline">
            <div className="article-meta">
              <span>{resourceTypeLabels[article.resource_type]}</span>
              {article.grade && <span>پایه {article.grade}</span>}
              {article.subject && <span>{article.subject}</span>}
            </div>
            <Link className="article-back" href="/mag">
              <span aria-hidden="true">← </span><span className="mag-desktop-label">بازگشت به مجله</span><span className="mag-mobile-label">بازگشت</span>
            </Link>
          </div>
          <h1>{article.title}</h1>
          {article.summary && <p>{article.summary}</p>}
          <div className="article-byline">
            {author?.full_name && <div>{author.full_name.slice(0, 1)}</div>}
            <span>
              {author?.full_name && <strong>{author.full_name}</strong>}
              <small>{formatPersianDate(article.published_at)}</small>
            </span>
          </div>
        </header>

        <RichContent document={parseContent(article.body)} />

        {author?.full_name && (
          <aside className="article-author" aria-label="نویسنده مقاله">
            <div>{author.full_name.slice(0, 1)}</div>
            <div><h2>{author.full_name}</h2></div>
          </aside>
        )}
      </article>
    </main>
  );
}
