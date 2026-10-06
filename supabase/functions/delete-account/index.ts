import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

function corsHeaders(req: Request) {
  const origin = req.headers.get("origin") ?? "";
  const allowed =
    origin === "https://nova-academy.ir" ||
    /^https:\/\/[a-z0-9-]+-nova\.doob4347\.workers\.dev$/.test(origin);

  return {
    "Access-Control-Allow-Origin": allowed ? origin : "https://nova-academy.ir",
    "Access-Control-Allow-Headers":
      "authorization, x-client-info, apikey, content-type",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    Vary: "Origin",
  };
}

function json(req: Request, body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders(req), "Content-Type": "application/json" },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS")
    return new Response("ok", { headers: corsHeaders(req) });
  if (req.method !== "POST")
    return json(req, { error: "Method not allowed" }, 405);

  const auth = req.headers.get("Authorization");
  if (!auth) return json(req, { error: "Unauthorized" }, 401);

  try {
    const body = await req.json();
    if (body?.confirmation !== "DELETE_MY_ACCOUNT") {
      return json(req, { error: "Confirmation required" }, 400);
    }

    const url = Deno.env.get("SUPABASE_URL")!;
    const anon = Deno.env.get("SUPABASE_ANON_KEY")!;
    const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const userClient = createClient(url, anon, {
      global: { headers: { Authorization: auth } },
    });
    const {
      data: { user },
      error: userError,
    } = await userClient.auth.getUser();

    if (userError || !user) return json(req, { error: "Unauthorized" }, 401);

    const admin = createClient(url, service);
    const { data: profile, error: profileError } = await admin
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single();

    if (profileError || profile?.role !== "student") {
      return json(
        req,
        { error: "Only student accounts can be self-deleted" },
        403,
      );
    }

    const { error } = await admin.auth.admin.deleteUser(user.id);
    if (error) throw error;

    return json(req, { ok: true });
  } catch (error) {
    console.error(
      "delete-account failed",
      error instanceof Error ? error.message : "unknown",
    );
    return json(req, { error: "Deletion failed" }, 500);
  }
});
