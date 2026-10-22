"use server";
import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { requireProfile } from "@/lib/auth";
import { validateEditorial } from "@/lib/editorial/validation";
import { refreshEditorial,refreshSubmission } from "@/lib/editorial/refresh";
import { editorialKinds, type EditorialKind } from "@/lib/editorial/types";
const uuid=/^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i;
export async function saveReviewEdits(_state:{error?:string},form:FormData):Promise<{error?:string}> {
 const {supabase}=await requireProfile(["content_manager"]);
 const id=String(form.get("submission_id")??""),kind=String(form.get("kind")??"") as EditorialKind,version=Number(form.get("revision"));
 if(!uuid.test(id)||!editorialKinds.includes(kind)||!Number.isInteger(version)) return {error:"اطلاعات معتبر نیست؛ صفحه را دوباره باز کن."};
 // Kind is derived again from the protected submission, never trusted from the form.
 const {data:submission}=await supabase.from("content_submissions").select("kind").eq("id",id).single();
 if(!submission||submission.kind!==kind) return {error:"ارسال پیدا نشد."};
 const result=validateEditorial(kind,form);
 if(!result.payload)return {error:result.error};
 const {error}=await supabase.rpc("edit_content_submission",{target_submission_id:id,content_payload:result.payload,expected_version:version});
 if(error)return {error:"ویرایش ذخیره نشد؛ ممکن است نسخه توسط شخص دیگری تغییر کرده باشد. صفحه را دوباره باز کن."};
 revalidatePath(`/dashboard/content_manager/${id}`);revalidatePath("/dashboard/content_manager");
 redirect(`/dashboard/content_manager/${id}?saved=1`);
}
export async function decideSubmission(form:FormData) {
 const {supabase}=await requireProfile(["content_manager"]);
 const id=String(form.get("submission_id")??""),decision=String(form.get("decision")??""),reason=String(form.get("reason")??"").trim(),version=Number(form.get("version"));
 if(!uuid.test(id)||!["approve","reject"].includes(decision)||!Number.isInteger(version)) redirect("/dashboard/content_manager?error=invalid");
 if(decision==="reject"&&(reason.length<5||reason.length>2000)) redirect(`/dashboard/content_manager/${id}?error=reason`);
 const {data:submission}=await supabase.from("content_submissions").select("kind").eq("id",id).single();
 if(!submission) redirect("/dashboard/content_manager?error=missing");
 const {data,error}=await supabase.rpc("review_content_submission",{target_submission_id:id,decision,reason,expected_version:version});
 if(error)redirect(`/dashboard/content_manager/${id}?error=changed`);
 if(decision==="approve")refreshEditorial(submission.kind as EditorialKind,data as string);
 else refreshSubmission(submission.kind as EditorialKind,data as string);
 revalidatePath(`/dashboard/content_manager/${id}`);
 redirect(`/dashboard/content_manager?state=${decision==="approve"?"published":"rejected"}&done=1`);
}

export async function archiveContent(_state:{error?:string},form:FormData):Promise<{error?:string}> {
 const {supabase}=await requireProfile(["content_manager"]);
 const kind=String(form.get("kind")??"") as EditorialKind,id=String(form.get("content_id")??""),updatedAt=String(form.get("updated_at")??"");
 if(!editorialKinds.includes(kind)||!uuid.test(id)||!updatedAt||!Number.isFinite(Date.parse(updatedAt)))return {error:"اطلاعات معتبر نیست؛ صفحه را دوباره باز کن."};
 const {error}=await supabase.rpc("archive_editorial_content",{target_kind:kind,target_content_id:id,expected_updated_at:updatedAt});
 if(error)return {error:"بایگانی انجام نشد؛ ممکن است محتوا تغییر کرده یا قبلاً بایگانی شده باشد. صفحه را دوباره باز کن."};
 refreshEditorial(kind,id);
 revalidatePath("/dashboard/content_manager/[id]","page");
 redirect("/dashboard/content_manager?state=archived&archived=1");
}

export async function manageArchivedContent(_state:{error?:string},form:FormData):Promise<{error?:string}> {
 const {supabase}=await requireProfile(["content_manager"]);
 const kind=String(form.get("kind")??"") as EditorialKind,id=String(form.get("id")??""),updatedAt=String(form.get("updated_at")??""),operation=String(form.get("operation")??"edit");
 const reason=String(form.get("reason")??"").trim();
 if(!editorialKinds.includes(kind)||!uuid.test(id)||!updatedAt||!Number.isFinite(Date.parse(updatedAt))||!["edit","publish","return"].includes(operation))return {error:"اطلاعات معتبر نیست؛ صفحه را دوباره باز کن."};
 if(operation==="return"&&(reason.length<5||reason.length>2000))return {error:"دلیل رد باید بین ۵ تا ۲۰۰۰ نویسه باشد."};
 const result=operation==="edit"?validateEditorial(kind,form):null;
 if(result&&!result.payload)return {error:result.error};
 const {error}=await supabase.rpc("manage_archived_content",{target_kind:kind,target_content_id:id,expected_updated_at:updatedAt,operation,content_payload:result?.payload??null,reason:operation==="return"?reason:null});
 if(error)return {error:operation==="return"?"بازگشت انجام نشد؛ نویسنده باید مشاور باشد و نسخهٔ جداگانهٔ پیش‌نویس، ردشده یا در انتظار بررسی نداشته باشد. نسخهٔ موجود را بررسی کن یا صفحه را دوباره باز کن.":"عملیات انجام نشد؛ ممکن است محتوا تغییر کرده باشد یا اطلاعات انتشار کامل نباشد. صفحه را دوباره باز کن."};
 refreshEditorial(kind,id);
 revalidatePath(`/dashboard/content_manager/archived/${kind}/${id}`);
 if(operation==="edit")redirect(`/dashboard/content_manager/archived/${kind}/${id}?saved=1`);
 redirect(`/dashboard/content_manager?state=${operation==="publish"?"published":"rejected"}&done=1`);
}
