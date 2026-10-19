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
          تخصیص انجام نشد؛ دانش‌آموز باید بدون مشاور باشد و مشاور انتخابی تأییدشده باشد. صفحه را تازه کن و دوباره بررسی کن.
        </p>
      ) : params.error ? (
        <p className="portal-alert error" role="alert">
          تأیید انجام نشد؛ اطلاعات و فیش باید کامل باشند و مشاور تأییدشده انتخاب شود. اگر فیش تغییر کرده، دوباره آن را بررسی کن.
        </p>
      ) : null}

      {params.assigned && (
        <p className="portal-alert success" role="status">
          مشاور اختصاص داده شد؛ وضعیت ثبت‌نام و خدمات دانش‌آموز تغییری نکرد.
        </p>
      )}
      {params.saved && (
        <p className="portal-alert success" role="status">
          حساب فعال و مشاور اختصاص داده شد.
        </p>
      )}

      <RegistrationDirectory audience="admin" />
    </DashboardShell>
  );
}
