import type { RegistrationRow } from "@/lib/registration";
import type { createClient } from "@/lib/supabase/server";

export type RegistrationPage = {
  rows: (RegistrationRow & {review_plan_count: number | null})[];
  total: number; waiting: number; assigned: number; unassigned: number;
  review_count: number; page: number; pages: number;
};

export function parseRegistrationPage(value?: string) {
  if (!value || !/^[1-9]\d*$/.test(value)) return 1;
  const parsed = Number(value);
  return Number.isSafeInteger(parsed) ? Math.min(parsed, 2147483647) : 1;
}

export async function loadRegistrationPage(supabase: Awaited<ReturnType<typeof createClient>>, options: {search: string; province?: string; reviewOnly: boolean; page: number}): Promise<RegistrationPage> {
  const {data,error} = await supabase.rpc("admin_registration_directory_page", {
    search_query: options.search, province_filter: options.province ?? null,
    review_only: options.reviewOnly, requested_page: options.page,
  });
  if (error || !data || !Array.isArray(data.rows)) throw new Error("Registration directory unavailable");
  return data as RegistrationPage;
}

// Show first and last pages and neighbors, without generating thousands of links.
export function registrationPageNumbers(page: number, pages: number): (number | "ellipsis")[] {
  const numbers = [...new Set([1, pages, page - 1, page, page + 1].filter(n => n >= 1 && n <= pages))].sort((a,b) => a-b);
  return numbers.flatMap((n,i) => i && n - numbers[i-1] > 1 ? ["ellipsis" as const,n] : [n]);
}
