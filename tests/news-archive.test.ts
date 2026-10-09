import { test } from "node:test";
import { strict as assert } from "node:assert";
import { readFileSync } from "node:fs";
import { join } from "node:path";

const read = (path: string) => readFileSync(join(process.cwd(), path), "utf8");
test("archive is a standalone page, not the landing teaser", () => {
  const page = read("app/news/page.tsx");
  assert.ok(page.includes("NewsArchiveCard"));
  assert.ok(page.includes('<h1 id="news-archive-title">'));
  assert.ok(page.includes("بازگشت به صفحه اصلی"));
  assert.equal(page.includes("KonkurNewsLatest"), false);
  assert.equal(page.includes("landing-v2d"), false);
  assert.equal(page.includes("nova-mag-all"), false);
});
test("landing retains its all-news CTA", () => {
  const teaser = read("components/konkur-news-latest.tsx");
  assert.ok(teaser.includes('href="/news" className="nova-mag-all"'));
  assert.ok(teaser.includes("همهٔ خبرها"));
});
test("source image migration is limited and protects existing images", () => {
  const migration = read(
    "supabase/migrations/024_konkur_news_source_images.sql",
  );
  assert.ok(migration.includes("n.author_id is null"));
  assert.ok(migration.includes("not jsonb_path_exists"));
  assert.equal(
    (migration.match(/https:\/\/media\.mehrnews\.com\//g) ?? []).length,
    3,
  );
  assert.equal(migration.includes("public.resources"), false);
  assert.equal(/set\s+published_at\s*=/i.test(migration), false);
});
