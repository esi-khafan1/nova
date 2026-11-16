const fs = require('node:fs');
const assert = require('node:assert/strict');
const { PGlite } = require('@electric-sql/pglite');
const { buildSync } = require('esbuild');
const read = n => fs.readFileSync(`supabase/migrations/${n}.sql`, 'utf8');
const migrations = ['204_planner_sociology_1405', '205_planner_history12_1405'];
const data = migrations.map(name => {
 const sql = read(name);
 return { sql, topics: JSON.parse(sql.split('$topics$')[1]), fixes: JSON.parse(sql.split('$fixes$')[1]) };
});
const code = buildSync({ entryPoints: ['lib/planning-curriculum.ts'], bundle: true, platform: 'node', format: 'cjs', write: false, alias: { '@': process.cwd() } }).outputFiles[0].text;
const mod = { exports: {} }; new Function('module', 'exports', 'require', code)(mod, mod.exports, require);
(async () => {
 const db = new PGlite();
 try {
  await db.exec(`create role anon; create role authenticated; create schema private;
   create table private.planner_topic_bank(id uuid primary key, edition text not null, study_field text not null, grade text not null, preparation_track text not null, subject text not null, chapter text not null, title text not null, page_start integer, page_end integer, position integer not null, revision bigint not null default 1, updated_at timestamptz not null default now(), check ((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));
   create table published_snapshot(content jsonb); insert into published_snapshot values ('{"plan":"p1","exam":"e1","ticks":[true,false],"page":55}');`);
  for (const n of ['141_planner_humanities_topics', '143_planner_sociology12_topics', '144_planner_sociology11_topics', '150_planner_history12_topics', '167_planner_english9_1405_pages']) await db.exec(read(n));
  const old = (await db.query("select * from private.planner_topic_bank where subject in ('جامعه‌شناسی ۲','جامعه‌شناسی ۳','تاریخ ۳') order by id")).rows;
  assert.equal(old.length, 260);
  const protectedRows = [];
  for (const subject of ['جامعه‌شناسی ۲', 'جامعه‌شناسی ۳', 'تاریخ ۳']) {
   const [edited, deleted] = old.filter(row => row.subject === subject && row.chapter === 'درس ۱');
   await db.query("update private.planner_topic_bank set title='ویرایش مدیر',chapter='فصل مدیر',revision=2 where id=$1", [edited.id]);
   await db.query('delete from private.planner_topic_bank where id=$1', [deleted.id]);
   protectedRows.push([edited.id, deleted.id, (await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1', [edited.id])).rows[0].v]);
  }
  for (const {sql} of data) await db.exec(sql);
  for (const [id, deleted, state] of protectedRows) {
   assert.deepEqual((await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1', [id])).rows[0].v, state);
   assert.equal((await db.query('select id from private.planner_topic_bank where id=$1', [deleted])).rows.length, 0);
  }
  const contexts = [['جامعه‌شناسی ۲','11',0], ['جامعه‌شناسی ۳','12',0], ['تاریخ ۳','12',1]];
  for (const [subject,grade,i] of contexts) {
   const {topics, fixes} = data[i];
   for (const track of ['konkur','final_exam']) {
    const book = mod.exports.curriculumBooks('humanities', Number(grade), 'konkur').find(b => b.subject === subject);
    assert.ok(book);
    assert.ok(mod.exports.curriculumBooks('humanities', Number(grade), track).some(b => b.subject === subject));
    for (const chapter of book.chapters) {
     const matching = topics.filter(p => (p.subject ?? subject) === subject && (p.grade ?? grade) === grade && p.chapter === chapter);
     assert.ok(matching.some(p => p.title === 'کل درس'), `${subject} ${chapter}`);
     assert.ok(matching.length >= 3, `${subject} ${chapter}`);
     for (const p of matching) {
      assert.ok(p.start > 0 && p.end >= p.start, JSON.stringify(p));
      const rows = (await db.query('select title,page_start,page_end from private.planner_topic_bank where study_field=$1 and grade=$2 and preparation_track=$3 and subject=$4 and chapter=$5 and position=$6', ['humanities',grade,track,subject,chapter,p.position])).rows;
      assert.deepEqual(rows,[{title:p.title,page_start:p.start,page_end:p.end}]);
     }
    }
    for (const p of fixes.filter(p => (p.subject ?? subject) === subject && (p.grade ?? grade) === grade)) {
     const row = old.find(r => r.grade === grade && r.preparation_track === track && r.subject === subject && r.chapter === p.chapter && r.position === p.position);
     assert.ok(row, JSON.stringify(p));
     if (protectedRows.some(([id, deleted]) => row.id === id || row.id === deleted)) continue;
     const actual = (await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where id=$1',[row.id])).rows[0];
     assert.deepEqual([actual.title,actual.page_start,actual.page_end,Number(actual.revision)],[p.title,p.start,p.end,2]);
    }
   }
  }
  const suspect = (await db.query("select page_start from private.planner_topic_bank where subject='جامعه‌شناسی ۲' and chapter='درس ۱۵' and position=1")).rows;
  assert.equal(suspect.length,2); assert.ok(suspect.every(r => r.page_start === null));
  const selected = (await db.query("select id from private.planner_topic_bank where position>=400 and subject='تاریخ ۳' order by id limit 2")).rows;
  await db.query('delete from private.planner_topic_bank where id=$1',[selected[0].id]);
  await db.query("update private.planner_topic_bank set title='ویرایش',revision=2 where id=$1",[selected[1].id]);
  const state = (await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
  for (const {sql} of data) await db.exec(sql);
  assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,state);
  assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',exam:'e1',ticks:[true,false],page:55});
  console.log('PASS: 6 contexts, full lesson coverage, guarded edits/deletions, idempotence and simulated snapshot');
 } finally { await db.close(); }
})().catch(e => {console.error(e); process.exitCode=1;});
