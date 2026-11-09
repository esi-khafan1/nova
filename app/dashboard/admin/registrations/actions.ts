"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { provinces, receiptImageType } from "@/lib/registration";
import { parseRegistrationPage } from "@/lib/registration-pagination";
import { parseAdminFinalCourse } from "@/lib/admin-final-course";

function directoryRedirect(fd: FormData, result: string): never {
  const params = new URLSearchParams(result);
  const search = fd.get("directory_search");
  const province = fd.get("directory_province");
  const review = fd.get("directory_review");
  const page = fd.get("directory_page");
  if (typeof search === "string" && search.trim()) params.set("q", search.trim().slice(0, 120));
  if (typeof province === "string" && provinces.includes(province)) params.set("province", province);
  if (review === "continuation") params.set("review", "continuation");
  if (typeof page === "string" && parseRegistrationPage(page) > 1) params.set("page", String(parseRegistrationPage(page)));
  redirect(`/dashboard/admin/registrations?${params}`);
}

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
    directoryRedirect(fd, "error=assignment");
  }

  const { data: existing, error: lookupError } = await supabase
    .from("counselor_students")
    .select("counselor_id")
    .eq("student_id", studentId)
    .limit(1);
  if (lookupError || existing?.length) {
    directoryRedirect(fd, "error=assignment");
  }

  const { error } = await supabase.rpc("admin_assign_student_counselor", {
    target_student_id: studentId,
    target_counselor_id: counselorId,
  });
  if (error) directoryRedirect(fd, "error=assignment");

  revalidateRegistrationPaths();
  directoryRedirect(fd, "assigned=1");
}

export async function activateStudent(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = String(fd.get("student_id") ?? "");
  const counselorId = String(fd.get("counselor_id") ?? "");

  if (!uuidPattern.test(studentId) || !uuidPattern.test(counselorId)) {
    directoryRedirect(fd, "error=1");
  }

  const finalCourse = parseAdminFinalCourse(fd);
  if (!finalCourse) directoryRedirect(fd, "error=course");

  // The database chooses the receipt/manual route from its locked registration
  // row. The expected path only detects a new/replaced receipt since page load.
  const expectedReceiptPath = fd.get("expected_receipt_path");
  if (typeof expectedReceiptPath !== "string" || expectedReceiptPath.length > 1000) {
    directoryRedirect(fd, "error=1");
  }
  const { error } = await supabase.rpc("admin_activate_student_with_course", {
    target_student_id: studentId,
    target_counselor_id: counselorId,
    expected_receipt_path: expectedReceiptPath || null,
    target_course_type: finalCourse.course,
    target_course_duration_months: finalCourse.months,
  });
  if (error) directoryRedirect(fd, "error=1");

  revalidateRegistrationPaths();
  directoryRedirect(fd, "saved=1");
}

export async function uploadStudentReceipt(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = String(fd.get("student_id") ?? "");
  const expected = fd.get("expected_receipt_path");
  const file = fd.get("receipt");
  if (!uuidPattern.test(studentId) || typeof expected !== "string" || expected.length > 1000 ||
      !(file instanceof File) || !file.size || file.size > 5 * 1024 * 1024) {
    directoryRedirect(fd, "error=upload");
  }
  const bytes = new Uint8Array(await file.arrayBuffer());
  const type = receiptImageType(bytes);
  if (!type) directoryRedirect(fd, "error=upload");

  const path = `${studentId}/${crypto.randomUUID()}.${type.extension}`;
  // The bucket is private; RLS allows an admin to write only to an inactive
  // student's folder. The DB function checks the exact target and stale path.
  const bucket = supabase.storage.from("registration-receipts");
  const { error: uploadError } = await bucket.upload(path, bytes, { contentType: type.mime, upsert: false });
  if (uploadError) directoryRedirect(fd, "error=upload");

  const name = (file.name.split(/[\\/]/).pop() ?? "").replace(/[\u0000-\u001f\u007f]/g, "").slice(0, 150) || `receipt.${type.extension}`;
  const { error } = await supabase.rpc("admin_submit_student_receipt", {
    target_student_id: studentId,
    expected_receipt_path: expected || null,
    new_receipt_path: path,
    new_receipt_name: name,
  });
  if (error) {
    await bucket.remove([path]);
    directoryRedirect(fd, "error=upload");
  }
  // Old files are never deleted before the new receipt is recorded. If
  // cleanup fails, the old object stays private and is no longer linked.
  if (expected) await bucket.remove([expected]);
  revalidateRegistrationPaths();
  directoryRedirect(fd, "uploaded=1");
}

export async function disableStudent(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = fd.get("student_id");
  const expected = fd.get("expected_counselor_id");
  if (typeof studentId !== "string" || !uuidPattern.test(studentId) ||
      typeof expected !== "string" || (expected !== "" && !uuidPattern.test(expected))) {
    directoryRedirect(fd, "error=disable");
  }
  const { error } = await supabase.rpc("admin_disable_student", {
    target_student_id: studentId,
    expected_counselor_id: expected || null,
  });
  if (error) directoryRedirect(fd, "error=disable");
  revalidateRegistrationPaths();
  directoryRedirect(fd, "disabled=1");
}

export async function resumeStudent(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = fd.get("student_id");
  const counselorId = fd.get("counselor_id");
  if (typeof studentId !== "string" || !uuidPattern.test(studentId) ||
      typeof counselorId !== "string" || !uuidPattern.test(counselorId)) {
    directoryRedirect(fd, "error=resume");
  }
  const finalCourse = parseAdminFinalCourse(fd);
  if (!finalCourse) directoryRedirect(fd, "error=course");
  const { error } = await supabase.rpc("admin_resume_student_with_course", {
    target_student_id: studentId,
    target_counselor_id: counselorId,
    target_course_type: finalCourse.course,
    target_course_duration_months: finalCourse.months,
  });
  if (error) directoryRedirect(fd, "error=resume");
  revalidateRegistrationPaths();
  directoryRedirect(fd, "resumed=1");
}

export async function changeStudentCourse(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = fd.get("student_id");
  const expected = parseAdminFinalCourse(fd, "expected_");
  const selected = parseAdminFinalCourse(fd);
  if (typeof studentId !== "string" || !uuidPattern.test(studentId) || !expected || !selected ||
      (expected.course === selected.course && expected.months === selected.months)) {
    directoryRedirect(fd, "error=course-change");
  }
  const { error } = await supabase.rpc("admin_change_student_course", {
    target_student_id: studentId,
    expected_course_type: expected.course,
    expected_course_duration_months: expected.months,
    target_course_type: selected.course,
    target_course_duration_months: selected.months,
  });
  if (error) directoryRedirect(fd, "error=course-change");
  revalidateRegistrationPaths();
  directoryRedirect(fd, "course_changed=1");
}

export async function continueStudentPlanServiceReview(fd: FormData) {
  const { supabase } = await requireProfile(["admin"]);
  const studentId = fd.get("student_id");
  const planCount = Number(fd.get("expected_plan_count"));
  if (typeof studentId !== "string" || !uuidPattern.test(studentId) ||
      !Number.isInteger(planCount) || planCount < 4 || planCount % 4 !== 0) {
    directoryRedirect(fd, "review=continuation&error=plan-review");
  }
  const { error } = await supabase.rpc("admin_continue_student_plan_service_review", {
    target_student_id: studentId,
    expected_plan_count: planCount,
  });
  if (error) directoryRedirect(fd, "review=continuation&error=plan-review");
  revalidateRegistrationPaths();
  directoryRedirect(fd, "review=continuation&plan_review_continued=1");
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
    directoryRedirect(fd, "error=reassign");
  }
  const { error } = await supabase.rpc("admin_change_student_counselor", {
    target_student_id: studentId,
    expected_counselor_id: oldCounselorId,
    target_counselor_id: newCounselorId,
  });
  if (error) directoryRedirect(fd, "error=reassign");
  revalidateRegistrationPaths();
  directoryRedirect(fd, "reassigned=1");
}
