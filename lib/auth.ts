import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
export type AppRole = "student" | "counselor" | "admin";
export type CurrentProfile = {
  id: string;
  full_name: string;
  role: AppRole;
  grade: number | null;
  phone: string | null;
};
export async function requireProfile(allowed?: AppRole[]) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/auth/sign-in");
  const { data } = await supabase
    .from("profiles")
    .select("id,full_name,role,grade,phone")
    .eq("id", user.id)
    .single();
  if (!data) redirect("/auth/sign-in");
  const profile = data as CurrentProfile;
  if (allowed && !allowed.includes(profile.role)) redirect("/dashboard");
  return { supabase, user, profile };
}
