const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const out=await esbuild.build({entryPoints:['lib/planner-review-settings.ts','lib/planner-week-templates.ts','lib/planner-review-today.ts'],bundle:true,platform:'node',format:'cjs',write:false,outdir:'virtual-review-settings'});
 const load=name=>{const m={exports:{}};new Function('module','exports',out.outputFiles.find(x=>x.path.endsWith('/'+name+'.js')).text)(m,m.exports);return m.exports};
 const {reviewKind,reviewDescription,readReviewSetting,normalizeReviewKind}=load('planner-review-settings'),{makeWeekTemplate,parseWeekTemplate,makeReadyBlock,applyReadyBlock}=load('planner-week-templates'),{parseTodayReviews}=load('planner-review-today');
 assert.equal(reviewKind('زیست‌شناسی ۱',10,'experimental_sciences'),'specialist');assert.equal(reviewKind('فارسی ۱',10,'experimental_sciences'),'general');assert.equal(reviewKind('عربی ۱ تخصصی',10,'humanities'),'specialist');assert.equal(reviewKind('ریاضی',9,null),'specialist');assert.equal(reviewKind('فارسی',9,null),'general');
 const setting={offset:30,kind:'specialist',reading:true,practice:true};assert.equal(reviewDescription(setting),'خواندن جمع‌بندی و زدن تست‌های مارکدار');assert.equal(reviewDescription({...setting,kind:'general',practice:false}),'مطالعه درسنامه');assert.equal(reviewDescription({...setting,kind:'general',reading:false}),'حل نمونه سوال');
 for(const invalid of [{...setting,offset:1},{...setting,practice:false,reading:false},{...setting,kind:'other'}])assert.equal(readReviewSetting(invalid),null);
 const spaced={schedule:'spaced4',kind:'general',reading:true,practice:false};assert.deepEqual(readReviewSetting(spaced),spaced);assert.equal(readReviewSetting({...spaced,offset:3}),null);
 const item={key:'x',dayOfWeek:0,subject:'زیست‌شناسی ۱',chapter:'فصل',activityType:'lesson',durationMinutes:60,targetTestCount:null,details:'',sourceGrade:10,preparationTrack:'konkur',recommendedPublisher:null,otherPublisher:false,extra:{review:setting,other:'not copied'}};
 const routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:'',secondSubject:'',secondDetails:''}));
 const template=makeWeekTemplate([item],routines);assert.deepEqual(parseWeekTemplate(template).days[0][0].extra,{review:{schedule:'spaced4',kind:'specialist',reading:true,practice:true}});
 const target={...item,key:'target',extra:{other:'keep'}};assert.deepEqual(applyReadyBlock(target,makeReadyBlock(item)).extra,{other:'keep',review:{schedule:'spaced4',kind:'specialist',reading:true,practice:true}});
 assert.deepEqual(normalizeReviewKind({review:setting,other:'keep'},'فارسی ۱',10,'experimental_sciences'),{review:{...setting,kind:'general'},other:'keep'});assert.deepEqual(normalizeReviewKind({review:setting},'ریاضی',9,null),{review:setting});
 const row={item_id:'item',due_date:'2026-11-04',offset:30,subject:'زیست',chapter:null,topics:[],review:setting,completed:false};assert.equal(parseTodayReviews([row]).length,1);assert.throws(()=>parseTodayReviews([row,row]));assert.throws(()=>parseTodayReviews([{...row,offset:7}]));
 console.log('PASS: subject categories, combined labels, setting validation, template preservation and review parsing');
})().catch(e=>{console.error(e);process.exitCode=1});
