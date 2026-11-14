// Render the real authorized route with disposable data. No external service is called.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path');
const {renderToStaticMarkup}=require('react-dom/server');
(async()=>{
 const built=await esbuild.build({entryPoints:['app/dashboard/counselor/plans/[planId]/print/page.tsx'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,outdir:'virtual-print-route',external:['react','react/jsx-runtime'],plugins:[{name:'mock',setup(b){
  b.onResolve({filter:/^(next\/navigation|next\/link|@\/lib\/auth)$/},a=>({path:a.path,namespace:'mock'}));
  b.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',contents:a.path==='next/navigation'?`export function notFound(){throw new Error('not-found')}`:a.path==='next/link'?`import React from 'react';export default function Link({href,children}){return React.createElement('a',{href},children)}`:`export async function requireProfile(){return global.__printAuth}` }));
 }}]});
 const filename=path.join(process.cwd(),'virtual-print-route.cjs'),mod=new Module(filename,module);mod.filename=filename;mod.paths=Module._nodeModulePaths(process.cwd());mod._compile(built.outputFiles.find(f=>f.path.endsWith('.js')).text,filename);
 const item={id:'item',day_of_week:0,duration_minutes:60,subject:'زیست',chapter:'اول',activity_type:'lesson',target_test_count:null,details:null,sort_order:0};
 const plan={id:'plan',student_id:'student',counselor_id:'counselor',week_start:'2026-11-03',title:'هفته',notes:null,status:'published',weekly_plan_items:[item]};
 const review={item_id:'item',source_week_start:'2026-11-03',due_date:'2026-11-04',offset:1,subject:'زیست',chapter:'اول',topics:[{title:'گفتار یک'}],completed:true,historical:false};
 let reviewError=null,extraError=null,directory=[{student_id:'student',full_name:'دانش‌آموز',grade:10,study_field:'experimental_sciences'}];
 const client={from(){const query={select(){return query},eq(){return query},gt(){return query},lte(){return Promise.resolve({data:[],error:null})},single(){return Promise.resolve({data:plan,error:null})}};return query},rpc(name){if(name==='counselor_student_directory')return Promise.resolve({data:directory,error:null});if(name==='planner_review_week')return Promise.resolve({data:[review],error:reviewError});if(name==='planner_get_published_extras')return Promise.resolve({data:{week:{goal:'هدف هفته'},items:{item:{topics:[{title:'موضوع چاپ',pageStart:5,pageEnd:6}]}}},error:extraError});throw Error(name)}};
 global.__printAuth={supabase:client,profile:{id:'counselor',full_name:'مشاور'}};
 const render=async()=>renderToStaticMarkup(await mod.exports.default({params:Promise.resolve({planId:'plan'})}));
 let html=await render();assert.match(html,/پیش‌نمایش چاپ/);assert.match(html,/هدف هفته/);assert.match(html,/موضوع چاپ/);assert.match(html,/گفتار یک/);assert.match(html,/aria-label="انجام شده"/);assert.match(html,/تحلیل برنامه/);
 reviewError={code:'PGRST202'};html=await render();assert.doesNotMatch(html,/پیش‌نمایش چاپ/);assert.match(html,/a4-weekly-plan/);
 reviewError={code:'42501'};await assert.rejects(render,/Unable to load print data/);
 reviewError=null;directory=[];await assert.rejects(render,/not-found/);
 console.log('PASS: authorized real print route uses review/metadata RPCs, falls back only for missing migration, and rejects access errors');
})().catch(e=>{console.error(e);process.exitCode=1});
