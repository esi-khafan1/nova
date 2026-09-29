"use server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
const clean = (v: FormDataEntryValue | null, max = 500) =>
  String(v ?? "")
    .trim()
    .slice(0, max);
export async function signOut() {
  const s = await createClient();
  await s.auth.signOut();
  redirect("/");
}
export async function updateStudentProfile(fd: FormData) {
  const s = await createClient();
  const {
    data: { user },
  } = await s.auth.getUser();
  if (!user) redirect("/auth/sign-in");
  const full_name = clean(fd.get("full_name"), 100),
    phone = clean(fd.get("phone"), 20) || null,
    n = Number(fd.get("grade")),
    grade = [10, 11, 12].includes(n) ? n : null;
  if (full_name.length < 2) redirect("/dashboard/student?error=profile");
  const { error } = await s
    .from("profiles")
    .update({ full_name, phone, grade })
    .eq("id", user.id);
  if (error) redirect("/dashboard/student?error=profile");
  revalidatePath("/dashboard");
  redirect("/dashboard/student?saved=profile");
}
export async function applyForCounselor(fd: FormData) {
  const s = await createClient();
  const {
    data: { user },
  } = await s.auth.getUser();
  if (!user) redirect("/auth/sign-in");
  const headline = clean(fd.get("headline"), 160),
    specialty = clean(fd.get("specialty"), 160),
    experience_years = Math.max(
      0,
      Math.min(50, Number(fd.get("experience_years")) || 0),
    );
  if (headline.length < 5 || specialty.length < 3)
    redirect("/dashboard/apply-counselor?error=application");
  const { error } = await s
    .from("counselor_profiles")
    .upsert(
      {
        user_id: user.id,
        headline,
        specialty,
        experience_years,
        is_accepting: false,
      },
      { onConflict: "user_id" },
    );
  if (error) redirect("/dashboard/apply-counselor?error=application");
  revalidatePath("/dashboard");
  redirect("/dashboard/apply-counselor?sent=1");
}
export async function reviewCounselor(fd: FormData) {
  const s = await createClient(),
    user_id = clean(fd.get("user_id"), 50),
    decision = clean(fd.get("decision"), 20);
  if (!user_id || !["approved", "rejected"].includes(decision))
    redirect("/dashboard/admin?error=review");
  const { error } = await s
    .from("counselor_profiles")
    .update({ approval_status: decision })
    .eq("user_id", user_id);
  if (error) redirect("/dashboard/admin?error=review");
  revalidatePath("/dashboard/admin");
  redirect("/dashboard/admin?reviewed=1");
}
