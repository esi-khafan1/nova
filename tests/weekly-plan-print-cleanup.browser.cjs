// Real-Chromium print check for the weekly-plan page: only the A4 sheet is
// printed (no support/chat launcher or other global chrome), the optional notes
// section no longer stretches the footer into a blank band, and the approved
// four-row boxes still fit on a single A4 landscape page.
const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const esbuild = require("esbuild");
const { chromium } = require("playwright-core");

const weekDays = ["پنجشنبه", "جمعه", "شنبه", "یکشنبه", "دوشنبه", "سه\u200cشنبه", "چهارشنبه"];

const sparsePlan = {
  id: "plan-sparse",
  student_id: "student-1",
  week_start: "2026-10-22", // Thursday: matches the expected weekday order below
  title: "برنامه هفتگی",
  notes: null, // the reported print-out had no counselor note
  status: "published",
  routines: [],
  weekly_plan_items: [
    { id: "i1", day_of_week: 2, duration_minutes: 90, subject: "حسابان ۱", chapter: "فصل ۱: تابع و مثلثات", activity_type: "practice_tests", target_test_count: 8, details: null, sort_order: 0 },
    { id: "i2", day_of_week: 2, duration_minutes: 90, subject: "حسابان ۱", chapter: "فصل ۱: تابع و مثلثات", activity_type: "practice_tests", target_test_count: 8, details: null, sort_order: 1 },
    { id: "i3", day_of_week: 3, duration_minutes: 60, subject: "آمار و احتمال", chapter: "فصل ۲: آمار توصیفی", activity_type: "lesson", target_test_count: null, details: "مرور تمرین\u200cهای فصل", sort_order: 0 },
  ],
};

const densePlan = {
  ...sparsePlan,
  id: "plan-dense",
  notes: "یادداشت کلی مشاور: اولویت با مرور تست\u200cهای علامت\u200cدار است.",
  routines: Array.from({ length: 7 }, (_, dayOfWeek) => ({ dayOfWeek, subject: "فارسی ۱", details: "مرور daily" })),
  weekly_plan_items: Array.from({ length: 35 }, (_, index) => ({
    id: `dense-${index}`,
    day_of_week: Math.floor(index / 5),
    duration_minutes: 90,
    subject: "درک عمومی ریاضی و فیزیک و آمار",
    chapter: "فصل ۷: فناوری\u200cهای نوین زیستی و مهندسی ژنتیک",
    activity_type: index % 7 === 0 ? "practice_tests" : "lesson",
    target_test_count: index % 7 === 0 ? 20 : null,
    details: index % 7 === 0 ? null : "نکته\u200cهای مشاور: مرور فرمول\u200cهای پرتکرار",
    sort_order: index % 5,
  })),
};

const propsFor = (plan) => ({
  plan,
  student: { full_name: "دانش\u200cآموز دهم", grade: 10, study_field: null },
  counselorName: "مشاور نووا",
  backHref: "/dashboard/student#weekly-plan",
});

const stubs = {
  "next/link": `import React from 'react';export default function Link({href,children,...rest}){return React.createElement('a',{href,...rest},children);}`,
  "@/components/dashboard/print-plan-button": `export function PrintPlanButton(){return null;}`,
};

async function renderPlan(plan) {
  const bundle = await esbuild.build({
    absWorkingDir: process.cwd(),
    tsconfig: "tsconfig.json",
    stdin: {
      contents: `import React from 'react';import {renderToStaticMarkup} from 'react-dom/server';import {PrintWeeklyPlan} from './components/dashboard/print-weekly-plan';const props=${JSON.stringify(propsFor(plan))};export const html=renderToStaticMarkup(React.createElement(PrintWeeklyPlan,props));`,
      resolveDir: process.cwd(),
      loader: "ts",
    },
    bundle: true,
    write: false,
    outfile: "/tmp/nova-weekly-print-cleanup.cjs",
    platform: "node",
    format: "cjs",
    target: "node22",
    jsx: "automatic",
    plugins: [
      {
        name: "print-stubs",
        setup(build) {
          build.onResolve({ filter: /^(next\/link|@\/components\/dashboard\/print-plan-button)$/ }, (args) => ({ path: args.path, namespace: "nova-stub" }));
          build.onLoad({ filter: /.*/, namespace: "nova-stub" }, (args) => ({ contents: stubs[args.path], loader: "tsx", resolveDir: process.cwd() }));
        },
      },
    ],
  });
  const compiled = { exports: {} };
  new Function("module", "exports", "require", bundle.outputFiles[0].text)(compiled, compiled.exports, require);
  return compiled.exports.html;
}

const globalsCss = fs.readFileSync(path.join(process.cwd(), "app/globals.css"), "utf8");
const supportCss = fs.readFileSync(path.join(process.cwd(), "components/support/support.css"), "utf8");
const fixesCss = fs.readFileSync(path.join(process.cwd(), "app/exam-interaction-fixes.css"), "utf8");
const fontFile = fs.readFileSync(path.join(process.cwd(), "public/fonts/estedad-arabic-wght-normal.woff2"));
const fontCss = `@font-face{font-family:'Estedad Variable';src:url('/font.woff2') format('woff2');font-style:normal;font-weight:100 900;font-display:swap}body{font-family:'Estedad Variable',sans-serif}`;

const fitScript = `<script>
(function(){
 function fit(){
  document.querySelectorAll('.print-fit-text').forEach(function(el){
   var base=parseFloat(el.dataset.basePt||'8');
   var min=parseFloat(el.dataset.minPt||'5.5');
   var size=base;
   el.style.width='';el.style.maxWidth='';el.style.transform='';el.style.transformOrigin='';
   el.dataset.fitScale='1';
   el.style.fontSize=size+'pt';
   while(size>min&&el.scrollWidth>el.clientWidth+0.2){size-=0.15;el.style.fontSize=size+'pt';}
   el.dataset.fitSize=size.toFixed(2);
   if(el.scrollWidth>el.clientWidth+0.2){
    var ratio=el.clientWidth/el.scrollWidth;
    el.style.width=(100/ratio)+'%';
    el.style.maxWidth='none';
    el.style.transform='scaleX('+ratio+')';
    el.style.transformOrigin='right center';
    el.dataset.fitScale=ratio.toFixed(3);
   }
  });
 }
 window.fitPrintText=fit;
 window.addEventListener('beforeprint',fit);
 if(document.fonts&&document.fonts.ready)document.fonts.ready.then(fit);else window.addEventListener('load',fit);
})();
</script>`;

// Mirrors app/layout.tsx: the support widget is a sibling of the page, and
// other global/portal UI may also be mounted next to it.
const globalChrome = `<header class="site-header">سربرگ سایت</header>
<footer class="site-footer">پانویس سایت</footer>
<div class="nova-support" dir="rtl" data-print-hide><button class="support-launcher" aria-label="گفتگو با پشتیبانی"><svg aria-hidden="true" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 13v-2a8 8 0 0 1 16 0v2M4 12H2v7h4v-7H4Zm16 0h2v7h-4v-7h2ZM18 19c0 2-3 3-6 3"/></svg></button></div>
<div class="some-chat-widget" data-print-hide>چت پشتیبانی</div>`;

(async () => {
  const browser = await chromium.launch({ executablePath: process.env.CHROMIUM_PATH || "/tmp/chromium", args: ["--no-sandbox", "--disable-dev-shm-usage"] });
  try {
    for (const [name, plan] of [["sparse", sparsePlan], ["dense", densePlan]]) {
      const html = await renderPlan(plan);
      const page = await browser.newPage({ viewport: { width: 1123, height: 794 }, deviceScaleFactor: 1 });
      await page.route("**/*", async (route) => {
        const url = new URL(route.request().url());
        if (url.pathname === "/font.woff2") return route.fulfill({ contentType: "font/woff2", body: fontFile });
        if (url.pathname !== "/") return route.abort();
        return route.fulfill({
          contentType: "text/html",
          body: `<!doctype html><html lang="fa" dir="rtl"><head><meta charset="utf-8"><style>${fontCss}\n${globalsCss}\n${supportCss}\n${fixesCss}</style></head><body>${html}${globalChrome}${fitScript}</body></html>`,
        });
      });
      await page.goto("http://nova-weekly-print.test/");
      await page.evaluate(() => document.fonts.ready);

      // Normal screen view must keep the toolbar and the support widget.
      const screen = await page.evaluate(() => ({
        support: getComputedStyle(document.querySelector(".nova-support")).display,
        toolbar: getComputedStyle(document.querySelector(".print-plan-toolbar")).display,
      }));
      assert.notEqual(screen.support, "none", `${name}: support widget must stay on screen`);
      assert.notEqual(screen.toolbar, "none", `${name}: toolbar must stay on screen`);

      await page.emulateMedia({ media: "print" });
      await page.evaluate(() => window.fitPrintText && window.fitPrintText());
      await page.waitForTimeout(150);

      const checks = await page.evaluate(() => {
        const q = (sel) => document.querySelector(sel);
        const display = (el) => (el ? getComputedStyle(el).display : "missing");
        const box = (sel) => { const el = q(sel); return el ? el.getBoundingClientRect().toJSON() : null; };
        const root = q(".a4-weekly-plan");
        const grid = q(".print-week-grid");
        const footer = q(".print-plan-footer");
        const footerStyle = getComputedStyle(footer);
        const inside = (child, parent) => {
          const a = child.getBoundingClientRect(), b = parent.getBoundingClientRect();
          return a.left >= b.left - 1 && a.right <= b.right + 1 && a.top >= b.top - 1 && a.bottom <= b.bottom + 1;
        };
        const clipped = [...document.querySelectorAll(".print-activity")].flatMap((el) =>
          [...el.children].filter((child) => getComputedStyle(child).display !== "none" && !inside(child, el))
            .map((child) => child.textContent.slice(0, 30)));
        return {
          hiddenChrome: {
            support: display(q(".nova-support")),
            launcher: display(q(".support-launcher")),
            chatWidget: display(q(".some-chat-widget")),
            siteHeader: display(q(".site-header")),
            siteFooter: display(q(".site-footer")),
            toolbar: display(q(".print-plan-toolbar")),
          },
          visibleBodyChildren: [...document.body.children]
            .filter((el) => getComputedStyle(el).display !== "none" && el.tagName !== "SCRIPT")
            .map((el) => el.className || el.tagName),
          sheetVisible: display(root),
          root: box(".a4-weekly-plan"),
          grid: box(".print-week-grid"),
          footer: box(".print-plan-footer"),
          page: box(".print-plan-page"),
          footerPaddingBottom: footerStyle.paddingBottom,
          footerHeight: footer.getBoundingClientRect().height,
          gridToFooterGap: footer.getBoundingClientRect().top - grid.getBoundingClientRect().bottom,
          footerToPageBottom: document.querySelector(".print-plan-page").getBoundingClientRect().bottom - footer.getBoundingClientRect().bottom,
          overflow: root.scrollHeight > root.clientHeight + 2 || root.scrollWidth > root.clientWidth + 2,
          horizontalOverflow: document.documentElement.scrollWidth > innerWidth,
          clipped,
          columns: getComputedStyle(grid).gridTemplateColumns.split(" ").length,
          dayColumns: document.querySelectorAll(".print-day-column").length,
          routines: document.querySelectorAll(".print-routine").length,
          emptyBoxes: document.querySelectorAll(".print-activity-empty").length,
          headings: [...document.querySelectorAll(".print-day-column > header h2")].map((el) => el.textContent.trim()),
          subjectBase: q(".print-activity:not(.print-routine) .print-activity-subject")?.dataset.basePt,
          chapterBase: q(".print-activity:not(.print-routine) .print-activity-chapter")?.dataset.basePt,
          lastBase: q(".print-activity:not(.print-routine) .print-activity-last")?.dataset.basePt,
          firstSummary: q(".print-activity-summary")?.textContent.trim(),
          testLines: [...document.querySelectorAll(".print-activity-last.is-test")].map((el) => el.textContent.trim()),
          notesVisible: q(".print-plan-notes") ? display(q(".print-plan-notes")) : "absent",
        };
      });

      for (const [key, value] of Object.entries(checks.hiddenChrome)) {
        assert.equal(value, "none", `${name}: ${key} must not print`);
      }
      assert.deepEqual(checks.visibleBodyChildren, ["print-plan-page"], `${name}: only the A4 sheet prints`);
      assert.notEqual(checks.sheetVisible, "none", `${name}: sheet must print`);
      assert.equal(checks.footerPaddingBottom, "0px", `${name}: no global 48px footer padding`);
      assert.ok(checks.footerHeight < 30, `${name}: footer is not stretched (${checks.footerHeight}px)`);
      assert.ok(checks.gridToFooterGap < 10, `${name}: week grid reaches the footer (${checks.gridToFooterGap}px)`);
      assert.ok(checks.footerToPageBottom < 30, `${name}: footer sits at the page bottom (${checks.footerToPageBottom}px)`);
      assert.ok(checks.grid.height > checks.root.height * 0.7, `${name}: week grid fills the A4 sheet`);
      assert.equal(checks.overflow, false, `${name}: no A4 overflow`);
      assert.equal(checks.horizontalOverflow, false, `${name}: no horizontal overflow`);
      assert.deepEqual(checks.clipped, [], `${name}: no clipped activity rows`);
      assert.equal(checks.columns, 7, `${name}: seven day columns`);
      assert.equal(checks.dayColumns, 7);
      assert.equal(checks.routines, 7, `${name}: one routine box per day`);
      assert.deepEqual(checks.headings, weekDays);
      assert.equal(checks.subjectBase, "10.5");
      assert.equal(checks.chapterBase, "8.5");
      assert.equal(checks.lastBase, "7.5");
      assert.match(checks.firstSummary, /^[۰-۹]+ دقیقه /, `${name}: third row keeps approved wording`);
      assert.ok(checks.testLines.length > 0, `${name}: test boxes exist`);
      for (const line of checks.testLines) assert.match(line, /زده شده از [۰-۹]+ تست/);
      if (plan.notes) assert.notEqual(checks.notesVisible, "none", `${name}: notes section prints when present`);
      else assert.equal(checks.notesVisible, "absent", `${name}: no empty notes band`);

      const pdf = await page.pdf({ preferCSSPageSize: true, printBackground: true, displayHeaderFooter: false });
      assert.equal((pdf.toString("latin1").match(/\/Type\s*\/Page\b/g) || []).length, 1, `${name}: exactly one A4 page`);
      await page.close();
    }
    console.log("Weekly-plan print: only the A4 sheet prints (no support/chat/global chrome), no blank footer band, approved four-row boxes fit one A4 page with and without notes.");
  } finally {
    await browser.close();
  }
})().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
