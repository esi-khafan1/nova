import { createClient } from "npm:@supabase/supabase-js@2";
import { makeStudentAccountBlockHandler, makeAuthBanSetter } from "./handler.mjs";

const url = Deno.env.get("SUPABASE_URL")!;
const anon = Deno.env.get("SUPABASE_ANON_KEY")!;
const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const authClient = (authorization: string) => createClient(url, anon, {
  global: { headers: { Authorization: authorization } },
  auth: { persistSession: false, autoRefreshToken: false },
});
const admin = createClient(url, service, { auth: { persistSession: false, autoRefreshToken: false } });
Deno.serve(makeStudentAccountBlockHandler({
  randomUUID: () => crypto.randomUUID(),
  verifyUser: async (authorization: string) => {
    const {data, error} = await authClient(authorization).auth.getUser();
    return error ? null : data.user;
  },
  begin: async (authorization: string, target: string, blocked: boolean, operation: string) => {
    const {data, error} = await authClient(authorization).rpc("begin_student_account_block", {target, should_block: blocked, operation});
    if (error) throw error;
    return data;
  },
  setAuthBan: makeAuthBanSetter(admin),
  finish: async (operation: string, succeeded: boolean, authUntil: string | null) => {
    const {error} = await admin.rpc("finish_student_account_block", {operation, succeeded, auth_until: authUntil});
    if (error) throw error;
  },
}));
