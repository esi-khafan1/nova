import Link from "next/link";
import { requireProfile } from "@/lib/auth";
import { loadRegistrationDirectory } from "@/lib/load-registration-directory";
import { isPendingUnassignedReceipt, prioritizePendingUnassignedReceipts, registrationLabels } from "@/lib/registration";
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
  let counselors: { id: string; full_name: string }[] = [];
  try {
    const [directory,counselorResult]=await Promise.all([
      loadRegistrationDirectory(supabase),
      supabase.from("profiles").select("id,full_name,counselor_profiles!inner(approval_status)")
        .eq("role","counselor").eq("counselor_profiles.approval_status","approved").order("full_name"),
    ]);
    rows=directory;
    if(counselorResult.error)return <p className="portal-alert error" role="alert">فهرست مشاورها دریافت نشد؛ برای جلوگیری از تخصیص ناقص، دوباره تلاش کن.</p>;
    counselors=(counselorResult.data??[]) as {id:string;full_name:string}[];
  } catch {
    return <p className="portal-alert error" role="alert">وضعیت ثبت‌نام دریافت نشد. دوباره تلاش کن.</p>;
  }

  const orderedRows = prioritizePendingUnassignedReceipts(rows);
  const waitingForReview = rows.filter(isPendingUnassignedReceipt).length;

  return (
    <section className="portal-card registration-directory">
      <div className="portal-card-title">
        <div>
          <h2>ثبت‌نام، فیش و تخصیص مشاور</h2>
          <p>
            دانش‌آموزهای دارای فیش که هنوز تأیید نشده‌اند و مشاور ندارند، در ابتدای فهرست هستند. با اختصاص مشاور، حساب و خدمات دانش‌آموز فعال می‌شوند.
          </p>
        </div>
        <a className="button button-secondary" href="/api/registrations/export">
          دریافت خروجی CSV
        </a>
      </div>
      <small className="registration-export-note">خروجی شامل لینک خصوصی فیش است؛ بازکردن آن به ورود ادمین نیاز دارد.</small>

      <div className="registration-summary" aria-label="خلاصه دانش‌آموزها">
        <span>فیش‌های منتظر تأیید و بدون مشاور <strong>{waitingForReview.toLocaleString("fa-IR")}</strong></span>
        <span>کل دانش‌آموزها <strong>{rows.length.toLocaleString("fa-IR")}</strong></span>
        <span>بدون مشاور <strong>{rows.filter((row) => !row.counselor_id).length.toLocaleString("fa-IR")}</strong></span>
        <span>دارای مشاور <strong>{rows.filter((row) => row.counselor_id).length.toLocaleString("fa-IR")}</strong></span>
      </div>

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
              {orderedRows.map((row) => {
                const canManualActivate =
                  row.registration_status !== "active" && row.has_account_details;
                const canActivateWithReceipt = row.registration_status === "pending";

                return (
                  <tr key={row.student_id}>
                    <td data-label="دانش‌آموز و تماس"><div className="registration-cell-content">
                      <strong>{row.full_name || "نام ثبت نشده"}</strong>
                      <small dir="ltr">{row.phone || "شماره ثبت نشده"}</small>
                      <small dir="ltr">
                        {row.telegram_id ? `@${row.telegram_id}` : "تلگرام ثبت نشده"}
                      </small>
                    </div></td>
                    <td data-label="پایه و رشته"><div className="registration-cell-content">
                      {row.grade ? `پایه ${row.grade.toLocaleString("fa-IR")}` : "—"}
                      <small>
                        {row.study_field
                          ? studyFieldLabels[row.study_field]
                          : "رشته ثبت نشده"}
                      </small>
                    </div></td>
                    <td data-label="محل سکونت"><div className="registration-cell-content">
                      {row.province || "—"}
                      <small>{row.city || "—"}</small>
                    </div></td>
                    <td className="registration-course-details" data-label="دوره و توضیحات"><div className="registration-cell-content">
                      <strong>{courseTypeLabel(row.course_type) || "دوره انتخاب نشده"}</strong>
                      {row.course_duration_months && (
                        <small>{courseDurationLabel(row.course_duration_months)}</small>
                      )}
                      {row.additional_notes && <p>{row.additional_notes}</p>}
                    </div></td>
                    <td data-label="وضعیت و فیش"><div className="registration-cell-content">
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
                    </div></td>
                    <td className="registration-actions-cell" data-label="مشاور و فعال‌سازی"><div className="registration-cell-content">
                      <small>
                        {row.counselor_id
                          ? `مشاور فعلی: ${row.counselor_name || counselors.find((counselor) => counselor.id === row.counselor_id)?.full_name || "تخصیص داده شده"}`
                          : "هنوز اختصاص داده نشده"}
                      </small>

                      {audience === "admin" && (!row.counselor_id || canActivateWithReceipt || canManualActivate) && (
                        <form action={assignCounselor} className="registration-student-actions">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <input
                            name="receipt_path"
                            type="hidden"
                            value={row.receipt_path ?? ""}
                          />

                          {row.counselor_id ? (
                            <input name="counselor_id" type="hidden" value={row.counselor_id} />
                          ) : <label className="registration-counselor-picker">
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
                          </label>}

                          {!row.counselor_id && !counselors.length && <small role="status">مشاور تأییدشده‌ای برای تخصیص موجود نیست.</small>}

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
                            {!row.counselor_id && <button
                              className="button button-secondary"
                              type="submit"
                              disabled={!counselors.length}
                            >
                              اختصاص مشاور و فعال‌سازی حساب
                            </button>}

                            {canActivateWithReceipt && (
                              <button
                                className="button"
                                type="submit"
                                name="activation_mode"
                                value="receipt"
                                formAction={activateStudent}
                                disabled={(!row.counselor_id && !counselors.length) || !row.receipt_path}
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
                                disabled={!row.counselor_id && !counselors.length}
                              >
                                فعال‌سازی دستی بدون فیش
                              </button>
                            )}
                          </div>

                          {!row.counselor_id && row.registration_status === "incomplete" && (
                            <small className="registration-assignment-note">
                              با اختصاص مشاور توسط ادمین، حساب فعال می‌شود؛ تأیید جداگانه لازم نیست.
                            </small>
                          )}
                        </form>
                      )}
                    </div></td>
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
