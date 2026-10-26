import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const builder = readFileSync("components/dashboard/weekly-plan-builder.tsx", "utf8");
const actions = readFileSync("app/dashboard/actions.ts", "utf8");
const print = readFileSync("components/dashboard/print-weekly-plan.tsx", "utf8");
const curriculum = readFileSync("lib/planning-curriculum.ts", "utf8");
const school = readFileSync("lib/school-catalog.ts", "utf8");
const css = readFileSync("app/globals.css", "utf8");
const migration = readFileSync("supabase/migrations/078_weekly_plan_routines.sql", "utf8");
const checkMigration = readFileSync("supabase/migrations/077_plan_check_timestamps.sql", "utf8");

test("counselor builder has exactly one default routine per day and no add/remove control", () => {
  assert.match(builder, /const defaultRoutines = \(\): PlanRoutine\[\] =>/);
  assert.match(builder, /weekDays\.map\(\(_, dayOfWeek\)/);
  assert.match(builder, /useState<PlanRoutine\[\]>\(\(\) => planRoutines\(initialPlan\)\)/);
  assert.match(builder, /className="plan-routine"/);
  assert.match(builder, /فقط همین یک روتین ثبت میشود/);
  assert.doesNotMatch(builder, /افزودن روتین|حذف روتین/);
  assert.match(builder, /name="routines" value=\{JSON\.stringify\(routines\)\}/);
});

test("server accepts exactly seven unique daily routines and saves them through v5", () => {
  assert.match(actions, /const rawRoutines = clean\(fd\.get\("routines"\)/);
  assert.match(actions, /parsed\.length !== 7/);
  assert.match(actions, /routineDays\.size !== 7/);
  assert.match(actions, /s\.rpc\("save_weekly_plan_v5"/);
  assert.match(actions, /target_routines: safeRoutines/);
  assert.match(migration, /Exactly seven daily routines are required/);
  assert.match(migration, /Duplicate routine day/);
  assert.match(migration, /create or replace function public\.save_weekly_plan_v5/);
  assert.match(migration, /notify pgrst, 'reload schema'/);
});

test("routine weekdays come from week_start and the routine title is just روتین", () => {
  assert.match(print, /formatPersianWeekday/);
  assert.match(print, /const weekday = formatPersianWeekday\(dayDate\)/);
  assert.match(print, /data-weekday=\{weekday\}/);
  assert.match(print, /<strong>روتین<\/strong>/);
  assert.doesNotMatch(print, /روتین ·/);
  assert.match(builder, /formatPersianWeekday/);
  assert.match(builder, /const realWeekday = formatPersianWeekday\(dayDate\(weekStart, dayIndex\)\)/);
  assert.match(builder, /aria-label=\{`روتین/);
});

test("routine subjects are limited to the student's field and lab stays with experimental sciences", () => {
  assert.match(curriculum, /export function routineSubjectOptions/);
  assert.match(curriculum, /hasOwnProperty\.call\(studyCatalog,field\)/);
  assert.match(curriculum, /validField\?\[validField\]:Object\.keys\(studyCatalog\)/);
  assert.match(builder, /routineSubjectOptions\(student\?\.study_field\?\?null,student\?\.grade\?\?null\)/);
  assert.match(actions, /routineSubjectOptions\(student\.study_field,student\.grade\)/);
  assert.match(actions, /allowedRoutineSubjects/);
  assert.match(actions, /savedRoutineSubjects/);
  assert.match(school, /labExtras=field==="experimental_sciences"/);
  assert.match(school, /commonExtras[\s\S]*زمین/);
});

test("print plan keeps seven day columns and puts one routine last in each day", () => {
  assert.match(print, /normalizeRoutines\(plan\.routines\)/);
  assert.match(print, /weekDays\.map\(\(_, index\)/);
  assert.match(print, /weekDays\.map\(\(_, dayIndex\)/);
  assert.match(print, /className="print-activity print-routine"/);
  assert.match(css, /grid-template-rows:repeat\(5,minmax\(0,0\.88fr\)\) minmax\(0,0\.66fr\)!important/);
  assert.match(css, /\.print-plan-page \.print-routine\{[\s\S]*?margin-inline:4px/);
  assert.match(print, /<b>\{item\.duration_minutes\.toLocaleString\("fa-IR"\)\} د<\/b>/);
});

test("counselor anti-cheat timestamp is server-preserved and hidden from students", () => {
  assert.match(checkMigration, /add column if not exists checked_at timestamptz/);
  assert.match(checkMigration, /checked_at is deliberately not updated/);
  assert.match(checkMigration, /notify pgrst, 'reload schema'/);
});
