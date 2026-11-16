// Phase 3 item 2 — منابع rows are ordinary, optional bank rows.
//
// VERDICT (verified below, no migration / no code change):
// - The bank schema (migration 128) has NO required/optional flag column.
// - planner_list_topics returns منابع rows exactly like every other row.
// - Selection is a single optional pick (PlannerTopicEditor dropdown +
//   manual entry); there is no "select all", no default pick, and the
//   suggestion (lib/planner-topics.ts suggestNextTopic) is advisory only.
// - Publication validation (migration 126) never looks at the bank at all:
//   bankId is optional, topics have only a 50-item upper bound, and the
//   only "missing" check is about plan *items*, not topics.
// - So a plan / topic set with NO منابع row is valid as far as the bank
//   is concerned, and deleting a منابع row does not break selection.
//
// The test applies ONLY the already-shipped migrations that contain the
// منابع rows (233, 234, 235, 237, 239, 240) on top of 128 + 167, and
// asserts the rows exist, are selectable, are not required, and that
// re-running those migrations is a no-op that neither resurrects an
// admin-deleted منابع row nor overwrites an admin edit.
const fs = require('node:fs'), assert = require('node:assert/strict'),
  crypto = require('node:crypto'), { PGlite } = require('@electric-sql/pglite'),
  { buildSync } = require('esbuild');
const sql = n => fs.readFileSync(`supabase/migrations/${n}.sql`, 'utf8');
const MIGS = ['233_planner_audit_batch3_1405', '234_planner_audit_batch4_1405',
  '235_planner_audit_batch5_1405', '237_planner_audit_batch7_1405',
  '239_planner_followup_outside79_a_1405', '240_planner_followup_outside79_b_1405'];
// Back-matter bibliography rows (the "منابع rows"). Lesson-content titles
// that merely contain the word منابع (e.g. «منابع آب», «منابع معدنی») are
// NOT in this set: they are ordinary lesson content, not back matter.
const isManabe = t => ['منابع', 'فهرست منابع', 'منابع و مآخذ', 'منابع برای مطالعه بیشتر'].includes(t)
  || t.startsWith('مطالعه بیشتر: منابع') || t.includes('منابع پیشنهادی');
const MANABE_SQL = `(title in ('منابع','فهرست منابع','منابع و مآخذ','منابع برای مطالعه بیشتر')`
  + ` or title like 'مطالعه بیشتر: منابع%' or title like '%منابع پیشنهادی%')`;
const md5uuid = s => { const h = crypto.createHash('md5').update(s, 'utf8').digest('hex');
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-${h.slice(12, 16)}-${h.slice(16, 20)}-${h.slice(20)}`; };
// Parse the $topics$ JSON of each migration, as the batch tests do.
const topicsOf = n => JSON.parse(sql(n).split('$topics$')[1]);
const manabeTopics = MIGS.flatMap(n => topicsOf(n).filter(t => isManabe(t.title)).map(t => ({ mig: n.slice(0, 3), ...t })));
const expectedPerMig = { 233: 6, 234: 9, 235: 6, 237: 12, 239: 11, 240: 1 };
// Bundle the real selection logic (same approach as tests/planner-topics.test.cjs).
const code = buildSync({ entryPoints: ['lib/planner-topics.ts'], bundle: true, platform: 'node', format: 'cjs', write: false }).outputFiles[0].text,
  mod = { exports: {} }; new Function('module', 'exports', code)(mod, mod.exports);
const { suggestNextTopic, selectBankTopic } = mod.exports;
const count = async (db, where, params = []) => Number((await db.query(`select count(*) n from private.planner_topic_bank where ${where}`, params)).rows[0].n);
(async () => { const db = new PGlite(); try {
  await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
   create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
   create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
   create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
   create table private.planner_seed_installations(seed_key text primary key);`);
  await db.exec(sql('128_planner_topic_bank'));
  await db.exec(sql('167_planner_english9_1405_pages'));
  for (const n of MIGS) await db.exec(sql(n));

  // 1. The منابع rows exist, exactly where the migrations say, with pages.
  assert.equal(manabeTopics.length, 45, `back-matter topics in files: ${manabeTopics.length}`);
  for (const [mig, n] of Object.entries(expectedPerMig))
    assert.equal(manabeTopics.filter(t => t.mig === mig).length, n, `migration ${mig} back-matter topics`);
  assert.equal(await count(db, MANABE_SQL), 74, 'منابع DB rows total');
  assert.equal(await count(db, `${MANABE_SQL} and page_start is null`), 0, 'every منابع row has pages');
  assert.equal(await count(db, `${MANABE_SQL} and position < 3000`), 0, 'every منابع row is at position >= 3000');
  assert.equal(await count(db, `${MANABE_SQL} and revision <> 1`), 0, 'every منابع row is revision 1');
  for (const t of manabeTopics) {
    const tracks = t.konkur ? ['konkur', 'final_exam'] : ['final_exam'];
    for (const track of tracks) {
      const r = (await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',
        ['1405', t.field, t.grade, track, t.subject, t.chapter, t.position])).rows;
      assert.deepEqual(r, [{ title: t.title, page_start: t.start, page_end: t.end, revision: 1 }], `${t.mig} ${t.subject} ${t.chapter} pos ${t.position} ${track}`);
    }
  }
  // Spot-check the id formula: md5('nova:planner:1405:v<MIG>:<field>:<grade>:<track>:<subject>:<chapter>:<position>').
  const idOf = async (mig, field, grade, track, subject, chapter, pos) =>
    (await db.query('select id from private.planner_topic_bank where subject=$1 and chapter=$2 and position=$3 and study_field=$4 and grade=$5 and preparation_track=$6',
      [subject, chapter, pos, field, grade, track])).rows[0].id;
  assert.equal(await idOf('234', 'mathematics', '12', 'konkur', 'حسابان ۲', 'فصل ۵: کاربردهای مشتق', 3003),
    md5uuid('nova:planner:1405:v234:mathematics:12:konkur:حسابان ۲:فصل ۵: کاربردهای مشتق:3003'));
  assert.equal(await idOf('240', 'humanities', '11', 'final_exam', 'تاریخ ۲', 'درس ۱۶', 3000),
    md5uuid('nova:planner:1405:v240:humanities:11:final_exam:تاریخ ۲:درس ۱۶:3000'));
  // Batches 1/2/6/8 added no back-matter منابع rows: the 74 rows come only from 233/234/235/237/239/240.
  assert.equal(await count(db, MANABE_SQL), 74);

  // 2. No optionality/required mechanism exists in the bank schema.
  const cols = (await db.query(`select column_name from information_schema.columns where table_schema='private' and table_name='planner_topic_bank' order by ordinal_position`)).rows.map(r => r.column_name);
  assert.deepEqual(cols, ['id', 'edition', 'study_field', 'grade', 'preparation_track', 'subject', 'chapter', 'title', 'page_start', 'page_end', 'position', 'revision', 'updated_at']);
  assert.ok(!cols.some(c => /required|optional/.test(c)), 'no required/optional column');
  assert.ok(!/required/i.test(sql('128_planner_topic_bank').replace(/Counselor or administrator required|Administrator required/g, '')), 'migration 128 has no required-flag logic');

  // 3. planner_list_topics returns منابع rows as ordinary rows (no required key).
  await db.query("select set_config('test.role','counselor',false),set_config('test.approved','true',false)");
  const list = async (field, grade, track, subject, chapter) =>
    (await db.query('select public.planner_list_topics($1,$2,$3,$4,$5,$6) x', ['1405', field, grade, track, subject, chapter])).rows[0].x;
  const calc2 = await list('mathematics', '12', 'konkur', 'حسابان ۲', 'فصل ۵: کاربردهای مشتق');
  assert.equal(calc2.length, 4, 'حسابان ۲ فصل ۵ konkur rows');
  assert.deepEqual(calc2.map(t => t.title), ['تمرین اکسترمم‌های یک تابع و توابع صعودی و نزولی', 'تمرین جهت تقعر نمودار یک تابع و نقطه عطف آن', 'تمرین رسم نمودار تابع', 'منابع']);
  assert.deepEqual(Object.keys(calc2[3]).sort(), ['chapter', 'edition', 'grade', 'id', 'order', 'pageEnd', 'pageStart', 'revision', 'studyField', 'subject', 'title', 'track']);
  assert.equal(calc2[3].pageStart, 145); assert.equal(calc2[3].pageEnd, 145);

  // 4. Selection/completion: nothing requires the منابع row.
  const toBank = rows => rows.map(r => ({ id: r.id, subject: r.subject, grade: Number(r.grade), chapter: r.chapter, title: r.title, pageStart: r.page_start, pageEnd: r.page_end, order: r.position }));
  const bankRows = (await db.query(`select id,subject,grade,chapter,title,page_start,page_end,position from private.planner_topic_bank where subject='حسابان ۲' and chapter='فصل ۵: کاربردهای مشتق' and study_field='mathematics' and grade='12' and preparation_track='konkur' order by position`)).rows;
  const bank = toBank(bankRows), manabe = bank.find(t => t.title === 'منابع'), rest = bank.filter(t => t.title !== 'منابع');
  const dest = { studentId: 'S1', subject: 'حسابان ۲', grade: 12, chapter: 'فصل ۵: کاربردهای مشتق', date: '2026-11-10', order: 1 };
  const use = ids => ({ studentId: 'S1', subject: 'حسابان ۲', grade: 12, chapter: 'فصل ۵: کاربردهای مشتق', date: '2026-11-03', order: 0, topicIds: ids });
  // A منابع row IS selectable (it is an ordinary option, not hidden).
  assert.deepEqual(selectBankTopic(manabe), { bankId: manabe.id, title: 'منابع', pageStart: 145, pageEnd: 145 });
  // With no history the suggestion is the FIRST topic, not منابع.
  assert.equal(suggestNextTopic(bank, [], dest).title, 'تمرین اکسترمم‌های یک تابع و توابع صعودی و نزولی');
  // After the three تمرین rows are used, the suggestion is منابع — advisory only: the caller must still choose it.
  assert.equal(suggestNextTopic(bank, [use(rest.map(t => t.id))], dest).title, 'منابع');
  // After منابع itself is used, the chapter is done: null, no error, nothing outstanding.
  assert.equal(suggestNextTopic(bank, [use(bank.map(t => t.id))], dest), null);
  // A plan/topic set with NO منابع row at all is valid as far as the bank is concerned:
  // every non-منابع row selects cleanly, and the suggestion path works on the reduced bank.
  const planTopics = rest.map(t => selectBankTopic(t));
  assert.equal(planTopics.length, 3);
  assert.ok(planTopics.every(t => t.bankId && t.title !== 'منابع'));
  assert.equal(suggestNextTopic(rest, [], dest).id, rest[0].id);
  assert.equal(suggestNextTopic(rest, [use(rest.map(t => t.id))], dest), null, 'reduced bank ends cleanly without منابع');

  // 5. The planner source has no forcing mechanism (static checks, grounded in the files).
  const topicsSrc = fs.readFileSync('lib/planner-topics.ts', 'utf8');
  assert.ok(!/required/i.test(topicsSrc), 'lib/planner-topics.ts mentions no required flag');
  assert.ok(!/selectAll/i.test(topicsSrc), 'no select-all in lib/planner-topics.ts');
  const editorSrc = fs.readFileSync('components/dashboard/planner-topic-editor.tsx', 'utf8');
  assert.ok(editorSrc.includes('انتخاب مبحث'), 'editor is a single optional dropdown (placeholder انتخاب مبحث)');
  assert.ok(!/selectAll/i.test(editorSrc), 'no select-all in the topic editor');
  assert.ok(editorSrc.includes('می‌توانی مبحث را دستی وارد کنی'), 'manual free-text entry is allowed when the bank is unavailable');
  const validationSrc = fs.readFileSync('supabase/migrations/126_planner_publish_validation.sql', 'utf8');
  assert.ok(!validationSrc.includes('planner_topic_bank'), 'publication validation never reads the bank');
  assert.ok(validationSrc.includes(`topic ? 'bankId' and jsonb_typeof(topic->'bankId') not in ('string','null')`), 'bankId is optional in publication validation');
  assert.ok(validationSrc.includes(`jsonb_array_length(extra->'topics')>50`), 'topics have only an upper bound (50), no minimum');
  assert.ok(validationSrc.includes(`raise exception 'Missing plan activities'`), 'the only missing-check is about plan items, not topics');

  // 6. Admin delete of a منابع row does not break selection; re-running the
  // shipped migrations is a no-op that neither resurrects it nor overwrites an admin edit.
  await db.query("select set_config('test.role','admin',false)");
  const del = (await db.query(`select id,revision::text r from private.planner_topic_bank where ${MANABE_SQL} and subject='حسابان ۲' and chapter='فصل ۵: کاربردهای مشتق' and preparation_track='konkur'`)).rows[0];
  await db.query('select public.planner_delete_topic($1,$2)', [del.id, del.r]);
  const del2 = (await db.query(`select id,revision::text r from private.planner_topic_bank where ${MANABE_SQL} and subject='ریاضیات گسسته' and chapter='فصل ۳: ترکیبیات' and preparation_track='final_exam'`)).rows[0];
  await db.query('select public.planner_delete_topic($1,$2)', [del2.id, del2.r]);
  const edit = (await db.query(`select id,revision::text r from private.planner_topic_bank where ${MANABE_SQL} and subject='هندسه ۳' and chapter='فصل ۳: بردارها' and preparation_track='final_exam'`)).rows[0];
  await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','12','final_exam','هندسه ۳','فصل ۳: بردارها','منابع (ویرایش مدیر)',87,87,3000)", [edit.id, edit.r]);
  await db.query("select set_config('test.role','counselor',false)");
  const afterDelete = await list('mathematics', '12', 'konkur', 'حسابان ۲', 'فصل ۵: کاربردهای مشتق');
  assert.equal(afterDelete.length, 3, 'chapter lists fine without its منابع row');
  assert.ok(afterDelete.every(t => t.title !== 'منابع'));
  assert.equal(suggestNextTopic(toBank((await db.query(`select id,subject,grade,chapter,title,page_start,page_end,position from private.planner_topic_bank where subject='حسابان ۲' and chapter='فصل ۵: کاربردهای مشتق' and study_field='mathematics' and grade='12' and preparation_track='konkur' order by position`)).rows), [], dest).title, 'تمرین اکسترمم‌های یک تابع و توابع صعودی و نزولی');
  const snapshot = (await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
  for (const n of MIGS) await db.exec(sql(n));
  assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v, snapshot, 're-run is a no-op');
  assert.equal(await count(db, `${MANABE_SQL} and subject='حسابان ۲'`), 1, 'deleted حسابان ۲ konkur منابع row NOT resurrected (final_exam twin remains)');
  assert.equal(await count(db, `${MANABE_SQL} and subject='ریاضیات گسسته'`), 1, 'deleted ریاضیات گسسته final_exam منابع row NOT resurrected (konkur twin remains)');
  const edited = (await db.query(`select title,revision from private.planner_topic_bank where subject='هندسه ۳' and chapter='فصل ۳: بردارها' and preparation_track='final_exam'`)).rows[0];
  assert.deepEqual(edited, { title: 'منابع (ویرایش مدیر)', revision: 2 }, 'admin edit survives re-run');
  console.log('PASS: Phase 3 item 2 — 45 منابع topics / 74 rows exist as ordinary selectable rows (migrations 233/234/235/237/239/240); no required/optional mechanism in schema, list, selection, suggestion or publication validation; a plan without any منابع row is valid; admin delete/edit protection holds');
} finally { await db.close() } })().catch(e => { console.error(e); process.exitCode = 1; });
