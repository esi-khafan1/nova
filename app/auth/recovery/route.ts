import { NextResponse } from "next/server";
import { AUTH_SITE_ORIGIN } from "@/lib/auth-urls";
import { validConfirmationHash, confirmationHeaders } from "@/lib/email-confirmation";
import { recoveryCookie } from "@/lib/supabase/recovery";

export const dynamic = "force-dynamic";
export async function GET(request: Request) {
  const token = new URL(request.url).searchParams.get("token_hash");
  const valid = validConfirmationHash(token);
  // No visible intermediate page; do not consume the token on email-scanner GET.
  const response = NextResponse.redirect(`${AUTH_SITE_ORIGIN}/auth?${valid ? "mode=reset" : "mode=signin&error=recovery"}`, {
    status: 303, headers: confirmationHeaders,
  });
  response.cookies.set(recoveryCookie, valid ? token : "", {
    httpOnly: true, secure: true, sameSite: "lax", path: "/auth", maxAge: valid ? 600 : 0,
  });
  return response;
}
