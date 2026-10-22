"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";

const uuidPattern = /^[0-9a-f-]{36}$/i;
const revalidateRegistrationPaths = () => {
  for (const path of [
    "/dashboard/admin/registrations",
    "/dashboard/counselor",
    "/dashboard/counselor/students",
    "/dashboard/counselor/plans",
    "/dashboard/student",
    "/dashboard/student/account",
    "/dashboard/student/exams",
    "/dashboard/registration",
  ]) {
    revalidatePath(path);
  }
};

export async function assignCounselor(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = String(fd.get("student_id") ?? "");
  const counselorId = String(fd.get("counselor_id") ?? "");

  if (!uuidPattern.test(studentId) || !uuidPattern.test(counselorId)) {
    redirect("/dashboard/admin/registrations?error=assignment");
  }

  const { data: existing, error: lookupError } = await supabase
    .from("counselor_students")
    .select("counselor_id")
    .eq("student_id", studentId)
    .limit(1);
  if (lookupError || existing?.length) {
    redirect("/dashboard/admin/registrations?error=assignment");
  }

  const { error } = await supabase.rpc("admin_assign_student_counselor", {
    target_student_id: studentId,
    target_counselor_id: counselorId,
  });
  if (error) redirect("/dashboard/admin/registrations?error=assignment");

  revalidateRegistrationPaths();
  redirect("/dashboard/admin/registrations?assigned=1");
}

export async function activateStudent(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = String(fd.get("student_id") ?? "");
  const counselorId = String(fd.get("counselor_id") ?? "");

  if (!uuidPattern.test(studentId) || !uuidPattern.test(counselorId)) {
    redirect("/dashboard/admin/registrations?error=1");
  }

  const manual = fd.get("activation_mode") === "manual";
  if (manual && fd.get("manual_confirmation") !== "on") {
    redirect("/dashboard/admin/registrations?error=1");
  }
  if (!manual && fd.get("receipt_confirmation") !== "on") {
    redirect("/dashboard/admin/registrations?error=1");
  }

  const { error } = manual
    ? await supabase.rpc("admin_activate_student_without_receipt", {
        target_student_id: studentId,
        target_counselor_id: counselorId,
      })
    : await supabase.rpc("admin_activate_student", {
        target_student_id: studentId,
        target_counselor_id: counselorId,
        expected_receipt_path: String(fd.get("receipt_path") ?? "") || null,
      });
  if (error) redirect("/dashboard/admin/registrations?error=1");

  revalidateRegistrationPaths();
  redirect("/dashboard/admin/registrations?saved=1");
}
