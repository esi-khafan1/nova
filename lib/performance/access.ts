import { cookies } from "next/headers";
import { cache } from "react";
import type {SupabaseClient} from "@supabase/supabase-js";
export const performanceEnabled=cache(async(supabase:SupabaseClient)=>{
 if((await cookies()).get("nova-perf")?.value!=="1")return false;
 const {data,error}=await supabase.rpc("performance_debug_enabled");
 return !error&&data===true;
});
