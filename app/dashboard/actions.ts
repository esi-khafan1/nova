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
export async function changeUserRole(fd: FormData) {
  const s = await createClient();
  const {
    data: { user },
  } = await s.auth.getUser();
  if (!user) redirect("/auth");

  const user_id = clean(fd.get("user_id"), 50);
  const target_role = clean(fd.get("target_role"), 20);
  if (
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      user_id,
    ) ||
    !["student", "counselor"].includes(target_role)
  )
    redirect("/dashboard/admin/users?error=role");

  const { error } = await s.rpc("admin_set_user_role", {
    target_user_id: user_id,
    target_role,
  });
  if (error) redirect("/dashboard/admin/users?error=role");

  revalidatePath("/dashboard/admin");
  revalidatePath("/dashboard/admin/users");
  redirect("/dashboard/admin/users?updated=1");
}
