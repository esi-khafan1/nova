"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { parseExamStartWindow } from "@/lib/floating-exams";
import { requireProfile } from "@/lib/auth";

const uuidPattern = /^[0-9a-f-]{36}$/i;

function backToHistory(formData: FormData, result: string): never {
  const studentId = String(formData.get("student_id") ?? "");
  const pageValue = Number(formData.get("page"));
  const page = Number.isSafeInteger(pageValue) && pageValue >= 1 && pageValue <= 2000 ? pageValue : 1;
  const params = new URLSearchParams({ student: studentId, page: String(page), extension: result });
  redirect(`/dashboard/counselor/exams?${params.toString()}`);
}

export async function setExamExtension(formData: FormData) {
  const { supabase } = await requireProfile(["counselor"]);
  const examId = String(formData.get("exam_id") ?? "");
  const studentId = String(formData.get("student_id") ?? "");
  const date = String(formData.get("extension_date") ?? "");
  const startTime = String(formData.get("extension_start_time") ?? "");
  const endTime = String(formData.get("extension_end_time") ?? "");
  const window = parseExamStartWindow(date, startTime, endTime);
  if (!uuidPattern.test(examId) || !uuidPattern.test(studentId) || !window) {
    backToHistory(formData, "error");
  }
  const { error } = await supabase.rpc("counselor_set_exam_extension", {
    target_exam_id: examId,
    target_student_id: studentId,
    target_starts_at: window.start.toISOString(),
    target_ends_at: window.end.toISOString(),
  });
  if (error) backToHistory(formData, "error");
  revalidatePath("/dashboard/counselor/exams");
  revalidatePath("/dashboard/student");
  revalidatePath("/dashboard/student/exams");
  revalidatePath(`/dashboard/student/exams/${examId}`);
  backToHistory(formData, "saved");
}

export async function cancelExamExtension(formData: FormData) {
  const { supabase } = await requireProfile(["counselor"]);
  const examId = String(formData.get("exam_id") ?? "");
  const studentId = String(formData.get("student_id") ?? "");
  if (!uuidPattern.test(examId) || !uuidPattern.test(studentId)) {
    backToHistory(formData, "error");
  }
  const { error } = await supabase.rpc("counselor_cancel_exam_extension", {
    target_exam_id: examId,
    target_student_id: studentId,
  });
  if (error) backToHistory(formData, "error");
  revalidatePath("/dashboard/counselor/exams");
  revalidatePath("/dashboard/student");
  revalidatePath("/dashboard/student/exams");
  revalidatePath(`/dashboard/student/exams/${examId}`);
  backToHistory(formData, "canceled");
}
