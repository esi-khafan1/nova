import { requireProfile } from "@/lib/auth";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { RegistrationDirectory } from "@/components/dashboard/registration-directory";

export default async function Registrations({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { profile } = await requireProfile(["admin"]);
  const params = await searchParams;

  return (
    <DashboardShell role="admin" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>مدیریت نووا</span>
          <h1>فعال‌سازی دانش‌آموزها</h1>
        </div>
      </section>

      {params.error === "assignment" ? (
        <p className="portal-alert error" role="alert">
          تخصیص انجام نشد؛ این دکمه فقط برای دانش‌آموزی است که از قبل فعال و بدون مشاور باشد. مشاور انتخابی هم باید تأییدشده باشد.
        </p>
      ) : params.error ? (
        <p className="portal-alert error" role="alert">
          فعال‌سازی انجام نشد؛ اگر فیشی ارسال شده، باید همان فیش را بررسی کنی و وضعیت ثبت‌نام آمادهٔ تأیید باشد. بدون فیش، اطلاعات حساب و راه تماس تأییدشده لازم است. صفحه را تازه کن و دوباره بررسی کن.
        </p>
      ) : null}

      {params.assigned && (
        <p className="portal-alert success" role="status">
          مشاور به حسابِ از قبل فعال اختصاص داده شد.
        </p>
      )}
      {params.saved && (
        <p className="portal-alert success" role="status">
          حساب از مسیر مناسبِ وضعیت فیش فعال شد و مشاور اختصاص یافت.
        </p>
      )}

      <RegistrationDirectory audience="admin" />
    </DashboardShell>
  );
}
