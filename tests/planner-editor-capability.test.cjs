const assert=require('node:assert/strict'),fs=require('node:fs'),{PGlite}=require('@electric-sql/pglite'),esbuild=require('esbuild');
(async()=>{
 const db=new PGlite();try{
  await db.exec(`create role anon;create role authenticated;create schema private;
   create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved',true) is distinct from 'yes' then raise exception 'Approved counselor required' using errcode='42501';end if;end$$;
   grant usage on schema public to authenticated,anon;`);
  await db.exec(fs.readFileSync('supabase/migrations/130_planner_editor_capability.sql','utf8'));
  await db.query("select set_config('test.approved','yes',false)");await db.exec('set role authenticated');
  const available=async()=>(await db.query('select public.planner_editor_available() as available')).rows[0].available;
  assert.equal(await available(),false,'missing RPCs must not activate the editor');await db.exec('reset role');
  const sql=fs.readFileSync('supabase/migrations/130_planner_editor_capability.sql','utf8');const signatures=[...sql.matchAll(/'public\.(planner_[a-z_]+\([^']*\))'/g)].map(m=>m[1]);assert.equal(signatures.length,15);
  for(const sig of signatures){await db.exec(`create function public.${sig} returns void language sql as 'select'; revoke all on function public.${sig} from public,anon,authenticated; grant execute on function public.${sig} to authenticated;`)}
  await db.exec('revoke execute on function public.planner_publish_working_draft(uuid,date,text) from authenticated; set role authenticated');assert.equal(await available(),false,'unreviewed publisher remains disabled');
  await db.exec(`reset role;
   create function private.planner_publish_working_draft_unvalidated(uuid,date,text) returns void language sql as 'select';
   create function private.planner_validate_publication(uuid,uuid,date,jsonb) returns void language sql as 'select';
   revoke all on function private.planner_publish_working_draft_unvalidated(uuid,date,text) from public,anon,authenticated;
   revoke all on function private.planner_validate_publication(uuid,uuid,date,jsonb) from public,anon,authenticated;`);
  const release=fs.readFileSync('supabase/migrations/249_planner_enable_reviewed_publication.sql','utf8');
  await db.exec('grant execute on function private.planner_publish_working_draft_unvalidated(uuid,date,text) to authenticated');
  await assert.rejects(db.exec(release),/Planner publication privileges are unsafe/);
  await db.exec('revoke all on function private.planner_publish_working_draft_unvalidated(uuid,date,text) from authenticated');
  await db.exec(release);await db.exec('set role authenticated');assert.equal(await available(),true);
  await db.query("select set_config('test.approved','no',false)");await assert.rejects(available,/Approved counselor required/);
  await db.exec('reset role; set role anon');await assert.rejects(available,/permission denied/);
 }finally{await db.close()}
 const output=esbuild.buildSync({entryPoints:['lib/planner-editor-capability.ts'],platform:'node',format:'cjs',bundle:true,write:false});const module={exports:{}};new Function('module','exports',output.outputFiles[0].text)(module,module.exports);const {loadPlannerEditorCapability:load}=module.exports;
 assert.equal(await load({rpc:async()=>({data:null,error:{code:'PGRST202'}})}),false);assert.equal(await load({rpc:async()=>({data:true,error:null})}),true);await assert.rejects(()=>load({rpc:async()=>({data:null,error:{code:'42501'}})}));await assert.rejects(()=>load({rpc:async()=>({data:null,error:null})}));
 console.log('PASS: actual page capability gate, missing or revoked publisher, and authorization');
})().catch(e=>{console.error(e);process.exitCode=1});
