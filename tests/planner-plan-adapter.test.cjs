// Round-trip the existing plan and private snapshot using synthetic data only.
const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const result=await esbuild.build({entryPoints:['lib/planner-plan-adapter.ts','lib/planner-grid.ts'],bundle:true,platform:'node',format:'cjs',write:false,outdir:'/tmp/planner-adapter-test'});
 const load=output=>{const mod={exports:{}};new Function('module','exports',output.text)(mod,mod.exports);return mod.exports};
 const adapter=load(result.outputFiles.find(f=>f.path.endsWith('/planner-plan-adapter.js')));
 const gridHelpers=load(result.outputFiles.find(f=>f.path.endsWith('/planner-grid.js')));
 const item=(id,day,order,more={})=>({id,day_of_week:day,sort_order:order,duration_minutes:60,subject:'زیست',chapter:'فصل یک',activity_type:'lesson',target_test_count:null,details:'',source_grade:10,preparation_track:'konkur',recommended_publisher:null,exam_year:null,linked_exam_id:null,...more});
 const plan={id:'plan',student_id:'student',week_start:'2027-01-01',title:'هفته',notes:'یادداشت',status:'published',weekly_plan_items:[item('future',2,1),item('past',0,0),item('today',1,0,{activity_type:'exam',linked_exam_id:'exam'})]};
 const extras={week:{goal:'هدف',nested:{value:2}},items:{future:{topics:[{title:'گفتار یک'}],unknown:{keep:true}},today:{action:'آزمون'}}};
 const source=JSON.stringify({plan,extras});
 const grid=adapter.plannerGridFromPlan(plan,new Set(['today']),extras,'2027-01-02');
 assert.equal(JSON.stringify({plan,extras}),source,'loading does not mutate saved plan');
 assert.equal(grid[0][0].locked,true);assert.equal(grid[1][0].completed,true);assert.equal(grid[1][0].linkedExamId,'exam');
 assert.equal(grid[2][0].sourceItemId,'future');assert.equal(grid[2][0].sourceDayOfWeek,2);
 assert.deepEqual(grid[2][0].topics,[{title:'گفتار یک'}],'loading does not rewrite topic JSON');
 const routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:'',secondSubject:'',secondDetails:''}));
 const state={title:plan.title,notes:plan.notes,weekStart:plan.week_start,today:'2027-01-02',planStatus:'published',grid,routines,weekExtra:extras.week};
 const snap=adapter.plannerSnapshotFromEditor(state);
 assert.deepEqual(snap.items.map(i=>i.sourceItemId),['today','future']);assert.equal(snap.items[0].id,'today');assert.equal(snap.items[1].id,null);
 assert.equal(snap.editor.grid[0][0].id,'past','past remains visible in durable editor snapshot');
 assert.deepEqual(snap.extras.items,[{action:'آزمون'},{topics:[{title:'گفتار یک'}],unknown:{keep:true}}]);
 assert.equal(snap.extras.week.goal,'هدف');snap.editor.grid[2][0].extra.unknown.keep=false;assert.equal(grid[2][0].extra.unknown.keep,true);
 // Copying never aliases its source, retains useful metadata, and does not
 // transfer the old activity, review history, progress, or exam identity.
 const copied=gridHelpers.copyPlannerBlock(grid[2][0],3,'copy');
 assert.equal(copied.sourceItemId,null);assert.equal(copied.sourceDayOfWeek,null);assert.equal(copied.id,null);assert.equal(copied.linkedExamId,null);
 copied.extra.unknown.keep=false;assert.equal(grid[2][0].extra.unknown.keep,true);
 grid[3].push(copied);const withCopy=adapter.plannerSnapshotFromEditor(state);
 assert.equal(withCopy.items.at(-1).sourceItemId,null);assert.equal(withCopy.items.at(-1).id,null);
 // A future source moved to today cannot be updated by its old database ID:
 // v9 creates a new item, while sourceItemId preserves the review identity.
 const moved=gridHelpers.movePlannerBlock(grid,{day:2,index:0},{day:1,index:1});
 const movedSnap=adapter.plannerSnapshotFromEditor({...state,grid:moved});
 assert.equal(movedSnap.items[1].id,null);assert.equal(movedSnap.items[1].sourceItemId,'future');
 const changed=gridHelpers.clonePlannerGrid(grid);changed[2][0].topics=[{title:'گفتار دوم',pageStart:4,pageEnd:8}];
 const changedSnap=adapter.plannerSnapshotFromEditor({...state,grid:changed});
 assert.deepEqual(changedSnap.extras.items[1].topics,[{title:'گفتار دوم',pageStart:4,pageEnd:8}]);assert.equal(changedSnap.extras.items[1].unknown.keep,true);
 assert.throws(()=>adapter.plannerGridFromPlan(plan,new Set(),extras,'2027-02-30'),/Invalid/);
 assert.throws(()=>adapter.plannerGridFromPlan(plan,new Set(),{week:{},items:{future:{topics:[{title:'x',pageStart:3,pageEnd:1}]}}},'2027-01-02'),/Invalid/);
 const duplicate=gridHelpers.clonePlannerGrid(grid);duplicate[3][0].sourceItemId='future';assert.throws(()=>adapter.plannerSnapshotFromEditor({...state,grid:duplicate}),/source identity/);
 const mismatch=gridHelpers.clonePlannerGrid(grid);mismatch[2][0].id='wrong';assert.throws(()=>adapter.plannerSnapshotFromEditor({...state,grid:mismatch}),/source identity/);
 const missingDay=gridHelpers.clonePlannerGrid(grid);delete missingDay[2][0].sourceDayOfWeek;assert.throws(()=>adapter.plannerSnapshotFromEditor({...state,grid:missingDay}),/source identity/);
 const partialCopy=gridHelpers.clonePlannerGrid(grid);partialCopy[3][0].sourceDayOfWeek=2;assert.throws(()=>adapter.plannerSnapshotFromEditor({...state,grid:partialCopy}),/identity has no source/);
 console.log('PASS: editor grid/snapshot bridge preserves old items, nested metadata, copied identity and review sources');
})().catch(e=>{console.error(e);process.exitCode=1});
