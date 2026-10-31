import { hasConfirmedContact, verifiedMobileForAccount } from "@/lib/phone-auth";
import Link from "next/link";
import { redirect } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { getRequestUser } from "@/lib/supabase/request-auth";
import { safeReturnPath } from "@/lib/return-path";
import { parseCourseSelection, courseRegistrationPath, studentCourseCatalogPath } from "@/lib/courses";
import { loadStudentAccount } from "@/lib/load-student-account";
import { RegistrationForm } from "@/components/registration/registration-form";
import { StudentProfileCompletionNotice } from "@/components/dashboard/student-profile-completion-notice";
import { requiredStudentFieldsIssue } from "@/lib/registration";
import "@/app/registration.css";
export default async function RegistrationPage({ searchParams }: { searchParams: Promise<Record<string,string|string[]|undefined>> }) {
  const params = await searchParams;
  const requested = parseCourseSelection(params);
  const invalidSelection = !requested && ["grade","field","course","months"].some(key => params[key] !== undefined);
  const next = requested ? courseRegistrationPath(requested) : "/dashboard/registration";
  const { user } = await getRequestUser();
  if (!user || !hasConfirmedContact(user)) redirect(`/auth?mode=signup&next=${encodeURIComponent(safeReturnPath(next))}`);
  const { supabase, profile } = await requireProfile(["student"], true);
  if (profile.registration_status === "disabled") redirect("/dashboard/student");
  if (profile.registration_status === "active") return <DashboardShell role="student" name={profile.full_name}><section className="portal-card"><h1>خدمات حساب تو فعال است</h1><p>برای حفظ ثبت‌نام تأییدشده، این فرم آن را بازنویسی نمی‌کند. برای تغییر یا تمدید دوره با نووا هماهنگ کن.</p><Link className="button" href="/dashboard/student">رفتن به پنل من</Link></section></DashboardShell>;
  const verifiedPhone = verifiedMobileForAccount(user);
  const account = await loadStudentAccount(supabase,profile,verifiedPhone);
  const existing = account.registration;
  const saved = existing ? parseCourseSelection({grade:existing.grade,field:existing.study_field,course:existing.course_type,months:existing.course_duration_months}) : null;
  const selection = requested ?? saved;
  const legacy = !invalidSelection && !selection && existing?.receipt_name && !existing.course_type;
  const completionIssue = !account.error ? requiredStudentFieldsIssue({ ...account.values, grade: selection?.grade ?? account.values.grade, study_field: selection?.field ?? account.values.study_field }, true) : null;
  return <DashboardShell role="student" name={profile.full_name}><div className="registration-page"><section className="registration-welcome"><span>به خانوادهٔ نووا خوش آمدی</span><h1>ثبت‌نام دوره را کامل کن</h1><p>اطلاعات و فیش واریزی را ارسال کن. خدمات پولی پس از تأیید فیش و تخصیص مشاور توسط مدیر فعال می‌شوند؛ در این فاصله می‌توانی همهٔ بخش‌های پنل را ببینی.</p><Link href="/dashboard/student">مشاهدهٔ پنل من ←</Link></section>
    {profile.registration_status === "pending" && <section className="registration-pending" role="status"><strong>اطلاعاتت ارسال شده و منتظر بررسی است.</strong><p>تا قبل از تأیید می‌توانی اطلاعات یا فیش همین درخواست را اصلاح کنی.</p></section>}
    {completionIssue && <StudentProfileCompletionNotice issue={completionIssue} active={false} onRegistrationPage={Boolean(!invalidSelection && (selection || legacy))}/>}
    <section id="student-registration-details" className="registration-card">{account.error ? <p role="alert">اطلاعات فعلاً دریافت نشد؛ صفحه را دوباره باز کن.</p> : invalidSelection || (!selection && !legacy) ? <><h2>ابتدا دوره‌ات را انتخاب کن</h2><p>با انتخاب پایه و رشته، ۸ دوره در دو پلن و چهار بازهٔ زمانی برایت نمایش داده می‌شود.</p><Link className="button" href={studentCourseCatalogPath(account.values.grade, account.values.study_field)}>انتخاب دوره</Link><p><Link href="/dashboard/student/account">تکمیل عادی اطلاعات، بدون دوره و فیش ←</Link></p></> : <RegistrationForm key={selection ? courseRegistrationPath(selection) : "legacy"} values={{...account.values,receipt_name:existing?.receipt_name,additional_notes:existing?.additional_notes ?? account.values.additional_notes}} verifiedPhone={verifiedPhone} selection={selection}/>}</section>
  </div></DashboardShell>;
}
