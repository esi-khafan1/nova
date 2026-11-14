// A fake transport proves state-machine behavior without touching any account.
const assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const bundle=await esbuild.build({entryPoints:['lib/planner-draft-session.ts'],bundle:true,platform:'node',format:'cjs',write:false});
 const mod={exports:{}};new Function('module','exports',bundle.outputFiles[0].text)(mod,mod.exports);
 const {createPlannerDraftSession}=mod.exports;
 const ctx=(student,plan=null)=>({studentId:student,weekStart:'2026-11-03',planId:plan});
 const cache=new Map(),events=[];let calls=[],hold=null,failSave=false,failPublish=false,failLoad=false;
 const key=c=>`${c.studentId}:${c.weekStart}`;
 const transport={
  load:async c=>{calls.push(['load',c.studentId]);if(failLoad)throw new Error('load failed');return cache.get(key(c))??null},
  save:async(c,snapshot,rev)=>{calls.push(['save',c.studentId,rev,snapshot.title]);if(hold)await hold;if(failSave)throw new Error('save failed');const old=cache.get(key(c));if((old?.revision??null)!==rev)throw new Error('conflict');const next={planId:c.planId,basePlanUpdatedAt:c.planId?'2026-11-01T10:00:00Z':null,revision:String(Number(rev??0)+1),snapshot};cache.set(key(c),next);return {revision:next.revision,basePlanUpdatedAt:next.basePlanUpdatedAt}},
  publish:async(c,rev)=>{calls.push(['publish',c.studentId,rev]);if(failPublish)throw new Error('publish failed');const draft=cache.get(key(c));assert.equal(draft.revision,rev);cache.delete(key(c));return {published:draft.snapshot}},
 };
 const session=createPlannerDraftSession({transport,onEvent:event=>events.push(event),delayMs:100000});
 assert.equal(await session.open(ctx('a'),{title:'initial'}),true);
 assert.equal(session.hasPendingWork(),false);
 const source={title:'changed'};session.update(source);source.title='MUTATED';assert.equal(session.hasPendingWork(),true);
 assert.equal(await session.open(ctx('b'),{title:'B'}),true,'switch flushes first');
 assert.deepEqual(calls.slice(0,3),[['load','a'],['save','a',null,'changed'],['load','b']]);
 assert.equal(cache.get('a:2026-11-03').snapshot.title,'changed');
 assert.equal(await session.open(ctx('a'),{title:'ignored'}),true);
 assert.equal(events.filter(e=>e.type==='opened').at(-1).restored,true);
 assert.equal(events.filter(e=>e.type==='opened').at(-1).snapshot.title,'changed');
 session.update({title:'save failure'});failSave=true;
 assert.equal(await session.open(ctx('b'),{title:'B'}),false,'failed save blocks switching');
 assert.ok(events.some(e=>e.type==='save-state'&&e.state==='error'));
 assert.equal(session.hasPendingWork(),true,'failed saves require navigation protection');
 failSave=false;assert.equal(await session.retry(),true);assert.equal(session.hasPendingWork(),false);assert.equal(cache.get('a:2026-11-03').revision,'2');
 failLoad=true;assert.equal(await session.open(ctx('b'),{title:'B'}),false,'failed load retains current context');failLoad=false;
 session.update({title:'still A'});assert.equal(await session.flush(),true);assert.equal(cache.get('a:2026-11-03').snapshot.title,'still A');
 failPublish=true;assert.equal(await session.publish(),null);assert.equal(cache.get('a:2026-11-03').revision,'3','publish failure retains draft');
 session.update({title:'after failure'});failPublish=false;const published=await session.publish();assert.equal(published.published.title,'after failure');assert.equal(cache.has('a:2026-11-03'),false);
 assert.throws(()=>session.update({}),/No draft/);
 assert.equal(await session.open(ctx('b'),{title:'untouched'}),true);
 const untouched=await session.publish();assert.equal(untouched.published.title,'untouched','untouched draft is saved before publish');
 assert.equal(await session.open(ctx('c'),{title:'C'}),true);session.update({title:'pending'});
 let release;hold=new Promise(resolve=>{release=resolve});const switching=session.open(ctx('d'),{title:'D'});
 assert.throws(()=>session.update({title:'must not be lost'}),/busy/);await assert.rejects(session.publish(),/busy/);
 release();assert.equal(await switching,true);hold=null;assert.equal(cache.get('c:2026-11-03').snapshot.title,'pending');
 cache.set('bad:2026-11-03',{planId:'other',revision:'1',snapshot:{title:'wrong plan'}});
 assert.equal(await session.open(ctx('bad','expected'),{}),false);session.update({title:'still D'});await session.flush();
 assert.equal(cache.get('d:2026-11-03').snapshot.title,'still D');
 session.dispose();assert.throws(()=>session.update({}),/closed/);
 console.log('PASS: draft save, context switches, stale plans, publish serialization and failure recovery');
})().catch(e=>{console.error(e);process.exitCode=1});
