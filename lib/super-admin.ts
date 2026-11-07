import { requireProfile } from "@/lib/auth";
import { redirect } from "next/navigation";

export async function requireSuperAdmin() {
  const context = await requireProfile(["admin"]);
  const {data,error} = await context.supabase.rpc("admin_list_super_admins");
  if (error || !data?.some((row: {user_id:string})=>row.user_id===context.profile.id)) redirect("/dashboard/admin");
  return context;
}
