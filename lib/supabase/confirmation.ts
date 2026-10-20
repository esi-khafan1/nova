import { createClient } from "@supabase/supabase-js";

/** Verify the signup without saving a login session into the visitor's cookies. */
export async function verifySignupEmail(tokenHash: string): Promise<boolean> {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) return false;
  const supabase = createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
  });
  const { error } = await supabase.auth.verifyOtp({ token_hash: tokenHash, type: "signup" });
  return !error;
}
