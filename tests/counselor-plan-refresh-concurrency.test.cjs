const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),ts=require('typescript');
const text=ts.transpileModule(fs.readFileSync('app/dashboard/counselor/plans/page.tsx','utf8'),{compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
const jsx=(type,props)=>({type,props}), Builder=()=>null;
function find(node,type){if(!node||typeof node!=='object')return null;if(node.type===type)return node;for(const child of Array.isArray(node.props?.children)?node.props.children:[node.props?.children]){const found=find(child,type);if(found)return found}return null}
async function run({mismatch=false,fail=false}={}){
 const events=[];let releaseAuth;const authGate=new Promise(r=>releaseAuth=r);const mod={exports:{}};
 const client={rpc:async name=>{events.push(name);return {data:[],error:null}}};
 vm.runInNewContext(text,{module:mod,exports:mod.exports,Promise,Map,Set,Array,require(name){
  if(name==='react/jsx-runtime')return{jsx,jsxs:jsx,Fragment:'fragment'};
  if(name==='next/link')return{default:'a',__esModule:true};
  if(name==='@/lib/auth')return{requireProfile:async()=>{events.push('auth');await authGate;return {profile:{id:'verified',full_name:'test'}}}};
  if(name==='@/lib/supabase/request-auth')return{getRequestClient:async()=>client};
  if(name==='@/lib/load-counselor-plans')return{loadCounselorEditorPage:async(_s,previous)=>{events.push(previous?'history':'plans');if(fail&&previous)throw Error('offline');return {counselorId:mismatch&&previous?'wrong':'verified',plans:[]}}};
  if(name==='@/components/dashboard/dashboard-shell')return{DashboardShell:'shell'};
  if(name==='@/components/dashboard/weekly-plan-builder')return{WeeklyPlanBuilder:Builder};
  if(name==='@/lib/study-catalog')return{studyFieldLabels:{}};
  throw Error(name);
 }});
 let settled=false;const result=mod.exports.default({searchParams:Promise.resolve({})}).then(x=>{settled=true;return x});
 await new Promise(r=>setImmediate(r));
 assert.deepEqual(events.sort(),['auth','counselor_completed_plan_item_ids','counselor_student_directory','history','plans'].sort(),'all scoped reads start without waiting for Auth');
 assert.equal(settled,false,'no page renders before verified Auth');releaseAuth();const root=await result;
 if(mismatch||fail){assert.equal(find(root,Builder),null,'partial or identity-mismatched data must not render');assert.ok(find(root,'section'));}
 else assert.ok(find(root,Builder));
}
(async()=>{await run();await run({mismatch:true});await run({fail:true});console.log('PASS: authenticated editor data fetch overlaps Auth; mismatches and failed pages block the form');})().catch(e=>{console.error(e);process.exitCode=1});
