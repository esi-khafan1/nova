import { createClient } from "@supabase/supabase-js";

export type ConfirmationResult = "confirmed" | "expired" | "rate_limit" | "unavailable";

/** Verify without persisting a login session; never classify all errors as expiry. */
export async function verifySignupEmail(tokenHash: string): Promise<ConfirmationResult> {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) {
    console.warn(JSON.stringify({ event: "signup_confirmation_failed", code: "missing_configuration" }));
    return "unavailable";
  }
  try {
    const supabase = createClient(url, key, {
      auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
    });
    const { error } = await supabase.auth.verifyOtp({ token_hash: tokenHash, type: "signup" });
    if (!error) return "confirmed";
    // Only machine codes/status; no token, email, upstream URL or raw message.
    console.warn(JSON.stringify({ event: "signup_confirmation_failed", code: error.code ?? "unknown", status: error.status }));
    if (error.status === 429) return "rate_limit";
    if (error.code === "otp_expired") return "expired";
    return "unavailable";
  } catch {
    console.warn(JSON.stringify({ event: "signup_confirmation_failed", code: "network_failure" }));
    return "unavailable";
  }
}
