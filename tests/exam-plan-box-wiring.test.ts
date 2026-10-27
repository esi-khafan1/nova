import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const migration = readFileSync("supabase/migrations/079_exam_plan_boxes.sql", "utf8");
const dashboard = readFileSync("supabase/migrations/080_student_dashboard_exam_links.sql", "utf8");
const editFix = readFileSync("supabase/migrations/081_exam_box_edit_validation.sql", "utf8");
const saveExam = readFileSync("app/dashboard/exams/actions.ts", "utf8");
const builder = readFileSync("components/dashboard/exam-builder.tsx", "utf8");
const picker = readFileSync("components/dashboard/exam-box-picker.tsx", "utf8");
const designerPage = readFileSync("app/dashboard/exam_designer/page.tsx", "utf8");
const editPage = readFileSync("app/dashboard/exam_designer/[id]/page.tsx", "utf8");
const panel = readFileSync("components/dashboard/student-planning-panel.tsx", "utf8");
const reportLoader = readFileSync("lib/load-study-report.ts", "utf8");
const planLoader = readFileSync("lib/load-counselor-plans.ts", "utf8");
const planBuilder = readFileSync("components/dashboard/weekly-plan-builder.tsx", "utf8");
const saveErrors = readFileSync("lib/exam-save-errors.ts", "utf8");
const types = readFileSync("lib/student-planning.ts", "utf8");

test("database sends only exam boxes, links them and keeps the link on plan re-save", () => {
  assert.match(migration, /add column if not exists linked_exam_id uuid references public\.exams\(id\)/);
  assert.match(migration, /i\.activity_type::text='exam'/);
  assert.doesNotMatch(migration, /activity_type::text\s*IN\s*\([^)]*simulation_exam/);
  assert.match(migration, /create or replace function public\.designer_exam_boxes\(\)/);
  assert.match(migration, /student_name text/);
  assert.match(migration, /box_date date/);
  assert.match(migration, /subject text/);
  assert.match(migration, /Only exam designers can view exam boxes/);
  assert.match(migration, /target_box_ids uuid\[\] default '\{\}'::uuid\[\]/);
  assert.match(migration, /Invalid exam boxes/);
  assert.match(migration, /update public\.weekly_plan_items set linked_exam_id=saved/);
  assert.match(migration, /linked_exam_id=e\.id and wp\.student_id=p\.id/);
  assert.match(migration, /Re-attach exam links by the box's stable day \+ subject \+ chapter identity/);
  assert.match(migration, /'box_ids'/);
  assert.match(dashboard, /'linked_exam_id',\(select e\.id from public\.exams e where e\.id=i\.linked_exam_id and e\.status='published'/);
  assert.match(editFix, /target_exam_id is not null and i\.linked_exam_id=target_exam_id/);
  assert.match(editFix, /create or replace function public\.save_designer_exam/);
});

test("designer UI receives the box queue and submits the selection", () => {
  assert.match(designerPage, /supabase\.rpc\("designer_exam_boxes"\)/);
  assert.match(designerPage, /boxes=\{boxes\}/);
  assert.match(designerPage, /initialBoxId=\{params\.box\}/);
  assert.match(designerPage, /box=\$\{box\.item_id\}#exam-boxes/);
  assert.match(editPage, /supabase\.rpc\("designer_exam_boxes"\)/);
  assert.match(editPage, /boxes=\{boxes\}/);
  assert.match(editPage, /boxIds:Array\.isArray\(payload\.box_ids\)/);
  assert.match(builder, /name="box_ids" value=\{JSON\.stringify\(boxIds\)\}/);
  assert.match(builder, /ExamBoxPicker/);
  assert.match(builder, /assignedStudentCount/);
  assert.match(builder, /examPublicationReadiness\(booklets, assignedStudentCount, windowValid\)/);
  assert.match(picker, /linked_exam_owned/);
  assert.match(picker, /تنظیم تاریخ آزمون/);
  assert.match(picker, /آزمون شبیهساز/);
  assert.match(saveExam, /formData\.get\("box_ids"\)/);
  assert.match(saveExam, /target_box_ids: boxIds/);
  assert.match(saveExam, /studentIds\.length === 0 && boxIds\.length === 0/);
  assert.match(saveErrors, /boxes: /);
});

test("students enter the exam from the same box in daily and weekly plans", () => {
  assert.match(panel, /item\.activity_type==="exam"&&item\.linked_exam_id/);
  assert.match(panel, /\/dashboard\/student\/exams\/\$\{item\.linked_exam_id\}/);
  assert.match(panel, /ورود به آزمون/);
  assert.match(panel, /sp-exam-link/);
  assert.match(panel, /sp-exam-linked/);
  assert.match(types, /linked_exam_id\?:string\|null/);
  assert.match(reportLoader, /linked_exam_id\)/);
  assert.match(planLoader, /linked_exam_id\)/);
  assert.match(planBuilder, /plan-exam-box-status/);
  assert.match(planBuilder, /linkedExamId:item\.linked_exam_id/);
});
