import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import { courseCatalogPath, courseDurationLabel, courseLandingPath, courseRegistrationPath, parseCourseSelection } from "@/lib/courses";
import { getCoursePlan } from "@/lib/course-plans";
import { studyFieldLabels } from "@/lib/study-catalog";

type PageProps = {
  params: Promise<{ grade: string; field: string; plan: string; months: string }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
};

async function getCourse(params: PageProps["params"]) {
  const route = await params;
  const selection = parseCourseSelection({ grade: route.grade, field: route.field, course: route.plan, months: route.months });
  if (!selection) return null;
  const plan = getCoursePlan(selection.course);
  if (!plan) return null;
  return { selection, plan };
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const course = await getCourse(params);
  if (!course) return { title: "دوره پیدا نشد | نووا" };
  return {
    title: `${course.plan.label} · ${courseDurationLabel(course.selection.months)} | نووا`,
    description: course.plan.summary,
  };
}

export default async function CourseDetailsPage({ params, searchParams }: PageProps) {
  const course = await getCourse(params);
  if (!course) notFound();

  const { selection, plan } = course;
  const query = await searchParams;
  const gradeLabel = selection.grade.toLocaleString("fa-IR");
  const fieldLabel = studyFieldLabels[selection.field];
  const context = { grade: selection.grade, field: selection.field };
  const backHref = query.return === "landing" ? courseLandingPath(context) : courseCatalogPath(context);
  const registrationHref = courseRegistrationPath(selection);

  return (
    <main className="mag-shell course-detail-shell">
      <article className="container article-page course-detail-page">
        <header className="course-detail-header">
          <div className="article-topline course-detail-topline">
            <div className="article-meta">
              <span>{plan.label}</span>
              <span>پایهٔ {gradeLabel}</span>
              <span>{fieldLabel}</span>
              <span>{courseDurationLabel(selection.months)}</span>
            </div>
            <Link className="article-back" href={backHref}>
              <span aria-hidden="true">← </span>
              <span className="mag-desktop-label">بازگشت به دوره‌ها</span>
              <span className="mag-mobile-label">بازگشت</span>
            </Link>
          </div>
          <h1>{plan.label}</h1>
          <p className="course-detail-tagline"><strong>{plan.tagline}</strong></p>
          <div className="course-detail-cover-wrap">
            <Image
              className="course-detail-cover"
              unoptimized
              src={`/courses/${plan.imageType}-${selection.field}.svg`}
              alt=""
              width={640}
              height={640}
              priority
            />
          </div>
        </header>

        <div className="article-rich-content course-detail-copy">
          {plan.paragraphs.map((paragraph) => <p key={paragraph}>{paragraph}</p>)}
          <h2>خدمات این پلن</h2>
          <ul>{plan.services.map((service) => <li key={service}>{service}</li>)}</ul>
          <aside className="course-suitable"><strong>مناسب برای:</strong> {plan.suitable}</aside>
          {plan.closing && <p className="course-plan-closing"><strong>{plan.closing}</strong></p>}
        </div>

        <section className="course-detail-cta" aria-labelledby="course-detail-cta-title">
          <div>
            <h2 id="course-detail-cta-title">آماده‌ای مسیرت رو شروع کنی؟</h2>
            <p>پلن و بازهٔ زمانی انتخاب‌شده برای پایهٔ {gradeLabel} و رشتهٔ {fieldLabel} ثبت می‌شود.</p>
          </div>
          <Link className="course-cta-button" href={registrationHref}>
            انتخاب و ثبت‌نام در این دوره <span aria-hidden="true">←</span>
          </Link>
        </section>
      </article>
    </main>
  );
}
