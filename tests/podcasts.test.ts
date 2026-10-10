import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { validatePodcast } from "../lib/podcast-validation";
import { validateAudioFile, isSafePodcastAudioUrl } from "../lib/podcast-media";
import { GET, HEAD } from "../app/podcasts/audio/[slug]/route";
process.env.NEXT_PUBLIC_IMAGEKIT_URL_ENDPOINT =
  "https://ik.imagekit.io/2936832";
function form(patch: Record<string, string | undefined> = {}) {
  const f = new FormData();
  Object.entries({
    title: "پادکست آموزشی تست",
    summary: "راهنمای مطالعه",
    body: JSON.stringify({
      type: "doc",
      content: [
        {
          type: "paragraph",
          content: [
            {
              type: "text",
              text: "یک متن آموزشی کامل برای پادکست نووا و آزمودن انتشار.",
            },
          ],
        },
      ],
    }),
    intent: "publish",
    resourceType: "konkur",
    grade: "12",
    subject: "مطالعه",
    audioUrl: "/podcasts/audio/planning",
    audioSeconds: "99",
    ...patch,
  }).forEach(([k, v]) => f.set(k, v ?? ""));
  return f;
}
test("podcast publishing requires audio but draft may omit it", () => {
  assert.ok(validatePodcast(form()).payload);
  assert.ok(validatePodcast(form({ audioUrl: "", audioSeconds: "" })).error);
  assert.ok(
    validatePodcast(form({ intent: "draft", audioUrl: "", audioSeconds: "" }))
      .payload,
  );
});
test("podcast payload rejects malformed IDs, metadata, document, unsafe image/link", () => {
  for (const patch of [
    { id: "x" },
    { intent: "erase" },
    { title: "x" },
    { grade: "13" },
    { resourceType: "bad" },
    { audioSeconds: "Infinity" },
    { audioSeconds: "10801" },
    { audioSeconds: "0" },
    { body: "not JSON" },
    {
      body: JSON.stringify({
        type: "doc",
        content: [{ type: "image", attrs: { src: "javascript:alert(1)" } }],
      }),
    },
    {
      body: JSON.stringify({
        type: "doc",
        content: [
          {
            type: "paragraph",
            content: [
              {
                type: "text",
                text: "unsafe links never belong in a podcast",
                marks: [
                  { type: "link", attrs: { href: "javascript:alert(1)" } },
                ],
              },
            ],
          },
        ],
      }),
    },
  ])
    assert.ok(validatePodcast(form(patch)).error, JSON.stringify(patch));
});
test("audio is provider-scoped or one of the three bundled samples", () => {
  assert.ok(
    isSafePodcastAudioUrl(
      "https://ik.imagekit.io/2936832/nova/podcasts/audio/test.mp3",
    ),
  );
  for (const x of [
    "javascript:alert(1)",
    "data:audio/mp3;base64,AA==",
    "https://evil.example/a.mp3",
    "https://ik.imagekit.io/another/nova/podcasts/a.mp3",
    "/podcasts/audio/unknown",
    "https://user:pw@ik.imagekit.io/2936832/nova/podcasts/a.mp3",
  ])
    assert.equal(isSafePodcastAudioUrl(x), false, x);
});
test("audio upload checks size and file format", () => {
  assert.equal(
    validateAudioFile({ name: "voice.mp3", type: "audio/mpeg", size: 1024 }),
    null,
  );
  for (const file of [
    { name: "x.svg", type: "image/svg+xml", size: 100 },
    { name: "x.mp3", type: "text/html", size: 100 },
    { name: "x.mp3", type: "audio/mpeg", size: 0 },
    { name: "x.mp3", type: "audio/mpeg", size: 41 * 1024 * 1024 },
  ])
    assert.ok(validateAudioFile(file));
});
test("MP3 endpoint handles seeking, suffix, HEAD, invalid range, and unknown samples", async () => {
  const ctx = { params: Promise.resolve({ slug: "planning" }) };
  const full = await GET(
    new Request("https://nova.test/podcasts/audio/planning"),
    ctx,
  );
  assert.equal(full.status, 200);
  assert.equal(full.headers.get("content-type"), "audio/mpeg");
  const len = Number(full.headers.get("content-length"));
  assert.ok(len > 100000);
  for (const range of ["bytes=0-99", "bytes=-100", "bytes=100-"]) {
    const res = await GET(
      new Request("https://nova.test", { headers: { range } }),
      ctx,
    );
    assert.equal(res.status, 206);
    assert.ok(res.headers.get("content-range"));
  }
  assert.equal(
    (
      await GET(
        new Request("https://nova.test", {
          headers: { range: `bytes=${len}-` },
        }),
        ctx,
      )
    ).status,
    416,
  );
  assert.equal((await HEAD(new Request("https://nova.test"), ctx)).body, null);
  assert.equal(
    (
      await GET(new Request("https://nova.test"), {
        params: Promise.resolve({ slug: "constructor" }),
      })
    ).status,
    404,
  );
});
test("isolated storage has RLS, author ownership, approval and publish constraints", () => {
  const sql = readFileSync("supabase/migrations/026_podcasts.sql", "utf8");
  for (const x of [
    "enable row level security",
    "private.is_approved_counselor()",
    "author_id=(select auth.uid())",
    "audio_url is not null",
    "not is_sample",
  ])
    assert.ok(sql.includes(x));
  assert.equal(sql.includes("alter table public.resources"), false);
  assert.equal(sql.includes("alter table public.konkur_news"), false);
});
