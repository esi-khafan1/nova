"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { validatePodcast } from "@/lib/podcast-validation";
import type { ContentActionState } from "@/app/dashboard/counselor/content/actions";

function refreshPodcasts(id?: string) {
  revalidatePath("/");
  revalidatePath("/podcasts");
  revalidatePath("/sitemap.xml");
  revalidatePath("/dashboard/counselor/podcasts");
  if (id) {
    revalidatePath(`/podcasts/${id}`);
    revalidatePath(`/dashboard/counselor/podcasts/${id}`);
  }
}

export async function savePodcastAction(
  _previousState: ContentActionState,
  formData: FormData,
): Promise<ContentActionState> {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const { data: counselor } = await supabase
    .from("counselor_profiles")
    .select("approval_status")
    .eq("user_id", profile.id)
    .maybeSingle();
  if (counselor?.approval_status !== "approved")
    return { error: "انتشار پادکست فقط برای مشاور تأییدشده فعال است." };
  const result = validatePodcast(formData);
  if (!result.payload) return { error: result.error };
  const { id, payload } = result;
  let previousPublishedAt: string | null = null;
  if (id) {
    const { data, error } = await supabase
      .from("podcasts")
      .select("published_at")
      .eq("id", id)
      .eq("author_id", profile.id)
      .maybeSingle();
    if (error || !data)
      return { error: "پادکست پیدا نشد یا اجازه ویرایش آن را نداری." };
    previousPublishedAt = data.published_at;
  }
  const values = {
    ...payload,
    published_at:
      payload.status === "published"
        ? (previousPublishedAt ?? new Date().toISOString())
        : null,
  };
  const query = id
    ? supabase
        .from("podcasts")
        .update(values)
        .eq("id", id)
        .eq("author_id", profile.id)
    : supabase.from("podcasts").insert({ ...values, author_id: profile.id });
  const { data, error } = await query.select("id").single();
  if (error || !data)
    return { error: "ذخیره پادکست انجام نشد. دوباره تلاش کن." };
  refreshPodcasts(data.id);
  redirect("/dashboard/counselor/podcasts?saved=1");
}

export async function archivePodcastAction(formData: FormData) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const id = String(formData.get("id") ?? "").trim();
  if (!id) return;
  const { data, error } = await supabase
    .from("podcasts")
    .update({ status: "archived", published_at: null })
    .eq("id", id)
    .eq("author_id", profile.id)
    .select("id")
    .single();
  if (error || !data) redirect("/dashboard/counselor/podcasts?error=archive");
  refreshPodcasts(id);
  redirect("/dashboard/counselor/podcasts?saved=1");
}
