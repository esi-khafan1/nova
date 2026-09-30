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
    .update({ full_name, phone, grade, study_field })
    .eq("id", user.id);
  if (error) redirect("/dashboard/student?error=profile");
  revalidatePath("/dashboard");
  redirect("/dashboard/student?saved=profile");
}

const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export async function selectStudent(fd: FormData) {
  const s = await createClient();
  const {
    data: { user },
  } = await s.auth.getUser();
  if (!user) redirect("/auth/sign-in");

  const studentId = clean(fd.get("student_id"), 50);
  if (!uuidPattern.test(studentId))
    redirect("/dashboard/counselor/plans?error=student");

  const { error } = await s.rpc("counselor_select_student", {
    target_student_id: studentId,
  });

  if (error) redirect("/dashboard/counselor/plans?error=student");
  revalidatePath("/dashboard/counselor");
  revalidatePath("/dashboard/counselor/plans");
  redirect("/dashboard/counselor/plans?selected=1");
}

type WeeklyPlanItemInput = {
  dayOfWeek: number;
  startTime: string;
  durationMinutes: number;
  subject: string;
  chapter: string;
  activityType: string;
  details: string;
};

export async function saveWeeklyPlan(fd: FormData) {
  const s = await createClient();
  const {
    data: { user },
  } = await s.auth.getUser();
  if (!user) redirect("/auth/sign-in");

  const studentId = clean(fd.get("student_id"), 50);
  const weekStart = clean(fd.get("week_start"), 10);
  const title = clean(fd.get("title"), 120);
  const notes = clean(fd.get("notes"), 2000);
  const status = clean(fd.get("status"), 20);
  const rawItems = clean(fd.get("items"), 100_000);

  if (
    !uuidPattern.test(studentId) ||
    !/^\d{4}-\d{2}-\d{2}$/.test(weekStart) ||
    !["draft", "published"].includes(status)
  ) {
    redirect("/dashboard/counselor/plans?error=plan");
  }

  let items: WeeklyPlanItemInput[] = [];
  try {
    const parsed = JSON.parse(rawItems);
    if (!Array.isArray(parsed)) throw new Error("Invalid items");
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
      startTime: clean(item.startTime as unknown as string, 5),
      durationMinutes: Number(item.durationMinutes),
      subject: clean(item.subject as unknown as string, 100),
      chapter: clean(item.chapter as unknown as string, 160),
      activityType: clean(item.activityType as unknown as string, 30),
      details: clean(item.details as unknown as string, 500),
    }))
    .filter(
      (item) =>
        Number.isInteger(item.dayOfWeek) &&
        item.dayOfWeek >= 0 &&
        item.dayOfWeek <= 6 &&
        Number.isFinite(item.durationMinutes) &&
        item.durationMinutes >= 15 &&
        item.durationMinutes <= 720 &&
        item.subject.length > 0 &&
        activityTypes.has(item.activityType) &&
        (item.startTime === "" || /^\d{2}:\d{2}$/.test(item.startTime)),
    );

  if (!safeItems.length || safeItems.length !== items.length)
    redirect("/dashboard/counselor/plans?error=items");

  const { error } = await s.rpc("save_weekly_plan", {
    target_student_id: studentId,
    target_week_start: weekStart,
    target_title: title,
    target_notes: notes,
    target_status: status,
    target_items: safeItems,
  });

  if (error) redirect("/dashboard/counselor/plans?error=plan");
  revalidatePath("/dashboard/counselor");
  revalidatePath("/dashboard/counselor/plans");
  revalidatePath("/dashboard/student");
  redirect(
    `/dashboard/counselor/plans?saved=${status === "published" ? "published" : "draft"}`,
  );
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
