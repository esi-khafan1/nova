// Disposable RPC responses: diagnostics must never expose user data or error messages.
const assert = require('node:assert/strict');
const esbuild = require('esbuild');
const Module = require('node:module');
const path = require('node:path');
(async () => {
  const built = await esbuild.build({entryPoints:['lib/load-planner-print.ts'], bundle:true, platform:'node', format:'cjs', write:false});
  const filename = path.join(process.cwd(),'virtual-print-diagnostics.cjs');
  const mod = new Module(filename, module); mod.filename = filename; mod.paths = Module._nodeModulePaths(process.cwd());
  mod._compile(built.outputFiles[0].text, filename);
  const load = mod.exports.loadPublishedPlannerPrintData;
  const plan = {id:'private-plan-id',student_id:'private-student-id',week_start:'2026-11-03'};
  let review, extra;
  const client = {rpc(name) {return Promise.resolve(name === 'planner_review_today_v2' ? review : extra)}};
  const okReview = {data:[],error:null,status:200};
  const okExtra = {data:{week:{},items:{}},error:null,status:200};
  const logs=[]; const previous=console.error; console.error=(...args)=>logs.push(args);
  try {
    review={data:null,error:{code:'42501',message:'private message',details:'private details'},status:403}; extra=okExtra;
    await assert.rejects(load(client,plan), /Unable to load print data/);
    assert.deepEqual(logs.pop(), ['planner_print_rpc_failed',{rpc:'planner_review_today_v2',code:'42501',status:403}]);
    review=okReview; extra={data:null,error:{code:'private-secret',message:'private message'},status:503};
    await assert.rejects(load(client,plan), /Unable to load print data/);
    assert.deepEqual(logs.pop(), ['planner_print_rpc_failed',{rpc:'planner_get_published_extras',code:'unknown',status:503}]);
    review={error:{code:'PGRST202'},status:404}; extra=okExtra;
    assert.equal(await load(client,plan),null); assert.equal(logs.length,0);
    extra={error:{code:'42501'},status:403};
    await assert.rejects(load(client,plan),/Unable to load print data/);
    assert.deepEqual(logs.pop(), ['planner_print_rpc_failed',{rpc:'planner_get_published_extras',code:'42501',status:403}]);
    review=okReview; extra={data:{week:null},error:null,status:200};
    await assert.rejects(load(client,plan),/Unable to load print data/);
    assert.deepEqual(logs.pop(), ['planner_print_invalid_response',{rpc:'planner_get_published_extras'}]);
    review=okReview; extra=okExtra; assert.ok(await load(client,plan)); assert.equal(logs.length,0);
  } finally {console.error=previous;}
  console.log('PASS: print diagnostics preserve fallback and do not log RPC messages, arguments, or data');
})().catch(error=>{console.error(error);process.exitCode=1});
