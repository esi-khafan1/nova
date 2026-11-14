// Private draft restoration against fresh synthetic published state.
const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const build=await esbuild.build({entryPoints:['lib/planner-plan-adapter.ts','lib/planner-draft-restore.ts'],bundle:true,platform:'node',format:'cjs',write:false,outdir:'/tmp/restore-test'});
 const load=name=>{const m={exports:{}};new Function('module','exports',build.outputFiles.find(f=>f.path.endsWith('/'+name+'.js')).text)(m,m.exports);return m.exports};
 const {plannerGridFromPlan,plannerSnapshotFromEditor}=load('planner-plan-adapter'),{restorePlannerDraft}=load('planner-draft-restore');
 const item=(id,day,more={})=>({id,day_of_week:day,sort_order:0,duration_minutes:60,subject:'زیست',chapter:'فصل یک',activity_type:'lesson',target_test_count:null,details:'',source_grade:10,preparation_track:'konkur',recommended_publisher:null,exam_year:null,linked_exam_id:null,...more});
 const plan={id:'p',student_id:'s',week_start:'2027-01-01',title:'هفته',notes:'',status:'published',weekly_plan_items:[item('past',0),item('today',1),item('future',2)]};
 const extras={week:{goal:'هدف'},items:{today:{topics:[{title:'گفتار اول'}],unrecognized:{v:1}}}};
 const routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:'',secondSubject:'',secondDetails:''}));
 const context={planId:'p',studentId:'s',weekStart:plan.week_start};
 const grid=plannerGridFromPlan(plan,new Set(),extras,'2027-01-02');
 const snapshot=plannerSnapshotFromEditor({title:'ویرایش',notes:'یادداشت خصوصی',weekStart:plan.week_start,today:'2027-01-02',planStatus:'published',grid,routines,weekExtra:extras.week});
 const base='2027-01-01T09:00:00.123456Z';
 const input={context,snapshot,today:'2027-01-02',freshPlan:plan,freshPlanUpdatedAt:'2027-01-01T12:30:00.123456+03:30',basePlanUpdatedAt:base,completed:new Set(),publishedExtras:extras};
 const original=JSON.stringify({snapshot,plan,extras});
 let result=restorePlannerDraft(input);assert.equal(result.canPublish,true);assert.deepEqual(result.conflicts,[]);assert.equal(result.title,'ویرایش');
 assert.equal(result.grid[0][0].locked,true);assert.equal(result.grid[1][0].locked,false);assert.equal(JSON.stringify({snapshot,plan,extras}),original,'restoration does not mutate inputs');
 result.grid[2][0].subject='changed';assert.equal(snapshot.editor.grid[2][0].subject,'زیست');
 // New completion locks the block and stale stored flags are never trusted.
 result=restorePlannerDraft({...input,completed:new Set(['today'])});assert.equal(result.canPublish,true);assert.equal(result.grid[1][0].completed,true);
 const staleFlags=structuredClone(snapshot);staleFlags.editor.grid[1][0].completed=true;staleFlags.editor.grid[1][0].locked=true;staleFlags.editor.grid[1][0].linkedExamId='old';
 result=restorePlannerDraft({...input,snapshot:staleFlags});assert.equal(result.grid[1][0].completed,false);assert.equal(result.grid[1][0].locked,false);assert.equal(result.grid[1][0].linkedExamId,null);
 const edited=structuredClone(snapshot);edited.editor.grid[1][0].durationMinutes=90;
 result=restorePlannerDraft({...input,snapshot:edited,completed:new Set(['today'])});assert.equal(result.canPublish,false);assert.equal(result.grid[1][0].durationMinutes,90,'draft edit remains visible');assert.ok(result.conflicts.some(c=>c.kind==='protected-changed'));
 const deleted=structuredClone(snapshot);deleted.editor.grid[1]=[];
 result=restorePlannerDraft({...input,snapshot:deleted,completed:new Set(['today'])});assert.ok(result.conflicts.some(c=>c.kind==='protected-removed'&&c.sourceItemId==='today'));assert.equal(deleted.editor.grid[1].length,0);
 const examPlan=structuredClone(plan);examPlan.weekly_plan_items[2].activity_type='exam';examPlan.weekly_plan_items[2].linked_exam_id='exam';
 result=restorePlannerDraft({...input,freshPlan:examPlan});assert.ok(result.conflicts.some(c=>c.kind==='protected-changed'&&c.sourceItemId==='future'));assert.equal(result.grid[2][0].linkedExamId,'exam');
 const removed=structuredClone(snapshot);removed.editor.grid[2]=[];
 result=restorePlannerDraft({...input,snapshot:removed,freshPlan:examPlan});assert.ok(result.conflicts.some(c=>c.kind==='protected-removed'&&c.sourceItemId==='future'));
 // Advancing the calendar must not silently drop an edit made before midnight.
 result=restorePlannerDraft({...input,snapshot:edited,today:'2027-01-03'});assert.equal(result.grid[1][0].locked,true);assert.ok(result.conflicts.some(c=>c.kind==='day-elapsed'&&c.sourceItemId==='today'));
 const newPast=structuredClone(snapshot);newPast.editor.grid[0].push({...newPast.editor.grid[2][0],key:'new',id:null,sourceItemId:null,sourceDayOfWeek:null,dayOfWeek:0});
 result=restorePlannerDraft({...input,snapshot:newPast});assert.ok(result.conflicts.some(c=>c.kind==='day-elapsed'&&c.key==='new'));
 const movedPast=structuredClone(snapshot);const old=movedPast.editor.grid[0].pop();old.dayOfWeek=3;movedPast.editor.grid[3].push(old);
 result=restorePlannerDraft({...input,snapshot:movedPast});assert.ok(result.conflicts.some(c=>c.kind==='day-elapsed'&&c.key==='past'));assert.equal(result.grid[3][0].locked,true);
 result=restorePlannerDraft({...input,freshPlanUpdatedAt:'2027-01-01T09:00:00.123457Z'});assert.ok(result.conflicts.some(c=>c.kind==='published-changed'),'even a one-microsecond change conflicts');
 const missing=structuredClone(snapshot);missing.editor.grid[2][0].id='gone';missing.editor.grid[2][0].sourceItemId='gone';
 result=restorePlannerDraft({...input,snapshot:missing});assert.ok(result.conflicts.some(c=>c.kind==='source-missing'));assert.equal(result.grid[2][0].locked,true);
 assert.throws(()=>restorePlannerDraft({...input,context:{...context,studentId:'other'}}),/context/);
 assert.throws(()=>restorePlannerDraft({...input,basePlanUpdatedAt:null}),/Missing plan version/);
 assert.throws(()=>restorePlannerDraft({...input,basePlanUpdatedAt:'bad'}),/timestamp/);
 assert.throws(()=>restorePlannerDraft({...input,snapshot:{title:'broken'}}),/snapshot/);
 const bad=structuredClone(snapshot);bad.editor.grid[2][0].topics=[{title:'x',pageStart:4,pageEnd:2}];assert.throws(()=>restorePlannerDraft({...input,snapshot:bad}),/Invalid/);
 const badRoutines=structuredClone(snapshot);badRoutines.routines[1].dayOfWeek=0;assert.throws(()=>restorePlannerDraft({...input,snapshot:badRoutines}),/routines/);
 console.log('PASS: restored drafts reconcile fresh ticks, exam links, past dates and microsecond plan versions without discarding edits');
})().catch(error=>{console.error(error);process.exitCode=1});
