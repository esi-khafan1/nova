import type { createClient } from "./supabase/server";
import type { RegistrationRow } from "./registration";
export async function loadRegistrationDirectory(supabase:Awaited<ReturnType<typeof createClient>>){
 const rows:RegistrationRow[]=[];
 for(let offset=0;;offset+=500){const {data,error}=await supabase.rpc("registration_directory").range(offset,offset+499);if(error)throw new Error("Registration directory unavailable");rows.push(...(data??[]) as RegistrationRow[]);if(!data||data.length<500)break;}
 // Keep the established directory RPC signature and its admin-only authorization.
 for(let offset=0;offset<rows.length;offset+=200){
  const ids=rows.slice(offset,offset+200).map(row=>row.student_id);
  const [enrollments,accounts]=await Promise.all([
   supabase.from("student_registrations").select("student_id,course_type,course_duration_months,additional_notes").in("student_id",ids),
   supabase.from("student_account_details").select("student_id,telegram_id,province,city,additional_notes").in("student_id",ids),
  ]);
  if(enrollments.error||accounts.error)throw new Error("Registration details unavailable");
  const enrollmentMap=new Map((enrollments.data??[]).map(row=>[row.student_id,row]));
  const accountMap=new Map((accounts.data??[]).map(row=>[row.student_id,row]));
  for(const row of rows.slice(offset,offset+200)){
   const enrollment=enrollmentMap.get(row.student_id),account=accountMap.get(row.student_id);
   row.has_account_details=Boolean(enrollment||account);
   Object.assign(row,enrollment??{});
   if(!enrollment&&account)Object.assign(row,account);
  }
 }
 return rows;
}
