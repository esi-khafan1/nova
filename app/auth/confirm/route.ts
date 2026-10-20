import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { AUTH_SITE_ORIGIN, authCallbackErrorUrl, authRedirectUrl } from "@/lib/auth-urls";
import { confirmationHeaders, validConfirmationHash } from "@/lib/email-confirmation";

export const dynamic = "force-dynamic";

function redirect(success: boolean) {
  // Never retain the credential in the destination URL, or redirect to user input.
  return NextResponse.redirect(
    success ? authRedirectUrl("/dashboard") : authCallbackErrorUrl("/dashboard"),
    { status: 303, headers: confirmationHeaders },
  );
}

export async function GET(request: Request) {
  const hash = new URL(request.url).searchParams.get("token_hash");
  if (!validConfirmationHash(hash)) return redirect(false);

  // Email security scanners may prefetch GET links. Consume the token only after
  // an explicit button press; no scripts or third-party assets receive the hash.
  return new Response(`<!doctype html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>تأیید ایمیل | نووا</title></head>
<body><main><h1>تأیید ایمیل نووا</h1><p>برای تأیید ایمیل و ورود به حساب، دکمهٔ زیر را بزن.</p>
<form method="post" action="${AUTH_SITE_ORIGIN}/auth/confirm"><input type="hidden" name="token_hash" value="${hash}"><button type="submit">تأیید ایمیل و ورود</button></form>
</main></body></html>`, {
    headers: { ...confirmationHeaders, "Content-Type": "text/html; charset=utf-8" },
  });
}

export async function POST(request: Request) {
  if (request.headers.get("origin") !== AUTH_SITE_ORIGIN) {
    return new Response("Forbidden", { status: 403, headers: confirmationHeaders });
  }
  try {
    const form = await request.formData();
    const hash = form.get("token_hash");
    if (!validConfirmationHash(hash)) return redirect(false);
    const supabase = await createClient();
    // Only signup confirmation is supported here, never recovery or email change.
    // Server-to-server request: the visitor never needs to open Supabase's host.
    const { error } = await supabase.auth.verifyOtp({ token_hash: hash, type: "signup" });
    return redirect(!error);
  } catch {
    // Do not log credentials or include upstream details in the redirect.
    return redirect(false);
  }
}
