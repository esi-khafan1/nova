import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";
import { safeReturnPath } from "@/lib/return-path";
import { authRedirectUrl, authCallbackErrorUrl, canonicalWorkerCallback } from "@/lib/auth-urls";

export async function GET(request: Request) {
  const workerCallback = canonicalWorkerCallback(request.url, request.headers.get("host"));
  if (workerCallback) return NextResponse.redirect(workerCallback);

  const { searchParams } = new URL(request.url);
  const code = searchParams.get("code");
  const next = safeReturnPath(searchParams.get("next"));
  if (code) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) return NextResponse.redirect(authRedirectUrl(next));
  }
  return NextResponse.redirect(authCallbackErrorUrl(next));
}
