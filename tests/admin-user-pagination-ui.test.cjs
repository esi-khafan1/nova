const assert=require('node:assert/strict'),esbuild=require('esbuild'),{renderToStaticMarkup}=require('react-dom/server');
(async()=>{
 const build=await esbuild.build({entryPoints:['app/dashboard/admin/users/page.tsx'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',packages:'external',write:false,plugins:[{name:'mock-next',setup(b){
  b.onResolve({filter:/^(next\/link|@\/components\/dashboard\/(dashboard-shell|user-role-form)|@\/lib\/auth)$/},a=>({path:a.path,namespace:'mock'}));
  b.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',resolveDir:process.cwd(),contents:a.path==='next/link'?`import React from 'react';export default function Link({href,children,prefetch,...p}){return React.createElement('a',{href,...p},children)}`:a.path.includes('dashboard-shell')?`import React from 'react';export function DashboardShell({children}){return React.createElement('main',null,children)}`:a.path.includes('user-role-form')?`import React from 'react';export function UserRoleForm({search,page}){return React.createElement('span',{'data-context':search+':'+page},'role form')}`:`export const requireProfile=async()=>({supabase:globalThis.__testSupabase,profile:{id:'admin',full_name:'مدیر'}});`}));
  b.onResolve({filter:/\.css$/},a=>({path:a.path,namespace:'style'}));
  b.onLoad({filter:/.*/,namespace:'style'},()=>({contents:'',loader:'js'}));
 }}]});
 const mod={exports:{}};new Function('require','module','exports',build.outputFiles[0].text)(require,mod,mod.exports);
 const render=async(params,data,error=false)=>{const calls=[];globalThis.__testSupabase={rpc:async(name,args)=>{calls.push({name,args});return name==='admin_list_super_admins'?{data:[],error:null}:error?{error:{message:'failure'},data:null}:{data,error:null}}};const element=await mod.exports.default({searchParams:Promise.resolve(params)});return {html:renderToStaticMarkup(element),calls}};
 const user={id:'test-user',full_name:'کاربر نمونه',role:'student',grade:10,email:'sample@example.test',created_at:'2026-01-01'};
 const result=await render({q:' نام ویژه ',page:'2'},{rows:[user],total:21,page:2,pages:3});
 assert.deepEqual(result.calls.find(x=>x.name==='admin_user_directory_page').args,{search_query:'نام ویژه',requested_page:2});
 assert.ok(result.html.includes('data-context="نام ویژه:2"'));assert.ok(result.html.includes('value="نام ویژه"'));
 assert.ok(result.html.includes('page=3'));assert.ok(result.html.includes('aria-current="page"'));assert.ok(result.html.includes('کاربر نمونه'));
 assert.equal(result.calls.some(x=>x.name==='admin_list_users'),false,'never fetch the complete unpaged list');
 const missing=await render({q:'missing'},{rows:[],total:0,page:1,pages:1});assert.ok(missing.html.includes('حسابی با این جست‌وجو پیدا نشد'));
 const failed=await render({},null,true);assert.ok(failed.html.includes('فهرست حساب‌ها دریافت نشد'));assert.ok(!failed.html.includes('حسابی در این فهرست وجود ندارد'));
 console.log('PASS: admin page uses paginated RPC, preserves search/page and reports errors');
})().catch(e=>{console.error(e);process.exitCode=1});
