"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { parseExamStartWindow, floatingExamErrorCode, floatingExamErrorMessage, type FloatingExamSession } from "@/lib/floating-exams";
import { examSaveErrorCode } from "@/lib/exam-save-errors";
import { hasCompleteExamKeys } from "@/lib/exam-key-validation";
import { matchesKonkurTemplate } from "@/lib/konkur-presets";
import type { StudyField } from "@/lib/study-catalog";
import { requireProfile } from "@/lib/auth";

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
  const {supabase} = await requireProfile(["exam_designer"]);

  const examId = clean(formData.get("exam_id"), 50);
  const title = clean(formData.get("title"), 160);
  const description = clean(formData.get("description"), 3000);
  let studentIds: string[] = [];
  try { studentIds=JSON.parse(String(formData.get("student_ids") || "[]")); } catch { redirect("/dashboard/exam_designer?error=students"); }
  if (!Array.isArray(studentIds) || studentIds.some(id=>typeof id!=="string" || !uuidPattern.test(id))) redirect("/dashboard/exam_designer?error=students");
  const status = clean(formData.get("status"), 20);
  const scheduledDate = clean(formData.get("scheduled_date"), 10);
  const scheduledTime = clean(formData.get("scheduled_time"), 5);
  const rawBooklets = clean(formData.get("booklets"), 500_000);
  const examField = clean(formData.get("exam_field"), 40);
  const schedulingMode = clean(formData.get("scheduling_mode"),20) || "fixed";
  const window = schedulingMode === "floating" ? parseExamStartWindow(scheduledDate,scheduledTime,clean(formData.get("start_window_end_time"),5)) : null;
  const startsAt = new Date(`${scheduledDate}T${scheduledTime}:00+03:30`);

  if (
    (examId && !uuidPattern.test(examId)) ||
    title.length < 3 ||
    !["fixed","floating"].includes(schedulingMode) ||
    !["draft", "published"].includes(status) ||
    !["", "mathematics", "experimental_sciences", "humanities", "arts", "foreign_languages"].includes(examField) ||
    description.length > 3000
  ) redirect("/dashboard/exam_designer?error=metadata");

  if (Number.isNaN(startsAt.getTime()) || startsAt.getTime() <= Date.now() + 60_000)
    redirect("/dashboard/exam_designer?error=schedule");

  if (schedulingMode === "floating" && !window) redirect("/dashboard/exam_designer?error=window");

  let booklets: RawBooklet[] = [];
  try {
    booklets = JSON.parse(rawBooklets || "[]");
    if (!Array.isArray(booklets) || booklets.length === 0 || booklets.some(b => !b || typeof b !== "object" || Array.isArray(b))) throw new Error("invalid");
  } catch {
    redirect("/dashboard/exam_designer?error=booklets");
  }

  if (examField && !matchesKonkurTemplate(examField as StudyField,booklets)) redirect("/dashboard/exam_designer?error=template");
  if (status === "published" && studentIds.length === 0) redirect("/dashboard/exam_designer?error=students");
  let totalDuration = 0;
  for (const b of booklets) {
    const qCount = Number(b.questionCount);
    const duration = Number(b.durationMinutes);
    if (!Number.isInteger(qCount) || qCount < 1 || qCount > 200 || !Number.isInteger(duration) || duration < 1 || duration > 360)
      redirect("/dashboard/exam_designer?error=booklet_params");
    totalDuration += duration;
    if (status === "published" && (!b.pdfUrl || !b.pdfUrl.startsWith("https://")))
      redirect("/dashboard/exam_designer?error=booklet_pdf");
  }

  if (totalDuration > 600) redirect("/dashboard/exam_designer?error=duration_total");

  if (status === "published" && !hasCompleteExamKeys(booklets))
    redirect("/dashboard/exam_designer?error=incomplete_key");

  const { data, error } = await supabase.rpc("save_designer_exam", {
    target_exam_id: examId || null,
    target_title: title,
    target_description: description || null,
    target_student_ids: studentIds,
    target_starts_at: startsAt.toISOString(),
    target_status: status,
    target_booklets: booklets,
    target_exam_field: examField || null,
    target_start_window_ends_at: window?.end.toISOString() || null,
  });
  if (error) {
    const category = examSaveErrorCode(error);
    console.error("[nova:save_exam]", { code: error.code, category });
    redirect(`/dashboard/exam_designer?error=${category}`);
  }
  if (!data) redirect("/dashboard/exam_designer?error=save_failed");

  revalidatePath("/dashboard/exam_designer");
  revalidatePath("/dashboard/counselor/exams");
  revalidatePath("/dashboard/student/exams");
  redirect(`/dashboard/exam_designer?saved=${status}`);
}

export async function submitExam(formData: FormData) {
  const {supabase} = await requireProfile(["student"]);
  const { data: { user } } = await supabase.auth.getUser();
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
          if (Number.isInteger(opt) && opt >= 1 && opt <= 4) answers[k] = opt;
        }
      }
    } catch { redirect(`/dashboard/student/exams/${examId}?error=submit`); }
  } else {
    for (const [key, value] of formData.entries()) {
      if (!key.startsWith("q_")) continue;
      const selected = Number(value);
      if (Number.isInteger(selected) && selected >= 1 && selected <= 4) answers[key.slice(2)] = selected;
    }
  }
  const floatingIndex = clean(formData.get("floating_booklet_index"),10);
  const isFloating = floatingIndex !== "";
  const index = Number(floatingIndex);
  if (isFloating && (!Number.isInteger(index) || index<0 || index>=600)) redirect(`/dashboard/student/exams/${examId}?error=submit`);
  const { error } = isFloating
    ? await supabase.rpc("submit_floating_booklet_exam", {target_exam_id:examId,expected_booklet_index:index,target_answers:answers,use_saved_answers:false})
    : await supabase.rpc("submit_booklet_exam", {target_exam_id:examId,target_answers:answers});
  if (error) redirect(`/dashboard/student/exams/${examId}?error=submit`);
  revalidatePath("/dashboard/student/exams");
  revalidatePath(`/dashboard/student/exams/${examId}`);
  revalidatePath(`/dashboard/counselor/exams/${examId}`);
  redirect(`/dashboard/student/exams/${examId}?submitted=1`);
}


export async function beginFloatingExam(formData: FormData) {
  const {supabase}=await requireProfile(["student"]);
  const examId=clean(formData.get("exam_id"),50);
  if(!uuidPattern.test(examId)) redirect("/dashboard/student/exams?error=exam");
  const {error}=await supabase.rpc("begin_floating_exam",{target_exam_id:examId});
  if(error) redirect(`/dashboard/student/exams/${examId}?error=${floatingExamErrorCode(error.message)}`);
  revalidatePath("/dashboard/student/exams");
  redirect(`/dashboard/student/exams/${examId}`);
}
export async function updateFloatingExamProgress(examId: string, index: number, answers: Record<string,number>, advance = false): Promise<{session?:FloatingExamSession;error?:string}> {
  const {supabase}=await requireProfile(["student"]);
  if(!uuidPattern.test(examId) || !Number.isInteger(index) || index<0 || index>=600 || !answers || typeof answers!=="object" || Array.isArray(answers) || JSON.stringify(answers).length>500_000) return {error:"درخواست معتبر نیست."};
  const {data,error}=await supabase.rpc("update_floating_exam_progress",{target_exam_id:examId,expected_booklet_index:index,target_answers:answers,advance_booklet:advance});
  if(error || !data?.[0]) return {error:floatingExamErrorMessage(error ? floatingExamErrorCode(error.message):undefined)};
  return {session:data[0] as FloatingExamSession};
}
export async function submitSavedFloatingExam(formData: FormData) {
  const {supabase}=await requireProfile(["student"]);
  const examId=clean(formData.get("exam_id"),50);
  if(!uuidPattern.test(examId)) redirect("/dashboard/student/exams?error=exam");
  const {error}=await supabase.rpc("submit_floating_booklet_exam",{target_exam_id:examId,expected_booklet_index:null,target_answers:{},use_saved_answers:true});
  if(error) redirect(`/dashboard/student/exams/${examId}?error=submit`);
  revalidatePath("/dashboard/student/exams");
  redirect(`/dashboard/student/exams/${examId}?submitted=1`);
}
