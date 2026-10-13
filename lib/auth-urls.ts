import { safeReturnPath } from "./return-path";

export const AUTH_SITE_ORIGIN = "https://nova-academy.ir";

/** Auth emails must never inherit a workers.dev / preview page's origin. */
export function emailConfirmationUrl(next: unknown): string {
  const url = new URL("/auth/callback", AUTH_SITE_ORIGIN);
  url.searchParams.set("next", safeReturnPath(next));
  return url.toString();
}

export function authRedirectUrl(next: unknown): string {
  return new URL(safeReturnPath(next), AUTH_SITE_ORIGIN).toString();
}

export function authCallbackErrorUrl(next: unknown): string {
  const url = new URL("/auth", AUTH_SITE_ORIGIN);
  url.searchParams.set("mode", "signin");
  url.searchParams.set("error", "callback");
  url.searchParams.set("next", safeReturnPath(next));
  return url.toString();
}

/** Forward old Worker email links before exchanging a host-bound PKCE code. */
export function canonicalWorkerCallback(requestUrl: string, host: string | null): string | null {
  const url = new URL(requestUrl);
  // Prefer the public Host: an adapter's internal request URL may be workers.dev.
  const hostname = (host ?? url.host).split(":")[0].toLowerCase();
  if (!hostname.endsWith(".workers.dev")) return null;
  const canonical = new URL("/auth/callback", AUTH_SITE_ORIGIN);
  canonical.search = url.search;
  return canonical.toString();
}
