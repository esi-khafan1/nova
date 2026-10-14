import Link from "next/link";
import Image from "next/image";
import { coursesFor, courseRegistrationPath, courseTypeLabel, courseDurationLabel } from "@/lib/courses";
import { studyFieldLabels, type StudyField } from "@/lib/study-catalog";
export function CourseCards({ grade, field }: { grade: number; field: string }) {
  return <div className="nova-course-grid" aria-label="دوره‌های مناسب پایه و رشتهٔ انتخاب‌شده">{coursesFor(grade, field).map(course => <article className="nova-course-card" key={`${course.course}-${course.months}`}>
    <Image unoptimized src={`/courses/${course.course}-${course.field}.svg`} alt={`${courseTypeLabel(course.course)} ویژهٔ ${studyFieldLabels[course.field as StudyField]}`} width={512} height={512} loading="lazy" />
    <div className="nova-course-body"><span>پایهٔ {course.grade.toLocaleString("fa-IR")} · {studyFieldLabels[course.field as StudyField]}</span><h3>{courseTypeLabel(course.course)}</h3><p className="nova-course-duration">{courseDurationLabel(course.months)}</p><Link className="nova-path-primary" href={courseRegistrationPath(course)}>انتخاب این دوره <span aria-hidden="true">←</span></Link></div>
  </article>)}</div>;
}
