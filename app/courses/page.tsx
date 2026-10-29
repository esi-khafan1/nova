import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import { CourseCards } from "@/components/registration/course-cards";
import { courseDurations, courseFields, parseCourseContext } from "@/lib/courses";
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
          <p>پایه و رشته‌ات را انتخاب کن تا دوره‌های مناسب را ببینی.</p>
        </div>
      </section>
      <section className="container mag-content course-catalog-content" aria-labelledby="course-context-title">
        <h2 id="course-context-title">انتخاب پایه و رشته</h2>
        <form className="course-context-picker" action="/courses" method="get">
          <label><span>پایهٔ تحصیلی</span><select name="grade" defaultValue="" required>
            <option value="" disabled>انتخاب پایه</option>
            {[10, 11, 12].map(grade => <option key={grade} value={grade}>پایهٔ {grade.toLocaleString("fa-IR")}</option>)}
          </select></label>
          <label><span>رشتهٔ تحصیلی</span><select name="field" defaultValue="" required>
            <option value="" disabled>انتخاب رشته</option>
            {courseFields.map(field => <option key={field} value={field}>{studyFieldLabels[field]}</option>)}
          </select></label>
          <button className="course-cta-button" type="submit">مشاهدهٔ دوره‌ها</button>
        </form>
      </section>
    </main>
  );

  const gradeLabel = context.grade.toLocaleString("fa-IR");
  const fieldLabel = studyFieldLabels[context.field];
  const courseCount = availableCoursePlans.length * courseDurations.length;

  return (
    <main className="mag-shell course-catalog-shell">
      <section className="mag-hero course-catalog-hero">
        <div className="container">
          <div className="mag-hero-topline">
            <span className="mag-eyebrow">انتخاب اختصاصی نووا</span>
            <Link className="mag-home" href="/courses">
              <span aria-hidden="true">←</span>
              <span className="mag-desktop-label">بازگشت به انتخاب پایه و رشته</span>
              <span className="mag-mobile-label">بازگشت</span>
            </Link>
          </div>
          <h1>دوره‌های مناسب تو</h1>
          <p>برای پایهٔ {gradeLabel} و رشتهٔ {fieldLabel}، دو پلن پایه و پیشرفت را در چهار بازهٔ زمانی آماده کردیم. جزئیات هر پلن را ببین و انتخابی متناسب با نیازت داشته باش.</p>
          <div className="course-context-chips" aria-label="انتخاب‌های تو">
            <span>پایهٔ {gradeLabel}</span>
            <span>{fieldLabel}</span>
          </div>
        </div>
      </section>

      <section className="container mag-content course-catalog-content" aria-labelledby="course-catalog-title">
        <div className="mag-list-heading">
          <h2 id="course-catalog-title">پلن‌های پایه و پیشرفت نووا</h2>
          <span>{courseCount.toLocaleString("fa-IR")} انتخاب · {courseDurations.length.toLocaleString("fa-IR")} بازهٔ زمانی</span>
        </div>
        <CourseCards grade={context.grade} field={context.field} />
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
