/** Only application-local dashboard destinations are accepted. */
export function safeReturnPath(value: unknown, fallback = "/dashboard"): string {
  if (typeof value !== "string" || !value.startsWith("/") || value.startsWith("//") || /[\\\r\n]/.test(value)) return fallback;
  try {
    const parsed = new URL(value, "https://nova-academy.ir");
    if (parsed.origin !== "https://nova-academy.ir" || !(parsed.pathname === "/dashboard" || parsed.pathname.startsWith("/dashboard/"))) return fallback;
    return `${parsed.pathname}${parsed.search}${parsed.hash}`;
  } catch { return fallback; }
}
