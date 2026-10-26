import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { studiedMinutes, summarizeItems, type StudyItem, type StudyCompletion } from "../lib/student-planning";

const lesson:StudyItem={id:"lesson",plan_id:"p",day_of_week:0,duration_minutes:90,subject:"ریاضی",chapter:null,activity_type:"lesson",target_test_count:null,details:null,sort_order:0};
const tests:StudyItem={...lesson,id:"tests",duration_minutes:60,activity_type:"practice_tests",target_test_count:20};
const untouched:StudyItem={...lesson,id:"untouched",duration_minutes:45};
const completions:StudyCompletion[]=[
  {item_id:"lesson",completed_at:"2026-10-25T18:00:00Z",completed_test_count:null},
  {item_id:"tests",completed_at:"2026-10-25T19:00:00Z",completed_test_count:10},
];
const done=new Map(completions.map(completion=>[completion.item_id,completion]));

test("study hours weight test activities by completed / target tests",()=>{
  assert.equal(studiedMinutes(lesson,done.get("lesson")),90);
  assert.equal(studiedMinutes(tests,done.get("tests")),30);
  assert.equal(studiedMinutes(untouched),0);
  const summary=summarizeItems([lesson,tests,untouched],done);
  assert.equal(summary.weightedMinutes,120);
  assert.equal(summary.hours,2);
  assert.equal(summary.plannedHours,195/60);
  assert.equal(summary.percent,Math.round((1+0.5+0)/3*100));
});

test("counselor report shows hours instead of percent and keeps student percent unchanged",()=>{
  const panel=readFileSync("components/dashboard/student-planning-panel.tsx","utf8");
  assert.match(panel,/counselor\?hoursText\(s\.hours\):s\.percent/);
  assert.match(panel,/const hoursText=\(hours:number\)=>time\(hours\*60\)/);
  assert.match(panel,/counselor\?hoursText\(itemHours\):`\$\{fa\(pct\)\}٪ تحقق`/);
  assert.match(panel,/counselor\?hoursText\(s\.hours\):`\$\{fa\(s\.percent\)\}٪ تحقق`/);
});

test("check-time audit is counselor-only and uses the first tick column",()=>{
  const panel=readFileSync("components/dashboard/student-planning-panel.tsx","utf8");
  const loader=readFileSync("lib/load-study-report.ts","utf8");
  const migration=readFileSync("supabase/migrations/077_plan_check_timestamps.sql","utf8");
  assert.match(panel,/counselor&&completion&&<p className="sp-tick-time">زمان تیک/);
  assert.match(panel,/completion\.checked_at\?\?completion\.completed_at/);
  assert.match(loader,/checked_at/);
  assert.match(migration,/add column if not exists checked_at timestamptz/);
  assert.match(migration,/checked_at is deliberately not updated/);
  assert.match(migration,/notify pgrst, 'reload schema'/);
});
