"use server";
import { requireProfile } from "@/lib/auth";
import { redirect } from "next/navigation";
export async function issueSheetKey(_state:{token?:string;error?:string;expires_at?:string},_fd:FormData):Promise<{token?:string;error?:string;expires_at?:string}>{
 await requireProfile(["admin"]);
 return {error:"اتصال خارجی حذف شده است؛ از جدول فعال‌سازی داخل پنل ادمین استفاده کن."};
}
export async function revokeSheetKey(_fd:FormData){await requireProfile(["admin"]);redirect("/dashboard/admin/registrations");}
export async function attachSheet(_fd:FormData){await requireProfile(["admin"]);redirect("/dashboard/admin/registrations");}
