"use server";
import { requireProfile } from "@/lib/auth";
import { exportTokenHash } from "@/lib/google-sheet-export";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
export async function issueSheetKey(_state:{token?:string;error?:string;expires_at?:string},fd:FormData):Promise<{token?:string;error?:string;expires_at?:string}>{
 const {supabase}=await requireProfile(["admin"]);const counselor=String(fd.get("counselor_id")??"")||null;
 if(counselor)return {error:"اتصال شیت فقط برای ادمین مجاز است."};
 const bytes=crypto.getRandomValues(new Uint8Array(32));const token="nova_sheet_"+Array.from(bytes,b=>b.toString(16).padStart(2,"0")).join("");
 const {data,error}=await supabase.rpc("admin_issue_sheet_export_token",{hash_value:await exportTokenHash(token),target_counselor_id:counselor});
 if(error||!data?.[0])return {error:"ساخت کلید انجام نشد؛ دوباره تلاش کن."};
 revalidatePath("/dashboard/admin/google-sheets");return {token,expires_at:data[0].expires_at};
}
export async function revokeSheetKey(fd:FormData){const {supabase}=await requireProfile(["admin"]);const id=String(fd.get("token_id")??"");if(!/^[a-f0-9-]{36}$/i.test(id))redirect("/dashboard/admin/google-sheets?error=1");const {error}=await supabase.rpc("admin_revoke_sheet_export_token",{target_token_id:id});if(error)redirect("/dashboard/admin/google-sheets?error=1");revalidatePath("/dashboard/admin/google-sheets");redirect("/dashboard/admin/google-sheets");}
export async function attachSheet(fd:FormData){const {supabase}=await requireProfile(["admin"]);const id=String(fd.get("token_id")??""),url=String(fd.get("sheet_url")??"").trim();const match=url.match(/^https:\/\/docs\.google\.com\/spreadsheets\/d\/([A-Za-z0-9_-]{20,200})(?:\/|$)/);if(!/^[a-f0-9-]{36}$/i.test(id)||!match)redirect("/dashboard/admin/google-sheets?error=1");const {error}=await supabase.rpc("admin_attach_google_sheet",{target_token_id:id,target_spreadsheet_id:match[1]});if(error)redirect("/dashboard/admin/google-sheets?error=1");revalidatePath("/dashboard/admin/google-sheets");redirect("/dashboard/admin/google-sheets");}
