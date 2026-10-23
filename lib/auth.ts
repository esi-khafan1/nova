import { redirect } from "next/navigation";
import { cache } from "react";
import { getRequestClient, getRequestUser } from "@/lib/supabase/request-auth";
export type AppRole = "student" | "counselor" | "exam_designer" | "admin" | "content_manager" | "support_agent";
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
const getOwnProfile = cache(async () => {
  const supabase = await getRequestClient();
  const started = performance.now();
  const { data } = await supabase.rpc("own_dashboard_profile").maybeSingle();
  if (process.env.AUTH_PERF_LOG === "1") {
    console.info(JSON.stringify({ event: "auth_timing", operation: "profile", ms: Math.round(performance.now() - started) }));
  }
  return { supabase, profile: data as CurrentProfile | null };
});
const getRequestProfile = cache(async () => {
  // The own-row RPC derives auth.uid() inside PostgreSQL, so it can start
  // alongside getUser. Never authorize until fresh getUser has also succeeded.
  const [{ user }, { supabase, profile }] = await Promise.all([
    getRequestUser(), getOwnProfile(),
  ]);
  if (!user || !profile || profile.id !== user.id) redirect("/auth/sign-in");
  return { supabase, user, profile };
});

// Routing hint only: this endpoint returns a destination, not protected data.
// Every destination page/action still performs full requireProfile/getUser checks.
export async function getDashboardDestination() {
  const { profile } = await getOwnProfile();
  if (!profile || !["student","counselor","exam_designer","admin","content_manager","support_agent"].includes(profile.role)) return "/auth/sign-in";
  return `/dashboard/${profile.role}`;
}

export async function requireProfile(allowed?: AppRole[], allowInactive = false) {
  const { supabase, user, profile } = await getRequestProfile();
  if (profile.role === "student" && !user.email_confirmed_at) redirect("/auth?mode=signin&error=unconfirmed");
  if (allowed && !allowed.includes(profile.role)) redirect("/dashboard");
  if(profile.role === "student" && profile.registration_status !== "active" && !allowInactive) redirect("/dashboard/registration");
  return { supabase, user, profile };
}
