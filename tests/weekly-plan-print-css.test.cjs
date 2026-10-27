// Source-level guard for the weekly-plan print isolation. The browser test
// (weekly-plan-print-cleanup.browser.cjs) verifies the rendered result; this
// one keeps the CSS rules themselves from being dropped in a future cleanup.
process.env.TZ = "UTC";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");

const globals = fs.readFileSync(path.join(process.cwd(), "app/globals.css"), "utf8");
const support = fs.readFileSync(path.join(process.cwd(), "components/support/support.css"), "utf8");
const widget = fs.readFileSync(path.join(process.cwd(), "components/support/widget.tsx"), "utf8");

// The global `footer { padding: 38px 0 48px }` must not leak into the A4 sheet.
const footerRule = globals.match(/\.print-plan-footer\s*\{[^}]*\}/);
assert.ok(footerRule, "weekly-plan footer rule exists");
assert.match(footerRule[0], /padding:\s*9px 0 0/, "footer resets the global bottom padding");
assert.match(footerRule[0], /background:\s*transparent/, "footer has no cream site-footer background");

// The last print block must hide global chrome and fill the page with the grid.
const printBlocks = [...globals.matchAll(/@media print\s*\{/g)];
assert.ok(printBlocks.length >= 8, "print rules are preserved");
const finalPrint = globals.slice(printBlocks[printBlocks.length - 1].index);
for (const selector of [
  ".nova-support",
  ".support-launcher",
  ".print-plan-toolbar",
  ".site-header",
  ".site-footer",
  "nextjs-portal",
]) {
  assert.ok(finalPrint.includes(selector), `${selector} is hidden in print`);
}
assert.match(finalPrint, /body:has\(\.print-plan-page\)\s*\{/, "print page is isolated at body level");
assert.match(finalPrint, /\.print-plan-page\s*>\s*\*:not\(\.a4-weekly-plan\)/, "only the A4 sheet prints");
assert.match(finalPrint, /display:\s*flex\s*!important/, "optional notes cannot give the footer the flexible row");
assert.match(finalPrint, /flex:\s*1 1 auto\s*!important/, "week grid takes the free space");
assert.match(finalPrint, /padding:\s*1\.5mm 0 0\s*!important/, "printed footer has no bottom padding");

// The widget stylesheet itself hides the launcher on every printed page.
const supportPrint = support.slice(support.lastIndexOf("@media print"));
assert.match(supportPrint, /\.nova-support,[\s\S]*?display:\s*none\s*!important/, "support widget never prints");
assert.match(widget, /className="nova-support"[^>]*data-print-hide/, "support widget is marked as non-printable");

console.log("PASS: weekly-plan print CSS hides support/global UI and removes the blank footer band");
