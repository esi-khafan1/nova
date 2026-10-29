import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const hero = readFileSync("components/landing-hero.tsx", "utf8");
const approved = readFileSync("app/landing-approved.css", "utf8");
const refresh = readFileSync("app/landing-hero-refresh.css", "utf8");
const mobile = readFileSync("app/landing-mobile.css", "utf8");

assert.match(hero, /srcSet="\/nova\/hero-desktop\.webp" type="image\/webp"/);
assert.match(hero, /srcSet="\/nova\/hero-mobile-outpaint\.webp" type="image\/webp"/);
assert.match(hero, /src="\/nova\/hero-desktop\.png" width="2172" height="724"/);
for (const path of ["public/nova/hero-desktop.webp", "public/nova/hero-mobile-outpaint.webp", "public/images/approved-star-clusters.webp"]) {
  const image = readFileSync(path);
  assert.equal(image.toString("ascii", 0, 4), "RIFF");
  assert.equal(image.toString("ascii", 8, 12), "WEBP");
}
assert.ok(readFileSync("public/nova/hero-desktop.webp").length < 150_000);
assert.ok(readFileSync("public/nova/hero-mobile-outpaint.webp").length < 150_000);
assert.ok(readFileSync("public/images/approved-star-clusters.webp").length < 250_000);
assert.match(readFileSync("app/path-finder.css", "utf8"), /approved-star-clusters\.webp/);
assert.match(hero, /<p className="nova-eyebrow">نوآ آکادمی \| همراه مسیر موفقیت<\/p>/);
assert.match(hero, /<h1 id="nova-hero-title">آینده‌ات رو بساز؛<br \/><em>قدم‌به‌قدم تا کنکور<\/em><\/h1>/);
assert.match(hero, /با برنامه‌ریزی اصولی، آموزش هدفمند و همراهی مشاوران نوآ،<br \/>مسیر رسیدن به هدفت رو با اطمینان بیشتری طی کن\./);
assert.match(hero, /className="nova-primary" href="\/auth\?mode=signup">شروع مشاوره رایگان/);
assert.match(hero, /className="nova-secondary" href="\/#find-path">دوره‌های آموزشی/);
assert.doesNotMatch(hero, /یک شروع تازه، با نوا|بهترین نسخهٔ|هدف تو، مسیر تو، برنامهٔ تو/);

assert.match(approved, /\.nova-hero-inner\{position:absolute;inset:0;/);
assert.match(refresh, /\.landing-v2d \.nova-hero-copy \{ width: 43%; margin-right: 0;/);
assert.match(refresh, /display: flex; align-items: flex-end/);
assert.match(refresh, /text-align: right/);
assert.match(refresh, /height: calc\(61vw \+ 240px\)/);
assert.match(mobile, /\.site-footer \.footer-col:last-child \{ display: none; \}/);
assert.match(mobile, /\.site-footer \.footer-grid--desktop \{ display: none; \}/);
assert.ok(readFileSync("public/nova/hero.svg", "utf8").includes("<svg"));

console.log("Landing hero copy, responsive artwork and mobile footer are preserved.");
