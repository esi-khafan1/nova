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

      {params.error === "upload" ? (
        <p className="portal-alert error" role="alert">
          ثبت فیش انجام نشد. عکس باید JPG، PNG یا WebP و حداکثر ۵ مگابایت باشد؛ حساب دانش‌آموز باید اطلاعات کامل و راه تماس تأییدشده داشته باشد. اگر فیش تغییر کرده، صفحه را تازه کن.
        </p>
      ) : params.error === "assignment" ? (
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
      {params.uploaded && (
        <p className="portal-alert success" role="status">
          فیش در پروندهٔ دانش‌آموز ثبت شد؛ برای فعال‌سازی، فیش را بررسی کن و مشاور تأییدشده را انتخاب کن.
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
