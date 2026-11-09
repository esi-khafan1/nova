import { courseTypeLabel, courseDurationLabel } from "@/lib/courses";
import { PhoneLink } from "@/components/dashboard/phone-link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { DeleteAccount } from "@/components/dashboard/delete-account";
import { RegistrationForm } from "@/components/registration/registration-form";
import { StudentServiceNotice } from "@/components/dashboard/student-service-notice";
import { StudentProfileCompletionNotice } from "@/components/dashboard/student-profile-completion-notice";
import { StudentNameForm } from "@/components/dashboard/student-name-form";
import { loadStudentAccount } from "@/lib/load-student-account";
import { verifiedMobileForAccount } from "@/lib/phone-auth";
import { requiredStudentFieldsIssue } from "@/lib/registration";
import { requireProfile } from "@/lib/auth";
import "@/app/registration.css";
export default async function StudentAccountPage() {
  const { supabase, profile, user } = await requireProfile(["student"], true);
  const verifiedPhone = verifiedMobileForAccount(user);
  const account = await loadStudentAccount(supabase, profile, verifiedPhone);
  const completionIssue = !account.error ? requiredStudentFieldsIssue(account.values, true) : null;
  return <DashboardShell role="student" name={profile.full_name}><div className="student-account-layout">
    <section className="portal-heading"><div><span>حساب کاربری</span><h1>اطلاعات و مدیریت حساب</h1><p>برای تکمیل اطلاعات حساب نیازی به انتخاب دوره یا ارسال فیش نیست.</p></div></section>
    {!profile.full_name?.trim() && <StudentNameForm/>}
    <StudentServiceNotice status={profile.registration_status} grade={profile.grade} studyField={profile.study_field}/>
    {!account.error && <section className="portal-card"><h2>دورهٔ حساب</h2>
      <p>دورهٔ اختصاص‌یافته توسط مدیر: <strong>{courseTypeLabel(account.service?.service_course_type) || "بدون دورهٔ اختصاص‌یافته"}</strong>{account.service?.service_course_duration_months ? ` · ${courseDurationLabel(account.service.service_course_duration_months)}` : ""}</p>
      {account.registration?.course_type && <p>درخواست ثبت‌شدهٔ شما: {courseTypeLabel(account.registration.course_type)}{account.registration.course_duration_months ? ` · ${courseDurationLabel(account.registration.course_duration_months)}` : ""} (این درخواست، دورهٔ فعال‌شده نیست.)</p>}
    </section>}
    {completionIssue && <StudentProfileCompletionNotice issue={completionIssue} active={profile.registration_status === "active"} onAccountPage/>}
    <section id="student-account-details" className="registration-card"><h2>اطلاعات حساب</h2>{account.error ? <p className="portal-alert error" role="alert">اطلاعات فعلاً دریافت نشد؛ صفحه را دوباره باز کن.</p> : <RegistrationForm values={account.values} verifiedPhone={verifiedPhone} mode="profile"/>}</section>
    <PhoneLink enabled={process.env.PHONE_SIGNUP_ENABLED === "true"} verifiedPhone={user.phone_confirmed_at ? user.phone || null : null}/>
    <section className="portal-card account-delete-card"><span>منطقه حساس</span><h2>حذف دائمی حساب</h2><p>با حذف حساب، پروفایل، برنامه‌های مرتبط، ثبت پیشرفت و پاسخ‌های آزمون وابسته به حساب حذف می‌شوند. این عملیات قابل بازگشت نیست.</p><DeleteAccount/></section>
  </div></DashboardShell>;
}
