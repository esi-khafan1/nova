import { extractContentText, type ContentNode } from "./content";

export function isSafeNewsUrl(value: string) {
  try {
    const url = new URL(value);
    return (
      ["https:", "http:"].includes(url.protocol) &&
      Boolean(url.hostname) &&
      !url.username &&
      !url.password
    );
  } catch {
    return false;
  }
}

function validDocument(node: unknown, depth = 0): node is ContentNode {
  if (!node || typeof node !== "object" || depth > 30) return false;
  const item = node as ContentNode;
  if (
    typeof item.type !== "string" ||
    ![
      "doc",
      "paragraph",
      "text",
      "heading",
      "bulletList",
      "orderedList",
      "listItem",
      "blockquote",
      "hardBreak",
      "horizontalRule",
      "image",
      "codeBlock",
    ].includes(item.type)
  )
    return false;
  if (item.text !== undefined && typeof item.text !== "string") return false;
  if (item.type === "text" && typeof item.text !== "string") return false;
  if (item.type !== "text" && item.text !== undefined) return false;
  if (
    ["text", "image", "hardBreak", "horizontalRule"].includes(item.type) &&
    item.content !== undefined
  )
    return false;
  if (
    item.attrs !== undefined &&
    (!item.attrs || typeof item.attrs !== "object" || Array.isArray(item.attrs))
  )
    return false;
  if (
    item.type === "image" &&
    (typeof item.attrs?.src !== "string" || !isSafeNewsUrl(item.attrs.src))
  )
    return false;
  if (item.marks !== undefined) {
    if (
      !Array.isArray(item.marks) ||
      item.marks.some(
        (mark) =>
          !mark ||
          typeof mark !== "object" ||
          typeof mark.type !== "string" ||
          (mark.type === "link" &&
            (typeof mark.attrs?.href !== "string" ||
              !isSafeNewsUrl(mark.attrs.href))),
      )
    )
      return false;
  }
  return (
    item.content === undefined ||
    (Array.isArray(item.content) &&
      item.content.every((child) => validDocument(child, depth + 1)))
  );
}

export function validateNews(
  formData: FormData,
  today = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Tehran",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date()),
) {
  const value = (key: string) => String(formData.get(key) ?? "").trim();
  const id = value("id");
  const title = value("title");
  const summary = value("summary");
  const sourceName = value("sourceName");
  const sourceUrl = value("sourceUrl");
  const sourceDate = value("sourcePublishedAt");
  const body = value("body");
  const intent = value("intent");
  const fail = (error: string) => ({ error, payload: null, id });
  if (
    id &&
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id)
  )
    return fail("شناسه خبر معتبر نیست.");
  if (!["draft", "publish"].includes(intent))
    return fail("عملیات ذخیره معتبر نیست.");
  if (title.length < 3 || title.length > 160)
    return fail("عنوان باید بین ۳ تا ۱۶۰ نویسه باشد.");
  if (summary.length > 400) return fail("خلاصه باید حداکثر ۴۰۰ نویسه باشد.");
  if (sourceName.length < 2 || sourceName.length > 120)
    return fail("نام منبع معتبر را وارد کن (۲ تا ۱۲۰ نویسه).");
  if (sourceUrl.length > 2048 || !isSafeNewsUrl(sourceUrl))
    return fail("لینک منبع باید یک نشانی معتبر http یا https باشد.");
  const parsedDate = new Date(`${sourceDate}T00:00:00Z`);
  if (
    !/^\d{4}-\d{2}-\d{2}$/.test(sourceDate) ||
    !Number.isFinite(parsedDate.getTime()) ||
    parsedDate.toISOString().slice(0, 10) !== sourceDate ||
    sourceDate > today
  )
    return fail("تاریخ انتشار منبع معتبر نیست یا در آینده است.");
  if (body.length > 500_000) return fail("متن خبر بیش از حد طولانی است.");
  let document: unknown;
  try {
    document = JSON.parse(body);
  } catch {
    return fail("ساختار متن خبر معتبر نیست.");
  }
  if (!validDocument(document) || document.type !== "doc")
    return fail("ساختار متن یا لینک‌های خبر معتبر نیست.");
  if (extractContentText(document).length < 20)
    return fail("متن خبر باید حداقل ۲۰ نویسه داشته باشد.");
  return {
    error: null,
    id,
    payload: {
      title,
      summary: summary || null,
      body: JSON.stringify(document),
      source_name: sourceName,
      source_url: sourceUrl,
      source_published_at: sourceDate,
      status:
        intent === "publish" ? ("published" as const) : ("draft" as const),
    },
  };
}
