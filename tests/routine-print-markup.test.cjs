process.env.TZ = "UTC";

const assert = require("node:assert/strict");
const esbuild = require("esbuild");

const weekStart = "2026-10-22"; // Thursday: deliberately not Saturday.
const expectedWeekdays = [
  "پنجشنبه",
  "جمعه",
  "شنبه",
  "یکشنبه",
  "دوشنبه",
  "سه\u200cشنبه",
  "چهارشنبه",
];

const plan = {
  id: "plan-1",
  student_id: "student-1",
  week_start: weekStart,
  title: "برنامه هفتگی نمونه",
  notes: null,
  status: "published",
  routines: Array.from({ length: 7 }, (_, dayOfWeek) => ({
    dayOfWeek,
    subject: "فارسی ۱",
    details: "مرور فرمولها",
  })),
  weekly_plan_items: Array.from({ length: 35 }, (_, index) => {
    const isTest = index % 7 === 0;
    return {
      id: `item-${index}`,
      day_of_week: Math.floor(index / 5),
      duration_minutes: 90,
      subject: "فارسی ۱",
      chapter: "فصل ۱",
      activity_type: isTest ? "practice_tests" : "lesson",
      target_test_count: isTest ? 12 : null,
      details: null,
      sort_order: index % 5,
    };
  }),
};
const props = {
  plan,
  student: { full_name: "نمونه دانشآموز", grade: 12, study_field: "experimental_sciences" },
  counselorName: "مشاور نووا",
  backHref: "/dashboard/counselor/plans",
};

const stubs = {
  "next/link": `const React=require('react');function Link({href,children,...rest}){return React.createElement('a',{href,...rest},children);}module.exports=Link;module.exports.default=Link;`,
  "@/components/dashboard/print-plan-button": `function PrintPlanButton(){return null;}module.exports={PrintPlanButton};`,
};

(async () => {
  const bundle = await esbuild.build({
    absWorkingDir: process.cwd(),
    tsconfig: "tsconfig.json",
    stdin: {
      contents: `import React from 'react';import {renderToStaticMarkup} from 'react-dom/server';import {PrintWeeklyPlan} from './components/dashboard/print-weekly-plan';const props=${JSON.stringify(props)};export const html=renderToStaticMarkup(React.createElement(PrintWeeklyPlan,props));`,
      resolveDir: process.cwd(),
      loader: "ts",
    },
    bundle: true,
    write: false,
    outfile: "/tmp/nova-routine-print-markup.cjs",
    platform: "node",
    format: "cjs",
    target: "node22",
    jsx: "automatic",
    logLevel: "silent",
    external: ["react", "react-dom", "react-dom/server", "react/jsx-runtime"],
    plugins: [
      {
        name: "print-stubs",
        setup(build) {
          build.onResolve({ filter: /^(next\/link|@\/components\/dashboard\/print-plan-button)$/ }, (args) => ({
            path: args.path,
            namespace: "nova-stub",
          }));
          build.onLoad({ filter: /.*/, namespace: "nova-stub" }, (args) => ({
            contents: stubs[args.path],
            loader: "js",
            resolveDir: process.cwd(),
          }));
        },
      },
    ],
  });

  const compiled = { exports: {} };
  new Function("module", "exports", "require", bundle.outputFiles[0].text)(compiled, compiled.exports, require);
  const html = compiled.exports.html;

  const headings = [...html.matchAll(/<h2>([^<]+)<\/h2>/g)].map((match) => match[1]);
  const routineWeekdays = [
    ...html.matchAll(/<article class="print-activity print-routine"[^>]*data-weekday="([^"]+)"/g),
  ].map((match) => match[1]);
  const routineTitles = html.match(/class="print-fit-text print-activity-subject"[^>]*>روتین<\/span>/g) || [];

  assert.deepEqual(headings, expectedWeekdays, "day headers must follow week_start");
  assert.deepEqual(routineWeekdays, expectedWeekdays, "routine data-weekday must follow week_start");
  assert.equal(routineTitles.length, 7, "exactly seven routine boxes");
  assert.equal((html.match(/class="print-day-column"/g) || []).length, 7, "seven day columns");
  assert.ok(!html.includes("روتین ·"), "routine title must not contain a static weekday");
  assert.ok(html.includes("۹۰ دقیقه"), "duration is written out in the third row");
  assert.ok(!html.includes(">۹۰ د<"), "old compact duration badge is gone");
  assert.ok(html.includes("زده شده از"), "test boxes show solved-out-of-target line");
  assert.ok(!html.includes("زده شده: "), "old generic solved-test line is gone");
  assert.ok(!html.includes("هدف "), "no extra target-test text in the third row");
  console.log("PASS: routine weekdays come from week_start, title is just روتین, approved four-row print layout");
})().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
