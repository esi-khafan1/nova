import { NextRequest, NextResponse } from "next/server";
import { requireSuperAdmin } from "@/lib/super-admin";
import { isTrustedAuthOrigin } from "@/lib/auth-origin";
import { normalizeMobile } from "@/lib/phone-auth";
export const dynamic = "force-dynamic";
function reply(status:number, body:object) {return NextResponse.json(body,{status,headers:{"Cache-Control":"no-store"}});}
export async function POST(request:NextRequest) {
 if(!isTrustedAuthOrigin(request)||!request.headers.get('content-type')?.startsWith('application/json'))return reply(403,{error:'درخواست مجاز نیست.'});
 try {
  const reader=request.body?.getReader();if(!reader)return reply(400,{error:'درخواست نامعتبر است.'});
  const chunks:Uint8Array[]=[];let size=0;
  while(true){const chunk=await reader.read();if(chunk.done)break;size+=chunk.value.length;if(size>4096){await reader.cancel();return reply(413,{error:'درخواست نامعتبر است.'});}chunks.push(chunk.value);}
  const body=JSON.parse(Buffer.concat(chunks).toString('utf8'));
  const {supabase}=await requireSuperAdmin();
  if(body?.step==='lookup') {
   const phone=normalizeMobile(body.phone);
   if(!phone)return reply(400,{error:'شمارهٔ همراه معتبر وارد کن.'});
   const {data,error}=await supabase.rpc('superadmin_student_login_lookup',{target_phone:phone});
   if(error)return reply(503,{error:'جست‌وجوی حساب انجام نشد.'});
   return reply(200,{phone,student:data?.[0]??null});
  }
  if(!['start','verify'].includes(body?.step))return reply(400,{error:'درخواست نامعتبر است.'});
  const {data,error}=await supabase.functions.invoke('superadmin-student-login',{body});
  if(error)return reply(400,{error:'نتیجه قطعی نیست؛ کد و وضعیت حساب را پیش از تلاش دوباره بررسی کن.'});
  return reply(200,data);
 } catch {return reply(503,{error:'ارتباط برقرار نشد؛ پیش از تلاش دوباره وضعیت حساب را بررسی کن.'});}
}
