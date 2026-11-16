// Follow-up item 1 — هندسه ۲ selector: «فصل ۴: تجسم فضایی» removed from the
// geometry2 (هندسه ۲, grade 11) catalog array ONLY. No migration, no bank row
// touched: the bank already has zero rows for هندسه ۲ chapter 4 (batch-4 test
// asserts that), so there is nothing to delete.
//
// Verifies, with the real bundled code (esbuild, same pattern as the batch-4
// test — no live browser, no DB needed for a catalog-only change):
//   1. curriculumBooks('mathematics', 11, 'konkur' AND 'final_exam') lists
//      هندسه ۲ with exactly chapters 1–3; فصل ۴ is gone from the selector.
//   2. هندسه ۱ (grade 10) still lists فصل ۴ — the real chapter is untouched.
//      هندسه ۳ is unchanged too.
//   3. Source-level guard: «تجسم فضایی» occurs exactly once in
//      lib/study-catalog.ts, inside the geometry1 array, never in geometry2.
//   4. A stored plan referencing (هندسه ۲, فصل ۴) still reads back:
//      plannerGridFromPlan (lib/planner-plan-adapter.ts) preserves the item's
//      subject/chapter and its stored topics (title/pages/bankId) verbatim —
//      it never validates a chapter against the catalog — and a
//      plannerSnapshotFromEditor round-trip keeps them too.
//   5. The chapter dropdown keeps the stored value visible: the builder
//      (components/dashboard/weekly-plan-builder.tsx) renders a stored chapter
//      that is no longer in the catalog as «<chapter> (ثبت قبلی)» instead of
//      dropping it; the source still contains that fallback.
//   6. The topic suggester does not crash or mis-suggest for the removed
//      chapter: with a bank holding only فصل ۱–۳ rows, suggestNextTopic for
//      فصل ۴ returns null.
//
// Run: node tests/followup-geometry2-selector.test.cjs  (from the repo root)
// Must print PASS and exit 0.
const fs = require('node:fs');
const assert = require('node:assert/strict');
const { buildSync } = require('esbuild');

const CH4 = 'فصل ۴: تجسم فضایی';
const G2_EXPECTED = [
  'فصل ۱: دایره',
  'فصل ۲: تبدیل‌های هندسی و کاربردها',
  'فصل ۳: روابط طولی در مثلث',
];
const G1_EXPECTED = [
  'فصل ۱: ترسیم‌های هندسی و استدلال',
  'فصل ۲: قضیه تالس، تشابه و کاربردهای آن',
  'فصل ۳: چندضلعی‌ها',
  'فصل ۴: تجسم فضایی',
];

function bundle(entry) {
  const code = buildSync({
    entryPoints: [entry],
    bundle: true,
    platform: 'node',
    format: 'cjs',
    write: false,
    alias: { '@': process.cwd() },
  }).outputFiles[0].text;
  const mod = { exports: {} };
  new Function('module', 'exports', 'require', code)(mod, mod.exports, require);
  return mod.exports;
}

// --- 1+2. Selector contents via the real curriculum code -------------------
const curriculum = bundle('lib/planning-curriculum.ts');
for (const track of ['konkur', 'final_exam']) {
  const g2 = curriculum.curriculumBooks('mathematics', 11, track)
    .find((b) => b.subject === 'هندسه ۲');
  assert.ok(g2, `هندسه ۲ missing from mathematics/11/${track}`);
  assert.deepEqual(g2.chapters, G2_EXPECTED, `هندسه ۲ chapters (${track})`);
  assert.ok(!g2.chapters.includes(CH4), `فصل ۴ still offered for هندسه ۲ (${track})`);
  const g1 = curriculum.curriculumBooks('mathematics', 10, track)
    .find((b) => b.subject === 'هندسه ۱');
  assert.ok(g1, `هندسه ۱ missing from mathematics/10/${track}`);
  assert.deepEqual(g1.chapters, G1_EXPECTED, `هندسه ۱ chapters (${track})`);
  assert.ok(g1.chapters.includes(CH4), `فصل ۴ lost from هندسه ۱ (${track})`);
  const g3 = curriculum.curriculumBooks('mathematics', 12, track)
    .find((b) => b.subject === 'هندسه ۳');
  assert.deepEqual(
    g3.chapters,
    ['فصل ۱: ماتریس و کاربردها', 'فصل ۲: آشنایی با مقاطع مخروطی', 'فصل ۳: بردارها'],
    `هندسه ۳ chapters (${track})`,
  );
}

// --- 3. Source-level guard: exactly one «تجسم فضایی», in geometry1 only ----
const catalogSrc = fs.readFileSync('lib/study-catalog.ts', 'utf8');
const occurrences = catalogSrc.split('تجسم فضایی').length - 1;
assert.equal(occurrences, 1, `expected exactly 1 «تجسم فضایی» in study-catalog.ts, found ${occurrences}`);
const arrayBody = (name) => {
  const m = catalogSrc.match(new RegExp(`const ${name} = \\[([\\s\\S]*?)\\];`));
  assert.ok(m, `${name} array not found in study-catalog.ts`);
  return m[1];
};
assert.ok(arrayBody('geometry1').includes(CH4), 'geometry1 lost فصل ۴');
assert.ok(!arrayBody('geometry2').includes(CH4), 'geometry2 still lists فصل ۴');
assert.ok(!arrayBody('geometry3').includes(CH4), 'geometry3 unexpectedly lists فصل ۴');

// --- 4. Stored-plan read-back via the real adapter --------------------------
// A plan saved BEFORE this change, referencing (هندسه ۲, فصل ۴). The bank has
// no chapter-4 rows, so its stored topics are free-text ones (bankId null);
// one topic below also carries a bankId string to prove an id survives too.
const adapter = bundle('lib/planner-plan-adapter.ts');
const storedTopics = [
  { title: 'تجسم فضایی — مرور', pageStart: null, pageEnd: null },
  { title: 'تمرین‌های فصل ۴', pageStart: 70, pageEnd: 72, bankId: null },
  { title: 'وضعیت خط و دایره', pageStart: 10, pageEnd: 11, bankId: '00000000-0000-0000-0000-000000000001' },
];
const storedPlan = {
  id: 'plan-1',
  student_id: 'student-1',
  week_start: '2026-11-16',
  title: 'هفته نمونه',
  notes: null,
  status: 'draft',
  weekly_plan_items: [{
    id: 'item-1',
    day_of_week: 0,
    duration_minutes: 60,
    subject: 'هندسه ۲',
    chapter: CH4,
    activity_type: 'lesson',
    target_test_count: 10,
    details: '',
    sort_order: 0,
    source_grade: 11,
    preparation_track: 'konkur',
  }],
};
const extras = {
  week: {},
  items: { 'item-1': { topics: storedTopics } },
};
const grid = adapter.plannerGridFromPlan(storedPlan, new Set(), extras, '2026-11-16');
const block = grid[0][0];
assert.ok(block, 'stored هندسه ۲ / فصل ۴ item did not load into the grid');
assert.equal(block.subject, 'هندسه ۲', 'stored subject changed on read-back');
assert.equal(block.chapter, CH4, 'stored chapter dropped on read-back');
assert.deepEqual(block.topics, storedTopics, 'stored topics changed on read-back');

// Round-trip back through the snapshot builder: chapter + topics survive.
const snapshot = adapter.plannerSnapshotFromEditor({
  title: 'هفته نمونه',
  notes: '',
  weekStart: '2026-11-16',
  today: '2026-11-16',
  planStatus: 'draft',
  grid,
  routines: [],
  weekExtra: {},
});
assert.equal(snapshot.items.length, 1, 'snapshot lost the stored item');
assert.equal(snapshot.items[0].subject, 'هندسه ۲', 'snapshot subject changed');
assert.equal(snapshot.items[0].chapter, CH4, 'snapshot chapter dropped');
assert.deepEqual(snapshot.extras.items[0].topics, storedTopics, 'snapshot topics changed');

// --- 5. Dropdown fallback: stored chapter stays visible as «(ثبت قبلی)» -----
const builderSrc = fs.readFileSync('components/dashboard/weekly-plan-builder.tsx', 'utf8');
assert.ok(
  builderSrc.includes("{item.chapter&&!chapters(item).includes(item.chapter)&&<option value={item.chapter}>{item.chapter} (ثبت قبلی)</option>}"),
  'weekly-plan-builder lost the (ثبت قبلی) fallback for a stored chapter no longer in the catalog',
);
// Simulate the fallback condition with the post-change chapter list.
const g2Chapters = curriculum.curriculumBooks('mathematics', 11, 'konkur')
  .find((b) => b.subject === 'هندسه ۲').chapters;
assert.ok(!g2Chapters.includes(CH4), 'fallback precondition wrong: فصل ۴ is still offered');
assert.ok(
  CH4 && !g2Chapters.includes(CH4),
  'stored فصل ۴ would not hit the (ثبت قبلی) branch',
);

// --- 6. Topic suggester: no crash, no wrong suggestion for فصل ۴ ------------
const topicsLib = bundle('lib/planner-topics.ts');
const bankCh13 = [
  { id: 'b1', subject: 'هندسه ۲', grade: 11, chapter: 'فصل ۱: دایره', title: 'وضعیت خط و دایره', pageStart: 10, pageEnd: 11, order: 451 },
  { id: 'b2', subject: 'هندسه ۲', grade: 11, chapter: 'فصل ۳: روابط طولی در مثلث', title: 'منابع', pageStart: 76, pageEnd: 77, order: 3000 },
];
assert.equal(
  topicsLib.suggestNextTopic(bankCh13, [], {
    studentId: 'student-1', subject: 'هندسه ۲', grade: 11, chapter: CH4,
    date: '2026-11-16', order: 0,
  }),
  null,
  'suggestNextTopic should return null (not crash or suggest another chapter) for فصل ۴ with no bank rows',
);

console.log('PASS: Follow-up 1 — هندسه ۲ selector no longer offers فصل ۴: تجسم فضایی (konkur + final_exam); هندسه ۱ still offers it; a stored plan referencing (هندسه ۲, فصل ۴) reads back with subject/chapter/topics intact and stays visible as (ثبت قبلی); no bank row touched');
