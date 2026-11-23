const assert=require('node:assert/strict');
const esbuild=require('esbuild');
const Module=require('node:module');
const path=require('node:path');
(async()=>{
 const built=await esbuild.build({entryPoints:['lib/planner-overlap-message.ts'],bundle:true,platform:'node',format:'cjs',write:false});
 const file=path.join(process.cwd(),'virtual-overlap-message.cjs');const mod=new Module(file,module);mod.filename=file;mod.paths=Module._nodeModulePaths(process.cwd());mod._compile(built.outputFiles[0].text,file);
 const {plannerOverlapMessage:message}=mod.exports;
 const plan=(id,start,days,student='s')=>({id,student_id:student,week_start:start,status:'published',weekly_plan_items:days.map(day_of_week=>({day_of_week}))});
 const prev=plan('previous','2026-11-17',[0,6]);
 assert.equal(message('2026-11-23',[prev],'s','',[0],'2026-11-23'), 'برنامهٔ قبلی تا ۲ آذر فعالیت دارد. تاریخ شروع را ۳ آذر یا بعد از آن انتخاب کنید.');
 const several=plan('previous','2026-11-20',[3,5,3]);
 assert.equal(message('2026-11-23',[several],'s','',[0],'2026-11-23'), 'برنامهٔ قبلی تا ۴ آذر فعالیت دارد. تاریخ شروع را ۵ آذر یا بعد از آن انتخاب کنید.');
 // Suggestions must be checked against all loaded plans, including later ones.
 const next=plan('next','2026-11-26',[0]);
 assert.equal(message('2026-11-23',[several,next],'s','',[0],'2026-11-23'), 'برنامهٔ قبلی تا ۴ آذر فعالیت دارد. تاریخ شروع را ۶ آذر یا بعد از آن انتخاب کنید.');
 const same=plan('same','2026-11-23',[1,2]);
 assert.equal(message('2026-11-23',[same],'s','',[0],'2026-11-23'), 'برنامهٔ قبلی تا ۴ آذر فعالیت دارد. تاریخ شروع را ۵ آذر یا بعد از آن انتخاب کنید.');
 const fallback='این بازه با روزهای دارای فعالیتِ برنامهٔ دیگری هم‌پوشانی دارد.';
 assert.equal(message('2026-11-23',[plan('same','2026-11-23',[])],'s','',[0],'2026-11-23'),fallback);
 assert.equal(message('2026-11-23',[plan('later','2026-11-25',[])],'s','',[2,3],'2026-11-23'),fallback);
 assert.equal(message('2026-11-23',[{...prev,weekly_plan_items:undefined}],'s','',[0],'2026-11-23'),fallback);
 assert.equal(message('2026-11-23',[prev],'s','editing',[0],'2026-11-23'),fallback);
 assert.equal(message('2027-03-20',[plan('year','2027-03-19',[1])],'s','',[0],'2027-03-20'),'برنامهٔ قبلی تا ۲۹ اسفند ۱۴۰۵ فعالیت دارد. تاریخ شروع را ۱ فروردین ۱۴۰۶ یا بعد از آن انتخاب کنید.');
 console.log('PASS: approved concise wording for one/multiple days, safe suggestions, and fallback for other cases');
})().catch(e=>{console.error(e);process.exitCode=1});
