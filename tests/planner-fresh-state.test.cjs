const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const result=await esbuild.build({entryPoints:['lib/planner-fresh-state.ts','lib/planner-builder-adapter.ts'],bundle:true,platform:'node',format:'cjs',write:false,outdir:'fresh-tests'});
 const load=name=>{const m={exports:{}};new Function('module','exports',result.outputFiles.find(f=>f.path.endsWith('/'+name+'.js')).text)(m,m.exports);return m.exports};
 const {loadFreshPlannerState}=load('planner-fresh-state'),{builderGrid,builderItems,builderSnapshot}=load('planner-builder-adapter');
 const plan={id:'p',student_id:'s',week_start:'2099-01-01',updated_at:'2026-10-19T10:00:00.123456Z',status:'published',title:'عنوان',notes:'',weekly_plan_items:[]};
 const state={plans:[plan],id:'c',user:'c',completed:[{item_id:'i'}],extras:{week:{goal:'هدف'},items:{i:{topics:[{title:'مبحث'}]}}}};
 const client={auth:{getUser:async()=>({data:{user:{id:state.user}},error:null})},rpc:async(name)=>{if(name==='counselor_plan_editor_page')return {data:{counselor_id:state.id,plans:state.plans,has_more:false},error:null};if(name==='counselor_completed_plan_item_ids')return {data:state.completed,error:null};if(name==='planner_get_published_extras')return {data:state.extras,error:null};throw Error(name)}};
 const ctx={studentId:'s',weekStart:plan.week_start,planId:'p'};
 const fresh=await loadFreshPlannerState(client,ctx,'c');assert.equal(fresh.planUpdatedAt,plan.updated_at);assert.equal(fresh.extras.week.goal,'هدف');assert.equal(fresh.completed.has('i'),true);
 state.user='other';await assert.rejects(loadFreshPlannerState(client,ctx,'c'));state.user='c';state.plans=[];await assert.rejects(loadFreshPlannerState(client,ctx,'c'));state.plans=[plan];state.extras.items.i=[];await assert.rejects(loadFreshPlannerState(client,ctx,'c'));
 const item={key:'i',id:'i',sourceItemId:'i',sourceDayOfWeek:0,dayOfWeek:0,durationMinutes:60,subject:'زیست',chapter:'فصل',activityType:'lesson',targetTestCount:null,details:'',sourceGrade:10,preparationTrack:'konkur',recommendedPublisher:null,otherPublisher:false,extra:{custom:'پایدار'},topics:[{title:'مبحث',pageStart:3,pageEnd:4}],examYear:null};
 const items=builderItems(builderGrid([item]));assert.deepEqual(items[0].extra,item.extra);assert.deepEqual(items[0].topics,item.topics);assert.equal(items[0].sourceItemId,'i');
 const routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:''}));const snap=builderSnapshot({items,routines,title:'عنوان',notes:'',weekStart:'2099-01-01',today:'2099-01-01',planStatus:'published',weekExtra:{goal:'هدف'}});
 assert.equal(snap.extras.items[0].custom,'پایدار');assert.deepEqual(snap.extras.items[0].topics,item.topics);assert.equal(snap.items[0].sourceItemId,'i');
 console.log('PASS: fresh identity/version/progress checks and editor snapshot metadata round trip');
})().catch(e=>{console.error(e);process.exitCode=1});
