"use client";

import type { SupabaseClient } from '@supabase/supabase-js';

// Planner calls run through the application's origin. The server uses the
// existing session cookie and public Supabase key, never a privileged client.
// Only rpc() and auth.getUser() are implemented; this is not a general client.
export function createPlannerClient(): SupabaseClient {
  async function call(operation: Record<string, unknown>) {
    try {
      const response = await fetch('/api/planner', {
        method: 'POST', credentials: 'same-origin', cache: 'no-store',
        headers: {'Content-Type': 'application/json'}, body: JSON.stringify(operation),
      });
      if (!response.ok) return {data: null, error: {code: 'PLANNER_CONNECTION', message: 'Planner request failed'}};
      const result: unknown = await response.json();
      if (!result || typeof result !== 'object' || !('data' in result) || !('error' in result)) throw new Error('Invalid response');
      return result as {data: unknown; error: {code?: string; message: string} | null};
    } catch {
      return {data: null, error: {code: 'PLANNER_CONNECTION', message: 'Planner request failed'}};
    }
  }
  return {
    rpc: (name: string, args?: Record<string, unknown>) => call({name, args: args ?? {}}),
    auth: {getUser: async () => {
      const result = await call({name: 'current_user'});
      return {data: {user: result.data}, error: result.error};
    }},
  } as unknown as SupabaseClient;
}
