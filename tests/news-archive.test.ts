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

test("desktop news archive uses three equal cards without a spotlight", () => {
  const css = read("app/news/news-archive.css");
  const card = read("components/news-archive-card.tsx");
  const page = read("app/news/page.tsx");
  assert.match(
    css,
    /grid-template-columns:\s*repeat\(3,\s*minmax\(0,\s*1fr\)\)/,
  );
  assert.equal(css.includes("is-lead"), false);
  assert.equal(card.includes("featured"), false);
  assert.equal(page.includes("featured="), false);
});
test("original illustrations are real generated raster images in safe SVG containers", () => {
  for (const name of ["konkur-results", "academic-records", "exam-subjects"]) {
    const svg = read(`public/news/generated/${name}.svg`);
    assert.equal(/<script|<foreignObject|<text\b/i.test(svg), false);
    const encoded = svg.match(
      /href="data:image\/webp;base64,([A-Za-z0-9+/=]+)"/,
    );
    assert.ok(encoded);
    const raster = Buffer.from(encoded[1], "base64");
    assert.equal(raster.toString("ascii", 0, 4), "RIFF");
    assert.equal(raster.toString("ascii", 8, 12), "WEBP");
    assert.ok(raster.length > 20000 && raster.length < 150000);
  }
});
test("illustration replacement does not overwrite editorial changes or claim real photos", () => {
  const migration = read(
    "supabase/migrations/025_konkur_news_original_illustrations.sql",
  );
  assert.ok(migration.includes("n.author_id is null"));
  assert.ok(migration.includes("= illustrations.old_image_url"));
  assert.ok(migration.includes("عکس واقعی رویداد نیست"));
  assert.equal(migration.includes("public.resources"), false);
  assert.equal(/set\s+published_at\s*=/i.test(migration), false);
});
