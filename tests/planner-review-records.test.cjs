const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{const out=await esbuild.build({entryPoints:['lib/planner-review-records.ts'],bundle:true,platform:'node',format:'cjs',write:false});const m={exports:{}};new Function('module','exports',out.outputFiles[0].text)(m,m.exports);const parse=m.exports.parsePlannerReviewRecords;
 const current={item_id:'item',source_week_start:'2026-11-03',due_date:'2026-11-04',offset:1,completed:true,historical:false};
 const archive={archive_id:'archive',item_id:'old',due_date:'2026-11-05',offset:3,subject:'زیست',chapter:null,topics:[{title:'گفتار یک',pageStart:1,pageEnd:4,bankId:'bio'}],completed:false,historical:true};
 const result=parse([current,archive]);assert.ok(result.completed.has(JSON.stringify(['2026-11-03','item',1])));assert.equal(result.historical[0].archiveId,'archive');assert.equal(result.historical[0].chapter,'');assert.equal(result.historical[0].topics[0].pageEnd,4);assert.equal(result.historical[0].completed,false);
 for(const row of [{...current,offset:'1'},{...current,due_date:'2026-02-30'},{...current,source_week_start:null},{...archive,topics:[{title:'x',pageStart:5,pageEnd:3}]},{...archive,topics:{}},{...archive,archive_id:null}])assert.throws(()=>parse([row]),/Invalid review/);
 assert.throws(()=>parse({}),/Invalid review/);console.log('PASS: published and historical review records map to stable UI keys; malformed responses rejected');
})().catch(e=>{console.error(e);process.exitCode=1});
