const assert=require('node:assert/strict');
const fs=require('node:fs');
const esbuild=require('esbuild');
const os=require('node:os');
const path=require('node:path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'nova-counselor-report-'));
try{
 const bundle=(source,name)=>{const file=path.join(dir,name+'.cjs');esbuild.buildSync({entryPoints:[source],outfile:file,bundle:true,platform:'node',format:'cjs',alias:{'@':process.cwd()}});return require(file);};
 const {planNumbers,nextPlanNumber,numberedPlanTitle}=bundle('lib/plan-numbering.ts','numbering');
 const {completedTestBreakdown,summarizeItems}=bundle('lib/student-planning.ts','study');
 const plans=[
  {id:'a',student_id:'student1',week_start:'2026-09-01'},
  {id:'b',student_id:'student1',week_start:'2026-09-08'},
  {id:'c',student_id:'student2',week_start:'2026-09-02'},
 ];
 const numbers=planNumbers([...plans,plans[0]]);
 assert.equal(numbers.get('a'),1);assert.equal(numbers.get('b'),2);assert.equal(numbers.get('c'),1);
 assert.equal(nextPlanNumber(plans,'student1','2026-09-15'),3);
 assert.equal(numberedPlanTitle('برنامه هفتگی',2),'برنامهٔ ۲');
 assert.equal(numberedPlanTitle('جمع‌بندی',3),'برنامهٔ ۳ · جمع‌بندی');
 const item=(id,subject,chapter,activity_type='practice_tests',target_test_count=20)=>({id,subject,chapter,activity_type,target_test_count,duration_minutes:60});
 const items=[item('1','ریاضی','فصل ۱'),item('2','ریاضی','فصل ۱'),item('3','ریاضی','فصل ۲'),item('4','فیزیک',null),item('5','شیمی',null),item('6','فیزیک',null,'lesson')];
 const done=new Map([['1',{completed_test_count:12}],['2',{completed_test_count:null}],['3',{completed_test_count:8}],['4',{completed_test_count:10}],['6',{completed_test_count:null}]]);
 assert.deepEqual(completedTestBreakdown(items,done).map(row=>[row.subject,row.chapter,row.count]),[
  ['ریاضی','فصل ۱',32],['ریاضی','فصل ۲',8],['فیزیک',null,10],
 ]);
 assert.equal(completedTestBreakdown(items,done).reduce((n,r)=>n+r.count,0),summarizeItems(items,done).tests);
 const builder=fs.readFileSync('components/dashboard/weekly-plan-builder.tsx','utf8');
 const panel=fs.readFileSync('components/dashboard/student-planning-panel.tsx','utf8');
 const registration=fs.readFileSync('components/dashboard/registration-directory.tsx','utf8');
 const designer=fs.readFileSync('app/dashboard/exam_designer/page.tsx','utf8');
 const studentPrint=fs.readFileSync('components/dashboard/print-weekly-plan.tsx','utf8');
 assert.match(builder,/numberingPlans = \[\]/);assert.match(panel,/numberedPlanTitle\(p\.title,numbers\.get\(p\.id\)\?\?1\)/);
 assert.match(panel,/counselor\?<details className="sp-test-breakdown"/);
 assert.match(registration,/rows\.filter\(row => row\.province === province\)/);
 assert.match(registration,/prioritizePendingUnassignedReceipts\(filteredRows\)/);
 assert.match(designer,/designer_exam_box_notes/);
 assert.match(panel,/item\.details&&\(item\.activity_type!=="exam"\|\|counselor\)/);
 assert.match(studentPrint,/item\.activity_type === "exam" \? "" : item\.details/);
 console.log('Plan numbering, daily/weekly test breakdown, province filtering and note visibility passed.');
}finally{fs.rmSync(dir,{recursive:true,force:true});}
