const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const out=await esbuild.build({entryPoints:['lib/planner-review-records.ts'],bundle:true,platform:'node',format:'cjs',write:false});
 const m={exports:{}};new Function('module','exports',out.outputFiles[0].text)(m,m.exports);
 const parse=m.exports.parsePrintableReviewRecords;
 const row={item_id:'i',source_week_start:'2026-11-03',due_date:'2026-11-04',offset:1,subject:'زیست',chapter:null,topics:[{title:'گفتار',pageStart:1,pageEnd:3}],completed:true,historical:false};
 const archived={...row,item_id:'old',historical:true,archive_id:'archive',completed:false};
 const rows=parse([row,archived]);assert.equal(rows.length,2);assert.equal(rows[0].checked,true);assert.equal(rows[1].checked,false);assert.equal(rows[1].key,'archive:archive');assert.equal(rows[0].topics[0].pageEnd,3);
 for(const bad of [{...row,due_date:'2026-02-30'},{...row,topics:[{title:'x',pageStart:5,pageEnd:2}]},{...archived,archive_id:null},{...row,completed:null}]) assert.throws(()=>parse([bad]));
 assert.throws(()=>parse([row,row]));assert.throws(()=>parse(null));
 console.log('PASS: print review rows preserve actual completion, history and pages; invalid input is rejected');
})().catch(e=>{console.error(e);process.exitCode=1});
