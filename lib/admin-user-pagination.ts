import type { AppRole } from "@/lib/auth";
import type { createClient } from "@/lib/supabase/server";
import { parseRegistrationPage, registrationPageNumbers } from "@/lib/registration-pagination";

export type AdminUserFilter = "all" | "active" | "blocked";
export type AdminUserRow = {
  id: string; full_name: string; role: AppRole; grade: number | null;
  created_at: string; email: string | null; blocked: boolean;
  block_state: "blocking" | "blocked" | "unblocking" | "needs_review" | null;
};
export type AdminUserPage = { rows: AdminUserRow[]; total: number; page: number; pages: number; blockControlsAvailable: boolean };
export const parseAdminUserPage = parseRegistrationPage;
export const adminUserPageNumbers = registrationPageNumbers;
export function adminUserSearch(value: unknown): string {
  return typeof value === "string" ? value.trim().slice(0, 120) : "";
}
export function adminUserFilter(value: unknown): AdminUserFilter {
  return value === "blocked" || value === "active" ? value : "all";
}
export function adminUserDirectoryUrl(search: string, page: number, status?: "updated" | "error" | "blocked" | "unblocked" | "block-error", filter: AdminUserFilter = "all") {
  const params = new URLSearchParams();
  if (search) params.set("q", search);
  if (page > 1) params.set("page", String(page));
  if (filter !== "all") params.set("filter", filter);
  if (status === "updated") params.set("updated", "1");
  if (status === "error") params.set("error", "role");
  if (status === "blocked" || status === "unblocked") params.set("block", status);
  if (status === "block-error") params.set("error", "block");
  return `/dashboard/admin/users${params.size ? `?${params}` : ""}`;
}
export async function loadAdminUserPage(supabase: Awaited<ReturnType<typeof createClient>>, search: string, page: number, filter: AdminUserFilter = "all"): Promise<AdminUserPage> {
  let {data,error} = await supabase.rpc("admin_user_directory_page_with_status", {search_query: search, requested_page: page, account_filter:filter});
  let blockControlsAvailable = true;
  // The web app may deploy before the database migration. Keep role management
  // usable, but never show a block control without its security backend.
  if (error && ["PGRST202", "42883"].includes(error.code)) {
    const fallback = await supabase.rpc("admin_user_directory_page", {search_query: search, requested_page: page});
    data = fallback.data; error = fallback.error;
    blockControlsAvailable = false;
    if (data && Array.isArray(data.rows)) data.rows = data.rows.map((row: AdminUserRow) => ({...row, blocked:false, block_state:null}));
  }
  if (error || !data || !Array.isArray(data.rows) || data.rows.length > 10 ||
      !Number.isInteger(data.total) || data.total < 0 || !Number.isInteger(data.page) || data.page < 1 ||
      !Number.isInteger(data.pages) || data.pages < data.page || data.rows.some((r: AdminUserRow) => typeof r.blocked !== "boolean")) throw new Error("User directory unavailable");
  return {...data, blockControlsAvailable} as AdminUserPage;
}
