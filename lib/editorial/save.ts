import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { validateEditorial } from "./validation";
import { refreshSubmission } from "./refresh";
import { authorPaths, type EditorialKind } from "./types";

export async function saveAuthorSubmission(kind: EditorialKind,form: FormData) {
 const {supabase}=await requireProfile(["counselor"]);
 const result=validateEditorial(kind,form);
 if(!result.payload) return {error:result.error};
 const id=String(form.get("id")??"")||null;
 const revision=Number(form.get("revision")??0);
 if (!Number.isInteger(revision)||revision<0) return {error:"نسخه معتبر نیست؛ صفحه را دوباره باز کن."};
 const {data,error}=await supabase.rpc("save_content_submission",{target_kind:kind,target_content_id:id,content_payload:result.payload,send_for_review:form.get("intent")==="publish",expected_version:revision});
 if(error) return {error:"ذخیره انجام نشد؛ ممکن است نسخه تغییر کرده یا محتوا در حال بررسی باشد. صفحه را دوباره باز کن."};
 refreshSubmission(kind,data as string);
 redirect(`/dashboard/counselor/${authorPaths[kind]}?saved=1`);
}
