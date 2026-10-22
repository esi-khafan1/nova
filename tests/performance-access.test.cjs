const assert=require('node:assert/strict');
const fs=require('node:fs');const vm=require('node:vm');const ts=require('typescript');
let cookie=false,calls=0,result={data:true,error:null};
const moduleStub={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('lib/performance/access.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText,{
 module:moduleStub,exports:moduleStub.exports,require(name){
  if(name==='react')return {cache:fn=>fn};
  if(name==='next/headers')return {cookies:async()=>({get:()=>cookie?{value:'1'}:undefined})};
  throw Error(name);
 }
});
(async()=>{
 const client={rpc:async name=>{assert.equal(name,'performance_debug_enabled');calls++;return result;}};
 const enabled=moduleStub.exports.performanceEnabled;
 assert.equal(await enabled(client),false);assert.equal(calls,0,'disabled diagnostics must add no database requests');
 cookie=true;
 assert.equal(await enabled(client),true);
 result={data:false,error:null};assert.equal(await enabled(client),false,'cookie alone must never grant access');
 result={data:true,error:{message:'denied'}};assert.equal(await enabled(client),false);
 result={data:null,error:null};assert.equal(await enabled(client),false);
 const actions=fs.readFileSync('app/dashboard/performance/actions.ts','utf8');
 assert.match(actions,/httpOnly:true/);assert.match(actions,/maxAge:3600/);assert.match(actions,/path:"\/dashboard",maxAge:0/);
 const ui=fs.readFileSync('components/performance/performance-report.tsx','utf8');
 assert.match(ui,/server_ready_ms:readyMs,stages,browser_requests:browser/);
 assert.doesNotMatch(ui,/document\.cookie|localStorage|user\.id|user\.email|access_token|refresh_token/);
 console.log('Performance access tests passed: opt-in, no extra DB call when off, fail-closed authorization and safe report fields.');
})().catch(e=>{console.error(e);process.exitCode=1;});
