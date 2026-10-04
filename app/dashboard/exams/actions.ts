"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const clean = (value: FormDataEntryValue | null, max = 500) =>
  String(value ?? "").trim().slice(0, max);

type RawBooklet = {
  title?: string;
  pdfUrl?: string;
  questionCount?: number;
  durationMinutes?: number;
  keyAnswers?: Record<string, number>;
};

export async function saveExam(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/auth/sign-in");

  const examId = clean(formData.get("exam_id"), 50);
  const title = clean(formData.get("title"), 160);
  const description = clean(formData.get("description"), 3000);
  const audience = clean(formData.get("audience"), 40);
  const status = clean(formData.get("status"), 20);
  const scheduledDate = clean(formData.get("scheduled_date"), 10);
  const scheduledTime = clean(formData.get("scheduled_time"), 5);
  const rawBooklets = clean(formData.get("booklets"), 500_000);
  const startsAt = new Date(`${scheduledDate}T${scheduledTime}:00+03:30`);

  if (
    (examId && !uuidPattern.test(examId)) ||
    title.length < 3 ||
    !["own_students", "all_assigned_students"].includes(audience) ||
    !["draft", "published"].includes(status) ||
    Number.isNaN(startsAt.getTime()) ||
    startsAt.getTime() <= Date.now() + 60_000
  ) {
    redirect("/dashboard/counselor/exams?error=exam");
  }

  let booklets: RawBooklet[] = [];
  try {
    booklets = JSON.parse(rawBooklets || "[]");
    if (!Array.isArray(booklets) || booklets.length === 0) {
      throw new Error("invalid");
    }
  } catch {
    redirect("/dashboard/counselor/exams?error=booklets");
  }

  // Validate booklets
  for (let i = 0; i < booklets.length; i++) {
    const b = booklets[i];
    const qCount = Number(b.questionCount);
    const duration = Number(b.durationMinutes);
    if (!qCount || qCount < 1 || qCount > 200 || !duration || duration < 1 || duration > 360) {
      redirect("/dashboard/counselor/exams?error=booklet_params");
    }
    if (status === "published" && (!b.pdfUrl || !b.pdfUrl.startsWith("https://"))) {
      redirect("/dashboard/counselor/exams?error=booklet_pdf");
    }
  }

  const { data, error } = await supabase.rpc("save_exam", {
    target_exam_id: examId || null,
    target_title: title,
    target_description: description || null,
    target_audience: audience,
    target_starts_at: startsAt.toISOString(),
    target_status: status,
    target_booklets: booklets,
  });

  if (error || !data) {
    redirect("/dashboard/counselor/exams?error=exam");
  }

  revalidatePath("/dashboard/counselor");
  revalidatePath("/dashboard/counselor/exams");
  revalidatePath("/dashboard/student/exams");
  redirect(`/dashboard/counselor/exams?saved=${status}`);
}

export async function submitExam(formData: FormData) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/auth/sign-in");

  const examId = clean(formData.get("exam_id"), 50);
  if (!uuidPattern.test(examId)) redirect("/dashboard/student/exams?error=exam");

  const answers: Record<string, number> = {};
  const rawAnswers = clean(formData.get("answers"), 500_000);

  if (rawAnswers) {
    try {
      const parsed = JSON.parse(rawAnswers);
      if (typeof parsed === "object" && parsed !== null) {
        for (const [k, v] of Object.entries(parsed)) {
          const opt = Number(v);
          if (Number.isInteger(opt) && opt >= 1 && opt <= 4) {
            answers[k] = opt;
          }
        }
      }
    } catch {
      redirect(`/dashboard/student/exams/${examId}?error=submit`);
    }
  } else {
    // Fallback: parse form entries
    for (const [key, value] of formData.entries()) {
      if (!key.startsWith("q_")) continue;
      const qNum = key.slice(2);
      const selected = Number(value);
      if (Number.isInteger(selected) && selected >= 1 && selected <= 4) {
        answers[qNum] = selected;
      }
    }
  }

  const { error } = await supabase.rpc("submit_booklet_exam", {
    target_exam_id: examId,
    target_answers: answers,
  });

  if (error) {
    redirect(`/dashboard/student/exams/${examId}?error=submit`);
  }

  revalidatePath("/dashboard/student/exams");
  revalidatePath(`/dashboard/student/exams/${examId}`);
  revalidatePath(`/dashboard/counselor/exams/${examId}`);
  redirect(`/dashboard/student/exams/${examId}?submitted=1`);
}

