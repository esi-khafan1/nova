import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { DeleteAccount } from "@/components/dashboard/delete-account";
import { requireProfile } from "@/lib/auth";
export default async function StudentAccountPage() {
  const { profile } = await requireProfile(["student"]);
  return (
    <DashboardShell role="student" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>حساب کاربری</span>
          <h1>مدیریت و حذف حساب</h1>
          <p>پیش از حذف، پیامدهای این تصمیم را با دقت بررسی کن.</p>
        </div>
      </section>
      <section className="portal-card account-delete-card">
        <span>منطقه حساس</span>
        <h2>حذف دائمی حساب</h2>
        <p>
          با حذف حساب، پروفایل، برنامه‌های مرتبط، ثبت پیشرفت و پاسخ‌های آزمون
          وابسته به حساب حذف می‌شوند. این عملیات قابل بازگشت نیست.
        </p>
        <DeleteAccount />
      </section>
    </DashboardShell>
  );
}
