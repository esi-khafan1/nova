import { test } from "node:test";
import { strict as assert } from "node:assert";
import { isSafeNewsUrl, validateNews } from "../lib/news-validation";

function form(overrides: Record<string, string | undefined> = {}) {
  const data = new FormData();
  const values = {
    title: "خبر معتبر کنکور",
    summary: "خلاصه خبر",
    sourceName: "خبرگزاری مهر",
    sourceUrl: "https://www.mehrnews.com/news/6955598",
    sourcePublishedAt: "2026-09-23",
    body: JSON.stringify({
      type: "doc",
      content: [
        {
          type: "paragraph",
          content: [
            {
              type: "text",
              text: "متن خبر معتبر و مستند برای دانش‌آموزان نووا",
            },
          ],
        },
      ],
    }),
    intent: "publish",
    ...overrides,
  };
  Object.entries(values).forEach(([key, value]) => data.set(key, value ?? ""));
  return data;
}
const check = (overrides: Record<string, string | undefined> = {}) =>
  validateNews(form(overrides), "2026-10-10");
test("valid published and draft news preserve source date", () => {
  assert.equal(check().payload?.status, "published");
  assert.equal(check().payload?.source_published_at, "2026-09-23");
  assert.equal(check({ intent: "draft" }).payload?.status, "draft");
});
test("source URL rejects script/data schemes and credentials", () => {
  for (const url of [
    "javascript:alert(1)",
    "data:text/html,x",
    "https://user:pass@example.com",
    "invalid",
  ]) {
    assert.equal(isSafeNewsUrl(url), false);
    assert.ok(check({ sourceUrl: url }).error);
  }
  assert.equal(isSafeNewsUrl("https://sanjesh.org/"), true);
});
test("metadata length and source presence limits", () => {
  for (const input of [
    { title: "x" },
    { title: "x".repeat(161) },
    { summary: "x".repeat(401) },
    { sourceName: "" },
    { sourceUrl: "" },
    { sourceName: "x".repeat(121) },
  ])
    assert.ok(check(input).error);
});
test("future and nonexistent source dates are rejected", () => {
  for (const date of [
    "2026-10-11",
    "2026-02-30",
    "2026-13-01",
    "",
    "23/09/2026",
  ])
    assert.ok(check({ sourcePublishedAt: date }).error);
  assert.equal(check({ sourcePublishedAt: "2026-10-10" }).error, null);
});
test("invalid ids and intents are rejected", () => {
  assert.ok(check({ id: "someone-elses-news" }).error);
  assert.ok(check({ intent: "archive" }).error);
  assert.equal(
    check({ id: "a2d87631-c0a7-4ab6-8e0d-000000000001" }).error,
    null,
  );
});
test("malformed, short and oversized documents are rejected", () => {
  for (const body of [
    "bad json",
    "null",
    "{}",
    JSON.stringify({
      type: "doc",
      text: "متن ساختگی روی ریشه که نمایش داده نمی‌شود",
    }),
    '{"type":"doc","content":{}}',
    JSON.stringify({ type: "doc", content: [{ type: "text", text: "short" }] }),
    "x".repeat(500001),
  ])
    assert.ok(check({ body }).error);
});
test("rich text refuses unsafe links and image sources", () => {
  for (const node of [
    {
      type: "text",
      text: "متن خبر با لینک نامعتبر بسیار طولانی",
      marks: [{ type: "link", attrs: { href: "javascript:alert(1)" } }],
    },
    { type: "image", attrs: { src: "data:image/svg+xml,x" } },
  ])
    assert.ok(
      check({ body: JSON.stringify({ type: "doc", content: [node] }) }).error,
    );
});
test("normal editor JSON with images and links is accepted", () => {
  const doc = {
    type: "doc",
    content: [
      {
        type: "paragraph",
        content: [
          {
            type: "text",
            text: "متن خبر به همراه لینک منبع معتبر و تصویر",
            marks: [{ type: "link", attrs: { href: "https://sanjesh.org" } }],
          },
        ],
      },
      {
        type: "image",
        attrs: { src: "https://ik.imagekit.io/example/image.jpg" },
      },
    ],
  };
  assert.equal(check({ body: JSON.stringify(doc) }).error, null);
});
