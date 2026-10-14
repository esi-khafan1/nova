import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { DeleteAccount } from "@/components/dashboard/delete-account";
import { updateStudentProfile } from "@/app/dashboard/actions";
import { studyFieldLabels } from "@/lib/study-catalog";
import { requireProfile } from "@/lib/auth";
export default async function StudentAccountPage() {
  const { profile } = await requireProfile(["student"]);
  return (
    <DashboardShell role="student" name={profile.full_name}>
      <div className="student-account-layout">
      <section className="portal-heading">
        <div>
          <span>حساب کاربری</span>
          <h1>مدیریت و حذف حساب</h1>
          <p>پیش از حذف، پیامدهای این تصمیم را با دقت بررسی کن.</p>
        </div>
      </section>
      <section className="portal-card student-account-profile"><h2>اطلاعات تحصیلی</h2><form action={updateStudentProfile} className="portal-form student-account-form"><label>نام و نام خانوادگی<input name="full_name" defaultValue={profile.full_name} required minLength={2}/></label><label>پایه<select name="grade" defaultValue={profile.grade??""}><option value="">انتخاب کن</option><option value="10">دهم</option><option value="11">یازدهم</option><option value="12">دوازدهم</option></select></label><label>رشته<select name="study_field" defaultValue={profile.study_field??""}><option value="">انتخاب کن</option>{Object.entries(studyFieldLabels).map(([v,label])=><option key={v} value={v}>{label}</option>)}</select></label><button className="button">ذخیره اطلاعات</button></form></section>
      <section className="portal-card account-delete-card">
        <span>منطقه حساس</span>
        <h2>حذف دائمی حساب</h2>
        <p>
          با حذف حساب، پروفایل، برنامه‌های مرتبط، ثبت پیشرفت و پاسخ‌های آزمون
          وابسته به حساب حذف می‌شوند. این عملیات قابل بازگشت نیست.
        </p>
        <DeleteAccount />
      </section>
    </div>
    </DashboardShell>
  );
}
