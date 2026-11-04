const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const esbuild = require('esbuild');

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'nova-grade-nine-'));
try {
  const compile = (name) => {
    const output = path.join(dir, `${name}.cjs`);
    esbuild.buildSync({entryPoints: [`lib/${name}.ts`], outfile: output, bundle: true,
      platform: 'node', format: 'cjs', alias: {'@': process.cwd()}});
    return require(output);
  };
  const {curriculumBooks, routineSubjectOptions, availableGrades, journeyGroups} = compile('planning-curriculum');
  const {validateRegistration} = compile('registration');
  const {activityTypes} = compile('study-catalog');
  const school = curriculumBooks(null,9,'final_exam');
  assert.ok(school.length >= 12);
  assert.deepEqual(school, curriculumBooks('humanities',9,'final_exam'));
  for (const name of ['ریاضی','فارسی','مطالعات اجتماعی','علوم تجربی','عربی','نگارش'])
    assert.ok(school.some(b=>b.subject===name));
  assert.ok(!school.some(b=>b.subject.includes('هوش')));
  assert.deepEqual(curriculumBooks(null,9,'konkur').map(b=>b.subject),['هوش و استعداد تحلیلی']);
  assert.deepEqual(availableGrades(9),[9]);
  assert.deepEqual(availableGrades(11),[10,11]);
  assert.ok(routineSubjectOptions(null,9).includes('هوش و استعداد تحلیلی'));
  assert.ok(journeyGroups([],null,9).some(g=>g.subject==='ریاضی'&&g.grade===9));
  const valid = {full_name:'سارا احمدی',grade:9,study_field:null,province:'تهران',city:'تهران'};
  assert.equal(validateRegistration(valid,true),null);
  assert.equal(validateRegistration(valid,false),null); // same paid plans as grades 10/11
  assert.notEqual(validateRegistration({...valid,study_field:'humanities'},true),null);
  assert.notEqual(validateRegistration({...valid,grade:10},true),null);
  assert.equal(activityTypes.find(a=>a.value==='exam_troubleshooting')?.label,'رفع اشکال آزمون');
  assert.notEqual(activityTypes.find(a=>a.value==='exam_analysis')?.value,'exam_troubleshooting');
  const migration = fs.readFileSync('supabase/migrations/100_grade_nine_planning_and_exam_troubleshooting.sql','utf8');
  for (const {subject} of school) assert.ok(migration.includes(`('${subject}')`),`SQL missing ${subject}`);
  assert.match(migration,/official\.grade=g and official\.subject=btrim/);
  assert.match(migration,/g=9 and \(btrim\(item->>'subject'\)<>'هوش و استعداد تحلیلی'/);
  assert.match(migration,/target_grade=9 and target_study_field is not null/);
  assert.match(migration,/school_metadata_check/);
  assert.match(migration,/add value if not exists 'exam_troubleshooting'/);
  const planner=fs.readFileSync('components/dashboard/weekly-plan-builder.tsx','utf8');
  assert.match(planner,/itemGrade\(item\)===9\?"هوش و استعداد تحلیلی":"کنکور"/);
  assert.match(planner,/newStudentItem\(dayIndex, undefined, student\?\.grade\)/);
  assert.match(planner,/activityTypes\.map\(\(activity\)/);
  console.log('PASS: grade-nine field-free school, aptitude, reports, activities and migration wiring');
} finally {
  fs.rmSync(dir,{recursive:true,force:true});
}
