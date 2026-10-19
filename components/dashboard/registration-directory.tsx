import Link from "next/link";
import { requireProfile } from "@/lib/auth";
import { loadRegistrationDirectory } from "@/lib/load-registration-directory";
import { registrationLabels } from "@/lib/registration";
import { courseTypeLabel, courseDurationLabel } from "@/lib/courses";
import { studyFieldLabels } from "@/lib/study-catalog";
import {
  activateStudent,
  assignCounselor,
} from "@/app/dashboard/admin/registrations/actions";
import "@/app/registration.css";

export async function RegistrationDirectory({
  audience,
}: {
  audience: "admin";
}) {
  const { supabase } = await requireProfile(["admin"]);
  let rows: Awaited<ReturnType<typeof loadRegistrationDirectory>>;

  try {
    rows = await loadRegistrationDirectory(supabase);
  } catch {
    return (
      <p className="portal-alert error" role="alert">
        وضعیت ثبت‌نام دریافت نشد. دوباره تلاش کن.
      </p>
    );
  }

  let counselors: { id: string; full_name: string }[] = [];
  if (audience === "admin") {
    const { data, error } = await supabase
      .from("profiles")
      .select("id,full_name,counselor_profiles!inner(approval_status)")
      .eq("role", "counselor")
      .eq("counselor_profiles.approval_status", "approved")
      .order("full_name");

    if (error) {
      return (
        <p className="portal-alert error" role="alert">
          فهرست مشاورها دریافت نشد؛ برای جلوگیری از تخصیص ناقص، دوباره تلاش کن.
        </p>
      );
    }
    counselors = (data ?? []) as { id: string; full_name: string }[];
  }

  return (
    <section className="portal-card registration-directory">
      <div className="portal-card-title">
        <div>
          <h2>ثبت‌نام، فیش و تخصیص مشاور</h2>
          <p>
            مشاور را می‌توانی برای همهٔ دانش‌آموزها، مستقل از وضعیت ثبت‌نام، اختصاص بدهی؛ این کار به‌تنهایی خدمات دانش‌آموز را فعال نمی‌کند. فعال‌سازی همچنان با تأیید فیش یا استثنای دستی انجام می‌شود.
          </p>
        </div>
        <a className="button button-secondary" href="/api/registrations/export">
          دریافت خروجی CSV
        </a>
      </div>
      <small>خروجی شامل لینک خصوصی فیش است؛ بازکردن آن به ورود ادمین نیاز دارد.</small>

      {!rows.length ? (
        <p>هنوز دانش‌آموزی در این فهرست نیست.</p>
      ) : (
        <div className="registration-table-wrap">
          <table>
            <thead>
              <tr>
                <th>دانش‌آموز و تماس</th>
                <th>پایه و رشته</th>
                <th>محل سکونت</th>
                <th>دوره و توضیحات</th>
                <th>وضعیت و فیش</th>
                <th>مشاور و فعال‌سازی</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => {
                const canManualActivate =
                  row.registration_status !== "active" && row.has_account_details;
                const canActivateWithReceipt = row.registration_status === "pending";

                return (
                  <tr key={row.student_id}>
                    <td data-label="دانش‌آموز و تماس">
                      <strong>{row.full_name || "نام ثبت نشده"}</strong>
                      <small dir="ltr">{row.phone || "شماره ثبت نشده"}</small>
                      <small dir="ltr">
                        {row.telegram_id ? `@${row.telegram_id}` : "تلگرام ثبت نشده"}
                      </small>
                    </td>
                    <td data-label="پایه و رشته">
                      {row.grade ? `پایه ${row.grade.toLocaleString("fa-IR")}` : "—"}
                      <small>
                        {row.study_field
                          ? studyFieldLabels[row.study_field]
                          : "رشته ثبت نشده"}
                      </small>
                    </td>
                    <td data-label="محل سکونت">
                      {row.province || "—"}
                      <small>{row.city || "—"}</small>
                    </td>
                    <td className="registration-course-details" data-label="دوره و توضیحات">
                      <strong>{courseTypeLabel(row.course_type) || "دوره انتخاب نشده"}</strong>
                      {row.course_duration_months && (
                        <small>{courseDurationLabel(row.course_duration_months)}</small>
                      )}
                      {row.additional_notes && <p>{row.additional_notes}</p>}
                    </td>
                    <td data-label="وضعیت و فیش">
                      <strong>
                        {row.registration_status === "incomplete" && row.has_account_details
                          ? "اطلاعات کامل؛ خدمات غیرفعال"
                          : registrationLabels[row.registration_status] ??
                            row.registration_status}
                      </strong>
                      {row.receipt_path ? (
                        <Link
                          href={`/api/registrations/${row.student_id}/receipt`}
                          target="_blank"
                          rel="noopener"
                        >
                          مشاهده فیش واریزی
                        </Link>
                      ) : (
                        <small>
                          {row.registration_status === "active"
                            ? "حساب فعلی ـ نیاز به ثبت‌نام مجدد ندارد"
                            : "فیش ارسال نشده"}
                        </small>
                      )}
                    </td>
                    <td className="registration-actions-cell" data-label="مشاور و فعال‌سازی">
                      <small>
                        {row.counselor_name
                          ? `مشاور فعلی: ${row.counselor_name}`
                          : "هنوز اختصاص داده نشده"}
                      </small>

                      {audience === "admin" && (
                        <form action={assignCounselor} className="registration-student-actions">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <input
                            name="receipt_path"
                            type="hidden"
                            value={row.receipt_path ?? ""}
                          />

                          <label className="registration-counselor-picker">
                            <span>مشاور</span>
                            <select
                              aria-label={`انتخاب مشاور برای ${row.full_name || "دانش‌آموز"}`}
                              name="counselor_id"
                              required
                              defaultValue={row.counselor_id ?? ""}
                              disabled={!counselors.length}
                            >
                              <option value="" disabled>
                                انتخاب مشاور
                              </option>
                              {counselors.map((counselor) => (
                                <option key={counselor.id} value={counselor.id}>
                                  {counselor.full_name || "مشاور نووا"}
                                </option>
                              ))}
                            </select>
                          </label>

                          {canActivateWithReceipt && (
                            <label className="registration-confirmation">
                              <input name="receipt_confirmation" type="checkbox" />
                              <span>اطلاعات و فیش بررسی و تأیید شد</span>
                            </label>
                          )}
                          {canManualActivate && (
                            <label className="registration-confirmation">
                              <input name="manual_confirmation" type="checkbox" />
                              <span>فعال‌سازی خدمات بدون فیش را تأیید می‌کنم</span>
                            </label>
                          )}

                          <div className="registration-action-buttons">
                            <button
                              className="button button-secondary"
                              type="submit"
                              disabled={!counselors.length}
                            >
                              {row.counselor_id
                                ? "ذخیره تخصیص مشاور"
                                : "اختصاص مشاور"}
                            </button>

                            {canActivateWithReceipt && (
                              <button
                                className="button"
                                type="submit"
                                name="activation_mode"
                                value="receipt"
                                formAction={activateStudent}
                                disabled={!counselors.length || !row.receipt_path}
                              >
                                تأیید و فعال‌سازی
                              </button>
                            )}

                            {canManualActivate && (
                              <button
                                className="button"
                                type="submit"
                                name="activation_mode"
                                value="manual"
                                formAction={activateStudent}
                                disabled={!counselors.length}
                              >
                                فعال‌سازی دستی بدون فیش
                              </button>
                            )}
                          </div>

                          {row.registration_status === "incomplete" && (
                            <small className="registration-assignment-note">
                              «اختصاص مشاور» فقط رابطهٔ مشاور و دانش‌آموز را ذخیره می‌کند و وضعیت ثبت‌نام را تغییر نمی‌دهد.
                            </small>
                          )}
                        </form>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}
