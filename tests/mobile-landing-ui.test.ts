import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const mobile = readFileSync("app/landing-mobile.css", "utf8");
const page = readFileSync("app/page.tsx", "utf8");
const auth = readFileSync("app/auth/auth-gradient.css", "utf8");
const readme = readFileSync("README.md", "utf8");
assert.match(mobile, /@media \(max-width: 700px\)/);
assert.equal((mobile.match(/@media/g) ?? []).length, 1);
for (const grid of ["proof-grid", "nova-why-grid", "nova-mag-layout", "social-grid", "footer-grid"]) {
  assert.match(mobile, new RegExp(`\\.${grid} \\{[^}]*grid-template-columns: repeat\\(2, minmax\\(0, 1fr\\)\\)`));
}
assert.match(mobile, /\.landing-v2d \.nova-mag-layout > \.nova-mag-article:nth-child\(n \+ 3\) \{ display: none; \}/);
assert.match(mobile, /\.landing-v2d \.nova-mag-summary \{ display: none; \}/);
assert.match(mobile, /\.landing-v2d \.footer-grid > \.footer-about \{ display: none; \}/);
assert.ok(page.indexOf('import "./landing-mobile.css"') > page.indexOf('import "./landing-white-sections.css"'));
assert.match(page, /\.limit\(3\)/);
assert.match(page, /getPublishedNews\(3\)/);
assert.match(page, /getPublishedPodcasts\(3\)/);
assert.match(auth, /\.nova-auth-reveal \{[^}]*inset: 0 1px 0 auto;/);
assert.match(auth, /\.nova-auth-password input::placeholder \{ direction: ltr; text-align: left;/);
assert.match(readme, /قواعد تأییدشدهٔ گوشی/);
console.log("Owner-approved mobile grids, landing-only limits, auth alignment and README guardrails are preserved.");