"use server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { normalizeDigits, validateRegistration,receiptImageType } from "@/lib/registration";
export async function submitRegistration(_state:{error?:string},fd:FormData):Promise<{error?:string}>{
 const {supabase,profile}=await requireProfile(["student"],true);
 if(profile.registration_status==="active")redirect("/dashboard/student");
 const text=(name:string)=>String(fd.get(name)??"").trim();
 const values={first_name:text("first_name"),last_name:text("last_name"),phone:normalizeDigits(text("phone")).replace(/[\s-]/g,""),telegram_id:text("telegram_id").replace(/^@/,""),grade:Number(text("grade")),study_field:text("study_field"),province:text("province"),city:text("city")};
 const invalid=validateRegistration(values);if(invalid)return {error:invalid};
 const {data:previous,error:readError}=await supabase.from("student_registrations").select("receipt_path,receipt_name").eq("student_id",profile.id).maybeSingle();
 if(readError)return {error:"اطلاعات قبلی دریافت نشد؛ دوباره تلاش کن."};
 let receipt_path=previous?.receipt_path,receipt_name=previous?.receipt_name;let uploaded=false;
 const file=fd.get("receipt");
 if(file instanceof File&&file.size){
  if(file.size>5*1024*1024)return {error:"حجم فیش باید حداکثر ۵ مگابایت باشد."};
  const bytes=new Uint8Array(await file.arrayBuffer());const type=receiptImageType(bytes);
  if(!type)return {error:"فیش را به صورت عکس JPG، PNG یا WebP ارسال کن."};
  receipt_path=`${profile.id}/${crypto.randomUUID()}.${type.extension}`;receipt_name=file.name.slice(0,150);
  const {error}=await supabase.storage.from("registration-receipts").upload(receipt_path,bytes,{contentType:type.mime,upsert:false});
  if(error)return {error:"بارگذاری فیش انجام نشد؛ دوباره تلاش کن."};uploaded=true;
 }
 if(!receipt_path)return {error:"عکس فیش واریزی را بارگذاری کن."};
 const {error}=await supabase.rpc("submit_student_registration",{payload:{...values,receipt_path,receipt_name}});
 if(error){if(uploaded)await supabase.storage.from("registration-receipts").remove([receipt_path]);return {error:"ثبت اطلاعات انجام نشد. اگر حساب تأیید شده، صفحه را دوباره باز کن؛ در غیر این صورت دوباره تلاش کن."};}
 if(uploaded&&previous?.receipt_path&&previous.receipt_path!==receipt_path)await supabase.storage.from("registration-receipts").remove([previous.receipt_path]);
 revalidatePath("/dashboard");revalidatePath("/dashboard/admin/registrations");redirect("/dashboard/registration?saved=1");
}
