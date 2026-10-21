import { NextResponse } from "next/server";
import { verifySignupEmail, type ConfirmationResult } from "@/lib/supabase/confirmation";
import { AUTH_SITE_ORIGIN } from "@/lib/auth-urls";
import { confirmationHeaders, validConfirmationHash } from "@/lib/email-confirmation";

export const dynamic = "force-dynamic";

function redirect(result: ConfirmationResult) {
  // Never retain the credential in the destination URL. Verification deliberately
  // does not create a browser session: the requested destination is the login form.
  return NextResponse.redirect(
    result === "confirmed"
      ? `${AUTH_SITE_ORIGIN}/auth?mode=signin&confirmed=1`
      : `${AUTH_SITE_ORIGIN}/auth?mode=signin&error=confirmation_${result}`,
    { status: 303, headers: confirmationHeaders },
  );
}

export async function GET(request: Request) {
  const hash = new URL(request.url).searchParams.get("token_hash");
  if (!validConfirmationHash(hash)) return redirect("expired");
  try {
    // A single click in the email verifies server-to-server and lands on Nova's
    // login page. No intermediate HTML, second button, or Supabase-host redirect.
    return redirect(await verifySignupEmail(hash));
  } catch {
    return redirect("unavailable");
  }
}
