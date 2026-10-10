import { createClient } from "@/lib/supabase/server";
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
export async function getPublishedPodcasts(limit?: number) {
  const supabase = await createClient();
  let query = supabase
    .from("podcasts")
    .select("*")
    .eq("status", "published")
    .order("published_at", { ascending: false })
    .order("id", { ascending: false });
  if (limit !== undefined) query = query.limit(limit);
  const { data, error } = await query;
  return { podcasts: (data ?? []) as Podcast[], error: Boolean(error) };
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
