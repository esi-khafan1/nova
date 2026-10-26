import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const builder=readFileSync("components/dashboard/weekly-plan-builder.tsx","utf8");
const actions=readFileSync("app/dashboard/actions.ts","utf8");
const print=readFileSync("components/dashboard/print-weekly-plan.tsx","utf8");
const css=readFileSync("app/globals.css","utf8");
const migration=readFileSync("supabase/migrations/078_weekly_plan_routines.sql","utf8");
const checkMigration=readFileSync("supabase/migrations/077_plan_check_timestamps.sql","utf8");

test("counselor builder has exactly one default routine per day and no add/remove control",()=>{
 assert.match(builder,/const defaultRoutines = \(\): PlanRoutine\[\] =>/);
 assert.match(builder,/weekDays\.map\(\(_, dayOfWeek\)/);
 assert.match(builder,/useState<PlanRoutine\[\]>\(\(\) => planRoutines\(initialPlan\)\)/);
 assert.match(builder,/className="plan-routine"/);
 assert.match(builder,/فقط همین یک روتین ثبت میشود/);
 assert.doesNotMatch(builder,/افزودن روتین|حذف روتین/);
 assert.match(builder,/name="routines" value=\{JSON\.stringify\(routines\)\}/);
});

test("server accepts exactly seven unique daily routines and saves them through v5",()=>{
 assert.match(actions,/const rawRoutines = clean\(fd\.get\("routines"\)/);
 assert.match(actions,/parsed\.length !== 7/);
 assert.match(actions,/routineDays\.size !== 7/);
 assert.match(actions,/s\.rpc\("save_weekly_plan_v5"/);
 assert.match(actions,/target_routines: safeRoutines/);
 assert.match(migration,/Exactly seven daily routines are required/);
 assert.match(migration,/Duplicate routine day/);
 assert.match(migration,/create or replace function public\.save_weekly_plan_v5/);
 assert.match(migration,/notify pgrst, 'reload schema'/);
});

test("print plan keeps seven day columns and puts one routine last in each day",()=>{
 assert.match(print,/normalizeRoutines\(plan\.routines\)/);
 assert.match(print,/weekDays\.map\(\(day, index\)/);
 assert.match(print,/className="print-activity print-routine"/);
 assert.match(css,/grid-template-rows:repeat\(5,minmax\(0,0\.88fr\)\) minmax\(0,0\.66fr\)!important/);
 assert.match(css,/\.print-plan-page \.print-routine\{[\s\S]*?margin-inline:4px/);
 assert.match(print,/<b>\{item\.duration_minutes\.toLocaleString\("fa-IR"\)\} د<\/b>/);
});

test("counselor anti-cheat timestamp is server-preserved and hidden from students",()=>{
 assert.match(checkMigration,/add column if not exists checked_at timestamptz/);
 assert.match(checkMigration,/checked_at is deliberately not updated/);
 assert.match(checkMigration,/notify pgrst, 'reload schema'/);
});
