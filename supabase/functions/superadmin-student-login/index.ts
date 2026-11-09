import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";
import { makeHandler } from "./handler.mjs";

Deno.serve(makeHandler({createClient,env:(name:string)=>Deno.env.get(name),fetch,crypto}));
