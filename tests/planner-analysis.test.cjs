// Calculations on fixtures only; no production accounts or services.
const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const output=await esbuild.build({entryPoints:['lib/planner-analysis.ts'],bundle:true,platform:'node',format:'cjs',write:false});
 const m={exports:{}};new Function('module','exports',output.outputFiles[0].text)(m,m.exports);
 const {analyzePlannerWeek}=m.exports;
 const defs=[['زیست',1050],['ریاضی',600],['فیزیک',450],['شیمی',450],['ادبیات',180],['زبان',180],['عربی',90],['دینی',90]];
 const grid=Array.from({length:7},()=>[]);let n=0;
 for(const [subject,total] of defs)for(let i=0;i<3;i++){const day=n%7;grid[day].push({key:String(n),dayOfWeek:day,subject,chapter:'',activityType:'lesson',durationMinutes:total/3,targetTestCount:n<6?20:15,details:''});n++;}
 const original=JSON.stringify(grid),result=analyzePlannerWeek(grid);
 assert.equal(result.minutes,3090);assert.equal(result.tests,390);assert.equal(result.blocks,24);assert.equal(result.emptySlots,11);
 assert.equal(result.subjects.find(row=>row.subject==='زیست').minutes,1050);
 assert.ok(Math.abs(result.testsPerHour-390/51.5)<1e-12);
 assert.ok(Math.abs(result.subjects.reduce((sum,row)=>sum+row.percent,0)-100)<1e-9);
 assert.equal(result.meanDailyMinutes,3090/7);assert.equal(JSON.stringify(grid),original);
 assert.equal(result.subjects.every(row=>row.days.reduce((x,y)=>x+y,0)===row.minutes),true);
 const empty=analyzePlannerWeek(Array.from({length:7},()=>[]));assert.equal(empty.testsPerHour,null);assert.deepEqual(empty.subjects,[]);
 const mixed=Array.from({length:7},()=>[]);mixed[0]=[{key:'x',dayOfWeek:0,subject:'',durationMinutes:0,targetTestCount:0,activityType:'lesson',chapter:'',details:''}];
 assert.equal(analyzePlannerWeek(mixed).subjects[0].subject,'فعالیت بدون درس');
 assert.equal(analyzePlannerWeek(mixed).subjects[0].percent,0);
 console.log('PASS: 24-block fixture produces 51:30, 390 tests, subject totals, day totals and safe empty ratios');
})().catch(e=>{console.error(e);process.exitCode=1});
