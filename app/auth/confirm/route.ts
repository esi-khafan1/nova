import { NextResponse } from "next/server";
import { verifySignupEmailResult } from "@/lib/supabase/confirmation";
import { AUTH_SITE_ORIGIN, authCallbackErrorUrl } from "@/lib/auth-urls";
import { confirmationHeaders, validConfirmationHash } from "@/lib/email-confirmation";

export const dynamic = "force-dynamic";

function redirect(success: boolean,next="/dashboard") {
  // Never retain the credential in the destination URL. Verification deliberately
  // does not create a browser session: the requested destination is the login form.
  return NextResponse.redirect(
    success
      ? `${AUTH_SITE_ORIGIN}/auth?mode=signin&confirmed=1${next!=="/dashboard"?`&next=${encodeURIComponent(next)}`:""}`
      : authCallbackErrorUrl("/dashboard"),
    { status: 303, headers: confirmationHeaders },
  );
}

export async function GET(request: Request) {
  const hash = new URL(request.url).searchParams.get("token_hash");
  if (!validConfirmationHash(hash)) return redirect(false);
  try {
    // A single click in the email verifies server-to-server and lands on Nova's
    // login page. No intermediate HTML, second button, or Supabase-host redirect.
    const result=await verifySignupEmailResult(hash);
    return redirect(result.verified,result.next);
  } catch {
    return redirect(false);
  }
}
