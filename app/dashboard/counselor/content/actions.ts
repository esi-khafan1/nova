"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import {
  extractContentText,
  parseContent,
  type ResourceType,
} from "@/lib/content";

export type ContentActionState = {
  error?: string;
};

const allowedTypes = new Set<ResourceType>(["konkur", "final_exam"]);

function value(formData: FormData, key: string) {
  return String(formData.get(key) ?? "").trim();
}

export async function saveResourceAction(
  _previousState: ContentActionState,
  formData: FormData,
): Promise<ContentActionState> {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const id = value(formData, "id");
  const title = value(formData, "title");
  const summary = value(formData, "summary");
  const subject = value(formData, "subject");
  const resourceType = value(formData, "resourceType") as ResourceType;
  const gradeValue = value(formData, "grade");
  const body = value(formData, "body");
  const intent = value(formData, "intent");
  const status = intent === "publish" ? "published" : "draft";

  if (title.length < 3 || title.length > 160) {
    return { error: "عنوان باید بین ۳ تا ۱۶۰ نویسه باشد." };
  }
  if (summary.length > 400) {
    return { error: "خلاصه باید حداکثر ۴۰۰ نویسه باشد." };
  }
  if (!allowedTypes.has(resourceType)) {
    return { error: "دسته‌بندی محتوا معتبر نیست." };
  }

  const grade = gradeValue ? Number(gradeValue) : null;
  if (grade !== null && ![10, 11, 12].includes(grade)) {
    return { error: "پایه تحصیلی معتبر نیست." };
  }

  const document = parseContent(body);
  if (extractContentText(document).length < 20) {
    return { error: "متن محتوا باید حداقل ۲۰ نویسه داشته باشد." };
  }

  const payload = {
    title,
    summary: summary || null,
    body: JSON.stringify(document),
    resource_type: resourceType,
    grade,
    subject: subject || null,
    status,
    published_at: status === "published" ? new Date().toISOString() : null,
  };

  const query = id
    ? supabase
        .from("resources")
        .update(payload)
        .eq("id", id)
        .eq("author_id", profile.id)
    : supabase.from("resources").insert({ ...payload, author_id: profile.id });

  const { error } = await query;
  if (error) {
    console.error("Unable to save counselor content", error.code);
    return { error: "ذخیره محتوا انجام نشد. دوباره تلاش کن." };
  }

  revalidatePath("/dashboard/counselor");
  revalidatePath("/dashboard/counselor/content");
  revalidatePath("/mag");
  if (id) revalidatePath(`/mag/${id}`);
  redirect("/dashboard/counselor/content?saved=1");
}

export async function archiveResourceAction(formData: FormData) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const id = value(formData, "id");
  if (!id) return;

  await supabase
    .from("resources")
    .update({ status: "archived", published_at: null })
    .eq("id", id)
    .eq("author_id", profile.id);

  revalidatePath("/dashboard/counselor");
  revalidatePath("/dashboard/counselor/content");
  revalidatePath("/mag");
}
