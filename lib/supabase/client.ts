import { createBrowserClient } from "@supabase/ssr";
import { parsePublicBrowserConfig, PUBLIC_SUPABASE_CONFIG_ID } from "./public-browser-config";
import { createPlannerClient } from "@/lib/planner-api-client";

export function createClient(options?: {planner?: boolean}) {
  if (options?.planner) return createPlannerClient();
  // Dashboard configuration is rendered from server runtime bindings. Public
  // variables baked into the browser bundle remain a fallback for other pages.
  const runtime = typeof document === 'undefined' ? null : parsePublicBrowserConfig(document.getElementById(PUBLIC_SUPABASE_CONFIG_ID)?.textContent);
  const url = runtime?.url ?? process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = runtime?.key ?? (process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ?? process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
  if (!url || !key) throw new Error("متغیرهای محیطی Supabase تنظیم نشده‌اند.");
  return createBrowserClient(url, key, { realtime: { reconnectAfterMs: tries => Math.min(30000,1000 * 2 ** Math.min(tries,5)) + Math.random()*2000 } });
}
