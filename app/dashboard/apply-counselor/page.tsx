import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { applyForCounselor } from "@/app/dashboard/actions";
import { requireProfile } from "@/lib/auth";
export default async function ApplyCounselor({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  const { supabase, profile } = await requireProfile(["student"]),
    params = await searchParams;
  const { data: a } = await supabase
    .from("counselor_profiles")
    .select("headline,specialty,experience_years,approval_status")
    .eq("user_id", profile.id)
    .maybeSingle();
  return (
    <DashboardShell role="student" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <span>همکاری با نووا</span>
          <h1>درخواست مشاورشدن</h1>
          <p>
            اطلاعات تخصصی‌ات را ثبت کن؛ مدیر پس از بررسی نتیجه را اعلام می‌کند.
          </p>
        </div>
      </section>
      {params.sent && (
        <div className="portal-alert success">
          درخواستت ثبت شد و در انتظار بررسی است.
        </div>
      )}
      {params.error && (
        <div className="portal-alert error">ثبت درخواست انجام نشد.</div>
      )}
      {a && (
        <div className={`application-status ${a.approval_status}`}>
          <strong>
            وضعیت:{" "}
            {a.approval_status === "pending"
              ? "در انتظار بررسی"
              : a.approval_status === "approved"
                ? "تأییدشده"
                : "ردشده"}
          </strong>
          <span>تا اعلام نتیجه می‌توانی اطلاعات را ویرایش کنی.</span>
        </div>
      )}
      <section className="portal-card portal-wide">
        <form action={applyForCounselor} className="portal-form">
          <label>
            عنوان حرفه‌ای
            <input
              name="headline"
              defaultValue={a?.headline ?? ""}
              placeholder="مثلاً مشاور تخصصی رشته تجربی"
              required
              minLength={5}
            />
          </label>
          <fieldset className="specialty-field">
            <legend>حوزه تخصص</legend>
            <div className="specialty-options">
              {[
                "رشته تجربی",
                "رشته ریاضی",
                "رشته انسانی",
                "امتحانات نهایی",
                "برنامه‌ریزی تحصیلی",
              ].map((specialty) => (
                <label key={specialty}>
                  <input
                    type="radio"
                    name="specialty"
                    value={specialty}
                    defaultChecked={a?.specialty === specialty}
                    required
                  />
                  <span>{specialty}</span>
                </label>
              ))}
            </div>
          </fieldset>
          <label>
            سابقه مشاوره (سال)
            <input
              name="experience_years"
              type="number"
              min="0"
              max="50"
              defaultValue={a?.experience_years ?? 0}
            />
          </label>
          <button className="button">ثبت درخواست برای بررسی</button>
        </form>
      </section>
    </DashboardShell>
  );
}
