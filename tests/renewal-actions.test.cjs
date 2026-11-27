// Server-action integration with synthetic calls and an unrelated input only.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path');
(async()=>{
 const built=await esbuild.build({entryPoints:['app/dashboard/registration/renewal-actions.ts'],bundle:true,platform:'node',format:'cjs',write:false,outdir:'virtual-renewal-actions',plugins:[{name:'mock',setup(b){b.onResolve({filter:/^(next\/cache|@\/lib\/auth)$/},a=>({path:a.path,namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',contents:a.path==='next/cache'?'export function revalidatePath(){}':'export async function requireProfile(){return global.__renewalContext}'}));}}]});
 const filename=path.join(process.cwd(),'virtual-renewal-actions.cjs'),mod=new Module(filename,module);mod.filename=filename;mod.paths=Module._nodeModulePaths(process.cwd());mod._compile(built.outputFiles[0].text,filename);
 const calls=[],uploads=[],removes=[];let fail=false;
 const quoteId='4c53cf2b-0344-4b0f-98cb-68c99682df93';
 const supabase={rpc:async(name,args)=>{calls.push({name,args});return name==='quote_student_renewal'?{data:{status:'ok',quote_id:quoteId,base_price:7470000,payable_price:args.target_code?6349500:7470000,discount_percent:args.target_code?15:0},error:null}:{data:null,error:fail?{code:'expired'}:null}},storage:{from:()=>({upload:async(...args)=>{uploads.push(args);return {error:null}},remove:async paths=>{removes.push(paths);return {error:null}}})}};
 global.__renewalContext={supabase,profile:{id:'student-123',registration_status:'active'}};
 const selection={grade:10,field:'humanities',course:'base',months:3};const q=await mod.exports.applyRenewalDiscount(selection,'SAMPLE');assert.equal(q.quote.payable_price,6349500);assert.equal(calls[0].args.target_code,'SAMPLE');
 function form(){const f=new FormData();for(const [key,value] of Object.entries({...selection,expected_price:'7470000',quote_id:quoteId}))f.set(key,String(value));f.set('receipt',new File([new Uint8Array([255,216,255,4])],'file.jpg',{type:'image/jpeg'}));return f;}
 const result=await mod.exports.submitRenewal({},form());assert.ok(result.success);assert.equal(uploads.length,1);assert.equal(calls[1].name,'submit_student_renewal');assert.deepEqual(Object.keys(calls[1].args).sort(),['target_name','target_quote_id','target_receipt']);assert.ok(calls[1].args.target_receipt.startsWith('student-123/renewal/'));
 fail=true;const failure=await mod.exports.submitRenewal({},form());assert.ok(failure.error);assert.equal(removes.length,1);assert.equal(removes[0][0],uploads[1][0]);
 const full=form();full.set('quote_id','');full.set('expected_price','123');const before=uploads.length;const changed=await mod.exports.submitRenewal({},full);assert.match(changed.error,/قیمت دوره تغییر/);assert.equal(uploads.length,before);
 global.__renewalContext.profile.registration_status='pending';assert.ok((await mod.exports.submitRenewal({},form())).error);
 console.log('PASS: server quote, no code in submission, immutable receipt upload and safe failure cleanup');
})().catch(e=>{console.error(e);process.exitCode=1});
