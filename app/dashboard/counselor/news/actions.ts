"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { validateNews } from "@/lib/news-validation";
import type { ContentActionState } from "@/app/dashboard/counselor/content/actions";

function refreshNews(id?: string) {
  revalidatePath("/");
  revalidatePath("/news");
  revalidatePath("/sitemap.xml");
  revalidatePath("/dashboard/counselor/news");
  if (id) {
    revalidatePath(`/news/${id}`);
    revalidatePath(`/dashboard/counselor/news/${id}`);
  }
}

export async function saveNewsAction(
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
    return { error: "انتشار خبر فقط برای مشاور تأییدشده فعال است." };
  const result = validateNews(formData);
  if (!result.payload) return { error: result.error };
  const { id, payload } = result;
  let previousPublishedAt: string | null = null;
  if (id) {
    const { data, error } = await supabase
      .from("konkur_news")
      .select("published_at")
      .eq("id", id)
      .eq("author_id", profile.id)
      .maybeSingle();
    if (error || !data)
      return { error: "خبر پیدا نشد یا اجازه ویرایش آن را نداری." };
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
        .from("konkur_news")
        .update(values)
        .eq("id", id)
        .eq("author_id", profile.id)
    : supabase.from("konkur_news").insert({ ...values, author_id: profile.id });
  const { data, error } = await query.select("id").single();
  if (error || !data) return { error: "ذخیره خبر انجام نشد. دوباره تلاش کن." };
  refreshNews(data.id);
  redirect("/dashboard/counselor/news?saved=1");
}

export async function archiveNewsAction(formData: FormData) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const id = String(formData.get("id") ?? "").trim();
  if (!id) return;
  const { data, error } = await supabase
    .from("konkur_news")
    .update({ status: "archived", published_at: null })
    .eq("id", id)
    .eq("author_id", profile.id)
    .select("id")
    .single();
  if (error || !data) redirect("/dashboard/counselor/news?error=archive");
  refreshNews(id);
  redirect("/dashboard/counselor/news?saved=1");
}
