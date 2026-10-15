import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
const read = (p: string) => readFileSync(p, "utf8");
for (const route of ["news", "podcasts"]) {
  const layout = read(`app/${route}/layout.tsx`);
  const archive = read(`app/${route}/page.tsx`);
  const detail = read(`app/${route}/[id]/page.tsx`);
  assert.match(layout, /LandingHeader isAuthenticated=\{Boolean\(user\)\}/);
  assert.match(layout, /magazine-theme/);
  assert.match(layout, /landing-approved.css/);
  for (const s of [archive, detail]) {
    assert.ok(!s.includes("<Logo"));
    assert.ok(!s.includes("mag-header"));
    assert.match(s, /mag-mobile-label">بازگشت/);
  }
  assert.match(archive, /mag-hero-topline/);
  assert.match(archive, /src="\/nova\/mark.svg"/);
  assert.match(archive, /className="mag-grid"/);
  assert.ok(!archive.includes(".limit("));
  assert.match(detail, /article-topline/);
  assert.match(detail, /<RichContent document=\{parseContent\(/);
  assert.match(detail, /generateMetadata/);
}
assert.match(read("app/news/[id]/page.tsx"), /item.source_url/);
assert.match(read("app/podcasts/[id]/page.tsx"), /<PodcastPlayer url=\{p.audio_url\}/);
assert.match(read("app/podcasts/[id]/page.tsx"), /p.is_sample/);
assert.match(read("app/mag/[id]/page.tsx"), /mag-desktop-label">بازگشت به مجله/);
assert.match(read("app/mag/[id]/page.tsx"), /mag-mobile-label">بازگشت/);
for (const card of ["components/news-archive-card.tsx", "components/podcast-archive-card.tsx"]) {
  assert.match(read(card), /mag-card-summary/);
  assert.match(read(card), /mag-card-footer/);
  assert.match(read(card), /formatPersianDate/);
}
console.log("Editorial theme, full content, sources, audio and mobile labels preserved.");
assert.match(read("app/mag/magazine-theme.css"), /\.mag-shell \{ display:flow-root;/);
