import { cache } from "react";
import { createClient } from "@/lib/supabase/server";

/** React request memoization only: never persist users in a process/global cache. */
export const getRequestUser = cache(async () => {
  const supabase = await createClient();
  const started = performance.now();
  const { data: { user } } = await supabase.auth.getUser();
  if (process.env.AUTH_PERF_LOG === "1") {
    // Operational timings only; no identities, cookies, passwords or tokens.
    console.info(JSON.stringify({ event: "auth_timing", operation: "getUser", ms: Math.round(performance.now() - started) }));
  }
  return { supabase, user };
});
