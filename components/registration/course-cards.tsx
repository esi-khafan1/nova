import Image from "next/image";
import Link from "next/link";
import { courseDurationLabel, courseDetailsPath, coursesFor } from "@/lib/courses";
import { getCoursePlan } from "@/lib/course-plans";
import { studyFieldLabels } from "@/lib/study-catalog";

export function CourseCards({ grade, field }: { grade: number; field: string }) {
  const courses = coursesFor(grade, field);
  const fieldLabel = studyFieldLabels[field as keyof typeof studyFieldLabels];

  return (
    <div className="course-plan-grid" role="list" aria-label={`${courses.length.toLocaleString("fa-IR")} دوره برای پایه ${grade.toLocaleString("fa-IR")} و رشتهٔ ${fieldLabel}`}>
      {courses.map((course) => {
        const plan = getCoursePlan(course.course);
        if (!plan) return null;
        const detailsHref = courseDetailsPath(course);
        return (
          <article className="mag-card course-plan-card" role="listitem" key={`${course.course}-${course.months}`}>
            <Image
              className="course-plan-cover"
              unoptimized
              src={`/courses/${plan.imageType}-${course.field}.svg`}
              alt=""
              width={640}
              height={640}
              loading="lazy"
            />
            <div className="mag-card-body">
              <div className="mag-card-meta">
                <span>پایهٔ {course.grade.toLocaleString("fa-IR")} · {fieldLabel}</span>
                <span>{courseDurationLabel(course.months)}</span>
              </div>
              <h2>{plan.label}</h2>
              <p className="course-plan-tagline">{plan.tagline}</p>
              <p className="mag-card-summary course-plan-summary">{plan.summary}</p>
              <div className="mag-card-footer course-plan-footer">
                <Link className="course-plan-details" href={detailsHref}>
                  جزئیات بیشتر <span aria-hidden="true">←</span>
                </Link>
              </div>
            </div>
          </article>
        );
      })}
    </div>
  );
}
