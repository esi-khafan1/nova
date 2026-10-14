"use client";
import Link from "next/link";
import Image from "next/image";
import { useEffect, useId, useRef, useState } from "react";
import { coursesFor, courseRegistrationPath, courseTypeLabel, courseDurationLabel } from "@/lib/courses";
import { studyFieldLabels, type StudyField } from "@/lib/study-catalog";
export function CourseCards({ grade, field }: { grade: number; field: string }) {
  const track = useRef<HTMLDivElement>(null);
  const trackId = useId();
  const hintId = useId();
  const [limits, setLimits] = useState({ previous: false, next: true });
  useEffect(() => {
    const element = track.current;
    if (!element) return;
    function update() {
      if (!element) return;
      const maximum = Math.max(0, element.scrollWidth - element.clientWidth);
      const position = Math.min(maximum, Math.abs(element.scrollLeft));
      setLimits({ previous: position > 2, next: position < maximum - 2 });
    }
    update();
    element.addEventListener("scroll", update, { passive: true });
    const observer = new ResizeObserver(update);
    observer.observe(element);
    return () => { element.removeEventListener("scroll", update); observer.disconnect(); };
  }, [grade, field]);
  function move(next: boolean) {
    const element = track.current;
    if (!element) return;
    const gap = parseFloat(getComputedStyle(element).columnGap) || 0;
    element.scrollBy({ left: (next ? -1 : 1) * (element.clientWidth + gap), behavior: matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth" });
  }
  return <section className="nova-course-carousel" aria-label="دوره‌های مناسب پایه و رشتهٔ انتخاب‌شده">
    <div ref={track} id={trackId} className="nova-course-grid" dir="rtl" tabIndex={0} role="region" aria-label="۹ دوره، قابل پیمایش افقی" aria-describedby={hintId} onKeyDown={event => {
      if (event.target !== event.currentTarget) return;
      if (event.key === "ArrowLeft" || event.key === "ArrowRight") { event.preventDefault(); move(event.key === "ArrowLeft"); }
    }}>{coursesFor(grade, field).map(course => <article className="nova-course-card" key={`${course.course}-${course.months}`} data-duration={course.months}>
      <Image unoptimized src={`/courses/${course.course}-${course.field}.svg`} alt={`${courseTypeLabel(course.course)} ویژهٔ ${studyFieldLabels[course.field as StudyField]}`} width={512} height={512} loading="lazy" />
      <div className="nova-course-body"><span>پایهٔ {course.grade.toLocaleString("fa-IR")} · {studyFieldLabels[course.field as StudyField]}</span><h3>{courseTypeLabel(course.course)}</h3><p className="nova-course-duration">{courseDurationLabel(course.months)}</p><Link className="nova-path-primary" href={courseRegistrationPath(course)}>انتخاب دوره <span aria-hidden="true">←</span></Link></div>
    </article>)}</div>
    <div className="nova-course-scroll-tools"><p id={hintId}>برای دیدن بقیهٔ دوره‌ها، افقی ورق بزن.</p><div><button type="button" aria-label="دوره‌های قبلی" aria-controls={trackId} disabled={!limits.previous} onClick={() => move(false)}><span aria-hidden="true">→</span></button><button type="button" aria-label="دوره‌های بعدی" aria-controls={trackId} disabled={!limits.next} onClick={() => move(true)}><span aria-hidden="true">←</span></button></div></div>
  </section>;
}
