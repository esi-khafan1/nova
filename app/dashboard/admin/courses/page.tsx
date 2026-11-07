import Link from "next/link";
import {DashboardShell} from "@/components/dashboard/dashboard-shell";
import {CourseOfferForm} from "@/components/dashboard/course-offer-form";
import {loadCourseOffers} from "@/lib/load-course-offers";
import {requireSuperAdmin} from "@/lib/super-admin";
import {saveCourseReservation} from "./actions";
import "./settings.css";

export default async function CourseSettingsPage({searchParams}:{searchParams:Promise<Record<string,string|string[]|undefined>>}) {
  const {profile}=await requireSuperAdmin();
  const [offers,params]=await Promise.all([loadCourseOffers(),searchParams]);
  return <DashboardShell role="admin" name={profile.full_name}>
    <section className="portal-heading"><div><span>مدیریت نووا</span><h1>دوره‌ها</h1></div><Link href="/dashboard/admin">بازگشت</Link></section>
    {params.saved && <p role="status" className="portal-alert success">تنظیمات ثبت شد.</p>}
    {params.error && <p role="alert" className="portal-alert error">تنظیمات ثبت نشد؛ مقادیر را بررسی و دوباره تلاش کن.</p>}
    {!offers ? <p role="alert" className="portal-alert error">تنظیمات دوره‌ها دریافت نشد؛ صفحه را دوباره باز کن.</p> : <>
      <section className="portal-card"><h2>وضعیت دوره‌ها</h2><form action={saveCourseReservation} className="course-settings-status"><label>وضعیت همهٔ دوره‌ها<select name="reservation" defaultValue={offers[0].reservation?"reservation":"sale"}><option value="sale">ثبت‌نام</option><option value="reservation">رزرو</option></select></label><button className="button button-small">ثبت وضعیت</button></form></section>
      <section className="portal-card"><h2>تخفیف و قیمت دوره‌ها</h2><p>با تغییر درصد، قیمت ماهانه محاسبه می‌شود؛ می‌توانی مبلغ را هم اصلاح کنی. قیمت دوره‌های چندماهه برابر قیمت ماهانه ضرب‌در تعداد ماه‌هاست.</p>
        {([9,10,11,12] as const).map(grade=><section className="course-settings-grade" key={grade}><h3>پایهٔ {grade.toLocaleString("fa-IR")}</h3><div className="course-settings-grid">{offers.filter(offer=>offer.grade===grade).map(offer=><CourseOfferForm key={`${offer.grade}-${offer.plan}-${offer.discount_percent}-${offer.monthly_price}`} offer={offer}/>)}</div></section>)}
      </section>
    </>}
  </DashboardShell>;
}
