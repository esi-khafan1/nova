"use server";

import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { recoveryClient } from "@/lib/supabase/recovery";
import { AUTH_SITE_ORIGIN } from "@/lib/auth-urls";

export async function sendRecoveryEmail(form: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const id = String(form.get("user_id") ?? "");
  const path = "/dashboard/admin/password-recovery";
  if (!/^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i.test(id)) redirect(`${path}?error=target`);
  // Resolve email server-side and enforce permissions/cooldown atomically in DB.
  const { data: email, error } = await supabase.rpc("admin_prepare_password_recovery", { target_user_id: id });
  if (error || !email) redirect(`${path}?error=${error?.code === "P0001" ? "limit" : "target"}`);
  let sendError;
  try {
    const result = await recoveryClient().auth.resetPasswordForEmail(email as string, { redirectTo: `${AUTH_SITE_ORIGIN}/auth/recovery` });
    sendError = result.error;
  } catch {
    redirect(`${path}?error=send`);
  }
  if (sendError) redirect(`${path}?error=${sendError.status === 429 ? "limit" : "send"}`);
  redirect(`${path}?sent=1`);
}
