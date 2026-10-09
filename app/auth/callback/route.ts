import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";
import { safeReturnPath } from "@/lib/return-path";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = safeReturnPath(searchParams.get("next"));
  if (code) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) return NextResponse.redirect(`${origin}${next}`);
  }
  return NextResponse.redirect(`${origin}/auth?mode=signin&error=callback&next=${encodeURIComponent(next)}`);
}
