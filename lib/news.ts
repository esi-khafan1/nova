import { unstable_cache } from "next/cache";
import { createPublicClient } from "@/lib/supabase/server";
import type { ContentStatus } from "@/lib/content";

export type KonkurNews = {
  id: string;
  author_id: string | null;
  title: string;
  summary: string | null;
  body: string;
  source_name: string;
  source_url: string;
  source_published_at: string;
  published_at: string | null;
  updated_at: string;
  status: ContentStatus;
};

export type PublishedNewsListItem = Pick<
  KonkurNews,
  "id" | "title" | "summary" | "body" | "source_name" | "source_published_at" | "published_at"
>;

const queryPublishedNews = unstable_cache(
  async (limit?: number, offset = 0) => {
    const supabase = createPublicClient();
    let query = supabase
      .from("konkur_news")
      .select("id,title,summary,body,source_name,source_published_at,published_at")
      .eq("status", "published")
      .order("source_published_at", { ascending: false })
      .order("published_at", { ascending: false })
      .order("id", { ascending: false });
    if (limit !== undefined) query = query.range(offset, offset + limit);
    const { data, error } = await query;
    const rows = (data ?? []) as PublishedNewsListItem[];
    return {
      news: limit === undefined ? rows : rows.slice(0, limit),
      hasMore: limit !== undefined && rows.length > limit,
      error: Boolean(error),
    };
  },
  ["published-news-v1"],
  { revalidate: 60, tags: ["published-news"] },
);

export async function getPublishedNews(limit?: number, offset = 0) {
  return queryPublishedNews(limit, offset);
}

const queryPublishedNewsItem = unstable_cache(
  async (id: string) => {
    const supabase = createPublicClient();
    const { data } = await supabase
      .from("konkur_news")
      .select("*")
      .eq("id", id)
      .eq("status", "published")
      .maybeSingle();
    return data as KonkurNews | null;
  },
  ["published-news-item-v1"],
  { revalidate: 300, tags: ["published-news"] },
);

export async function getPublishedNewsItem(id: string) {
  if (
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id)
  ) return null;
  return queryPublishedNewsItem(id);
}
