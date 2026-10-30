const assert = require('node:assert/strict');
const fs = require('node:fs');
const esbuild = require('esbuild');
const vm = require('node:vm');

const built = esbuild.transformSync(fs.readFileSync('lib/recommended-publishers.ts', 'utf8'), { loader: 'ts', format: 'cjs' }).code;
const moduleStub = { exports: {} };
vm.runInNewContext(built, { module: moduleStub, exports: moduleStub.exports, require });
const { recommendedPublishers, canRecommendPublisher, cleanRecommendedPublisher } = moduleStub.exports;
assert.ok(recommendedPublishers.includes('گاج') && recommendedPublishers.includes('خیلی سبز'));
assert.equal(new Set(recommendedPublishers).size, recommendedPublishers.length);
for (const type of ['lesson', 'practice_tests', 'review', 'homework']) assert.equal(canRecommendPublisher('konkur', type), true, type);
for (const type of ['class', 'offline_class', 'exam', 'simulation_exam', 'exam_analysis', 'textbook_reading', 'notes', 'summary', 'other']) {
  assert.equal(canRecommendPublisher('konkur', type), false, type);
}
for (const type of ['lesson', 'practice_tests', 'review', 'homework']) assert.equal(canRecommendPublisher('final_exam', type), false, type);
assert.equal(cleanRecommendedPublisher('  گاج  '), 'گاج');
assert.equal(cleanRecommendedPublisher('ناشر دلخواه'), 'ناشر دلخواه');
assert.equal(cleanRecommendedPublisher(null), null);
assert.equal(cleanRecommendedPublisher(3), undefined);
assert.equal(cleanRecommendedPublisher('x'.repeat(81)), undefined);
assert.equal(cleanRecommendedPublisher('x\ny'), undefined);

const builder = fs.readFileSync('components/dashboard/weekly-plan-builder.tsx', 'utf8');
const actions = fs.readFileSync('app/dashboard/actions.ts', 'utf8');
const student = fs.readFileSync('components/dashboard/student-planning-panel.tsx', 'utf8');
assert.match(builder, /canRecommendPublisher\(item\.preparationTrack, item\.activityType\)/);
assert.match(builder, /name="items"[\s\S]*?recommendedPublisher:/);
assert.match(actions, /s\.rpc\("save_weekly_plan_v7"/);
assert.match(student, /item\.recommended_publisher&&<p className="sp-recommended-publisher"/);
for (const path of ['components/dashboard/print-weekly-plan.tsx', 'app/dashboard/counselor/plans/[planId]/print/page.tsx', 'app/dashboard/student/plans/[planId]/print/page.tsx']) {
  assert.doesNotMatch(fs.readFileSync(path, 'utf8'), /recommended_publisher|recommendedPublisher/, `${path}: print must not fetch or show publisher`);
}
console.log('Publisher options, Konkur-only eligible activities, validation, on-site display and print exclusion passed.');
