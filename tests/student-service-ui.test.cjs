const assert=require('node:assert/strict');
const fs=require('node:fs');
const read=path=>fs.readFileSync(path,'utf8');
for(const path of [
  'app/dashboard/student/exams/[id]/page.tsx',
  'app/dashboard/student/exams/[id]/review/page.tsx',
  'app/dashboard/student/exams/[id]/report/page.tsx',
]) assert.match(read(path),/registration_status\s*!==?\s*"active"|registration_status\s*!==?\s*'active'/,
  `${path}: direct exam URL must block inactive students before loading exam data`);
assert.match(read('lib/auth.ts'),/registration_status === "disabled"\) redirect\("\/dashboard\/student"\)/);
assert.match(read('app/dashboard/registration/page.tsx'),/registration_status === "disabled"\) redirect\("\/dashboard\/student"\)/);
assert.match(read('components/dashboard/student-service-notice.tsx'),/status === "disabled"/);
assert.match(read('supabase/migrations/095_admin_student_service_controls.sql'),/student_has_submitted_exam[\s\S]*student_services_active/);
assert.match(read('components/dashboard/registration-directory.tsx'),/isDisabled && \(/);
assert.match(read('components/dashboard/registration-directory.tsx'),/isActive && row\.counselor_id && \(/);
assert.match(read('app/dashboard/counselor/plans/page.tsx'),/loadAssignedPublishedHistory\(supabase\)/);
assert.match(read('app/dashboard/counselor/plans/page.tsx'),/plans=\{counselorPlans\}/, 'Earlier plans must stay read-only in the builder');
assert.match(read('app/dashboard/counselor/plans/[planId]/print/page.tsx'),/if \(!student \|\| \(planData\.counselor_id !== profile\.id && planData\.status !== "published"\)\) notFound\(\)/);
console.log('PASS: disabled accounts have a distinct notice, closed enrollment and direct exam links; admin rows offer resume, disable and reassignment');
