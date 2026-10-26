import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { activityTypes } from "../lib/study-catalog";

const actions = readFileSync("app/dashboard/actions.ts", "utf8");
const progress = readFileSync("lib/progress.ts", "utf8");
const printComponent = readFileSync(
  "components/dashboard/print-weekly-plan.tsx",
  "utf8",
);
const printCss = readFileSync("app/globals.css", "utf8");
const migration = readFileSync(
  "supabase/migrations/076_study_activity_types.sql",
  "utf8",
);
const appendedPrintCss = printCss.slice(
  printCss.indexOf("/* Weekly plan print: larger readable type"),
);

test("counselor activity list keeps existing values and adds four requested labels", () => {
  const labels = new Map(activityTypes.map((activity) => [activity.value, activity.label]));
  assert.equal(labels.get("textbook_reading"), "خواندن کتاب درسی");
  assert.equal(labels.get("offline_class"), "آفلاین کلاس");
  assert.equal(labels.get("exam_analysis"), "تحلیل آزمون");
  assert.equal(labels.get("simulation_exam"), "آزمون شبیه ساز");
  assert.equal(labels.get("practice_tests"), "تست زنی");
  assert.equal(new Set(activityTypes.map((activity) => activity.value)).size, activityTypes.length);
});

test("server validation derives its allow-list from the shared activity catalog", () => {
  assert.match(actions, /import \{ activityTypes \} from "@\/lib\/study-catalog"/);
  assert.match(actions, /allowedActivityTypes = new Set<string>\(\s*activityTypes\.map/);
  assert.match(actions, /allowedActivityTypes\.has\(item\.activityType\)/);
  assert.doesNotMatch(actions, /const activityTypes = new Set\(\[/);
});

test("new study-like activities remain study time while simulation exams remain exam time", () => {
  for (const value of ["exam_analysis", "offline_class", "textbook_reading"]) {
    assert.match(progress, new RegExp(`"${value}"`));
  }
  assert.doesNotMatch(progress, /studyActivities = new Set\([\s\S]*?"simulation_exam"/);
});

test("print view writes the full duration and reflects the new enum values", () => {
  assert.match(printComponent, /persianNumber\.format\(item\.duration_minutes\)\} دقیقه/);
  assert.doesNotMatch(printComponent, /duration_minutes\.toLocaleString\("fa-IR"\)\} د/);
  for (const value of ["exam_analysis", "simulation_exam", "offline_class", "textbook_reading"]) {
    assert.match(migration, new RegExp(`add value if not exists '${value}'`));
  }
  assert.match(migration, /notify pgrst, 'reload schema'/);
  assert.match(appendedPrintCss, /\.print-plan-page \.print-activity-duration \{[\s\S]*?font-size: 10pt/);
  assert.match(appendedPrintCss, /\.print-plan-page \.print-activity-chapter,\s*\.print-plan-page \.print-activity-summary \{ font-size: 7\.5pt/);
});

test("print names are never ellipsized and Persian words keep their spaces", () => {
  assert.match(printComponent, /زده شده: \.{12,} تست/);
  assert.doesNotMatch(printComponent, /زده\u200cشده/);
  assert.match(printCss, /overflow-wrap: anywhere/);
  assert.match(appendedPrintCss, /text-overflow: clip/);
  assert.match(appendedPrintCss, /white-space: normal/);
  assert.doesNotMatch(appendedPrintCss, /text-overflow: ellipsis/);
  assert.doesNotMatch(appendedPrintCss, /-webkit-line-clamp: [1-9]/);
  assert.match(appendedPrintCss, /-webkit-line-clamp: unset/);
});
