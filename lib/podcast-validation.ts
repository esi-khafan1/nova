import { extractContentText } from "./content";
import { validDocument } from "./news-validation";
import { isSafePodcastAudioUrl } from "./podcast-media";
export function validatePodcast(formData: FormData) {
  const value = (key: string) => String(formData.get(key) ?? "").trim();
  const id = value("id"),
    title = value("title"),
    summary = value("summary"),
    body = value("body");
  const intent = value("intent"),
    audio = value("audioUrl"),
    seconds = value("audioSeconds"),
    subject = value("subject"),
    type = value("resourceType"),
    grade = value("grade");
  const fail = (error: string) => ({ id, error, payload: null });
  if (
    id &&
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id)
  )
    return fail("شناسه پادکست معتبر نیست.");
  if (!["draft", "publish"].includes(intent))
    return fail("عملیات ذخیره معتبر نیست.");
  if (title.length < 3 || title.length > 160)
    return fail("عنوان باید بین ۳ تا ۱۶۰ نویسه باشد.");
  if (summary.length > 400 || subject.length > 100)
    return fail("خلاصه یا موضوع بیش از حد طولانی است.");
  if (
    !["konkur", "final_exam"].includes(type) ||
    !["", "10", "11", "12"].includes(grade)
  )
    return fail("دسته‌بندی یا پایه معتبر نیست.");
  if (audio && !isSafePodcastAudioUrl(audio))
    return fail("ویس را از بخش بارگذاری فایل صوتی آپلود کن.");
  if (intent === "publish" && !audio)
    return fail("برای انتشار پادکست، یک ویس بارگذاری کن.");
  if (
    seconds &&
    (!/^\d+$/.test(seconds) ||
      Number(seconds) < 1 ||
      Number(seconds) > 10800 ||
      !audio)
  )
    return fail("مدت فایل صوتی معتبر نیست (حداکثر سه ساعت).");
  if (body.length > 500000) return fail("متن پادکست بیش از حد طولانی است.");
  let doc: unknown;
  try {
    doc = JSON.parse(body);
  } catch {
    return fail("ساختار متن پادکست معتبر نیست.");
  }
  if (
    !validDocument(doc) ||
    doc.type !== "doc" ||
    extractContentText(doc).length < 20
  )
    return fail("متن معتبر با حداقل ۲۰ نویسه بنویس.");
  return {
    id,
    error: null,
    payload: {
      title,
      summary: summary || null,
      body: JSON.stringify(doc),
      subject: subject || null,
      grade: grade ? Number(grade) : null,
      resource_type: type,
      audio_url: audio || null,
      audio_seconds: seconds ? Number(seconds) : null,
      status:
        intent === "publish" ? ("published" as const) : ("draft" as const),
    },
  };
}
