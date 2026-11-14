// Real session + preflight with a synthetic, revisioned transport.
const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const bundle=await esbuild.build({entryPoints:['lib/planner-draft-session.ts','lib/planner-plan-adapter.ts','lib/planner-publication-preflight.ts'],bundle:true,format:'cjs',platform:'node',write:false,outdir:'/tmp/preflight-test'});
 const load=name=>{const m={exports:{}};new Function('module','exports',bundle.outputFiles.find(f=>f.path.endsWith('/'+name+'.js')).text)(m,m.exports);return m.exports};
 const {createPlannerDraftSession}=load('planner-draft-session'),{plannerGridFromPlan,plannerSnapshotFromEditor}=load('planner-plan-adapter'),{createPlannerPublicationPreflight}=load('planner-publication-preflight');
 const plan={id:'p',student_id:'s',week_start:'2027-01-01',title:'قدیمی',notes:'',status:'published',weekly_plan_items:[{id:'i',day_of_week:0,sort_order:0,duration_minutes:60,subject:'زیست',chapter:'فصل',activity_type:'lesson',target_test_count:null,details:'',source_grade:10,preparation_track:'konkur',recommended_publisher:null,exam_year:null,linked_exam_id:null}]};
 const extras={week:{goal:'هدف'},items:{}},base='2027-01-01T09:00:00.123456Z',ctx={studentId:'s',weekStart:plan.week_start,planId:plan.id},routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:''}));
 const grid=plannerGridFromPlan(plan,new Set(),extras,'2027-01-01');grid[0][0].durationMinutes=90;
 const input=plannerSnapshotFromEditor({title:'خصوصی',notes:'',weekStart:plan.week_start,today:'2027-01-01',planStatus:'published',grid,routines,weekExtra:extras.week});
 let draft=null,publishCount=0,published=null,completed=new Set(['i']),failLoad=false,version=base;
 const transport={load:async()=>draft,save:async(c,snapshot,expected)=>{assert.equal(c.planId,'p');assert.equal(expected,draft?.revision??null);draft={planId:'p',basePlanUpdatedAt:base,revision:String(Number(expected??0)+1),snapshot:structuredClone(snapshot)};return {revision:draft.revision,basePlanUpdatedAt:base}},publish:async(c,revision)=>{assert.equal(revision,draft.revision);publishCount++;published=structuredClone(draft.snapshot);draft=null;return 'p'}};
 const fresh=async(c)=>{assert.deepEqual(c,ctx);if(failLoad)throw Error('fresh data unavailable');return {today:'2027-01-01',plan,planUpdatedAt:version,completed,extras}};
 const events=[];const session=createPlannerDraftSession({transport,onEvent:e=>events.push(e),delayMs:100000,preparePublication:createPlannerPublicationPreflight(fresh)});
 assert.equal(await session.open(ctx,input),true);session.update(input);
 assert.equal(await session.publish(),null);assert.equal(publishCount,0);assert.equal(draft.snapshot.editor.grid[0][0].durationMinutes,90,'blocked edit remains in private draft');
 assert.ok(events.some(e=>e.type==='error'&&e.operation==='publish'&&/پیش‌نویس حفظ شد/.test(e.error.message)));
 const corrected=structuredClone(input);corrected.editor.grid[0][0].durationMinutes=60;corrected.items[0].durationMinutes=60;session.update(corrected);
 failLoad=true;assert.equal(await session.publish(),null);assert.equal(publishCount,0);assert.equal(draft.snapshot.title,'خصوصی','fresh-load failure retains the draft');failLoad=false;
 version='2027-01-01T09:00:00.123457Z';assert.equal(await session.publish(),null);assert.equal(publishCount,0,'stale plan cannot publish');version=base;
 assert.equal(await session.publish(),'p');assert.equal(publishCount,1);assert.equal(published.title,'خصوصی');assert.equal(published.editor.grid[0][0].completed,true,'fresh progress is persisted before publication');
 assert.equal(published.items[0].id,'i');assert.equal(published.items[0].sourceItemId,'i');assert.equal(plan.title,'قدیمی','synthetic live plan was not mutated');session.dispose();
 console.log('PASS: session preflight blocks stale edits and durably saves fresh state before exact revision publication');
})().catch(error=>{console.error(error);process.exitCode=1});
