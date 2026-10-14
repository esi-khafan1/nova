import { requireProfile } from "@/lib/auth";
import { NextResponse } from "next/server";
export async function GET(_request:Request,{params}:{params:Promise<{studentId:string}>}){
 const {supabase}=await requireProfile(["admin","student"],true);const {studentId}=await params;
 if(!/^[0-9a-f-]{36}$/i.test(studentId))return new NextResponse("Not found",{status:404});
 // RLS only permits the owner or admin.
 const {data,error}=await supabase.from("student_registrations").select("receipt_path").eq("student_id",studentId).maybeSingle();
 if(error||!data)return new NextResponse("Not found",{status:404,headers:{"Cache-Control":"private, no-store"}});
 const {data:signed,error:signError}=await supabase.storage.from("registration-receipts").createSignedUrl(data.receipt_path,60);
 if(signError||!signed)return new NextResponse("Receipt unavailable",{status:503,headers:{"Cache-Control":"private, no-store"}});
 return new NextResponse(null,{status:307,headers:{Location:signed.signedUrl,"Cache-Control":"private, no-store","Referrer-Policy":"no-referrer"}});
}
