const assert = require("node:assert/strict");
const fs = require("node:fs");

const migration = fs.readFileSync("supabase/migrations/105_admin_plan_service_reviews.sql", "utf8");
const milestoneMigration = fs.readFileSync("supabase/migrations/106_admin_plan_service_review_milestones.sql", "utf8");
const directory = fs.readFileSync("components/dashboard/registration-directory.tsx", "utf8");
const actions = fs.readFileSync("app/dashboard/admin/registrations/actions.ts", "utf8");
const page = fs.readFileSync("app/dashboard/admin/registrations/page.tsx", "utf8");
const shell = fs.readFileSync("components/dashboard/dashboard-shell.tsx", "utf8");

assert.match(migration, /published\.plan_count >= 4/);
assert.match(migration, /published\.plan_count % 4 = 0/);
assert.match(migration, /event_type = 'plan_review_continued'/);
assert.match(migration, /plan_review_plan_count = published\.plan_count/);
assert.match(migration, /admin_continue_student_plan_service_review/);
assert.match(migration, /grant execute on function public\.admin_student_plan_service_reviews\(\) to authenticated/);
assert.doesNotMatch(migration, /counselor.*notification|notification.*counselor/i);
assert.match(milestoneMigration, /\(count\(\*\)::integer \/ 4\) \* 4 as review_count/);
assert.match(milestoneMigration, /current_review_count := \(current_plan_count \/ 4\) \* 4/);

assert.match(directory, /نیازمند بررسی ادامه یا توقف خدمات \(\{reviewRows\.length\.toLocaleString\("fa-IR"\)\} نفر\)/);
assert.match(directory, /reviewOnly \? reviewRows : provinceRows/);
assert.match(directory, /continueStudentPlanServiceReview/);
assert.match(directory, /label="ادامهٔ خدمات تأیید شد"/);
assert.doesNotMatch(directory, /برنامهٔ \{reviewPlanCount[^}]*\} · نیازمند بررسی/);
assert.doesNotMatch(shell, /نیازمند بررسی ادامه یا توقف خدمات/);

assert.match(actions, /admin_continue_student_plan_service_review/);
assert.match(actions, /planCount % 4 !== 0/);
assert.match(page, /reviewOnly=\{params\.review === "continuation"\}/);
assert.match(page, /plan_review_continued/);

console.log("PASS: admin-only multiple-of-four plan review is exposed only through the student-services page filter");
