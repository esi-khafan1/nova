const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const out=await esbuild.build({entryPoints:['lib/student-planning.ts'],bundle:true,platform:'node',format:'cjs',write:false});
 const m={exports:{}};new Function('module','exports',out.outputFiles[0].text)(m,m.exports);
 const {summarizeRoutineMinutes,summarizeItems}=m.exports;
 const plan={id:'p',week_start:'2026-11-17',title:'',notes:null,weekly_plan_items:[],routines:[
  {dayOfWeek:0,subject:'ریاضی',details:'تمرین',durationMinutes:25,secondSubject:'زبان',secondDetails:'مرور',secondDurationMinutes:15},
  {dayOfWeek:1,subject:'فیزیک',details:'مرور',durationMinutes:40},
  {dayOfWeek:2,subject:'شیمی',details:'',durationMinutes:null},
  {dayOfWeek:3,subject:'زیست',details:'',durationMinutes:-10},
 ]};
 const tick=(day,slot,subject,details,plan_id='p')=>({plan_id,student_id:'s',day_of_week:day,slot,subject,details,checked_at:''});
 const ticks=[tick(0,1,'ریاضی','تمرین'),tick(0,1,'ریاضی','تمرین'),tick(0,2,'زبان','قدیمی'),tick(1,1,'فیزیک','مرور','other'),tick(2,1,'شیمی','')];
 assert.deepEqual(summarizeRoutineMinutes(plan,[0,0,1,2,3],ticks),{plannedMinutes:80,minutes:25});
 ticks.push(tick(0,2,'زبان','مرور'),tick(1,1,'فیزیک','مرور'));
 assert.deepEqual(summarizeRoutineMinutes(plan,[0],ticks),{plannedMinutes:40,minutes:40});
 assert.deepEqual(summarizeRoutineMinutes(plan,[0,1],ticks),{plannedMinutes:80,minutes:80});
 assert.deepEqual(summarizeRoutineMinutes(plan,[1],ticks),{plannedMinutes:40,minutes:40});
 assert.deepEqual(summarizeRoutineMinutes(undefined,[0],ticks),{plannedMinutes:0,minutes:0});
 const item={id:'i',plan_id:'p',day_of_week:0,duration_minutes:60,activity_type:'practice_tests',target_test_count:20};
 const completion={item_id:'i',completed_test_count:10,completed_minutes:null};
 const s=summarizeItems([item],new Map([['i',completion]]));
 assert.equal(s.percent,50);assert.equal(s.tests,10);assert.equal(s.minutes,60);
 console.log('PASS: timed routines count exactly once by matching plan, day and slot, without changing activity ratios or tests');
})().catch(e=>{console.error(e);process.exitCode=1});
