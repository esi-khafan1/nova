import Link from "next/link";
import { requireProfile } from "@/lib/auth";
import { loadRegistrationDirectory } from "@/lib/load-registration-directory";
import { isPendingUnassignedReceipt, prioritizePendingUnassignedReceipts, provinces, registrationLabels } from "@/lib/registration";
import { courseTypeLabel, courseDurationLabel } from "@/lib/courses";
import { studyFieldLabels } from "@/lib/study-catalog";
import {
  activateStudent,
  assignCounselor,
  uploadStudentReceipt,
  disableStudent,
  resumeStudent,
  changeStudentCounselor,
  changeStudentCourse,
  continueStudentPlanServiceReview,
} from "@/app/dashboard/admin/registrations/actions";
import { ActivationSubmitButton } from "@/components/dashboard/activation-submit-button";
import { AdminFinalCoursePicker } from "@/components/dashboard/admin-final-course-picker";
import { CourseChangeSubmitButton } from "@/components/dashboard/course-change-submit-button";
import { RequiredFieldsForm } from "@/components/dashboard/required-fields-form";
import { RegistrationManagementButton } from "@/components/dashboard/registration-management-button";
import "@/app/registration.css";

type PlanServiceReview = {
  student_id: string;
  review_plan_count: number;
};

export async function RegistrationDirectory({
  audience,
  province,
  reviewOnly = false,
}: {
  audience: "admin";
  province?: string;
  reviewOnly?: boolean;
}) {
  const { supabase } = await requireProfile(["admin"]);
  let rows: Awaited<ReturnType<typeof loadRegistrationDirectory>>;
  let counselors: { id: string; full_name: string }[] = [];
  let planServiceReviews: PlanServiceReview[] = [];
  try {
    const [directory,counselorResult,reviewResult]=await Promise.all([
      loadRegistrationDirectory(supabase),
      supabase.from("profiles").select("id,full_name,counselor_profiles!inner(approval_status)")
        .eq("role","counselor").eq("counselor_profiles.approval_status","approved").order("full_name"),
      supabase.rpc("admin_student_plan_service_reviews"),
    ]);
    rows=directory;
    if(counselorResult.error)return <p className="portal-alert error" role="alert">فهرست مشاورها دریافت نشد؛ برای جلوگیری از تخصیص ناقص، دوباره تلاش کن.</p>;
    if(reviewResult.error)return <p className="portal-alert error" role="alert">فهرست بررسی ادامه یا توقف خدمات دریافت نشد؛ دوباره تلاش کن.</p>;
    counselors=(counselorResult.data??[]) as {id:string;full_name:string}[];
    planServiceReviews=(reviewResult.data??[]) as PlanServiceReview[];
  } catch {
    return <p className="portal-alert error" role="alert">وضعیت ثبت‌نام دریافت نشد. دوباره تلاش کن.</p>;
  }

  const provinceRows = province ? rows.filter(row => row.province === province) : rows;
  const reviewPlanCounts = new Map(planServiceReviews.map(review => [review.student_id, review.review_plan_count]));
  const reviewRows = provinceRows.filter(row => row.registration_status === "active" && reviewPlanCounts.has(row.student_id));
  const filteredRows = reviewOnly ? reviewRows : provinceRows;
  const orderedRows = prioritizePendingUnassignedReceipts(filteredRows);
  const waitingForReview = filteredRows.filter(isPendingUnassignedReceipt).length;
  const reviewParams = new URLSearchParams();
  if (province) reviewParams.set("province", province);
  if (!reviewOnly) reviewParams.set("review", "continuation");
  const reviewHref = `/dashboard/admin/registrations${reviewParams.size ? `?${reviewParams.toString()}` : ""}`;

  return (
    <section className="portal-card registration-directory">
      <div className="portal-card-title">
        <div>
          <h2>ثبت‌نام، فیش و تخصیص مشاور</h2>
          <p>
            اول فیش‌های ارسال‌شدهٔ منتظر بررسی و بدون مشاور نمایش داده می‌شوند؛ سپس حساب‌های بدون فیش. ارسال فیش به‌تنهایی به معنی تأیید پرداخت نیست.
          </p>
        </div>
        <div className="registration-directory-actions">
          <Link
            className={`button ${reviewOnly || reviewRows.length ? "registration-review-button" : "button-secondary"}`}
            href={reviewHref}
            aria-pressed={reviewOnly}
          >
            نیازمند بررسی ادامه یا توقف خدمات ({reviewRows.length.toLocaleString("fa-IR")} نفر)
          </Link>
          <a className="button button-secondary" href="/api/registrations/export">
            دریافت خروجی CSV
          </a>
        </div>
      </div>
      <small className="registration-export-note">خروجی شامل همهٔ استان‌ها و لینک خصوصی فیش است؛ بازکردن آن به ورود ادمین نیاز دارد.</small>

      <form className="registration-province-filter" method="get" action="/dashboard/admin/registrations">
        <label>فیلتر استان
          <select name="province" defaultValue={province ?? ""}>
            <option value="">همهٔ استان‌ها</option>
            {provinces.map(name=><option key={name} value={name}>{name}</option>)}
          </select>
        </label>
        <button className="button secondary" type="submit">نمایش دانش‌آموزان</button>
      </form>
      <div className="registration-summary" aria-label="خلاصه دانش‌آموزها">
        <span>فیش‌های منتظر تأیید و بدون مشاور <strong>{waitingForReview.toLocaleString("fa-IR")}</strong></span>
        <span>{province?"دانش‌آموزهای این استان":"کل دانش‌آموزها"} <strong>{filteredRows.length.toLocaleString("fa-IR")}</strong></span>
        <span>بدون مشاور <strong>{filteredRows.filter((row) => !row.counselor_id).length.toLocaleString("fa-IR")}</strong></span>
        <span>دارای مشاور <strong>{filteredRows.filter((row) => row.counselor_id).length.toLocaleString("fa-IR")}</strong></span>
      </div>

      {!filteredRows.length ? (
        <p>{reviewOnly ? "دانش‌آموزی اکنون نیازمند بررسی ادامه یا توقف خدمات نیست." : province ? `دانش‌آموزی برای استان ${province} پیدا نشد.` : "هنوز دانش‌آموزی در این فهرست نیست."}</p>
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
                const isActive = row.registration_status === "active";
                const isDisabled = row.registration_status === "disabled";
                const hasReceipt = Boolean(row.receipt_path);
                const canActivate = !isActive && !isDisabled && (hasReceipt
                  ? row.registration_status === "pending"
                  : Boolean(row.has_account_details));
                const canAssign = isActive && !row.counselor_id;
                const priorityReceipt = isPendingUnassignedReceipt(row);
                const reviewPlanCount = reviewPlanCounts.get(row.student_id);

                return (
                  <tr key={row.student_id} className={priorityReceipt ? "registration-priority-row" : hasReceipt ? "registration-receipt-row" : "registration-ordinary-row"}>
                    <td data-label="دانش‌آموز و تماس"><div className="registration-cell-content">
                      <strong>{row.full_name || "نام ثبت نشده"}</strong>
                      {priorityReceipt && <small className="registration-priority-label">اولویت بررسی · فیش ارسال شده</small>}
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
                          : row.grade === 9 ? "بدون رشته" : "رشته ثبت نشده"}
                      </small>
                    </div></td>
                    <td data-label="محل سکونت"><div className="registration-cell-content">
                      {row.province || "—"}
                      <small>{row.city || "—"}</small>
                    </div></td>
                    <td className="registration-course-details" data-label="دوره و توضیحات"><div className="registration-cell-content">
                      <small>درخواست دانش‌آموز (نه دورهٔ فعال)</small>
                      <strong>{courseTypeLabel(row.course_type) || "دوره انتخاب نشده"}</strong>
                      {row.course_duration_months && (
                        <small>{courseDurationLabel(row.course_duration_months)}</small>
                      )}
                      <small>دورهٔ اختصاص‌یافته توسط مدیر</small>
                      <strong>{courseTypeLabel(row.service_course_type) || "بدون دورهٔ اختصاص‌یافته"}</strong>
                      {row.service_course_duration_months && <small>{courseDurationLabel(row.service_course_duration_months)}</small>}
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

                      {audience === "admin" && (canActivate || canAssign) && (
                        <RequiredFieldsForm action={canActivate ? activateStudent : assignCounselor} className="registration-student-actions">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          {canActivate && <input name="expected_receipt_path" type="hidden" value={row.receipt_path ?? ""} />}

                          {row.counselor_id ? (
                            <input name="counselor_id" type="hidden" value={row.counselor_id} />
                          ) : <label className="registration-counselor-picker">
                            <span>مشاور</span>
                            <select
                              aria-label={`انتخاب مشاور برای ${row.full_name || "دانش‌آموز"}`}
                              data-required-message="لطفاً مشاور را انتخاب کن"
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

                          {canActivate && <AdminFinalCoursePicker />}

                          {canActivate && (
                            <small className="registration-activation-path" role="status">
                              {hasReceipt
                                ? "مسیر فیش: پس از بررسی فیش، تأیید آن ثبت و حساب فعال می‌شود."
                                : "مسیر بدون فیش: فعال‌سازی دستی ثبت می‌شود؛ پرداختی تأیید نمی‌شود."}
                            </small>
                          )}
                          <div className="registration-action-buttons">
                            {canActivate ? (
                              <ActivationSubmitButton hasReceipt={hasReceipt} disabled={!row.counselor_id && !counselors.length} />
                            ) : (
                              <button className="button button-secondary" type="submit" disabled={!counselors.length}>
                                اختصاص مشاور به حساب فعال
                              </button>
                            )}
                          </div>
                        </RequiredFieldsForm>
                      )}
                      {audience === "admin" && !isActive && !isDisabled && row.has_account_details && (
                        <RequiredFieldsForm action={uploadStudentReceipt} className="registration-receipt-upload">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <input name="expected_receipt_path" type="hidden" value={row.receipt_path ?? ""} />
                          <label>
                            <span>{hasReceipt ? "جایگزینی فیش دریافت‌شده در تلگرام" : "بارگذاری فیش دریافت‌شده در تلگرام"}</span>
                            <input name="receipt" type="file" accept="image/jpeg,image/png,image/webp" required data-required-message="لطفاً فیش را انتخاب کن" aria-label={`عکس فیش ${row.full_name || "دانش‌آموز"}`} />
                          </label>
                          <small>عکس JPG، PNG یا WebP تا ۵ مگابایت؛ ثبت فیش به معنی تأیید پرداخت نیست.</small>
                          <button type="submit" className="button button-secondary">ثبت فیش برای این دانش‌آموز</button>
                        </RequiredFieldsForm>
                      )}
                      {isActive && (
                        <RequiredFieldsForm action={changeStudentCourse} className="registration-admin-control registration-course-control">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <input name="expected_service_course_type" type="hidden" value={row.service_course_type ?? ""} />
                          <input name="expected_service_course_duration_months" type="hidden" value={row.service_course_duration_months ?? ""} />
                          <AdminFinalCoursePicker initialCourse={row.service_course_type} initialMonths={row.service_course_duration_months} />
                          <small>اصلاح دوره فقط برای حساب فعال است؛ مشاور، فیش و درخواست ثبت‌شدهٔ دانش‌آموز تغییر نمی‌کنند.</small>
                          <CourseChangeSubmitButton />
                        </RequiredFieldsForm>
                      )}
                      {isActive && row.counselor_id && (
                        <RequiredFieldsForm action={changeStudentCounselor} className="registration-admin-control">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <input name="expected_counselor_id" type="hidden" value={row.counselor_id} />
                          <label className="registration-counselor-picker">
                            <span>تغییر مشاور</span>
                            <select name="counselor_id" required defaultValue="" data-required-message="لطفاً مشاور را انتخاب کن"
                              aria-label={`مشاور جدید ${row.full_name || "دانش‌آموز"}`}
                              disabled={!counselors.some(c => c.id !== row.counselor_id)}>
                              <option value="" disabled>انتخاب مشاور جدید</option>
                              {counselors.filter(c => c.id !== row.counselor_id).map(c =>
                                <option key={c.id} value={c.id}>{c.full_name || "مشاور نووا"}</option>)}
                            </select>
                          </label>
                          <small>برنامه‌ها و آزمون‌های قبلی محفوظ می‌مانند و مشاور جدید سوابق را می‌بیند.</small>
                          <RegistrationManagementButton label="ثبت تغییر مشاور"
                            message="مشاور فعلی دسترسی خود را به این دانش‌آموز از دست می‌دهد و مشاور جدید سوابق را می‌بیند. تغییر انجام شود؟"
                            disabled={!counselors.some(c => c.id !== row.counselor_id)} />
                        </RequiredFieldsForm>
                      )}
                      {reviewOnly && isActive && reviewPlanCount && (
                        <RequiredFieldsForm action={continueStudentPlanServiceReview} className="registration-admin-control">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <input name="expected_plan_count" type="hidden" value={reviewPlanCount} />
                          <RegistrationManagementButton label="ادامهٔ خدمات تأیید شد"
                            message="ادامهٔ خدمات این دانش‌آموز برای این مرحله تأیید شود؟ دانش‌آموز فعال می‌ماند و در مضرب چهار بعدی دوباره بررسی می‌شود." />
                        </RequiredFieldsForm>
                      )}
                      {isActive && (
                        <RequiredFieldsForm action={disableStudent} className="registration-admin-control registration-disable-control">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <input name="expected_counselor_id" type="hidden" value={row.counselor_id ?? ""} />
                          <RegistrationManagementButton label="غیرفعال‌سازی خدمات" className="button button-secondary"
                            message="خدمات این دانش‌آموز غیرفعال شود؟ مشاور برداشته می‌شود و برنامه‌ها و آزمون‌ها تا فعال‌سازی دوباره پنهان می‌مانند؛ سوابق حذف نمی‌شوند." />
                        </RequiredFieldsForm>
                      )}
                      {isDisabled && (
                        <RequiredFieldsForm action={resumeStudent} className="registration-admin-control">
                          <input name="student_id" type="hidden" value={row.student_id} />
                          <label className="registration-counselor-picker">
                            <span>مشاور برای فعال‌سازی دوباره</span>
                            <select name="counselor_id" required defaultValue="" data-required-message="لطفاً مشاور را انتخاب کن"
                              aria-label={`مشاور برای فعال‌سازی دوبارهٔ ${row.full_name || "دانش‌آموز"}`}
                              disabled={!counselors.length}>
                              <option value="" disabled>انتخاب مشاور</option>
                              {counselors.map(c => <option key={c.id} value={c.id}>{c.full_name || "مشاور نووا"}</option>)}
                            </select>
                          </label>
                          <AdminFinalCoursePicker initialCourse={row.service_course_type} initialMonths={row.service_course_duration_months} />
                          <small>سوابق قبلی بدون تغییر، دوباره قابل مشاهده می‌شوند. دورهٔ قبلی در فرم انتخاب شده و می‌توانی آن را تغییر دهی یا حذف کنی.</small>
                          <RegistrationManagementButton label="فعال‌سازی دوباره و اختصاص مشاور"
                            message="خدمات دانش‌آموز دوباره فعال شود و سوابق برنامه‌ها و آزمون‌ها نمایش داده شوند؟"
                            disabled={!counselors.length} />
                        </RequiredFieldsForm>
                      )}
                      {audience === "admin" && !isActive && !isDisabled && !canActivate && (
                        <small className="registration-assignment-note" role="status">
                          {hasReceipt
                            ? "فیش ثبت شده اما وضعیت ثبت‌نام نیاز به بررسی دارد؛ حساب از مسیر بدون فیش فعال نمی‌شود."
                            : "برای فعال‌سازی بدون فیش، ابتدا اطلاعات حساب دانش‌آموز باید تکمیل شود."}
                        </small>
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
