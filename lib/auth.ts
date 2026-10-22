import { redirect } from "next/navigation";
import { cache } from "react";
import { getRequestUser } from "@/lib/supabase/request-auth";
export type AppRole = "student" | "counselor" | "exam_designer" | "admin" | "content_manager";
export type CurrentProfile = {
  id: string;
  full_name: string;
  role: AppRole;
  grade: number | null;
  phone: string | null;
  registration_status: "incomplete"|"pending"|"active";
  study_field:
    | "mathematics"
    | "experimental_sciences"
    | "humanities"
    | "arts"
    | "foreign_languages"
    | null;
};
// Memoize data, not authorization decisions. Every caller's allowed roles and
// registration requirements are still checked separately, including actions.
const getRequestProfile = cache(async () => {
  const { supabase, user } = await getRequestUser();
  if (!user) redirect("/auth/sign-in");
  const started = performance.now();
  const { data } = await supabase
    .from("profiles")
    .select("id,full_name,role,grade,phone,study_field,registration_status")
    .eq("id", user.id)
    .single();
  if (process.env.AUTH_PERF_LOG === "1") {
    console.info(JSON.stringify({ event: "auth_timing", operation: "profile", ms: Math.round(performance.now() - started) }));
  }
  if (!data) redirect("/auth/sign-in");
  return { supabase, user, profile: data as CurrentProfile };
});

export async function requireProfile(allowed?: AppRole[], allowInactive = false) {
  const { supabase, user, profile } = await getRequestProfile();
  if (profile.role === "student" && !user.email_confirmed_at) redirect("/auth?mode=signin&error=unconfirmed");
  if (allowed && !allowed.includes(profile.role)) redirect("/dashboard");
  if(profile.role === "student" && profile.registration_status !== "active" && !allowInactive) redirect("/dashboard/registration");
  return { supabase, user, profile };
}
