import { PhoneLink } from "@/components/dashboard/phone-link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { DeleteAccount } from "@/components/dashboard/delete-account";
import { RegistrationForm } from "@/components/registration/registration-form";
import { StudentServiceNotice } from "@/components/dashboard/student-service-notice";
import { loadStudentAccount } from "@/lib/load-student-account";
import { requireProfile } from "@/lib/auth";
import "@/app/registration.css";
export default async function StudentAccountPage() {
  const { supabase, profile, user } = await requireProfile(["student"], true);
  const account = await loadStudentAccount(supabase, profile);
  return <DashboardShell role="student" name={profile.full_name}><div className="student-account-layout">
    <section className="portal-heading"><div><span>حساب کاربری</span><h1>اطلاعات و مدیریت حساب</h1><p>برای تکمیل اطلاعات حساب نیازی به انتخاب دوره یا ارسال فیش نیست.</p></div></section>
    <StudentServiceNotice status={profile.registration_status} grade={profile.grade} studyField={profile.study_field}/>
    <section className="registration-card"><h2>اطلاعات ثبت‌نام</h2>{account.error ? <p className="portal-alert error" role="alert">اطلاعات فعلاً دریافت نشد؛ صفحه را دوباره باز کن.</p> : <RegistrationForm values={account.values} mode="profile"/>}</section>
    <PhoneLink enabled={process.env.PHONE_SIGNUP_ENABLED === "true"} verifiedPhone={user.phone_confirmed_at ? user.phone || null : null}/>
    <section className="portal-card account-delete-card"><span>منطقه حساس</span><h2>حذف دائمی حساب</h2><p>با حذف حساب، پروفایل، برنامه‌های مرتبط، ثبت پیشرفت و پاسخ‌های آزمون وابسته به حساب حذف می‌شوند. این عملیات قابل بازگشت نیست.</p><DeleteAccount/></section>
  </div></DashboardShell>;
}
