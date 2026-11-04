import Link from "next/link";
import type { CurrentProfile } from "@/lib/auth";
import { studentCourseCatalogPath } from "@/lib/courses";

export function StudentServiceNotice({ status, grade, studyField }: {
  status: CurrentProfile["registration_status"];
  grade: CurrentProfile["grade"];
  studyField: CurrentProfile["study_field"];
}) {
  if (status === "active") return null;
  if (status === "disabled") return <section className="student-service-notice" role="status"><h2>خدمات حساب غیرفعال است</h2><p>برنامه‌ها، آزمون‌ها و گزارش‌های قبلی محفوظ‌اند اما تا فعال‌سازی دوباره توسط مدیر نمایش داده نمی‌شوند. برای پیگیری با پشتیبانی تماس بگیر.</p><div><Link className="button" href="/dashboard/student/account">اطلاعات حساب</Link><Link href="/contact">تماس با پشتیبانی</Link></div></section>;
  if (grade === 9) return <section className="student-service-notice" role="status"><h2>به پنل نووا خوش آمدی</h2><p>{status === "pending" ? "درخواست قبلی تو در انتظار بررسی مدیر است؛ برای پیگیری با پشتیبانی تماس بگیر." : "اطلاعات پایهٔ نهم را بدون انتخاب رشته در حساب کاربری تکمیل کن. برای فعال‌سازی خدمات با پشتیبانی هماهنگ کن؛ دورهٔ پولی پایهٔ نهم هنوز در فهرست سایت تعریف نشده است."}</p><div><Link className="button" href="/dashboard/student/account">تکمیل اطلاعات حساب</Link>{status === "pending" && <Link href="/dashboard/registration">مشاهده و اصلاح درخواست</Link>}<Link href="/contact">تماس با پشتیبانی</Link></div></section>;
  return <section className="student-service-notice" role="status"><h2>به پنل نووا خوش آمدی</h2><p>{status === "pending" ? "اطلاعات و فیشت ارسال شده و در انتظار تأیید مدیر است. می‌توانی بخش‌های پنل را ببینی؛ خدمات پولی بعد از تأیید فیش و تخصیص مشاور فعال می‌شوند." : "همهٔ بخش‌های پنل را می‌توانی ببینی. برای فعال‌شدن برنامهٔ اختصاصی و خدمات پولی، یک دوره انتخاب کن و اطلاعات و فیش واریزی را ارسال کن."}</p><div><Link className="button" href={studentCourseCatalogPath(grade, studyField)}>انتخاب دوره</Link>{status === "pending" && <Link href="/dashboard/registration">مشاهده و اصلاح درخواست</Link>}<Link href="/dashboard/student/account">تکمیل اطلاعات حساب</Link></div></section>;
}
