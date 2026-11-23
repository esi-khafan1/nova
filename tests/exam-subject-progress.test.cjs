const assert = require('node:assert/strict');
const fs = require('node:fs');
const { PGlite } = require('@electric-sql/pglite');
const ts = require('typescript');
const Module = require('node:module');
const React = require('react');
const { renderToStaticMarkup } = require('react-dom/server');
const { JSDOM } = require('jsdom');

const originalResolve = Module._resolveFilename;
Module._resolveFilename = function(request, ...args) {
  return originalResolve.call(this, request.startsWith('@/') ? `${process.cwd()}/${request.slice(2)}` : request, ...args);
};
for (const ext of ['.ts', '.tsx']) require.extensions[ext] = (module, filename) => {
  const source = fs.readFileSync(filename, 'utf8');
  module._compile(ts.transpileModule(source, { compilerOptions: { module: ts.ModuleKind.CommonJS, jsx: ts.JsxEmit.ReactJSX, target: ts.ScriptTarget.ES2022 } }).outputText, filename);
};
const { ExamSubjectProgress } = require('../components/dashboard/exam-subject-progress.tsx');
const row = (subject_title, exam_id, starts_at, percentage) => ({ subject_title, exam_id, starts_at, percentage, exam_title: 'آزمون' });
const markup = renderToStaticMarkup(React.createElement(ExamSubjectProgress, { rows: [
  row('ریاضی','2','2026-02-01T00:00:00Z',45), row('فیزیک','3','2026-01-01T00:00:00Z',35),
  row('ریاضی','1','2026-01-01T00:00:00Z',25), row('شیمی','4','2026-01-01T00:00:00Z',65),
], unavailable: false }));
const doc = new JSDOM(markup).window.document;
assert.equal(doc.querySelectorAll('.exam-subject-chart').length, 3);
const math = [...doc.querySelectorAll('.exam-subject-chart')].find(el => el.textContent.includes('ریاضی'));
assert.equal(math.querySelectorAll('circle').length, 2);
assert.equal(math.querySelectorAll('polyline').length, 1);
assert.ok(math.textContent.indexOf('۲۵٪') < math.textContent.lastIndexOf('۴۵٪'));
assert.equal([...doc.querySelectorAll('.exam-subject-chart')].find(el => el.textContent.includes('فیزیک')).querySelectorAll('polyline').length, 0);
assert.match(renderToStaticMarkup(React.createElement(ExamSubjectProgress, { rows: [], unavailable: true })), /دریافت روند پیشرفت انجام نشد/);
assert.match(renderToStaticMarkup(React.createElement(ExamSubjectProgress, { rows: [], unavailable: false })), /هنوز نتیجهٔ درسی قابل نمایش وجود ندارد/);

async function testSql() {
  const db = new PGlite();
  await db.exec(`
    create role anon; create role authenticated;
    create schema private; create schema auth;
    create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('test.uid', true), '')::uuid $$;
    create function private.current_user_role() returns text language sql stable as $$ select current_setting('test.role', true) $$;
    create function private.student_report_available(uuid,uuid) returns boolean language sql stable as $$ select true $$;
    create table public.exams (id uuid primary key, title text, starts_at timestamptz, status text);
    create table public.exam_attempts (exam_id uuid, student_id uuid, submitted_at timestamptz, answers jsonb);
    create table public.exam_booklets (exam_id uuid, title text, subject_ranges jsonb, start_question_number integer, end_question_number integer, key_answers jsonb);
    create table public.counselor_students (student_id uuid, counselor_id uuid);
  `);
  await db.exec(fs.readFileSync('supabase/migrations/253_exam_subject_progress.sql', 'utf8'));
  const student = '00000000-0000-0000-0000-000000000100';
  const counselor = '00000000-0000-0000-0000-000000000200';
  const other = '00000000-0000-0000-0000-000000000300';
  const id = n => `00000000-0000-0000-0001-${String(n).padStart(12, '0')}`;
  for (let i = 1; i <= 9; i++) {
    await db.query('insert into public.exams values ($1,$2,$3,$4)', [id(i), `exam ${i}`, `2026-01-${String(i).padStart(2,'0')}T00:00:00Z`, 'published']);
    await db.query('insert into public.exam_attempts values ($1,$2,$3,$4)', [id(i), student, `2026-01-${String(i).padStart(2,'0')}T01:00:00Z`, JSON.stringify({'1':1,'2':2})]);
    const ranges = i <= 2 ? [{title:'ریاضی',start:1,end:1},{title:'فیزیک',start:2,end:2}] : i < 9 ? [{title:'ریاضی',start:1,end:1}] : [];
    await db.query('insert into public.exam_booklets values ($1,$2,$3,$4,$5,$6)', [id(i), i === 9 ? 'دفترچه ۱' : 'دفترچه', JSON.stringify(ranges), 1, ranges.length === 2 ? 2 : 1, JSON.stringify({'1':1,'2':1})]);
  }
  await db.query('insert into public.counselor_students values ($1,$2)', [student,counselor]);
  await db.query("select set_config('test.uid',$1,false),set_config('test.role','student',false)",[student]);
  const run = async (who, cutoff, limit=6) => (await db.query('select * from public.student_exam_subject_progress($1,$2,$3)',[who,cutoff,limit])).rows;
  let got = await run(student,id(9));
  assert.equal(got.filter(r => r.subject_title==='ریاضی').length, 6, 'last six per subject, not six exams overall');
  assert.equal(got.filter(r => r.subject_title==='فیزیک').length, 2, 'older physics remains available');
  assert.equal(got.find(r => r.subject_title==='فیزیک').percentage, '-33.33');
  assert.ok(got.filter(r => r.subject_title==='ریاضی').every(r => Number(r.percentage)===100));
  assert.ok(!got.some(r => r.subject_title.includes('دفترچه')), 'generic booklet not misrepresented as subject');
  got = await run(student,id(2));
  assert.equal(got.length, 4, 'historical report excludes later exams');
  got = await run(student,id(9),1);
  assert.equal(got.length, 2, 'limit applies separately to each subject');
  assert.equal((await run(other,id(9))).length, 0, 'student cannot see another student');
  await db.query("select set_config('test.uid',$1,false),set_config('test.role','counselor',false)",[counselor]);
  assert.equal((await run(student,id(9))).length, 8, 'assigned counselor can view history');
  await db.query("select set_config('test.uid',$1,false)",[other]);
  assert.equal((await run(student,id(9))).length, 0, 'unassigned counselor denied');
  const permissions = await db.query("select has_function_privilege('anon','public.student_exam_subject_progress(uuid,uuid,integer)','execute') as anon, has_function_privilege('authenticated','public.student_exam_subject_progress(uuid,uuid,integer)','execute') as authenticated");
  assert.equal(permissions.rows[0].anon,false);
  assert.equal(permissions.rows[0].authenticated,true);
  await db.close();
}
testSql().then(() => console.log('PASS: independent subject histories, as-of cutoff, scoring, permissions and chart rendering')).catch(error => { console.error(error); process.exitCode = 1; });
