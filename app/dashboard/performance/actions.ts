"use server";
import {cookies} from "next/headers";
import {redirect} from "next/navigation";
import {requireProfile} from "@/lib/auth";
export async function togglePerformance(form:FormData){
 const {supabase}=await requireProfile(["admin","content_manager"]);
 const enable=form.get("enabled")==="1";
 if(enable){const {data,error}=await supabase.rpc("performance_debug_enabled");if(error||data!==true)redirect("/dashboard/performance?error=access");}
 const jar=await cookies();
 if(enable)jar.set("nova-perf","1",{httpOnly:true,secure:process.env.NODE_ENV==="production",sameSite:"lax",path:"/dashboard",maxAge:3600});
 else jar.set("nova-perf","",{path:"/dashboard",maxAge:0,httpOnly:true,secure:process.env.NODE_ENV==="production",sameSite:"lax"});
 redirect("/dashboard/performance");
}
export async function grantPerformance(form:FormData){
 const {supabase}=await requireProfile(["admin"]);
 const id=String(form.get("user_id")??"");
 if(!/^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i.test(id))redirect("/dashboard/performance?error=invalid");
 const {error}=await supabase.rpc("set_performance_debug_access",{target_user_id:id,enabled:form.get("enabled")==="1"});
 redirect(`/dashboard/performance?${error?"error=access":"saved=1"}`);
}
