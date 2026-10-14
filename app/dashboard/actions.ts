"use server";

import { curriculumBooks, type Grade, type PreparationTrack } from "@/lib/planning-curriculum";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { requireProfile } from "@/lib/auth";
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
  const {supabase:s} = await requireProfile(["student"]);
  const {
    data: { user },
  } = await s.auth.getUser();
  if (!user) redirect("/auth/sign-in");
  const full_name = clean(fd.get("full_name"), 100),
    n = Number(fd.get("grade")),
    grade = [10, 11, 12].includes(n) ? n : null,
    field = clean(fd.get("study_field"), 40),
    study_field = [
      "mathematics",
      "experimental_sciences",
      "humanities",
      "arts",
      "foreign_languages",
    ].includes(field)
      ? field
      : null;
  if (full_name.length < 2) redirect("/dashboard/student?error=profile");
  const { error } = await s
    .from("profiles")
    .update({ full_name, grade, study_field })
    .eq("id", user.id);
  if (error) redirect("/dashboard/student?error=profile");
  revalidatePath("/dashboard");
  redirect("/dashboard/student?saved=profile");
}

const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

type WeeklyPlanItemInput = {
  dayOfWeek: number;
  durationMinutes: number;
  subject: string;
  chapter: string;
  activityType: string;
  targetTestCount: number | null;
  details: string;
  sourceGrade?:Grade|null;
  preparationTrack?:PreparationTrack;
  examYear?:number|null;
};

export async function saveWeeklyPlan(fd: FormData) {
  const s = await createClient();
  const {
    data: { user },
  } = await s.auth.getUser();
  if (!user) redirect("/auth/sign-in");

  const studentId = clean(fd.get("student_id"), 50);
  const planId = clean(fd.get("plan_id"), 50);
  const weekStart = clean(fd.get("week_start"), 10);
  const title = clean(fd.get("title"), 120);
  const notes = clean(fd.get("notes"), 2000);
  const status = clean(fd.get("status"), 20);
  const rawItems = clean(fd.get("items"), 100_000);

  if (
    !uuidPattern.test(studentId) ||
    (planId.length > 0 && !uuidPattern.test(planId)) ||
    !/^\d{4}-\d{2}-\d{2}$/.test(weekStart) ||
    !["draft", "published"].includes(status)
  ) {
    redirect("/dashboard/counselor/plans?error=plan");
  }

  const tehranParts = new Intl.DateTimeFormat("en-US", {
    timeZone: "Asia/Tehran",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date());
  const tehranPart = (type: Intl.DateTimeFormatPartTypes) =>
    tehranParts.find((part) => part.type === type)?.value ?? "";
  const today = new Date(
    `${tehranPart("year")}-${tehranPart("month")}-${tehranPart("day")}T12:00:00Z`,
  );
  const selectedWeek = new Date(`${weekStart}T12:00:00Z`);
  const endOfPeriod = new Date(selectedWeek); endOfPeriod.setUTCDate(endOfPeriod.getUTCDate()+6);
  if (Number.isNaN(selectedWeek.getTime()) || selectedWeek.toISOString().slice(0,10)!==weekStart || (!planId && selectedWeek<today) || endOfPeriod<today) redirect("/dashboard/counselor/plans?error=week");

  let items: WeeklyPlanItemInput[] = [];
  try {
    const parsed = JSON.parse(rawItems);
    if (!Array.isArray(parsed) || parsed.some(item => !item || typeof item!=="object" || Array.isArray(item))) throw new Error("Invalid items");
    items = parsed;
  } catch {
    redirect("/dashboard/counselor/plans?error=plan");
  }

  const activityTypes = new Set([
    "lesson",
    "notes",
    "practice_tests",
    "class",
    "exam",
    "review",
    "homework",
    "summary",
    "other",
  ]);

  const safeItems = items
    .slice(0, 100)
    .map((item) => ({
      dayOfWeek: Number(item.dayOfWeek),
      startTime: "",
      durationMinutes: Number(item.durationMinutes),
      subject: clean(item.subject as unknown as string, 100),
      chapter: clean(item.chapter as unknown as string, 160),
      activityType: clean(item.activityType as unknown as string, 30),
      targetTestCount:
        item.targetTestCount === null ? null : Number(item.targetTestCount),
      details: clean(item.details as unknown as string, 500),
      sourceGrade:item.sourceGrade==null?null:Number(item.sourceGrade),
      preparationTrack:item.preparationTrack??"konkur",
      examYear:item.examYear??null,
    }))
    .filter(
      (item) =>
        Number.isInteger(item.dayOfWeek) &&
        item.dayOfWeek >= 0 &&
        item.dayOfWeek <= 6 &&
        Number.isInteger(item.durationMinutes) &&
        item.durationMinutes >= 15 &&
        item.durationMinutes <= 720 &&
        item.subject.length > 0 &&
        activityTypes.has(item.activityType) &&
        (item.activityType === "practice_tests"
          ? Number.isInteger(item.targetTestCount) &&
            Number(item.targetTestCount) >= 1 &&
            Number(item.targetTestCount) <= 5000
          : item.targetTestCount === null) &&
        item.startTime === "" &&
        (() => {
          const plannedDay = new Date(selectedWeek);
          plannedDay.setUTCDate(plannedDay.getUTCDate() + item.dayOfWeek);
          return plannedDay >= today;
        })(),
    );

  if (
    safeItems.length !== items.length ||
    (!safeItems.length && !(planId && status === "published"))
  )
    redirect("/dashboard/counselor/plans?error=items");

  const {data:directory,error:directoryError}=await s.rpc("counselor_student_directory");
  const student=(directory as {student_id:string;is_selected:boolean;grade:number|null;study_field:import("@/lib/study-catalog").StudyField|null}[]|null)?.find(row=>row.student_id===studentId&&row.is_selected);
  if(directoryError||!student||safeItems.some(item=>!['konkur','final_exam'].includes(item.preparationTrack)|| (item.sourceGrade!==null&&(![10,11,12].includes(item.sourceGrade)||!student.grade||item.sourceGrade>student.grade)) || (item.preparationTrack==='final_exam'&&(item.examYear!==null||!item.sourceGrade||!curriculumBooks(student.study_field,item.sourceGrade as Grade,'final_exam').some(book=>book.subject===item.subject))) || (item.preparationTrack==='konkur'&&item.examYear!==null)))redirect('/dashboard/counselor/plans?error=items');
  const { error } = await s.rpc("save_weekly_plan_v4", {
    target_plan_id: planId || null,
    target_student_id: studentId,
    target_week_start: weekStart,
    target_title: title,
    target_notes: notes,
    target_status: status,
    target_items: safeItems,
  });

  if (error) redirect(`/dashboard/counselor/plans?error=${error.code === "23P01" ? "overlap" : "plan"}`);
  revalidatePath("/dashboard/counselor");
  revalidatePath("/dashboard/counselor/plans");
  revalidatePath("/dashboard/student");
  redirect(
    `/dashboard/counselor/plans?saved=${status === "published" ? "published" : "draft"}`,
  );
}

export async function togglePlanItemCompletion(
  itemId: string,
  completed: boolean,
  completedTestCount: number | null = null,
) {
  const {supabase:s} = await requireProfile(["student"]);
  const {data:{user}}=await s.auth.getUser();
  if(!user)redirect("/auth/sign-in");
  if (!uuidPattern.test(itemId)) return { ok: false };

  if (
    completedTestCount !== null &&
    (!Number.isInteger(completedTestCount) ||
      completedTestCount < 1 ||
      completedTestCount > 5000)
  )
    return { ok: false };

  const { error } = await s.rpc("set_weekly_plan_item_progress", {
    target_item_id: itemId,
    target_completed: completed,
    target_completed_test_count: completedTestCount,
  });

  if (error) return { ok: false };
  revalidatePath("/dashboard/student");
  return { ok: true };
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
    !uuidPattern.test(user_id) ||
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
