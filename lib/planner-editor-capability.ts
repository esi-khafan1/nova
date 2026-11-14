/** Missing rollout RPC is an expected legacy installation. Any other error is
 * different: do not quietly decide that the server is safe to use. */
export async function loadPlannerEditorCapability(client:{rpc:(name:string)=>PromiseLike<{data:unknown;error:{code?:string}|null}>}):Promise<boolean>{
 const {data,error}=await client.rpc('planner_editor_available');
 if(error && (error.code==='PGRST202'||error.code==='42883'))return false;
 if(error || typeof data!=='boolean')throw new Error('Unable to verify planner capabilities');
 return data;
}
