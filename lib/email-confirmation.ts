// Restrict interpolation into the confirmation form to URL-safe token hashes.
export function validConfirmationHash(value: unknown): value is string {
  return typeof value === "string" && value === value.trim() && /^[A-Za-z0-9_-]{20,256}$/.test(value);
}

export const confirmationHeaders = {
  "Cache-Control": "no-store, max-age=0",
  "Referrer-Policy": "same-origin",
  "X-Robots-Tag": "noindex, nofollow",
  "Content-Security-Policy": "default-src 'none'; style-src 'unsafe-inline'; font-src 'self'; form-action https://nova-academy.ir; frame-ancestors 'none'; base-uri 'none'",
};

/** Null/omitted Origin is accepted only with browser-provided same-origin evidence. */
export function trustedConfirmationPost(headers: Headers, canonicalOrigin: string): boolean {
  const origin = headers.get("origin");
  if (origin === canonicalOrigin) return headers.get("sec-fetch-site") !== "cross-site";
  return (!origin || origin === "null") && headers.get("sec-fetch-site") === "same-origin";
}
