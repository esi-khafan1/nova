import { safeReturnPath } from "@/lib/return-path";
import { createClient } from "@supabase/supabase-js";

/** Verify the signup without saving a login session into the visitor's cookies. */
export async function verifySignupEmailResult(tokenHash: string): Promise<{verified:boolean;next:string}> {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) return {verified:false,next:"/dashboard"};
  const supabase = createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
  });
  const { data, error } = await supabase.auth.verifyOtp({ token_hash: tokenHash, type: "signup" });
  return {verified:!error,next:safeReturnPath(data?.user?.user_metadata?.course_return_to)};
}

export async function verifySignupEmail(tokenHash:string):Promise<boolean>{ return (await verifySignupEmailResult(tokenHash)).verified; }
