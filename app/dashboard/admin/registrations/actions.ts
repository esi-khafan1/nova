"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { receiptImageType } from "@/lib/registration";

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

  // The database chooses the receipt/manual route from its locked registration
  // row. The expected path only detects a new/replaced receipt since page load.
  const expectedReceiptPath = fd.get("expected_receipt_path");
  if (typeof expectedReceiptPath !== "string" || expectedReceiptPath.length > 1000) {
    redirect("/dashboard/admin/registrations?error=1");
  }
  const { error } = await supabase.rpc("admin_activate_student_auto", {
    target_student_id: studentId,
    target_counselor_id: counselorId,
    expected_receipt_path: expectedReceiptPath || null,
  });
  if (error) redirect("/dashboard/admin/registrations?error=1");

  revalidateRegistrationPaths();
  redirect("/dashboard/admin/registrations?saved=1");
}

export async function uploadStudentReceipt(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = String(fd.get("student_id") ?? "");
  const expected = fd.get("expected_receipt_path");
  const file = fd.get("receipt");
  if (!uuidPattern.test(studentId) || typeof expected !== "string" || expected.length > 1000 ||
      !(file instanceof File) || !file.size || file.size > 5 * 1024 * 1024) {
    redirect("/dashboard/admin/registrations?error=upload");
  }
  const bytes = new Uint8Array(await file.arrayBuffer());
  const type = receiptImageType(bytes);
  if (!type) redirect("/dashboard/admin/registrations?error=upload");

  const path = `${studentId}/${crypto.randomUUID()}.${type.extension}`;
  // The bucket is private; RLS allows an admin to write only to an inactive
  // student's folder. The DB function checks the exact target and stale path.
  const bucket = supabase.storage.from("registration-receipts");
  const { error: uploadError } = await bucket.upload(path, bytes, { contentType: type.mime, upsert: false });
  if (uploadError) redirect("/dashboard/admin/registrations?error=upload");

  const name = (file.name.split(/[\\/]/).pop() ?? "").replace(/[\u0000-\u001f\u007f]/g, "").slice(0, 150) || `receipt.${type.extension}`;
  const { error } = await supabase.rpc("admin_submit_student_receipt", {
    target_student_id: studentId,
    expected_receipt_path: expected || null,
    new_receipt_path: path,
    new_receipt_name: name,
  });
  if (error) {
    await bucket.remove([path]);
    redirect("/dashboard/admin/registrations?error=upload");
  }
  // Old files are never deleted before the new receipt is recorded. If
  // cleanup fails, the old object stays private and is no longer linked.
  if (expected) await bucket.remove([expected]);
  revalidateRegistrationPaths();
  redirect("/dashboard/admin/registrations?uploaded=1");
}

export async function disableStudent(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = fd.get("student_id");
  const expected = fd.get("expected_counselor_id");
  if (typeof studentId !== "string" || !uuidPattern.test(studentId) ||
      typeof expected !== "string" || (expected !== "" && !uuidPattern.test(expected))) {
    redirect("/dashboard/admin/registrations?error=disable");
  }
  const { error } = await supabase.rpc("admin_disable_student", {
    target_student_id: studentId,
    expected_counselor_id: expected || null,
  });
  if (error) redirect("/dashboard/admin/registrations?error=disable");
  revalidateRegistrationPaths();
  redirect("/dashboard/admin/registrations?disabled=1");
}

export async function resumeStudent(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = fd.get("student_id");
  const counselorId = fd.get("counselor_id");
  if (typeof studentId !== "string" || !uuidPattern.test(studentId) ||
      typeof counselorId !== "string" || !uuidPattern.test(counselorId)) {
    redirect("/dashboard/admin/registrations?error=resume");
  }
  const { error } = await supabase.rpc("admin_resume_student", {
    target_student_id: studentId,
    target_counselor_id: counselorId,
  });
  if (error) redirect("/dashboard/admin/registrations?error=resume");
  revalidateRegistrationPaths();
  redirect("/dashboard/admin/registrations?resumed=1");
}

export async function changeStudentCounselor(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = fd.get("student_id");
  const oldCounselorId = fd.get("expected_counselor_id");
  const newCounselorId = fd.get("counselor_id");
  if (typeof studentId !== "string" || !uuidPattern.test(studentId) ||
      typeof oldCounselorId !== "string" || !uuidPattern.test(oldCounselorId) ||
      typeof newCounselorId !== "string" || !uuidPattern.test(newCounselorId) ||
      oldCounselorId === newCounselorId) {
    redirect("/dashboard/admin/registrations?error=reassign");
  }
  const { error } = await supabase.rpc("admin_change_student_counselor", {
    target_student_id: studentId,
    expected_counselor_id: oldCounselorId,
    target_counselor_id: newCounselorId,
  });
  if (error) redirect("/dashboard/admin/registrations?error=reassign");
  revalidateRegistrationPaths();
  redirect("/dashboard/admin/registrations?reassigned=1");
}
