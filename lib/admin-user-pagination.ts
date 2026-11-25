import type { AppRole } from "@/lib/auth";
import type { createClient } from "@/lib/supabase/server";
import { parseRegistrationPage, registrationPageNumbers } from "@/lib/registration-pagination";

export type AdminUserRow = {
  id: string; full_name: string; role: AppRole; grade: number | null;
  created_at: string; email: string | null;
};
export type AdminUserPage = { rows: AdminUserRow[]; total: number; page: number; pages: number };
export const parseAdminUserPage = parseRegistrationPage;
export const adminUserPageNumbers = registrationPageNumbers;
export function adminUserSearch(value: unknown): string {
  return typeof value === "string" ? value.trim().slice(0, 120) : "";
}
export function adminUserDirectoryUrl(search: string, page: number, status?: "updated" | "error") {
  const params = new URLSearchParams();
  if (search) params.set("q", search);
  if (page > 1) params.set("page", String(page));
  if (status === "updated") params.set("updated", "1");
  if (status === "error") params.set("error", "role");
  return `/dashboard/admin/users${params.size ? `?${params}` : ""}`;
}
export async function loadAdminUserPage(supabase: Awaited<ReturnType<typeof createClient>>, search: string, page: number): Promise<AdminUserPage> {
  const {data,error} = await supabase.rpc("admin_user_directory_page", {search_query: search, requested_page: page});
  if (error || !data || !Array.isArray(data.rows) || data.rows.length > 10 ||
      !Number.isInteger(data.total) || data.total < 0 || !Number.isInteger(data.page) || data.page < 1 ||
      !Number.isInteger(data.pages) || data.pages < data.page) throw new Error("User directory unavailable");
  return data as AdminUserPage;
}
