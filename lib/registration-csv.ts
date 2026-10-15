import { AUTH_SITE_ORIGIN } from "./auth-urls";
import { courseTypeLabel } from "./courses";
import { csvCell, registrationLabels, type RegistrationRow } from "./registration";
import { studyFieldLabels } from "./study-catalog";

// Keep the existing columns in order; append the enrollment fields so older
// consumers retain their column positions. Duration is an explicit month count.
export const registrationCsvHeaders = [
  "نام و نام خانوادگی", "همراه", "تلگرام", "پایه", "رشته", "استان", "شهر",
  "وضعیت حساب", "مشاور", "نام فایل فیش", "لینک خصوصی فیش",
  "نوع دوره", "مدت دوره (ماه)", "توضیحات تکمیلی",
] as const;

export function registrationCsvValues(row: RegistrationRow): unknown[] {
  return [
    row.full_name, row.phone, row.telegram_id ? `@${row.telegram_id}` : "",
    row.grade, row.study_field ? studyFieldLabels[row.study_field] : "",
    row.province, row.city, registrationLabels[row.registration_status],
    row.counselor_name, row.receipt_name,
    row.receipt_path ? `${AUTH_SITE_ORIGIN}/api/registrations/${row.student_id}/receipt` : "",
    courseTypeLabel(row.course_type), row.course_duration_months ?? "",
    row.additional_notes ?? "",
  ];
}

export function buildRegistrationCsv(rows: RegistrationRow[]): string {
  const lines = [registrationCsvHeaders, ...rows.map(registrationCsvValues)];
  // UTF-8 BOM for Persian in Excel; csvCell handles quotes, newlines and formulas.
  return "\uFEFF" + lines.map(line => line.map(csvCell).join(",")).join("\r\n");
}
