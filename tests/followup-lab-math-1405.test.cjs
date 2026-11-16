// Follow-up item 4 — آزمایشگاه ۱۰/۱۱: mathematics stream.
// Catalog: lib/school-catalog.ts labExtras now covers mathematics (same grade
// mapping as experimental_sciences: 10 → آزمایشگاه علوم تجربی ۱, 11 → ۲).
// Bank: migration 243 inserts mathematics/final_exam rows mirroring migration
// 206 topic-for-topic (same chapters/titles/pages/positions), fresh v243 ids.
//
// Part A (no DB): the real bundled catalog code (esbuild, same pattern as the
// follow-up-1 test) proves schoolBooks('mathematics', 10/11) lists the lab
// books, the math-student final_exam path (curriculumBooks) lists them, the
// konkur track does NOT (study-catalog has no lab entry — none invented),
// and the other fields are unchanged.
// Part B (PGlite): apply 128 + 167 + 206, then 243; proves the 186 math rows
// exist and mirror 206 exactly, planner_list_topics returns them for a
// mathematics/final_exam student, a math-stream selection resolves end to
// end (catalog subject -> listed topic id -> bank row), re-run is a no-op, a
// simulated admin edit survives re-run, and a simulated admin delete is NOT
// resurrected.
//
// Run: node tests/followup-lab-math-1405.test.cjs  (from the repo root)
// Must print PASS and exit 0.
const fs = require('node:fs');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const { PGlite } = require('@electric-sql/pglite');
const { buildSync } = require('esbuild');

const LAB1 = 'آزمایشگاه علوم تجربی ۱';
const LAB2 = 'آزمایشگاه علوم تجربی ۲';
const sql = (n) => fs.readFileSync(`supabase/migrations/${n}.sql`, 'utf8');
const migration = sql('243_planner_followup_lab_math_1405');

// --- The 206 topics, parsed from the actual migration 206 file -------------
const topics206 = JSON.parse(
  sql('206_planner_labs_1405').match(/jsonb_to_recordset\(\$topics\$([\s\S]*?)\$topics\$/)[1],
);
assert.equal(topics206.length, 186, 'migration 206 should seed 186 lab rows');

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
const md5uuid = (s) => {
  const h = crypto.createHash('md5').update(s, 'utf8').digest('hex');
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-${h.slice(12, 16)}-${h.slice(16, 20)}-${h.slice(20)}`;
};

// --- Part A. Catalog -------------------------------------------------------
const school = bundle('lib/school-catalog.ts');
const curriculum = bundle('lib/planning-curriculum.ts');
const subjects = (field, grade) => school.schoolBooks(field, grade).map((b) => b.subject);

assert.ok(subjects('mathematics', 10).includes(LAB1), 'schoolBooks(mathematics,10) missing lab 1');
assert.ok(subjects('mathematics', 11).includes(LAB2), 'schoolBooks(mathematics,11) missing lab 2');
assert.ok(!subjects('mathematics', 12).some((s) => s.includes('آزمایشگاه')), 'mathematics/12 unexpectedly lists a lab');
assert.ok(!subjects('mathematics', 10).includes(LAB2), 'mathematics/10 lists the wrong lab book');
assert.ok(!subjects('mathematics', 11).includes(LAB1), 'mathematics/11 lists the wrong lab book');
// Other fields unchanged.
assert.ok(subjects('experimental_sciences', 10).includes(LAB1), 'experimental_sciences/10 lost lab 1');
assert.ok(subjects('experimental_sciences', 11).includes(LAB2), 'experimental_sciences/11 lost lab 2');
assert.ok(!subjects('humanities', 10).includes(LAB1) && !subjects('humanities', 11).includes(LAB2), 'humanities unexpectedly lists a lab');
// The math student path: final_exam curriculum lists the lab books...
for (const [grade, lab] of [[10, LAB1], [11, LAB2]]) {
  const books = curriculum.curriculumBooks('mathematics', grade, 'final_exam');
  assert.ok(books.some((b) => b.subject === lab), `curriculumBooks(mathematics,${grade},final_exam) missing ${lab}`);
  // ...while the konkur track does not: no lab offering was invented there.
  assert.ok(!curriculum.curriculumBooks('mathematics', grade, 'konkur').some((b) => b.subject === lab),
    `curriculumBooks(mathematics,${grade},konkur) unexpectedly lists ${lab}`);
}
// Routine subjects for a math student include both lab books.
const routines = curriculum.routineSubjectOptions('mathematics', 11);
assert.ok(routines.includes(LAB1) && routines.includes(LAB2), 'routineSubjectOptions(mathematics,11) missing lab books');
// Source guard: study-catalog (konkur catalog) has no lab entry at all.
assert.equal(fs.readFileSync('lib/study-catalog.ts', 'utf8').split('آزمایشگاه').length - 1, 0,
  'study-catalog.ts unexpectedly mentions آزمایشگاه');

// --- Part B. Bank (PGlite) -------------------------------------------------
const preamble = `create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`;
const deps = ['128_planner_topic_bank', '167_planner_english9_1405_pages', '206_planner_labs_1405'];
const bank = async (db) => (await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
const byId = async (db, id) => (await db.query('select edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position,revision from private.planner_topic_bank where id=$1', [id])).rows;
const listTopics = async (db, field, grade, track, subject, chapter) =>
  (await db.query('select public.planner_list_topics($1,$2,$3,$4,$5,$6) v', ['1405', field, grade, track, subject, chapter])).rows[0].v;

(async () => {
  const db = new PGlite();
  try {
    await db.exec(preamble);
    for (const n of deps) await db.exec(sql(n));
    await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");

    // Pre-state: 206 seeded 186 experimental_sciences rows, zero mathematics lab rows.
    assert.equal(Number((await db.query("select count(*) c from private.planner_topic_bank where study_field='experimental_sciences' and subject like 'آزمایشگاه%'")).rows[0].c), 186);
    assert.equal(Number((await db.query("select count(*) c from private.planner_topic_bank where study_field='mathematics' and subject like 'آزمایشگاه%'")).rows[0].c), 0);

    const before = await bank(db);
    await db.exec(migration);
    const after = await bank(db);
    assert.equal(after.length, before.length + 186, 'migration 243 should add exactly 186 rows');

    // Every 206 topic has exactly one mathematics mirror: same grade/subject/
    // chapter/title/pages/position, final_exam, revision 1, fresh v243 id.
    const mathRows = after.filter((r) => r.study_field === 'mathematics' && r.subject.startsWith('آزمایشگاه'));
    assert.equal(mathRows.length, 186);
    const perCombo = {};
    for (const t of topics206) {
      const id = md5uuid(`nova:planner:1405:v243:mathematics:${t.grade}:final_exam:${t.subject}:${t.chapter}:${t.position}`);
      const row = mathRows.find((r) => r.id === id);
      assert.ok(row, `missing v243 row for ${t.grade}/${t.subject}/${t.chapter}/pos ${t.position}`);
      assert.deepEqual(
        [row.edition, row.study_field, row.grade, row.preparation_track, row.subject, row.chapter, row.title, row.page_start, row.page_end, row.position, row.revision],
        ['1405', 'mathematics', t.grade, 'final_exam', t.subject, t.chapter, t.title, t.start, t.end, t.position, 1],
        `v243 row mismatch ${id}`,
      );
      const key = `${t.grade}|${t.chapter}`;
      perCombo[key] = (perCombo[key] || 0) + 1;
    }
    assert.deepEqual(perCombo, {
      '10|فصل ۱: کلیات': 14, '10|فصل ۲: آزمایش‌های مربی': 29,
      '10|فصل ۳: آزمایش‌های دستورالعملی': 37, '10|فصل ۴: آزمایش‌های کاوشگری': 21,
      '11|فصل ۱: کلیات': 15, '11|فصل ۲: آزمایش‌های مربی': 16,
      '11|فصل ۳: آزمایش‌های دستورالعملی': 24, '11|فصل ۴: آزمایش‌های کاوشگری': 28,
      '11|پروژه': 2,
    }, 'per-chapter counts must mirror migration 206');
    assert.equal(mathRows.filter((r) => r.grade === '10').length, 101);
    assert.equal(mathRows.filter((r) => r.grade === '11').length, 85);
    assert.ok(mathRows.every((r) => r.page_start !== null && r.page_end !== null), 'all math lab rows must have pages');
    // No id collision with the 206 rows: same topic under the other field has a different id.
    const expIds = new Set(before.filter((r) => r.subject.startsWith('آزمایشگاه')).map((r) => r.id));
    assert.ok(mathRows.every((r) => !expIds.has(r.id)), 'v243 id collides with a v206 id');
    // The 206 rows are untouched by 243.
    assert.deepEqual(after.filter((r) => r.study_field === 'experimental_sciences'),
      before.filter((r) => r.study_field === 'experimental_sciences'));

    // planner_list_topics: a mathematics/final_exam student sees the lab rows.
    const ch1 = await listTopics(db, 'mathematics', '10', 'final_exam', LAB1, 'فصل ۱: کلیات');
    assert.equal(ch1.length, 14, 'فصل ۱ lab 1 should list 14 topics for math/final_exam');
    assert.deepEqual([ch1[0].title, ch1[0].pageStart, ch1[0].pageEnd, ch1[0].order, ch1[0].revision],
      ['کل فصل', 9, 23, 1, '1']);
    const pinnedId = 'b0801f32-715b-8d3f-4d4a-c058fe27778d';
    assert.equal(ch1[0].id, pinnedId, 'v243 id for grade 10 / فصل ۱ / position 1');
    assert.equal(ch1[0].id, md5uuid('nova:planner:1405:v243:mathematics:10:final_exam:آزمایشگاه علوم تجربی ۱:فصل ۱: کلیات:1'));
    const ch3 = await listTopics(db, 'mathematics', '11', 'final_exam', LAB2, 'فصل ۳: آزمایش‌های دستورالعملی');
    assert.equal(ch3.length, 24);
    const project = await listTopics(db, 'mathematics', '11', 'final_exam', LAB2, 'پروژه');
    assert.equal(project.length, 2);
    assert.deepEqual([project[1].title, project[1].pageStart, project[1].pageEnd], ['بررسی نقش نیتروژن در سلامت و رشد گیاه', 124, 125]);
    // No konkur-track lab rows: only final_exam was seeded, mirroring 206.
    assert.deepEqual(await listTopics(db, 'mathematics', '10', 'konkur', LAB1, 'فصل ۱: کلیات'), []);
    assert.deepEqual(await listTopics(db, 'mathematics', '11', 'konkur', LAB2, 'فصل ۱: کلیات'), []);

    // End-to-end math-stream selection: the catalog subject string is the
    // bank subject; a topic picked from the listed chapter resolves to the
    // exact bank row (same id, pages, revision); the same topic under the
    // experimental_sciences field is a different row (different id).
    const catalogSubject = subjects('mathematics', 10).find((s) => s === LAB1);
    assert.equal(catalogSubject, LAB1);
    const picked = (await listTopics(db, 'mathematics', '10', 'final_exam', catalogSubject, 'فصل ۳: آزمایش‌های دستورالعملی'))
      .find((t) => t.order === 10);
    assert.deepEqual([picked.title, picked.pageStart, picked.pageEnd],
      ['تخمین مسافت و مهارت استفاده از نقشه', 56, 57]);
    assert.deepEqual(await byId(db, picked.id), [{
      edition: '1405', study_field: 'mathematics', grade: '10', preparation_track: 'final_exam',
      subject: LAB1, chapter: 'فصل ۳: آزمایش‌های دستورالعملی',
      title: 'تخمین مسافت و مهارت استفاده از نقشه', page_start: 56, page_end: 57, position: 10, revision: 1,
    }]);
    const expTwin = (await listTopics(db, 'experimental_sciences', '10', 'final_exam', LAB1, 'فصل ۳: آزمایش‌های دستورالعملی'))
      .find((t) => t.order === 10);
    assert.ok(expTwin && expTwin.id !== picked.id, 'same topic under experimental_sciences must be a different row');
    assert.equal(expTwin.title, picked.title);

    // Re-running is a no-op.
    await db.exec(migration);
    assert.deepEqual(await bank(db), after);
    // Simulated super-admin edit of a math row survives a re-run.
    const edit = (await db.query('select id,revision::text r from private.planner_topic_bank where id=$1', [picked.id])).rows[0];
    await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','10','final_exam','آزمایشگاه علوم تجربی ۱','فصل ۳: آزمایش‌های دستورالعملی','ویرایش مدیر: تخمین مسافت',56,57,10)", [edit.id, edit.r]);
    // Simulated super-admin delete of another math row is NOT resurrected by a re-run.
    const del = (await db.query('select id,revision::text r from private.planner_topic_bank where id=$1', [pinnedId])).rows[0];
    await db.query('select public.planner_delete_topic($1,$2)', [del.id, del.r]);
    const current = await bank(db);
    await db.exec(migration);
    assert.deepEqual(await bank(db), current);
    assert.deepEqual(await byId(db, picked.id), [{
      edition: '1405', study_field: 'mathematics', grade: '10', preparation_track: 'final_exam',
      subject: LAB1, chapter: 'فصل ۳: آزمایش‌های دستورالعملی',
      title: 'ویرایش مدیر: تخمین مسافت', page_start: 56, page_end: 57, position: 10, revision: 2,
    }]);
    assert.deepEqual(await byId(db, pinnedId), []);
    assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,
      { plan: 'p1', ticks: [true, false], exam: 'e1', topics: [{ title: 'old', pageStart: 12 }] });
  } finally { await db.close(); }

  console.log('PASS: Follow-up 4 — schoolBooks(mathematics,10/11) lists آزمایشگاه علوم تجربی ۱/۲ and curriculumBooks(final_exam) lists them while konkur does not; migration 243 added 186 mathematics/final_exam lab rows mirroring 206 exactly (101 grade 10, 85 grade 11); planner_list_topics returns them for a math/final_exam student and a catalog→topic→bank selection resolves end to end; re-run no-op; admin edit survives; admin delete not resurrected');
})().catch((e) => { console.error(e); process.exitCode = 1; });
