"use server";

import { revalidatePath } from "next/cache";
import { requireProfile } from "@/lib/auth";
import { studyFieldLabels } from "@/lib/study-catalog";

export async function updateCounselorStudentStudy(data: FormData) {
  const { supabase } = await requireProfile(["counselor"]);
  const studentId = String(data.get("student_id") ?? "");
  const grade = Number(data.get("grade"));
  const field = String(data.get("study_field") ?? "");
  if (!/^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i.test(studentId) ||
      ![10, 11, 12].includes(grade) || !Object.hasOwn(studyFieldLabels, field)) {
    return { error: "پایه و رشتهٔ معتبر انتخاب کن." };
  }
  const { error } = await supabase.rpc("counselor_update_student_study", {
    target_student_id: studentId, target_grade: grade, target_study_field: field,
  });
  if (error) return { error: "ذخیره انجام نشد؛ دسترسی به دانش‌آموز و اطلاعات انتخاب‌شده را بررسی و دوباره تلاش کن." };
  revalidatePath("/dashboard", "layout");
  return { success: true };
}
