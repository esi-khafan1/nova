import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  // Matcher is deliberately narrow. Public pages and callback handlers do not
  // need a second auth check before their own server code can run.
  const requestHeaders=new Headers(request.headers);
  // Overwrite inbound timing headers; never trust client-supplied measurements.
  requestHeaders.delete("x-nova-perf-start-ms");requestHeaders.delete("x-nova-perf-claims-ms");
  const diagnostic=request.cookies.get("nova-perf")?.value==="1";
  const requestStarted=Date.now();
  let response = NextResponse.next({ request: {headers:requestHeaders} });
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) return response;
  const supabase = createServerClient(url, key, {
    cookies: {
      getAll: () => request.cookies.getAll(),
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
        requestHeaders.set("cookie",request.cookies.toString());
        response = NextResponse.next({ request: {headers:requestHeaders} });
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
  if(diagnostic){
    const duration=Math.round(performance.now()-started);
    requestHeaders.set("x-nova-perf-start-ms",String(requestStarted));
    requestHeaders.set("x-nova-perf-claims-ms",String(duration));
    // Re-create forwarded request headers without losing refreshed cookies.
    const previous=response;
    response=NextResponse.next({request:{headers:requestHeaders}});
    previous.cookies.getAll().forEach(cookie=>response.cookies.set(cookie));
    response.headers.set("Server-Timing",`auth_claims;dur=${duration}`);
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
  return response;
}

export const config = {
  matcher: ["/dashboard/:path*", "/auth", "/auth/sign-in", "/auth/sign-up"],
};
