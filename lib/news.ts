import { createClient } from "@/lib/supabase/server";
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

export async function getPublishedNews(limit?: number) {
  const supabase = await createClient();
  let query = supabase
    .from("konkur_news")
    .select("*")
    .eq("status", "published")
    .order("source_published_at", { ascending: false })
    .order("published_at", { ascending: false })
    .order("id", { ascending: false });
  if (limit !== undefined) query = query.limit(limit);
  const { data, error } = await query;
  return { news: (data ?? []) as KonkurNews[], error: Boolean(error) };
}

export async function getPublishedNewsItem(id: string) {
  if (
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id)
  )
    return null;
  const supabase = await createClient();
  const { data } = await supabase
    .from("konkur_news")
    .select("*")
    .eq("id", id)
    .eq("status", "published")
    .maybeSingle();
  return data as KonkurNews | null;
}
