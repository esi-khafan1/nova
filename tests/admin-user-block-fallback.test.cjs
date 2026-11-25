const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{const build=await esbuild.build({entryPoints:['lib/admin-user-pagination.ts'],bundle:true,platform:'node',format:'cjs',packages:'external',write:false});const mod={exports:{}};new Function('require','module','exports',build.outputFiles[0].text)(require,mod,mod.exports);const f=mod.exports.loadAdminUserPage;let calls=[];
 const client={rpc:async(name)=>{calls.push(name);return name==='admin_user_directory_page_with_status'?{data:null,error:{code:'PGRST202'}}:{data:{rows:[{id:'x',role:'student'}],total:1,page:1,pages:1},error:null}}};
 const page=await f(client,'',1,'all');assert.deepEqual(calls,['admin_user_directory_page_with_status','admin_user_directory_page']);assert.equal(page.blockControlsAvailable,false);assert.equal(page.rows[0].blocked,false);
 calls=[];const failing={rpc:async name=>{calls.push(name);return {data:null,error:{code:'42501'}}}};await assert.rejects(f(failing,'',1),/unavailable/);assert.equal(calls.length,1);
 console.log('PASS: absent migration keeps role directory usable; other errors fail closed');
})().catch(e=>{console.error(e);process.exitCode=1});
