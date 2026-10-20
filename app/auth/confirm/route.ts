import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { AUTH_SITE_ORIGIN, authCallbackErrorUrl, authRedirectUrl } from "@/lib/auth-urls";
import { confirmationHeaders, validConfirmationHash, trustedConfirmationPost } from "@/lib/email-confirmation";

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
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>تأیید ایمیل | نووا</title>
<style>
@font-face{font-family:Estedad;src:url('/fonts/estedad-arabic-wght-normal.woff2') format('woff2');font-weight:100 900;font-display:swap}
*{box-sizing:border-box}body{margin:0;background:#eaf4ff;color:#173653;font-family:Estedad,Tahoma,Arial,sans-serif;min-height:100vh;min-height:100svh;display:grid;place-items:center;padding:24px 16px;line-height:2}
main{width:100%;max-width:460px;text-align:center}.brand{font-size:34px;font-weight:850;color:#173653;text-decoration:none}.tagline{font-size:12px;color:#526c83;margin:0 0 28px}.card{background:#fff;border:1px solid #d9e7f5;border-top:5px solid #ff6b1a;border-radius:24px;padding:32px 24px}h1{font-size:24px;margin:0 0 16px;font-weight:800}p{font-size:14px;color:#526477;margin:0 0 24px}button{font:inherit;font-size:15px;font-weight:750;color:#173653;background:#ff6b1a;border:0;border-radius:12px;width:100%;min-height:56px;padding:14px;cursor:pointer}button:hover{background:#ff853f}button:focus-visible,a:focus-visible{outline:3px solid #176bce;outline-offset:4px}.note{font-size:12px;margin:20px 0 0}.back{display:inline-block;font-size:13px;color:#345d7d;margin-top:24px;text-underline-offset:4px}
</style></head>
<body><main><a class="brand" href="${AUTH_SITE_ORIGIN}">نووا</a><p class="tagline">مسیر روشن موفقیت تحصیلی</p><section class="card" aria-labelledby="confirm-title"><h1 id="confirm-title">یک قدم تا شروع مسیرت</h1><p>برای تأیید ایمیل و ورود به حساب نووا، دکمهٔ زیر را بزن.</p>
<form method="post" action="${AUTH_SITE_ORIGIN}/auth/confirm"><input type="hidden" name="token_hash" value="${hash}"><button type="submit">تأیید ایمیل و ورود</button></form>
<p class="note">این مرحله برای تأیید ایمیل توست؛ بعد از آن وارد پنل می‌شوی.</p></section><a class="back" href="${AUTH_SITE_ORIGIN}">بازگشت به صفحهٔ اصلی نووا</a>
</main></body></html>`, {
    headers: { ...confirmationHeaders, "Content-Type": "text/html; charset=utf-8" },
  });
}

export async function POST(request: Request) {
  if (!trustedConfirmationPost(request.headers, AUTH_SITE_ORIGIN)) {
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
