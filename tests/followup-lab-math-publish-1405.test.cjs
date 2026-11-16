// Follow-up item 4b — the frozen publication catalog must admit the lab books
// for mathematics students, or Item 4 is half-broken: the app catalog
// (lib/school-catalog.ts) and the topic bank (migration 243) list
// «آزمایشگاه علوم تجربی ۱/۲» for mathematics, but the frozen catalog inside
// private.planner_validate_publication (migration 126, re-issued by 226)
// omitted them from finals.mathematics."10"/"11", so publishing a math
// student's plan containing a lab item raised 'Invalid school subject'.
//
// Migration 244 re-issues the function with ONLY the lab subjects added to
// the mathematics lists — finals and routines — in exactly the positions the
// app curriculum puts them. Everything else in the function is byte-identical
// to migration 226 (proved in-test, below).
//
// Amendment 4c: 244 also reorders the cross-field routines."null" lists to the
// app's computed order (Item 4 made the lab books appear via the mathematics
// block first in the union). Order-only, no membership change — the validator
// only ever does `allowed ? subject`, so this cannot change any outcome. The
// reordering covers routines."null"."10"/"11"/"12"/"null" (all four drifted,
// not just "10": the publication test aborts at the first mismatch, which is
// "10", but the same union shift moved the labs in the other three too).
//
// PGlite test: apply 126 + 226, run a behavior matrix, apply 244, run it
// again. Asserts: (a) a mathematics grade-10 plan item with subject
// آزمایشگاه علوم تجربی ۱ validates; (b) a mathematics grade-11 plan item
// with آزمایشگاه علوم تجربی ۲ validates; (c) experimental_sciences lab items
// still validate; (d) the behavior matrix behaves identically under 226-only
// vs 226+244 except for the math+lab cases; (e) re-running 244 is a no-op.
// Also asserts the 244 catalog matches the app curriculum (finals for every
// field/grade, routines for every field including the cross-field "null"
// lists) and that the only lists that changed vs 226 are the six mathematics
// lists, by lab-only insertions, plus the four routines."null" lists, by
// order-only moves of the lab subjects. The behavior matrix also covers
// null-field students, proving the reorder changes no validation outcome.
//
// Run: node tests/followup-lab-math-publish-1405.test.cjs  (from the repo root)
// Must print PASS and exit 0.
const fs = require('node:fs');
const assert = require('node:assert/strict');
const { randomUUID } = require('node:crypto');
const { PGlite } = require('@electric-sql/pglite');
const { buildSync } = require('esbuild');

const LAB1 = 'آزمایشگاه علوم تجربی ۱';
const LAB2 = 'آزمایشگاه علوم تجربی ۲';
const sql = (n) => fs.readFileSync(`supabase/migrations/${n}.sql`, 'utf8');
const sql126 = sql('126_planner_publish_validation');
const sql226 = sql('226_planner_grade9_catalog_1405');
const sql244 = sql('244_planner_followup_lab_math_publish_1405');

// --- Static proof 1: the function outside the catalog is byte-identical to 226
const maskCatalog = (t) => t.replace(/\$catalog\$[\s\S]*?\$catalog\$/, '$catalog$<CATALOG>$catalog$');
const bodyOf = (t) => {
  const masked = maskCatalog(t);
  return masked.slice(masked.indexOf('create or replace function'));
};
assert.equal(bodyOf(sql244), bodyOf(sql226),
  'function body outside the catalog literal must be byte-identical to migration 226');

// --- Static proof 2: the catalogs differ ONLY in the six mathematics lists
// (each by lab-only insertions that preserve the order of the old elements)
// plus the four routines."null" lists (each by an order-only move of the lab
// subjects to the app's computed positions, with membership unchanged).
const cat226 = JSON.parse(sql226.match(/\$catalog\$([\s\S]*?)\$catalog\$/)[1]);
const cat244 = JSON.parse(sql244.match(/\$catalog\$([\s\S]*?)\$catalog\$/)[1]);
const changedLists = [];
const reorderedLists = [];
for (const section of ['finals', 'routines']) {
  for (const field of Object.keys(cat226[section])) {
    for (const grade of Object.keys(cat226[section][field])) {
      const o = cat226[section][field][grade];
      const n = cat244[section][field][grade];
      if (JSON.stringify(o) === JSON.stringify(n)) continue;
      const added = n.filter((x) => !o.includes(x));
      const removed = o.filter((x) => !n.includes(x));
      if (added.length > 0) {
        assert.deepEqual(removed, [],
          `${section}.${field}.${grade} dropped a subject: ${removed}`);
        assert.ok(added.every((x) => x === LAB1 || x === LAB2),
          `${section}.${field}.${grade} gained a non-lab subject: ${added}`);
        assert.deepEqual(n.filter((x) => o.includes(x)), o,
          `${section}.${field}.${grade} reordered or dropped an old subject`);
        changedLists.push(`${section}.${field}.${grade}:${added.join('+')}`);
      } else {
        // Order-only change: same subject set, and only the lab subjects
        // moved (everything else keeps its relative order).
        assert.deepEqual(new Set(n), new Set(o),
          `${section}.${field}.${grade} changed membership: ${removed}`);
        const withoutLabs = (list) => list.filter((x) => x !== LAB1 && x !== LAB2);
        assert.deepEqual(withoutLabs(n), withoutLabs(o),
          `${section}.${field}.${grade} moved a non-lab subject`);
        reorderedLists.push(`${section}.${field}.${grade}`);
      }
    }
  }
}
assert.deepEqual(changedLists.sort(), [
  'finals.mathematics.10:آزمایشگاه علوم تجربی ۱',
  'finals.mathematics.11:آزمایشگاه علوم تجربی ۲',
  'routines.mathematics.10:آزمایشگاه علوم تجربی ۱',
  'routines.mathematics.11:آزمایشگاه علوم تجربی ۱+آزمایشگاه علوم تجربی ۲',
  'routines.mathematics.12:آزمایشگاه علوم تجربی ۱+آزمایشگاه علوم تجربی ۲',
  'routines.mathematics.null:آزمایشگاه علوم تجربی ۱+آزمایشگاه علوم تجربی ۲',
], 'exactly the six mathematics lists may change by lab insertions');
assert.deepEqual(reorderedLists.sort(), [
  'routines.null.10',
  'routines.null.11',
  'routines.null.12',
  'routines.null.null',
], 'exactly the four routines."null" lists may change by lab-only reordering');

// --- Static proof 3: the 244 catalog matches the app curriculum -----------
// (Same esbuild pattern as the follow-up-4 test.)
const bundle = buildSync({
  entryPoints: ['lib/planning-curriculum.ts'],
  bundle: true,
  platform: 'node',
  format: 'cjs',
  write: false,
  alias: { '@': process.cwd() },
}).outputFiles[0].text;
const mod = { exports: {} };
new Function('module', 'exports', 'require', bundle)(mod, mod.exports, require);
const FIELDS = [null, 'mathematics', 'experimental_sciences', 'humanities', 'arts', 'foreign_languages'];
for (const field of FIELDS) {
  for (const grade of [9, 10, 11, 12]) {
    assert.deepEqual(cat244.finals[field ?? 'null'][grade],
      mod.exports.curriculumBooks(field, grade, 'final_exam').map((x) => x.subject),
      `244 finals.${field ?? 'null'}.${grade} must equal the app curriculum`);
  }
}
for (const field of FIELDS.filter(Boolean)) {
  for (const grade of [9, 10, 11, 12, null]) {
    assert.deepEqual(cat244.routines[field][grade === null ? 'null' : grade],
      mod.exports.routineSubjectOptions(field, grade),
      `244 routines.${field}.${grade} must equal the app curriculum`);
  }
}
// The cross-field routines."null" lists are membership-checked only, so their
// order is behavior-neutral — but the frozen snapshot must still mirror the
// app, including order (amendment 4c). Each list must equal the app's computed
// order exactly AND hold the same subjects as 226 (order-only change).
for (const grade of [9, 10, 11, 12, null]) {
  const key = grade === null ? 'null' : grade;
  assert.deepEqual(cat244.routines.null[key],
    mod.exports.routineSubjectOptions(null, grade),
    `244 routines.null.${key} must equal the app curriculum`);
  assert.deepEqual(new Set(cat244.routines.null[key]),
    new Set(cat226.routines.null[key]),
    `244 routines.null.${key} must hold the same subjects as 226`);
}

// --- PGlite: behavior matrix, 226-only vs 226+244 ---------------------------
const preamble = `create role anon;create role authenticated;create schema private;create schema auth;create type public.content_status as enum('draft','published');
 create table public.profiles(id uuid primary key,study_field text,grade integer);
 create table public.counselor_students(counselor_id uuid,student_id uuid);
 create table public.weekly_plans(id uuid primary key,counselor_id uuid,student_id uuid,week_start date,status public.content_status,routines jsonb);
 create table public.weekly_plan_items(id uuid primary key,plan_id uuid,subject text);
 create table private.planner_working_drafts(counselor_id uuid,student_id uuid,week_start date,plan_id uuid,snapshot jsonb,revision bigint);
 create function auth.uid() returns uuid language sql stable as $$select current_setting('request.jwt.claim.sub')::uuid$$;
 create function private.require_planner_draft_access(uuid) returns void language sql as $$select$$;
 create function public.planner_publish_working_draft(uuid,date,text) returns uuid language plpgsql security definer as $$begin return $1;end$$;
 grant usage on schema public,private,auth to authenticated;`;

const WEEK = '2099-01-01';
// One student per field for the finals matrix (student grade is irrelevant
// there — only the field and the item's sourceGrade gate); one per field+grade
// for the routines matrix (the student's own grade gates routines).
const fieldStudents = { mathematics: 'math', experimental_sciences: 'exp', humanities: 'hum', null: 'null9', arts: 'arts' };
const routineStudents = {
  math10: ['mathematics', 10], math11: ['mathematics', 11], math12: ['mathematics', 12],
  mathNull: ['mathematics', null], exp10: ['experimental_sciences', 10], exp11: ['experimental_sciences', 11],
  hum10: ['humanities', 10], null9: [null, 9], arts10: ['arts', 10],
  // Null-field students exercise the reordered routines."null" lists (4c):
  // their routine outcomes must be identical under 226-only vs 226+244.
  null10: [null, 10], null11: [null, 11], null12: [null, 12], nullNull: [null, null],
};
// A baseline valid plan item per student, used by the routines cases so only
// the routine subject varies.
const baselineItem = {
  math10: { subject: 'ریاضی ۱', grade: 10, track: 'final_exam' },
  math11: { subject: 'حسابان ۱', grade: 11, track: 'final_exam' },
  math12: { subject: 'حسابان ۲', grade: 12, track: 'final_exam' },
  mathNull: { subject: 'ریاضی ۱', grade: 10, track: 'final_exam' },
  exp10: { subject: 'زیست‌شناسی ۱', grade: 10, track: 'final_exam' },
  exp11: { subject: 'زیست‌شناسی ۲', grade: 11, track: 'final_exam' },
  hum10: { subject: 'تاریخ ۱', grade: 10, track: 'final_exam' },
  null9: { subject: 'ریاضی', grade: 9, track: 'final_exam' },
  arts10: { subject: 'درک عمومی هنر', grade: 10, track: 'konkur' },
  // Konkur track: finals."null" is empty for grades 10–12, so a final_exam
  // item would be rejected for every subject and mask the routine result;
  // a konkur item passes the grade gate and isolates the routine subject.
  null10: { subject: 'ریاضی ۱', grade: 10, track: 'konkur' },
  null11: { subject: 'حسابان ۱', grade: 11, track: 'konkur' },
  null12: { subject: 'حسابان ۲', grade: 12, track: 'konkur' },
  nullNull: { subject: 'ریاضی ۱', grade: 10, track: 'konkur' },
};

function snapshot(item, routineSubject) {
  const routines = Array.from({ length: 7 }, (_, dayOfWeek) =>
    ({ dayOfWeek, subject: '', details: '', secondSubject: '', secondDetails: '' }));
  if (routineSubject !== null) routines[0].subject = routineSubject;
  return {
    title: 'عنوان', notes: '',
    items: [{
      id: null, sourceItemId: null, dayOfWeek: 0, durationMinutes: 60,
      subject: item.subject, chapter: '', activityType: 'lesson', targetTestCount: null,
      details: '', sourceGrade: item.grade, preparationTrack: item.track,
      recommendedPublisher: null, examYear: null,
    }],
    routines,
    extras: { week: { goal: '', wakeTime: '07:30' }, items: [null] },
  };
}

(async () => {
  const db = new PGlite();
  try {
    await db.exec(preamble);
    await db.exec(sql126);
    await db.exec(sql226);
    const counselor = randomUUID();
    await db.query("select set_config('request.jwt.claim.sub',$1,false)", [counselor]);
    const studentIds = {};
    const planIds = {};
    const mkStudent = async (key, field, grade) => {
      const s = randomUUID();
      const p = randomUUID();
      studentIds[key] = s;
      planIds[key] = p;
      await db.query('insert into public.profiles values($1,$2,$3)', [s, field, grade]);
      await db.query('insert into public.counselor_students values($1,$2)', [counselor, s]);
      await db.query("insert into public.weekly_plans values($1,$2,$3,$4,'draft','[]'::jsonb)",
        [p, counselor, s, WEEK]);
    };
    for (const [field, key] of Object.entries(fieldStudents)) {
      await mkStudent(key, field === 'null' ? null : field, key === 'null9' ? 9 : 10);
    }
    for (const [key, [field, grade]] of Object.entries(routineStudents)) {
      if (studentIds[key]) continue;
      await mkStudent(key, field, grade);
    }
    const validate = async (studentKey, snap) => {
      try {
        await db.query('select private.planner_validate_publication($1,$2,$3,$4)',
          [studentIds[studentKey], planIds[studentKey], WEEK, JSON.stringify(snap)]);
        return 'OK';
      } catch (e) { return e.message; }
    };

    const MATRIX_SUBJECTS = [LAB1, LAB2, 'ریاضی ۱', 'زیست‌شناسی ۱', 'هندسه ۱', 'تاریخ ۱', 'فارسی ۱', 'ریاضی', 'درس نامعتبر'];
    const runMatrix = async () => {
      const out = {};
      // Finals path: (student field, item sourceGrade, subject, final_exam).
      for (const [field, key] of Object.entries(fieldStudents)) {
        for (const grade of [9, 10, 11, 12]) {
          for (const subject of MATRIX_SUBJECTS) {
            out[`finals|${field}|${grade}|${subject}`] =
              await validate(key, snapshot({ subject, grade, track: 'final_exam' }, null));
          }
        }
      }
      // Konkur path: only the grade-9 rule gates subjects there.
      for (const [field, key] of Object.entries(fieldStudents)) {
        out[`konkur|${field}|9|هوش و استعداد تحلیلی`] =
          await validate(key, snapshot({ subject: 'هوش و استعداد تحلیلی', grade: 9, track: 'konkur' }, null));
        out[`konkur|${field}|9|ریاضی`] =
          await validate(key, snapshot({ subject: 'ریاضی', grade: 9, track: 'konkur' }, null));
        out[`konkur|${field}|10|${LAB1}`] =
          await validate(key, snapshot({ subject: LAB1, grade: 10, track: 'konkur' }, null));
      }
      // Routines path: (student field+grade, routine subject), baseline item.
      for (const [key, item] of Object.entries(baselineItem)) {
        for (const subject of MATRIX_SUBJECTS) {
          out[`routines|${key}|${subject}`] = await validate(key, snapshot(item, subject));
        }
      }
      return out;
    };

    // (a)(b) under 226-only: the math lab items are rejected; (c) exp lab items pass.
    assert.equal(await validate('math', snapshot({ subject: LAB1, grade: 10, track: 'final_exam' }, null)),
      'Invalid school subject', '226 must reject mathematics/10 lab 1 plan item');
    assert.equal(await validate('math', snapshot({ subject: LAB2, grade: 11, track: 'final_exam' }, null)),
      'Invalid school subject', '226 must reject mathematics/11 lab 2 plan item');
    assert.equal(await validate('exp', snapshot({ subject: LAB1, grade: 10, track: 'final_exam' }, null)),
      'OK', '226 must accept experimental_sciences/10 lab 1 plan item');
    assert.equal(await validate('exp', snapshot({ subject: LAB2, grade: 11, track: 'final_exam' }, null)),
      'OK', '226 must accept experimental_sciences/11 lab 2 plan item');
    assert.equal(await validate('math10', snapshot(baselineItem.math10, LAB1)),
      'Invalid routine subject', '226 must reject a mathematics/10 routine with lab 1');

    const before = await runMatrix();
    const countBefore = Object.keys(before).length;
    await db.exec(sql244);

    // (a)(b) under 226+244: the math lab items validate; (c) exp lab items still do.
    assert.equal(await validate('math', snapshot({ subject: LAB1, grade: 10, track: 'final_exam' }, null)),
      'OK', '244 must accept mathematics/10 lab 1 plan item');
    assert.equal(await validate('math', snapshot({ subject: LAB2, grade: 11, track: 'final_exam' }, null)),
      'OK', '244 must accept mathematics/11 lab 2 plan item');
    assert.equal(await validate('exp', snapshot({ subject: LAB1, grade: 10, track: 'final_exam' }, null)),
      'OK', '244 must still accept experimental_sciences/10 lab 1 plan item');
    assert.equal(await validate('exp', snapshot({ subject: LAB2, grade: 11, track: 'final_exam' }, null)),
      'OK', '244 must still accept experimental_sciences/11 lab 2 plan item');
    // Routines: a math student's routine may now name the lab books.
    assert.equal(await validate('math10', snapshot(baselineItem.math10, LAB1)), 'OK');
    assert.equal(await validate('math11', snapshot(baselineItem.math11, LAB1)), 'OK');
    assert.equal(await validate('math11', snapshot(baselineItem.math11, LAB2)), 'OK');
    assert.equal(await validate('math12', snapshot(baselineItem.math12, LAB1)), 'OK');
    assert.equal(await validate('math12', snapshot(baselineItem.math12, LAB2)), 'OK');
    assert.equal(await validate('mathNull', snapshot(baselineItem.mathNull, LAB1)), 'OK');
    assert.equal(await validate('mathNull', snapshot(baselineItem.mathNull, LAB2)), 'OK');
    // ...but the wrong lab for the grade is still rejected (no lab 2 in grade 10).
    assert.equal(await validate('math10', snapshot(baselineItem.math10, LAB2)),
      'Invalid routine subject', 'mathematics/10 routine must still reject lab 2');
    assert.equal(await validate('math', snapshot({ subject: LAB2, grade: 10, track: 'final_exam' }, null)),
      'Invalid school subject', 'mathematics/10 plan item must still reject lab 2');
    assert.equal(await validate('math', snapshot({ subject: LAB1, grade: 11, track: 'final_exam' }, null)),
      'Invalid school subject', 'mathematics/11 plan item must still reject lab 1');

    // (d) Behavior matrix: identical except for the math+lab cases.
    const after = await runMatrix();
    assert.equal(Object.keys(after).length, countBefore, 'matrix size must not change');
    const diffs = Object.keys(before).filter((k) => before[k] !== after[k]);
    const expectedDiffs = [
      'finals|mathematics|10|آزمایشگاه علوم تجربی ۱',
      'finals|mathematics|11|آزمایشگاه علوم تجربی ۲',
      'routines|math10|آزمایشگاه علوم تجربی ۱',
      'routines|math11|آزمایشگاه علوم تجربی ۱',
      'routines|math11|آزمایشگاه علوم تجربی ۲',
      'routines|math12|آزمایشگاه علوم تجربی ۱',
      'routines|math12|آزمایشگاه علوم تجربی ۲',
      'routines|mathNull|آزمایشگاه علوم تجربی ۱',
      'routines|mathNull|آزمایشگاه علوم تجربی ۲',
    ];
    assert.deepEqual(diffs.sort(), expectedDiffs.sort(),
      `matrix must differ ONLY in the math+lab cases, got: ${JSON.stringify(diffs)}`);
    for (const k of diffs) {
      assert.ok(before[k].startsWith('Invalid'), `${k} was not rejected under 226: ${before[k]}`);
      assert.equal(after[k], 'OK', `${k} must validate under 244`);
    }

    // (e) Re-running 244 is a no-op: the installed function is unchanged and
    // the same cases still behave the same way.
    const defBefore = (await db.query("select pg_get_functiondef('private.planner_validate_publication(uuid,uuid,date,jsonb)'::regprocedure) d")).rows[0].d;
    await db.exec(sql244);
    const defAfter = (await db.query("select pg_get_functiondef('private.planner_validate_publication(uuid,uuid,date,jsonb)'::regprocedure) d")).rows[0].d;
    assert.equal(defAfter, defBefore, 're-running 244 must not change the function');
    assert.equal(await validate('math', snapshot({ subject: LAB1, grade: 10, track: 'final_exam' }, null)), 'OK');
    assert.equal(await validate('math', snapshot({ subject: 'درس نامعتبر', grade: 10, track: 'final_exam' }, null)),
      'Invalid school subject', 're-run must keep rejecting invalid subjects');

    console.log(`PASS: Follow-up 4b+4c — migration 244 re-issues planner_validate_publication with only the lab subjects added to the six mathematics lists (finals 10/11, routines 10/11/12/null), byte-identical to 226 everywhere else, plus the order-only 4c reorder of the four routines."null" lists to the app's computed order (lab ۱ after تربیت بدنی ۱, lab ۲ after زمین‌شناسی; membership unchanged); math grade-10/11 lab plan items and math lab routines now validate, experimental_sciences lab items still validate, null-field routine outcomes are identical under 226-only vs 226+244, and a ${countBefore}-case behavior matrix is identical under 226-only vs 226+244 except for the 9 math+lab cases; re-running 244 is a no-op`);
  } finally { await db.close(); }
})().catch((e) => { console.error(e); process.exitCode = 1; });
