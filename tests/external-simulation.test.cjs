const { PGlite } = require('@electric-sql/pglite');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const ts = require('typescript');
const vm = require('node:vm');

const source = fs.readFileSync('lib/external-simulation.ts', 'utf8');
const mod = { exports: {} };
vm.runInNewContext(ts.transpileModule(source, { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 } }).outputText,
  { module: mod, exports: mod.exports });
const { externalSimulationActivity, externalSimulationTitle, simulationSubject, simulationProvider, simulationProviderDraft, simulationProviders } = mod.exports;
assert.equal(simulationSubject('ماز'), `${externalSimulationTitle} · ماز`);
assert.equal(simulationProvider(simulationSubject('قلم‌چی (کانون)')), 'قلم‌چی (کانون)');
assert.equal(simulationProvider(simulationSubject('سایر')), 'سایر');
assert.equal(simulationProvider(simulationSubject('')), null, 'provider is required');
assert.equal(simulationProviderDraft(`${externalSimulationTitle} · م`), 'م', 'a custom name stays editable until valid');
assert.equal(simulationProvider(`${externalSimulationTitle} · ${'ب'.repeat(61)}`), null);
assert.equal(simulationProvider(`${externalSimulationTitle} · ماز\n`), null);
assert.ok(simulationProviders.includes('گزینه دو') && simulationProviders.includes('خیلی سبز'));

const builder = fs.readFileSync('components/dashboard/weekly-plan-builder.tsx','utf8');
const actions = fs.readFileSync('app/dashboard/actions.ts','utf8');
const catalog = fs.readFileSync('lib/study-catalog.ts','utf8');
const student = fs.readFileSync('components/dashboard/student-planning-panel.tsx','utf8');
const print = fs.readFileSync('components/dashboard/print-weekly-plan.tsx','utf8');
const designer = fs.readFileSync('lib/student-plan-exams.ts','utf8');
assert.match(catalog, /value: "simulation_exam"/, 'original activity option stays available');
assert.match(builder, /<option value="__external_simulation__">\{externalSimulationTitle\}<\/option>/, 'new entry belongs inside subject select');
assert.match(builder, /item\.activityType === externalSimulationActivity \? <>\s*<label className="plan-simulation-subject">درس/, 'the subject selector remains visible in the provider exam');
assert.match(builder, /value="__external_simulation__"\s*onChange=\{event=>leaveExternalSimulation\(item\.key,event\.target\.value\)\}/, 'changing the subject exits the exam without an extra button');
assert.doesNotMatch(builder, /بازگشت به انتخاب درس|<strong>\{externalSimulationTitle\}<\/strong>/, 'no orphaned heading or return button');
assert.match(builder, /simulationProviderDraft\(item\.subject\)/);
const css = fs.readFileSync('app/globals.css', 'utf8');
assert.match(css, /\.plan-item-fields\.plan-item-fields--external\s*\{\s*grid-template-columns:/);
assert.match(css, /\.plan-item-fields--external \.plan-details\s*\{\s*grid-column: 1 \/ -1;/, 'exam notes span the card width');
assert.match(actions, /allowedActivityTypes\.add\(externalSimulationActivity\)/);
assert.match(actions, /!simulationProvider\(item\.subject\)/);
assert.match(actions, /save_weekly_plan_v9/);
assert.match(student, /برگزارکننده: \$\{simulationProvider\(item\.subject\)/);
assert.match(print, /برگزارکننده: \$\{simulationProvider\(item\.subject\)/);
assert.match(designer, /activity_type === "exam"|activity_type!==['"]exam['"]/, 'only Nova exam boxes link to designer');

(async () => {
  const db = new PGlite();
  await db.exec(`
    create role authenticated; create role anon;
    create type public.content_status as enum ('draft','published');
    create type public.study_activity_type as enum ('lesson','simulation_exam','exam');
    create table public.weekly_plan_items (
      id uuid default gen_random_uuid(), subject text not null, chapter text,
      activity_type public.study_activity_type not null, target_test_count smallint,
      source_grade smallint, preparation_track text not null default 'konkur',
      exam_year smallint, recommended_publisher text
    );
    create function public.save_weekly_plan_v8(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb)
    returns uuid language plpgsql as $$
    declare it jsonb;
    begin
      for it in select value from jsonb_array_elements($7) loop
        insert into public.weekly_plan_items(subject,chapter,activity_type,target_test_count,source_grade,preparation_track,exam_year,recommended_publisher)
        values(it->>'subject',nullif(it->>'chapter',''),(it->>'activityType')::public.study_activity_type,
          nullif(it->>'targetTestCount','')::smallint,nullif(it->>'sourceGrade','')::smallint,
          it->>'preparationTrack',nullif(it->>'examYear','')::smallint,it->>'recommendedPublisher');
      end loop;
      return 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'::uuid;
    end $$;
  `);
  await db.exec(fs.readFileSync('supabase/migrations/103_external_simulation_provider_plan_boxes.sql','utf8'));
  const row = (subject, extra = {}) => ({ subject, chapter: '', activityType: externalSimulationActivity,
    targetTestCount: null, sourceGrade: null, preparationTrack: 'konkur', examYear: null, recommendedPublisher: null, ...extra });
  const save = items => db.query(`select public.save_weekly_plan_v9(null,null,current_date,'هفته',null,'draft',$1::jsonb,'[]'::jsonb)`, [JSON.stringify(items)]);
  await save([row(simulationSubject('ماز'))]);
  await save([row(simulationSubject('آزمون اختصاصی مدرسه'))]);
  await save([row('ریاضی', { activityType: 'simulation_exam', chapter: 'فصل ۱' })]);
  assert.deepEqual((await db.query('select subject from public.weekly_plan_items order by subject')).rows.map(r => r.subject).sort(),
    [simulationSubject('ماز'), simulationSubject('آزمون اختصاصی مدرسه'), 'ریاضی'].sort());
  const before = (await db.query('select count(*)::int as n from public.weekly_plan_items')).rows[0].n;
  for (const invalid of [
    row(externalSimulationTitle), row(simulationSubject('م')), row(`${externalSimulationTitle} · ماز `),
    row(simulationSubject('ماز'), { chapter: 'فصل ۱' }),
    row(simulationSubject('ماز'), { sourceGrade: 9 }),
    row(simulationSubject('ماز'), { preparationTrack: 'final_exam' }),
    row(simulationSubject('ماز'), { recommendedPublisher: 'گاج' }),
    row(simulationSubject('ماز'), { targetTestCount: 1 }),
    row(simulationSubject('ماز'), { examYear: 1406 }),
  ]) {
    await assert.rejects(save([row(simulationSubject('سنجش')), invalid]), /Invalid external simulation/);
    assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_items')).rows[0].n, before, 'rejected saves are atomic');
  }
  await assert.rejects(db.query(`insert into public.weekly_plan_items(subject,activity_type) values($1,'external_simulation_exam')`, [externalSimulationTitle]), /external_simulation_provider_check/);
  assert.equal((await db.query(`select count(*)::int as n from pg_enum where enumlabel in ('simulation_exam','external_simulation_exam')`)).rows[0].n,2);
  console.log('External exam provider selection, persistence, legacy activity and SQL validation passed.');
})().catch(error => { console.error(error); process.exitCode = 1; });
