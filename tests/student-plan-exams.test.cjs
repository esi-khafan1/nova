const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
function load(path) {
 const mod = { exports: {} };
 vm.runInNewContext(ts.transpileModule(fs.readFileSync(path, 'utf8'), {
   compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
 }).outputText, { module: mod, exports: mod.exports, require: name => assert.fail(`unexpected import: ${name}`), Intl, Date, Number, Set });
 return mod.exports;
}
const { examPlanDay, standalonePlanExams } = load('lib/student-plan-exams.ts');
const a = { id: 'a', title: 'آزمون ریاضی', description: 'راهنمای آزمون', starts_at: '2026-11-03T21:30:00Z', start_window_ends_at: null, duration_minutes: 40 };
const b = { ...a, id: 'b', title: 'آزمون زیست' };
assert.equal(examPlanDay(a.starts_at), '2026-11-04', 'Student plan uses the Tehran day, not UTC.');
assert.deepEqual(standalonePlanExams([a, b], []), [a, b], 'Picker-only exams appear without any counselor plan.');
const linked = [{ id: 'plan', week_start: '2026-11-04', weekly_plan_items: [{ id: 'item', activity_type: 'exam', linked_exam_id: b.id }] }];
assert.deepEqual(standalonePlanExams([a, b], linked), [a], 'A linked exam is already a study box, never a duplicate.');
const simulated = [{ ...linked[0], weekly_plan_items: [{ ...linked[0].weekly_plan_items[0], activity_type: 'simulation_exam' }] }];
assert.deepEqual(standalonePlanExams([a, b], simulated), [a, b], 'Simulation boxes must not be sent to the designer.');
const external = [{ ...linked[0], weekly_plan_items: [{ ...linked[0].weekly_plan_items[0], activity_type: 'external_simulation_exam', subject: 'آزمون شبیه‌ساز · ماز' }] }];
assert.deepEqual(standalonePlanExams([a, b], external), [a, b], 'Provider exams must not be sent to the designer.');
const panel = fs.readFileSync('components/dashboard/student-planning-panel.tsx', 'utf8');
assert.match(panel, /sp-task--designer-exam/);
assert.doesNotMatch(panel, /sp-exam-assignments|exams\.map\(exam=><DesignerExamBox/, 'No duplicated full exam grid above the study report.');
assert.match(panel, /راهنمای طراح آزمون: \{exam\.description\}/);
assert.match(panel, /byId\.get\(item\.linked_exam_id\)\?\.description/);
assert.match(panel, /assigned=\{dailyExams\}/);
assert.match(fs.readFileSync('components/landing-header.tsx','utf8'), /href: \"\/dashboard\/student\/exams\"/, 'Student menu still leads to the full exam catalog.');
assert.match(panel, /standalone\.filter\(exam=>examPlanDay\(exam\.starts_at\)===selectedWeekDate\)/);
const dashboard = fs.readFileSync('app/dashboard/student/page.tsx', 'utf8');
assert.match(dashboard, /\.from\("exams"\)\.select\("id,title,description,starts_at,start_window_ends_at,duration_minutes"\)/);
assert.match(dashboard, /\.eq\("status", "published"\)/);
assert.match(dashboard, /assignedExams\.failed/);
console.log('Picker and box assignments, descriptions, Tehran dates, daily/weekly program and RLS-backed loading passed.');
