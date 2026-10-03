"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const clean = (value: FormDataEntryValue | null, max = 500) =>
  String(value ?? "").trim().slice(0, max);

export async function saveExam(formData: FormData) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/auth/sign-in");

  const examId = clean(formData.get("exam_id"), 50);
  const title = clean(formData.get("title"), 160);
  const description = clean(formData.get("description"), 3000);
  const mode = clean(formData.get("mode"), 30);
  const audience = clean(formData.get("audience"), 40);
  const status = clean(formData.get("status"), 20);
  const questionPdfUrl = clean(formData.get("question_pdf_url"), 2000) || null;
  const rawQuestions = clean(formData.get("questions"), 200_000);

  if (
    (examId && !uuidPattern.test(examId)) ||
    title.length < 3 ||
    !["multiple_choice", "pdf"].includes(mode) ||
    !["own_students", "all_assigned_students"].includes(audience) ||
    !["draft", "published"].includes(status)
  ) redirect("/dashboard/counselor/exams?error=exam");

  let questions: unknown[] = [];
  try {
    questions = JSON.parse(rawQuestions || "[]");
    if (!Array.isArray(questions)) throw new Error("invalid");
  } catch {
    redirect("/dashboard/counselor/exams?error=questions");
  }

  const { data, error } = await supabase.rpc("save_exam", {
    target_exam_id: examId || null,
    target_title: title,
    target_description: description,
    target_mode: mode,
    target_audience: audience,
    target_question_pdf_url: questionPdfUrl,
    target_status: status,
    target_questions: questions,
  });

  if (error || !data) redirect("/dashboard/counselor/exams?error=exam");
  revalidatePath("/dashboard/counselor");
  revalidatePath("/dashboard/counselor/exams");
  revalidatePath("/dashboard/student/exams");
  redirect(`/dashboard/counselor/exams?saved=${status}`);
}

export async function submitExam(formData: FormData) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/auth/sign-in");

  const examId = clean(formData.get("exam_id"), 50);
  const mode = clean(formData.get("mode"), 30);
  if (!uuidPattern.test(examId)) redirect("/dashboard/student/exams?error=exam");

  if (mode === "pdf") {
    const answerPdfUrl = clean(formData.get("answer_pdf_url"), 2000);
    const { error } = await supabase.rpc("submit_pdf_exam", {
      target_exam_id: examId,
      target_answer_pdf_url: answerPdfUrl,
    });
    if (error) redirect(`/dashboard/student/exams/${examId}?error=submit`);
  } else if (mode === "multiple_choice") {
    const answers: Record<string, number> = {};
    for (const [key, value] of formData.entries()) {
      if (!key.startsWith("answer_") || !uuidPattern.test(key.slice(7))) continue;
      const selected = Number(value);
      if (Number.isInteger(selected) && selected >= 0 && selected <= 5) {
        answers[key.slice(7)] = selected;
      }
    }
    const { error } = await supabase.rpc("submit_multiple_choice_exam", {
      target_exam_id: examId,
      target_answers: answers,
    });
    if (error) redirect(`/dashboard/student/exams/${examId}?error=submit`);
  } else {
    redirect("/dashboard/student/exams?error=exam");
  }

  revalidatePath("/dashboard/student/exams");
  revalidatePath(`/dashboard/student/exams/${examId}`);
  revalidatePath(`/dashboard/counselor/exams/${examId}`);
  redirect(`/dashboard/student/exams/${examId}?submitted=1`);
}
