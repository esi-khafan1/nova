const assert = require("node:assert/strict");
const fs = require("node:fs");

const migration = fs.readFileSync("supabase/migrations/107_counselor_exam_extensions.sql", "utf8");
const counselorPage = fs.readFileSync("app/dashboard/counselor/exams/page.tsx", "utf8");
const counselorActions = fs.readFileSync("app/dashboard/counselor/exams/actions.ts", "utf8");
const extensionForm = fs.readFileSync("components/dashboard/exam-extension-form.tsx", "utf8");
const studentExam = fs.readFileSync("app/dashboard/student/exams/[id]/page.tsx", "utf8");
const studentExams = fs.readFileSync("app/dashboard/student/exams/page.tsx", "utf8");
const studentCard = fs.readFileSync("components/dashboard/student-exam-card.tsx", "utf8");
const studentDashboard = fs.readFileSync("app/dashboard/student/page.tsx", "utf8");
const planExams = fs.readFileSync("lib/student-plan-exams.ts", "utf8");
const planningPanel = fs.readFileSync("components/dashboard/student-planning-panel.tsx", "utf8");

// Storage and authorization boundaries.
assert.match(migration, /create table public\.exam_extensions/);
assert.match(migration, /unique \(exam_id, student_id\)/);
assert.match(migration, /grant select on public\.exam_extensions to authenticated/);
assert.match(migration, /student_id = \(select auth\.uid\(\)\)/);
assert.match(migration, /cs\.counselor_id = \(select auth\.uid\(\)\)/);
assert.match(migration, /counselor_set_exam_extension/);
assert.match(migration, /counselor_cancel_exam_extension/);
assert.match(migration, /student_services_active\(target_student_id\)/);
assert.match(migration, /attempt\.submitted_at is not null/);
assert.match(migration, /private\.exam_extension_is_missed/);

// An extension is a start window for one student, not a shortened exam.
assert.match(migration, /stamp \+ exam\.duration_minutes \* interval '1 minute'/);
assert.match(migration, /extension_id uuid references public\.exam_extensions/);
assert.match(migration, /extension_generation integer/);
assert.match(migration, /generation = public\.exam_extensions\.generation \+ 1/);
assert.match(migration, /delete from public\.exam_sessions/);
assert.match(migration, /student_exam_extensions\(\)/);
assert.match(migration, /can_extend boolean/);
assert.match(migration, /private\.exam_extension_is_missed\(exam\.id, target_student_id\)/);

// Counselor UI: the action lives in the paged per-student history.
assert.match(counselorPage, /ExamExtensionForm/);
assert.match(counselorPage, /exam\.can_extend/);
assert.match(counselorPage, /extension=\{exam\.extension_id/);
assert.match(counselorActions, /counselor_set_exam_extension/);
assert.match(counselorActions, /counselor_cancel_exam_extension/);
assert.match(extensionForm, /روز تمدید/);
assert.match(extensionForm, /پایان مهلت شروع/);
assert.match(extensionForm, /پس از شروع، کل مدت آزمون را دارد/);
assert.match(extensionForm, /لغو تمدید/);
// Extension scheduling mirrors the exam-designer controls: a live Tehran
// clock, a five-minute lead, and no selectable past time on the current day.
assert.match(extensionForm, /earliestExamSchedule/);
assert.match(extensionForm, /scheduleBounds\.date/);
assert.match(extensionForm, /todayDate=\{today\}/);
assert.match(extensionForm, /date === scheduleBounds\.date \? scheduleBounds\.time/);
assert.doesNotMatch(extensionForm, /اولین زمان مجاز امروز/);
assert.match(extensionForm, /\{!open && \(/);
assert.match(extensionForm, /useState\(false\)/);
assert.doesNotMatch(extensionForm, /تمدید فعلی/);
assert.doesNotMatch(counselorPage, /تمدید ثبت‌شده/);
assert.match(extensionForm, /date === today && !todayHasTime/);
assert.match(extensionForm, /setInterval\(refresh, 15000\)/);

// Student entry and lists use the personal window.
assert.match(studentExam, /student_exam_extensions/);
assert.match(studentExam, /extension\?\.starts_at \?\? exam\.starts_at/);
assert.match(studentExam, /تمدید مشاور/);
assert.match(studentExams, /student_exam_extensions/);
assert.match(studentCard, /مهلت شروع تمدید تا/);
assert.match(studentCard, /activeExtension \|\| exam\.start_window_ends_at/);

// Daily/weekly planning moves an unsubmitted extended exam to the extension day.
assert.match(studentDashboard, /starts_at: extension\.starts_at/);
assert.match(studentDashboard, /extended: true/);
assert.match(planExams, /exam\.extended/);
assert.match(planningPanel, /آزمون تمدیدشده/);

console.log("counselor exam extension checks passed");
