import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { RecoverySendButton } from "@/components/dashboard/recovery-send-button";
import { requireProfile } from "@/lib/auth";
import { sendRecoveryEmail } from "./actions";
import "./recovery.css";

type Account = { id: string; full_name: string; email: string | null; role: string };
export default async function PasswordRecoveryPage({ searchParams }: { searchParams: Promise<Record<string, string | undefined>> }) {
  const { supabase, profile } = await requireProfile(["admin"]);
  const params = await searchParams;
  const [{data:supers,error:superError},{data,error}]=await Promise.all([supabase.rpc("admin_list_super_admins"),supabase.rpc("admin_list_users")]);
  const superIds = new Set<string>((supers ?? []).map((row: { user_id: string }) => row.user_id));
  const isSuper = superIds.has(profile.id);
  const accounts = ((data ?? []) as Account[]).filter(account => account.email && (isSuper || !superIds.has(account.id)));
  return <DashboardShell role="admin" name={profile.full_name}>
    <section className="portal-heading"><div><span>مدیریت نووا</span><h1>بازیابی رمز عبور</h1><p>کاربر را انتخاب کن تا لینک تعیین رمز جدید برای ایمیل خودش ارسال شود.</p></div></section>
    {params.sent && <div className="portal-alert success" role="status">ایمیل بازیابی ارسال شد. کاربر با لینک ایمیل، رمز جدیدش را در صفحهٔ ورود تعیین می‌کند.</div>}
    {params.error && <div className="portal-alert error" role="alert">{params.error === "limit" ? "محدودیت ارسال فعال است. حداقل یک دقیقه صبر کن؛ ممکن است سهمیهٔ ساعتی هم پر شده باشد." : params.error === "target" ? "کاربر قابل انتخاب نیست یا اجازهٔ بازیابی این حساب را نداری." : "ارسال ایمیل انجام نشد؛ تنظیمات ایمیل و اتصال را بررسی کن."}</div>}
    <section className="portal-card recovery-card"><div className="portal-card-title"><div><span>ارسال امن</span><h2>ارسال لینک بازیابی</h2></div></div>
      <p>رمز فعلی نمایش داده نمی‌شود و مدیر رمز جدید را تعیین نمی‌کند. لینک فقط به ایمیل ثبت‌شدهٔ کاربر ارسال می‌شود.</p>
      {error || superError ? <p role="alert">دریافت کاربران انجام نشد؛ صفحه را دوباره بارگذاری کن.</p> : <form action={sendRecoveryEmail} className="recovery-send-form">
        <label htmlFor="recovery-user">انتخاب کاربر</label>
        <select id="recovery-user" name="user_id" defaultValue="" required disabled={!accounts.length}><option value="" disabled>نام و ایمیل کاربر را انتخاب کن</option>{accounts.map(account => <option key={account.id} value={account.id}>{account.full_name || "کاربر نووا"} — {account.email}</option>)}</select>
        <RecoverySendButton disabled={!accounts.length} />
      </form>}
      {!isSuper && <p className="recovery-note">می‌توانی برای همهٔ کاربران و مدیرها ارسال کنی؛ ارسال برای سوپرادمین‌ها فقط در اختیار سوپرادمین است.</p>}
    </section>
  </DashboardShell>;
}
