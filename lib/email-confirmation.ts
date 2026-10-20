// Restrict interpolation into the confirmation form to URL-safe token hashes.
export function validConfirmationHash(value: unknown): value is string {
  return typeof value === "string" && value === value.trim() && /^[A-Za-z0-9_-]{20,256}$/.test(value);
}

export const confirmationHeaders = {
  "Cache-Control": "no-store, max-age=0",
  "Referrer-Policy": "no-referrer",
  "X-Robots-Tag": "noindex, nofollow",
  "Content-Security-Policy": "default-src 'none'; form-action https://nova-academy.ir; frame-ancestors 'none'; base-uri 'none'",
};
