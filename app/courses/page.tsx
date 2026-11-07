import { loadCourseOffers } from "@/lib/load-course-offers";
import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import { CourseCards } from "@/components/registration/course-cards";
import { courseDurations, parseCourseContext } from "@/lib/courses";
import { CourseContextPicker } from "@/components/registration/course-context-picker";
import { availableCoursePlans } from "@/lib/course-plans";
import { studyFieldLabels } from "@/lib/study-catalog";

export default async function CourseCatalogPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const params = await searchParams;
  const context = parseCourseContext(params);
  if (!context && (params.grade !== undefined || params.field !== undefined)) notFound();
  if (!context) return (
    <main className="mag-shell course-catalog-shell">
      <section className="mag-hero course-catalog-hero">
        <div className="container">
          <div className="mag-hero-topline"><span className="mag-eyebrow">انتخاب اختصاصی نووا</span></div>
          <h1>دوره‌های مناسب تو</h1>
          <p>پایه‌ات را انتخاب کن؛ از دهم به بعد رشته‌ات را هم مشخص کن تا دوره‌های مناسب را ببینی.</p>
        </div>
      </section>
      <section className="container mag-content course-catalog-content" aria-labelledby="course-context-title">
        <h2 id="course-context-title">انتخاب پایه و در صورت نیاز رشته</h2>
        <CourseContextPicker/>
      </section>
    </main>
  );

  const offers = await loadCourseOffers();
  const gradeLabel = context.grade.toLocaleString("fa-IR");
  const fieldLabel = context.field ? studyFieldLabels[context.field] : null;
  const courseCount = availableCoursePlans.length * courseDurations.length;

  return (
    <main className="mag-shell course-catalog-shell">
      <section className="mag-hero course-catalog-hero">
        <div className="container">
          <div className="mag-hero-topline">
            <span className="mag-eyebrow">انتخاب اختصاصی نووا</span>
            <Link className="mag-home" href="/courses">
              <span aria-hidden="true">←</span>
              <span className="mag-desktop-label">بازگشت به انتخاب پایه</span>
              <span className="mag-mobile-label">بازگشت</span>
            </Link>
          </div>
          <h1>دوره‌های مناسب تو</h1>
          <p>برای پایهٔ {gradeLabel}{fieldLabel && ` و رشتهٔ ${fieldLabel}`}، دو پلن پایه و پریمیوم را در چهار بازهٔ زمانی آماده کردیم. جزئیات هر پلن را ببین و انتخابی متناسب با نیازت داشته باش.</p>
          <div className="course-context-chips" aria-label="انتخاب‌های تو">
            <span>پایهٔ {gradeLabel}</span>
            {fieldLabel && <span>{fieldLabel}</span>}
          </div>
        </div>
      </section>

      <section className="container mag-content course-catalog-content" aria-labelledby="course-catalog-title">
        <div className="mag-list-heading">
          <h2 id="course-catalog-title">پلن‌های پایه و پریمیوم نووا</h2>
          <span>{courseCount.toLocaleString("fa-IR")} انتخاب · {courseDurations.length.toLocaleString("fa-IR")} بازهٔ زمانی</span>
        </div>
        <CourseCards grade={context.grade} field={context.field} offers={offers} />
      </section>

      <footer className="mag-footer">
        <div className="container course-catalog-footer">
          <Link href="/courses" className="course-change-selection">تغییر پایه یا رشته</Link>
          <Link href="/" className="mag-footer-brand" aria-label="صفحهٔ اصلی نووا">
            <Image src="/nova/mark.svg" alt="لوگوی N نووا" width={68} height={68} unoptimized />
          </Link>
          <p>مسیر تحصیلی روشن‌تر، با انتخابی متناسب با تو.</p>
        </div>
      </footer>
    </main>
  );
}
