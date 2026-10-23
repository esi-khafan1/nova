import {createClient as createPublicClient} from "@supabase/supabase-js";
import {randomBytes} from "node:crypto";
import {NextRequest,NextResponse} from "next/server";
import {createClient} from "@/lib/supabase/server";
import {getRequestUser} from "@/lib/supabase/request-auth";
export const dynamic="force-dynamic";
export const runtime="nodejs";
const cookie="nova_support_session";
export async function GET(request:NextRequest){return exchange(request,false);}
export async function POST(request:NextRequest){
 const origin=request.headers.get("origin");
 let validOrigin=false;try{validOrigin=Boolean(origin&&new URL(origin).host===(request.headers.get("host")??request.nextUrl.host));}catch{}
 if(!validOrigin)return NextResponse.json({error:"درخواست مجاز نیست."},{status:403});
 return exchange(request,true);
}
async function exchange(request:NextRequest,posting:boolean){
 let token=request.cookies.get(cookie)?.value;
 if(!token||!/^[a-f0-9]{64}$/.test(token))token=randomBytes(32).toString("hex");
 try{
  if(posting&&Number(request.headers.get("content-length")??0)>12000)throw Error('large');
  let body:Record<string,unknown>={};
  if(posting){const reader=request.body?.getReader();if(!reader)throw Error('body');const chunks:Uint8Array[]=[];let length=0;
   while(true){const part=await reader.read();if(part.done)break;length+=part.value.length;if(length>12000){await reader.cancel();throw Error('large');}chunks.push(part.value);}
   const raw=Buffer.concat(chunks).toString('utf8');body=JSON.parse(raw);if(!body||typeof body!=='object')throw Error('body');
  }
  const text=posting?body.message:null;
  if(posting&&(typeof text!=="string"||!text.trim()||text.length>2000))throw Error('message');
  const after=Number(request.nextUrl.searchParams.get("after")??0);
  if(!Number.isSafeInteger(after)||after<0)throw Error('cursor');
  const supabase=await createClient();
  // Fresh Auth is required for staff access and attaching an account name.
  const {user}=await getRequestUser();
  const staff=request.nextUrl.searchParams.get("staff")==="1";
  if(staff){
   if(!user)return NextResponse.json({error:"وارد حساب پشتیبانی شو."},{status:401});
   const {data:profile}=await supabase.rpc("own_dashboard_profile").maybeSingle<{id:string;role:string}>();
   if(profile?.id!==user.id||profile?.role!=="support_agent")return NextResponse.json({error:"دسترسی مجاز نیست."},{status:403});
  }
  const thread=request.nextUrl.searchParams.get("thread");
  if(staff&&thread&&!/^[0-9a-f-]{36}$/i.test(thread))throw Error('thread');
  if(staff&&posting&&!thread)throw Error('thread');
  const page=Number(request.nextUrl.searchParams.get("page")??0);
  if(!Number.isInteger(page)||page<0||page>100000)throw Error('page');
  const client=user?supabase:createPublicClient(process.env.NEXT_PUBLIC_SUPABASE_URL!,process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY??process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,{auth:{persistSession:false,autoRefreshToken:false,detectSessionInUrl:false}});
  const result=staff?(thread?await supabase.rpc("support_agent_thread",{target_thread:thread,after_id:after,message_text:text}):await supabase.rpc("support_inbox",{needs_reply:request.nextUrl.searchParams.get("state")!=="answered",page_number:page})):
   await client.rpc("support_visitor",{visitor_token:token,after_id:after,message_text:text});
  let payload=result.data;
  if(staff&&!thread&&!result.error){const {data:topic,error:topicError}=await supabase.rpc("support_inbox_topic");if(topicError)throw Error('live config');payload={threads:result.data,realtime_topic:topic};}
  const response=NextResponse.json(result.error?{reset:result.error.code==="42501",error:"ارتباط انجام نشد؛ کمی صبر کن و دوباره تلاش کن."}:payload,{status:result.error?400:200,headers:{"Cache-Control":"no-store, max-age=0","Vary":"Cookie"}});
  if(result.error?.code==="42501"&&!staff)response.cookies.delete(cookie);
  else if(!staff)response.cookies.set(cookie,token,{httpOnly:true,sameSite:"lax",secure:process.env.NODE_ENV==="production",path:"/",maxAge:2592000});
  return response;
 }catch{return NextResponse.json({error:"درخواست انجام نشد؛ پیام حداکثر ۲۰۰۰ نویسه باشد و دوباره تلاش کن."},{status:400,headers:{"Cache-Control":"no-store"}});}
}
