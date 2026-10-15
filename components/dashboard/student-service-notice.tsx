import Link from "next/link";
import type { CurrentProfile } from "@/lib/auth";
export function StudentServiceNotice({ status }: { status: CurrentProfile["registration_status"] }) {
  if (status === "active") return null;
  return <section className="student-service-notice" role="status"><h2>به پنل نووا خوش آمدی</h2><p>{status === "pending" ? "اطلاعات و فیشت ارسال شده و در انتظار تأیید مدیر است. می‌توانی بخش‌های پنل را ببینی؛ خدمات پولی بعد از تأیید فیش و تخصیص مشاور فعال می‌شوند." : "همهٔ بخش‌های پنل را می‌توانی ببینی. برای فعال‌شدن برنامهٔ اختصاصی و خدمات پولی، یک دوره انتخاب کن و اطلاعات و فیش واریزی را ارسال کن."}</p><div><Link className="button" href="/#find-path">انتخاب دوره</Link>{status === "pending" && <Link href="/dashboard/registration">مشاهده و اصلاح درخواست</Link>}<Link href="/dashboard/student/account">تکمیل اطلاعات حساب</Link></div></section>;
}
