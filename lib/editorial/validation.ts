import { validateNews, validDocument } from "@/lib/news-validation";
import { validatePodcast } from "@/lib/podcast-validation";
import { extractContentText } from "@/lib/content";
import type { EditorialKind, EditorialPayload } from "./types";

export function validateEditorial(kind: EditorialKind, form: FormData): { payload?: EditorialPayload; error?: string } {
 if (kind === "news" || kind === "podcasts") {
  const result = kind === "news" ? validateNews(form) : validatePodcast(form);
  return result.payload ? { payload: result.payload as EditorialPayload } : { error: result.error ?? "اطلاعات معتبر نیست." };
 }
 const val = (key: string) => String(form.get(key) ?? "").trim();
 const title=val("title"), summary=val("summary"), body=val("body"), grade=val("grade"), subject=val("subject"), type=val("resourceType");
 if (title.length<3 || title.length>160 || summary.length>400 || subject.length>100 || body.length>500000) return {error:"عنوان، خلاصه یا متن بیش از حد کوتاه یا طولانی است."};
 if (!["konkur","final_exam"].includes(type) || !["","10","11","12"].includes(grade)) return {error:"دسته‌بندی یا پایه معتبر نیست."};
 try {
  const document: unknown=JSON.parse(body);
  if (!validDocument(document) || document.type!=="doc" || extractContentText(document).length<20) return {error:"متن معتبر با حداقل ۲۰ نویسه بنویس."};
 } catch { return {error:"ساختار متن معتبر نیست."}; }
 return {payload:{title,summary:summary||null,body,resource_type:type as "konkur"|"final_exam",grade:grade?Number(grade):null,subject:subject||null}};
}
