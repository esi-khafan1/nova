const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),ts=require('typescript'),esbuild=require('esbuild'),Module=require('node:module');
const counselor='own',student='student';
const prior=Array.from({length:205},(_,i)=>({id:`prev-${i}`,student_id:student,counselor_id:'previous',week_start:'2026-02-01',title:'پیشین',status:'published',weekly_plan_items:[{day_of_week:2}]}));
const own=[{id:'own-p',student_id:student,week_start:'2026-04-01',title:'منتشرشده',status:'published',weekly_plan_items:[{day_of_week:3}]},{id:'own-d',student_id:student,week_start:'2026-05-01',title:'پیش‌نویس',status:'draft',weekly_plan_items:[{day_of_week:4}]},{id:'own-a',student_id:student,week_start:'2026-01-01',title:'آرشیوی',status:'archived',weekly_plan_items:[]}];
const all=[...prior,...own.map(x=>({...x,counselor_id:counselor}))];
const accesses=[];
function client(){return{from(table){assert.equal(table,'weekly_plans');let rows=all,filters=[];return{select(){return this},eq(key,v){filters.push(['eq',key,v]);rows=rows.filter(r=>r[key]===v);return this},neq(key,v){filters.push(['neq',key,v]);rows=rows.filter(r=>r[key]!==v);return this},order(){return this},range(from,to){accesses.push({from,to,filters:[...filters]});return Promise.resolve({data:rows.slice(from,to+1),error:null})}}}}}
(async()=>{
 const text=esbuild.buildSync({entryPoints:['lib/load-counselor-plans.ts'],bundle:true,platform:'node',format:'cjs',write:false,tsconfig:'tsconfig.json'}).outputFiles[0].text;const m=new Module('load-plans.cjs');m.filename='load-plans.cjs';m.paths=module.paths;m._compile(text,'load-plans.cjs');
 const result=await m.exports.loadAssignedPublishedHistory(client(),counselor);
 assert.equal(result.length,205);assert.ok(result.every(x=>x.counselor_id==='previous'));assert.deepEqual(accesses.map(x=>x.from),[0,200]);assert.ok(accesses.every(x=>x.filters.some(f=>f[0]==='neq'&&f[1]==='counselor_id'&&f[2]==='own')));
 const pageSource=ts.transpileModule(fs.readFileSync('app/dashboard/counselor/plans/page.tsx','utf8'),{compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
 const jsx=(type,props)=>({type,props});const mod={exports:{}};const Builder=()=>null;let checkedId;
 vm.runInNewContext(pageSource,{module:mod,exports:mod.exports,Promise,Map,Set,Array,require(name){
 if(name==='react/jsx-runtime')return{jsx,jsxs:jsx,Fragment:'fragment'};if(name==='next/link')return{default:'a',__esModule:true};
 if(name==='@/lib/load-counselor-plans')return{loadCounselorEditorPage:async(_s,history)=>{checkedId=counselor;return {counselorId:counselor,plans:history?result:own}}};
 if(name==='@/lib/supabase/request-auth')return{getRequestClient:async()=>({rpc:async(name)=>({data:name==='counselor_completed_plan_item_ids'?[]:[{student_id:student,is_selected:true,full_name:'الف',grade:10,study_field:'humanities'}],error:null})})};
 if(name==='@/lib/auth')return{requireProfile:async()=>({profile:{id:counselor,full_name:'مشاور'}})};
 if(name==='@/components/dashboard/dashboard-shell')return{DashboardShell:'shell'};if(name==='@/components/dashboard/weekly-plan-builder')return{WeeklyPlanBuilder:Builder};if(name==='@/lib/study-catalog')return{studyFieldLabels:{humanities:'انسانی'}};throw Error(name)}});
 const root=await mod.exports.default({searchParams:Promise.resolve({})});
 function find(n){if(!n||typeof n!=='object')return null;if(n.type===Builder)return n;const children=n.props?.children;for(const child of Array.isArray(children)?children:[children]){const found=find(child);if(found)return found}return null}
 const props=find(root).props;assert.equal(checkedId,counselor);assert.equal(props.plans.length,3);assert.equal(props.recentPlans.length,207);assert.equal(props.numberingPlans.length,207);assert.equal(props.overlapPlans.length,207);
 assert.equal(props.recentPlans.some(p=>p.id==='own-a'),false);
 for(const p of own.filter(x=>x.status!=='archived')){const found=props.recentPlans.find(r=>r.id===p.id);assert.equal(found.counselor_id,counselor);assert.equal(found.status,p.status);assert.equal(found.weekly_plan_items[0].day_of_week,p.weekly_plan_items[0].day_of_week)}
 assert.equal(props.overlapPlans.find(p=>p.id==='prev-0').weekly_plan_items[0].day_of_week,2);
 assert.equal(new Set(props.recentPlans.map(p=>p.id)).size,207);
 console.log('PASS: previous-counselor history paging without duplicate own plans; published/draft history, numbering and overlap data preserved.');
})().catch(e=>{console.error(e);process.exitCode=1});
