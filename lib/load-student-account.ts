import type { createClient } from "./supabase/server";
import type { CurrentProfile } from "./auth";
import type { RegistrationFormValues } from "./registration";
export async function loadStudentAccount(supabase: Awaited<ReturnType<typeof createClient>>, profile: CurrentProfile) {
  const [details, registration] = await Promise.all([
    supabase.from("student_account_details").select("full_name,phone,telegram_id,grade,study_field,province,city,additional_notes").eq("student_id",profile.id).maybeSingle(),
    supabase.from("student_registrations").select("full_name,first_name,last_name,phone,telegram_id,grade,study_field,province,city,receipt_name,additional_notes,course_type,course_duration_months").eq("student_id",profile.id).maybeSingle(),
  ]);
  const source = (details.data ?? registration.data ?? {}) as RegistrationFormValues;
  return { values: { ...source, full_name: source.full_name || profile.full_name, grade: source.grade ?? profile.grade ?? undefined, study_field: source.study_field ?? profile.study_field ?? undefined, phone: source.phone ?? profile.phone ?? undefined } as RegistrationFormValues, registration: registration.data, error: Boolean(details.error || registration.error) };
}
