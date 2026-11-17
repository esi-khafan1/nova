/** Only public Supabase credentials may be sent to the browser. */
export type PublicBrowserSupabaseConfig = { url: string; key: string };
export const PUBLIC_SUPABASE_CONFIG_ID = 'nova-supabase-public-config';

function isPublicKey(key: string): boolean {
  if (key.startsWith('sb_publishable_')) return true;
  // Legacy Supabase anon keys are JWTs. Never expose a service-role JWT or a
  // new sb_secret_ key, even if one was accidentally put in a public variable.
  const parts = key.split('.');
  if (parts.length !== 3) return false;
  try {
    const payload = parts[1].replace(/-/g, '+').replace(/_/g, '/');
    const decoded: unknown = JSON.parse(atob(payload));
    return typeof decoded === 'object' && decoded !== null && 'role' in decoded && decoded.role === 'anon';
  } catch {
    return false;
  }
}

export function getPublicBrowserConfig(env: Record<string, string | undefined>): PublicBrowserSupabaseConfig | null {
  const url = env.NEXT_PUBLIC_SUPABASE_URL?.trim();
  const key = (env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY || env.NEXT_PUBLIC_SUPABASE_ANON_KEY)?.trim();
  if (!url || !key || !isPublicKey(key)) return null;
  return { url, key };
}

export function serializePublicBrowserConfig(config: PublicBrowserSupabaseConfig | null): string {
  // A JSON script is inert, but a closing script tag must not escape its node.
  return JSON.stringify(config).replace(/</g, '\\u003c').replace(/\u2028/g, '\\u2028').replace(/\u2029/g, '\\u2029');
}

export function parsePublicBrowserConfig(value: string | null | undefined): PublicBrowserSupabaseConfig | null {
  if (!value) return null;
  try {
    const config: unknown = JSON.parse(value);
    if (!config || typeof config !== 'object' || !('url' in config) || !('key' in config)) return null;
    if (typeof config.url !== 'string' || typeof config.key !== 'string' || !config.url || !isPublicKey(config.key)) return null;
    return { url: config.url, key: config.key };
  } catch {
    return null;
  }
}
