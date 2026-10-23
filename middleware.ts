import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  // Matcher is deliberately narrow. Public pages and callback handlers do not
  // need a second auth check before their own server code can run.
  let response = NextResponse.next({ request });
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) return response;
  const supabase = createServerClient(url, key, {
    cookies: {
      getAll: () => request.cookies.getAll(),
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
        response = NextResponse.next({ request });
        cookiesToSet.forEach(({ name, value, options }) => response.cookies.set(name, value, options));
      },
    },
  });
  // Verify signed claims, never trust getSession() or a user-supplied header.
  // Asymmetric JWTs can be checked locally (cached JWKS); legacy keys may still
  // need Auth. Fresh server-side getUser + profile/RLS checks remain in pages.
  const started = performance.now();
  const { data, error } = await supabase.auth.getClaims();
  if (process.env.AUTH_PERF_LOG === "1") {
    response.headers.set("Server-Timing", `auth_claims;dur=${Math.round(performance.now() - started)}`);
  }
  const authenticated = !error && Boolean(data?.claims?.sub);
  if (!authenticated && request.nextUrl.pathname.startsWith("/dashboard/student")) {
    const signIn = new URL("/auth", request.url);
    signIn.searchParams.set("mode", "signin");
    signIn.searchParams.set("next", `${request.nextUrl.pathname}${request.nextUrl.search}`);
    const redirectResponse = NextResponse.redirect(signIn);
    response.cookies.getAll().forEach(cookie => redirectResponse.cookies.set(cookie));
    return redirectResponse;
  }
  if(authenticated&&request.nextUrl.pathname==="/dashboard/registration")response.cookies.delete("nova_course_return");
  const intended=request.nextUrl.searchParams.get("next");
  if(request.nextUrl.pathname==="/auth"&&intended?.startsWith("/dashboard/registration?"))response.cookies.set("nova_course_return",intended,{httpOnly:true,sameSite:"lax",secure:process.env.NODE_ENV==="production",path:"/",maxAge:604800});
  return response;
}

export const config = {
  matcher: ["/dashboard/:path*", "/auth", "/auth/sign-in", "/auth/sign-up"],
};
