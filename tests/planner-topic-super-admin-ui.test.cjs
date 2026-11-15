const assert=require('node:assert/strict'),esbuild=require('esbuild'),React=require('react'),{renderToStaticMarkup}=require('react-dom/server');
const mocks={
 'next/link':`import React from 'react';export default function Link(p){return <a href={p.href}>{p.children}</a>}`,
 'next/navigation':`export function redirect(url){throw Error('REDIRECT:'+url)}`,
 '@/lib/auth':`export async function requireProfile(){return globalThis.__context}`,
 '@/components/dashboard/dashboard-shell':`import React from 'react';export function DashboardShell(p){return <main data-super={String(p.isSuperAdmin)}>{p.children}</main>}`,
 '@/components/dashboard/planner-topic-bank-manager':`import React from 'react';export function PlannerTopicBankManager(){return <div>MANAGER CONTROLS</div>}`,
};
async function load(file){const result=await esbuild.build({entryPoints:[file],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,packages:'external',plugins:[{name:'mocks',setup(b){b.onResolve({filter:/^(next\/link|next\/navigation|@\/lib\/auth|@\/components\/dashboard\/dashboard-shell|@\/components\/dashboard\/planner-topic-bank-manager)$/},a=>({path:a.path,namespace:'testmock'}));b.onLoad({filter:/.*/,namespace:'testmock'},a=>({contents:mocks[a.path],loader:'tsx',resolveDir:process.cwd()}));}}]});const m={exports:{}};new Function('module','exports','require',result.outputFiles[0].text)(m,m.exports,require);return m.exports.default}
function context(isSuper,error=false){return {profile:{id:'actor',role:'admin',full_name:'نام مدیر'},supabase:{rpc(name){if(name==='admin_dashboard_counts')return {single:async()=>({data:{users:1,students:1,counselors:0},error:null})};if(name==='admin_list_super_admins')return Promise.resolve({data:isSuper?[{user_id:'actor'}]:[],error:error?{}:null});throw Error(name)}}}}
(async()=>{const dashboard=await load('app/dashboard/admin/page.tsx'),page=await load('app/dashboard/admin/planner-topics/page.tsx');
 for(const [isSuper,error] of [[false,false],[false,true],[true,false]]){globalThis.__context=context(isSuper,error);const html=renderToStaticMarkup(await dashboard());assert.equal(html.includes('href="/dashboard/admin/planner-topics"'),isSuper);assert.ok(html.includes('خدمات دانش‌آموزان'));assert.ok(html.includes('نقش‌ها و پنل‌ها'));if(!isSuper)await assert.rejects(()=>page(),/REDIRECT:\/dashboard\/admin/);else{const content=renderToStaticMarkup(await page());assert.ok(content.includes('MANAGER CONTROLS'));assert.ok(content.includes('data-super="true"'));}}
 console.log('PASS: real dashboard and management page render; regular admin and capability errors fail closed');
})().catch(e=>{console.error(e);process.exitCode=1});
