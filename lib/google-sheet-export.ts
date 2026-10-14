import { AUTH_SITE_ORIGIN } from "./auth-urls";
import { registrationLabels } from "./registration";
import { studyFieldLabels } from "./study-catalog";
export async function exportTokenHash(token:string){const hash=await crypto.subtle.digest("SHA-256",new TextEncoder().encode(token));return Array.from(new Uint8Array(hash),b=>b.toString(16).padStart(2,"0")).join("");}
export function parseExportToken(header:string|null){const match=header?.match(/^Bearer (nova_sheet_[a-f0-9]{64})$/);return match?.[1]??null;}
export function sheetReceiptLink(id:string,hasReceipt:boolean){return hasReceipt&&/^[a-f0-9-]{36}$/i.test(id)?`${AUTH_SITE_ORIGIN}/api/registrations/${id}/receipt`:"";}
export function formatSheetSnapshot(data:{scope:string;subject_id:string;subject_name:string;expires_at:string;generated_at:string;students:Record<string,unknown>[]}){
 return {schema_version:1,scope:data.scope,subject_id:data.subject_id,subject_name:data.subject_name,expires_at:data.expires_at,generated_at:data.generated_at,headers:["نام و نام خانوادگی","همراه","تلگرام","پایه","رشته","استان","شهر","وضعیت حساب","مشاور","نام فایل فیش","لینک خصوصی فیش"],rows:data.students.map(s=>[s.full_name??"",s.phone??"",s.telegram_id?`@${s.telegram_id}`:"",s.grade??"",studyFieldLabels[s.study_field as keyof typeof studyFieldLabels]??"",s.province??"",s.city??"",registrationLabels[String(s.registration_status)]??"",s.counselor_name??"",s.receipt_name??"",sheetReceiptLink(String(s.student_id),Boolean(s.has_receipt))])};
}
