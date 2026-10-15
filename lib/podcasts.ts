import { createPublicClient } from "@/lib/supabase/server";
import type { ContentStatus, ResourceType } from "@/lib/content";

export type Podcast = {
  id: string;
  author_id: string | null;
  title: string;
  summary: string | null;
  body: string;
  resource_type: ResourceType;
  subject: string | null;
  grade: number | null;
  status: ContentStatus;
  audio_url: string | null;
  audio_seconds: number | null;
  is_sample: boolean;
  published_at: string | null;
  updated_at: string;
};

export type PublishedPodcastListItem = Pick<
  Podcast,
  "id" | "title" | "summary" | "body" | "resource_type" | "audio_seconds" | "published_at"
>;

export async function getPublishedPodcasts(limit?: number, offset = 0) {
  const supabase = createPublicClient();
  let query = supabase
    .from("podcasts")
    .select("id,title,summary,body,resource_type,audio_seconds,published_at")
    .eq("status", "published")
    .order("published_at", { ascending: false })
    .order("id", { ascending: false });
  if (limit !== undefined) query = query.range(offset, offset + limit);
  const { data, error } = await query;
  const rows = (data ?? []) as PublishedPodcastListItem[];
  return {
    podcasts: limit === undefined ? rows : rows.slice(0, limit),
    hasMore: limit !== undefined && rows.length > limit,
    error: Boolean(error),
  };
}

export async function getPublishedPodcast(id: string) {
  if (
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id)
  )
    return null;
  const supabase = await createClient();
  const { data } = await supabase
    .from("podcasts")
    .select("*")
    .eq("id", id)
    .eq("status", "published")
    .maybeSingle();
  return data as Podcast | null;
}
