const assert = require('node:assert/strict');
const esbuild = require('esbuild');
const Module = require('node:module');
const path = require('node:path');
const React = require('react');
const {renderToStaticMarkup} = require('react-dom/server');

(async()=>{
  const built = await esbuild.build({
    entryPoints:['components/dashboard/weekly-plan-builder.tsx'],
    bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,
    external:['react','react/jsx-runtime'],
    plugins:[{name:'mock-only-form-dependencies',setup(build){
      build.onResolve({filter:/^@\/(app\/dashboard\/actions|components\/dashboard\/(persian-date-picker|counselor-student-study-editor))$/},args=>({path:args.path,namespace:'mock'}));
      build.onLoad({filter:/.*/,namespace:'mock'},args=>({contents:args.path.includes('actions')
        ? 'export const saveWeeklyPlan="/save";'
        : args.path.includes('persian-date-picker')
          ? 'export const PersianDatePicker=()=>null;'
          : 'export const CounselorStudentStudyEditor=()=>null;',loader:'js'}));
    }}],
  });
  const filename=path.join(process.cwd(),'virtual-weekly-plan-builder.cjs');
  const mod=new Module(filename,module);mod.filename=filename;mod.paths=Module._nodeModulePaths(process.cwd());
  mod._compile(built.outputFiles[0].text,filename);
  const {WeeklyPlanBuilder}=mod.exports;
  const parts=new Intl.DateTimeFormat('en-US',{timeZone:'Asia/Tehran',year:'numeric',month:'2-digit',day:'2-digit'}).formatToParts(new Date());
  const part=type=>parts.find(p=>p.type===type).value;
  const today=`${part('year')}-${part('month')}-${part('day')}`;
  const id='11111111-1111-4111-8111-111111111111';
  const student='22222222-2222-4222-8222-222222222222';
  const plan={id:'33333333-3333-4333-8333-333333333333',student_id:student,week_start:today,title:'برنامه',notes:null,status:'published',weekly_plan_items:[{
    id,day_of_week:0,sort_order:0,duration_minutes:60,subject:'زیست',chapter:'درسنامه',
    activity_type:'lesson',target_test_count:null,details:'مرور',source_grade:10,
    preparation_track:'konkur',recommended_publisher:null,linked_exam_id:null,
  }]};
  const props={students:[{student_id:student,full_name:'دانش‌آموز',grade:10,study_field:'experimental_sciences'}],plans:[plan],initialStudentId:student,initialPlanId:plan.id};
  const render=completedItemIds=>renderToStaticMarkup(React.createElement(WeeklyPlanBuilder,{...props,completedItemIds}));
  const locked=render([id]);
  assert.match(locked,/این باکس انجام شده و قابل تغییر یا حذف نیست/);
  const lockedBox=locked.match(/<article class="plan-item-readonly"[^>]*>[\s\S]*?این باکس انجام شده و قابل تغییر یا حذف نیست\.[\s\S]*?<\/article>/)?.[0];
  assert.ok(lockedBox,'the completed item must render as a read-only box');
  assert.doesNotMatch(lockedBox,/<(?:button|select|input|textarea)\b/);
  const editable=render([]);
  assert.doesNotMatch(editable,/این باکس انجام شده و قابل تغییر یا حذف نیست/);
  assert.match(editable,/aria-label="حذف فعالیت"/);
  console.log('PASS: a completed counselor box is visibly locked and has no edit/delete controls');
})().catch(error=>{console.error(error);process.exitCode=1});
