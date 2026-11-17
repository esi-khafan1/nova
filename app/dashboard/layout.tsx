import { cookies } from 'next/headers';
import { getPublicBrowserConfig, PUBLIC_SUPABASE_CONFIG_ID, serializePublicBrowserConfig } from '@/lib/supabase/public-browser-config';

/** Dashboard pages are request-scoped. Read the public values at request time:
 * Cloudflare runtime bindings are not necessarily present during next build. */
export default async function DashboardLayout({ children }: { children: React.ReactNode }) {
  await cookies();
  const env = process.env;
  const config = getPublicBrowserConfig(env);
  return <><script id={PUBLIC_SUPABASE_CONFIG_ID} type="application/json" dangerouslySetInnerHTML={{ __html: serializePublicBrowserConfig(config) }} />{children}</>;
}
