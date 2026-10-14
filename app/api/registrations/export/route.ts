import { requireProfile } from "@/lib/auth";
import { loadRegistrationDirectory } from "@/lib/load-registration-directory";
import { csvCell, registrationLabels } from "@/lib/registration";
import { studyFieldLabels } from "@/lib/study-catalog";
import { AUTH_SITE_ORIGIN } from "@/lib/auth-urls";
export async function GET(){
 const {supabase}=await requireProfile(["admin"]);
 const headers={"Cache-Control":"private, no-store","Content-Type":"text/csv; charset=utf-8","Content-Disposition":'attachment; filename="nova-students.csv"'};
 try{
  const rows=await loadRegistrationDirectory(supabase);
  const lines=[["نام و نام خانوادگی","همراه","تلگرام","پایه","رشته","استان","شهر","وضعیت حساب","مشاور","نام فایل فیش","لینک خصوصی فیش"],...rows.map(r=>[r.full_name,r.phone,r.telegram_id?`@${r.telegram_id}`:"",r.grade,r.study_field?studyFieldLabels[r.study_field]:"",r.province,r.city,registrationLabels[r.registration_status],r.counselor_name,r.receipt_name,r.receipt_path?`${AUTH_SITE_ORIGIN}/api/registrations/${r.student_id}/receipt`:""])];
  return new Response('\uFEFF'+lines.map(line=>line.map(csvCell).join(',')).join('\r\n'),{headers});
 }catch{return new Response("Export unavailable",{status:503,headers:{"Cache-Control":"private, no-store"}});}
}
