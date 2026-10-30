"use server";
import { hasConfirmedContact, verifiedMobileForAccount } from "@/lib/phone-auth";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import { normalizeDigits, validateRegistration, receiptImageType } from "@/lib/registration";
import { parseCourseSelection } from "@/lib/courses";
export async function submitRegistration(_state: { error?: string; success?: string }, fd: FormData): Promise<{ error?: string; success?: string }> {
  const { supabase, user, profile } = await requireProfile(["student"], true);
  if (!hasConfirmedContact(user)) return { error: "ابتدا شماره تلفن همراه یا ایمیلت را تأیید کن، سپس دوباره وارد حساب شو." };
  const text = (name: string) => String(fd.get(name) ?? "").trim();
  const mode = text("form_mode");
  if (mode && mode !== "profile" && mode !== "enrollment") return { error: "نوع فرم معتبر نیست؛ صفحه را دوباره باز کن." };
  const typedPhone = normalizeDigits(text("phone")).replace(/[\s-]/g,"");
  const values = { full_name: text("full_name").replace(/\s+/g," ") || null, phone: verifiedMobileForAccount(user) ?? (typedPhone || null), telegram_id: text("telegram_id").replace(/^@/,"") || null, grade: text("grade") ? Number(text("grade")) : null, study_field: text("study_field") || null, province: text("province"), city: text("city"), additional_notes: text("additional_notes") };
  const invalid = validateRegistration(values, mode === "profile"); if (invalid) return { error: invalid };
  if (mode === "profile") {
    const { error } = await supabase.rpc("save_student_account_details", { payload: values });
    if (error) return { error: "ذخیره اطلاعات حساب انجام نشد؛ دوباره تلاش کن." };
    revalidatePath("/dashboard", "layout");
    return { success: profile.registration_status === "active"
      ? "اطلاعات حساب ذخیره شد. حسابت فعال است و نیازی به فعال‌سازی دوباره نداری."
      : "اطلاعات حساب ذخیره شد. فعال‌سازی خدمات جداگانه توسط مدیر انجام می‌شود." };
  }
  if (profile.registration_status === "active") redirect("/dashboard/student");
  const selection = parseCourseSelection({ grade: text("grade"), field: text("study_field"), course: text("course"), months: text("months") });
  const { data: previous, error: readError } = await supabase.from("student_registrations").select("receipt_path,receipt_name,course_type,course_duration_months").eq("student_id",profile.id).maybeSingle();
  if (readError) return { error: "اطلاعات قبلی دریافت نشد؛ دوباره تلاش کن." };
  // Preserve old, already-submitted requests without fabricating a course selection.
  if (!selection && (text("course") || text("months") || !previous?.receipt_path || previous.course_type)) return { error: "نوع دوره و بازه را از بخش دوره‌ها انتخاب کن." };
  let receipt_path = previous?.receipt_path, receipt_name = previous?.receipt_name; let uploaded = false;
  const file = fd.get("receipt");
  if (file instanceof File && file.size) {
    if (file.size > 5*1024*1024) return { error: "حجم فیش باید حداکثر ۵ مگابایت باشد." };
    const bytes = new Uint8Array(await file.arrayBuffer()); const type = receiptImageType(bytes);
    if (!type) return { error: "فیش را به صورت عکس JPG، PNG یا WebP ارسال کن." };
    receipt_path = `${profile.id}/${crypto.randomUUID()}.${type.extension}`; receipt_name = file.name.slice(0,150);
    const { error } = await supabase.storage.from("registration-receipts").upload(receipt_path,bytes,{contentType:type.mime,upsert:false});
    if (error) return { error: "بارگذاری فیش انجام نشد؛ دوباره تلاش کن." }; uploaded = true;
  }
  if (!receipt_path) return { error: "عکس فیش واریزی را بارگذاری کن." };
  const { error } = await supabase.rpc("submit_student_registration", { payload: { ...values, receipt_path, receipt_name, course_type: selection?.course ?? null, course_duration_months: selection?.months ?? null } });
  if (error) { if (uploaded) await supabase.storage.from("registration-receipts").remove([receipt_path]); return { error: "ثبت اطلاعات انجام نشد. اگر حساب تأیید شده، صفحه را دوباره باز کن؛ در غیر این صورت دوباره تلاش کن." }; }
  if (uploaded && previous?.receipt_path && previous.receipt_path !== receipt_path) await supabase.storage.from("registration-receipts").remove([previous.receipt_path]);
  revalidatePath("/dashboard", "layout"); revalidatePath("/dashboard/admin/registrations"); redirect("/dashboard/registration?saved=1");
}
