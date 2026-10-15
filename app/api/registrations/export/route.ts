import { requireProfile } from "@/lib/auth";
import { loadRegistrationDirectory } from "@/lib/load-registration-directory";
import { buildRegistrationCsv } from "@/lib/registration-csv";
export async function GET(){
 const {supabase}=await requireProfile(["admin"]);
 const headers={"Cache-Control":"private, no-store","Content-Type":"text/csv; charset=utf-8","Content-Disposition":'attachment; filename="nova-students.csv"'};
 try{
  const rows=await loadRegistrationDirectory(supabase);
  return new Response(buildRegistrationCsv(rows),{headers});
 }catch{return new Response("Export unavailable",{status:503,headers:{"Cache-Control":"private, no-store"}});}
}
