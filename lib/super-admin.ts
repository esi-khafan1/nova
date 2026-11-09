import { requireProfile } from "@/lib/auth";
import { redirect } from "next/navigation";

export async function hasSuperAdminAccess(context: Awaited<ReturnType<typeof requireProfile>>) {
  if (context.profile.role !== "admin") return false;
  try {
    const {data,error} = await context.supabase.rpc("admin_list_super_admins");
    return !error && Array.isArray(data) && data.some((row: {user_id:string})=>row.user_id===context.profile.id);
  } catch {
    return false;
  }
}

export async function requireSuperAdmin() {
  const context = await requireProfile(["admin"]);
  if (!(await hasSuperAdminAccess(context))) redirect("/dashboard/admin");
  return context;
}
