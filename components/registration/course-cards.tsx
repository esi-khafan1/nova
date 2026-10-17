"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useId, useRef, useState } from "react";
import { courseDetailsPath, courseDurationLabel, coursesFor } from "@/lib/courses";
import { getCoursePlan } from "@/lib/course-plans";
import { studyFieldLabels } from "@/lib/study-catalog";

export function CourseCards({
  grade,
  field,
  returnTo = "catalog",
}: {
  grade: number;
  field: string;
  returnTo?: "catalog" | "landing";
}) {
  const track = useRef<HTMLDivElement>(null);
  const trackId = useId();
  const [limits, setLimits] = useState({ previous: false, next: true });
  const courses = coursesFor(grade, field);
  const fieldLabel = studyFieldLabels[field as keyof typeof studyFieldLabels];

  useEffect(() => {
    const element = track.current;
    if (!element) return;

    function updateLimits() {
      if (!element) return;
      const viewport = element.getBoundingClientRect();
      const cards = element.querySelectorAll<HTMLElement>(".course-plan-card");
      if (!cards.length) {
        setLimits({ previous: false, next: false });
        return;
      }
      const first = cards[0].getBoundingClientRect();
      const last = cards[cards.length - 1].getBoundingClientRect();
      setLimits({
        previous: first.right > viewport.right + 2,
        next: last.left < viewport.left - 2,
      });
    }

    updateLimits();
    element.addEventListener("scroll", updateLimits, { passive: true });
    const observer = new ResizeObserver(updateLimits);
    observer.observe(element);
    return () => {
      element.removeEventListener("scroll", updateLimits);
      observer.disconnect();
    };
  }, [grade, field]);

  function move(next: boolean) {
    const element = track.current;
    if (!element) return;
    const gap = Number.parseFloat(getComputedStyle(element).columnGap) || 0;
    const distance = element.clientWidth + gap;
    element.scrollBy({
      left: next ? -distance : distance,
      behavior: matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth",
    });
  }

  return (
    <section className="course-plan-carousel" aria-label={`${courses.length.toLocaleString("fa-IR")} دوره برای پایه ${grade.toLocaleString("fa-IR")} و رشتهٔ ${fieldLabel}`}>
      <div className="course-carousel-tools">
        <p>برای دیدن دوره‌های بعدی، به چپ اسکرول کن.</p>
        <div className="course-carousel-controls" aria-label="پیمایش دوره‌ها">
          <button type="button" aria-label="دوره‌های بعدی" aria-controls={trackId} disabled={!limits.next} onClick={() => move(true)}><span aria-hidden="true">←</span></button>
          <button type="button" aria-label="دوره‌های قبلی" aria-controls={trackId} disabled={!limits.previous} onClick={() => move(false)}><span aria-hidden="true">→</span></button>
        </div>
      </div>
      <div className="course-plan-viewport">
        <div
          ref={track}
          id={trackId}
          className="course-plan-grid"
          dir="rtl"
          role="list"
          tabIndex={0}
          aria-label="دوره‌ها، قابل پیمایش افقی"
          onKeyDown={(event) => {
            if (event.target !== event.currentTarget) return;
            if (event.key === "ArrowLeft") { event.preventDefault(); move(true); }
            if (event.key === "ArrowRight") { event.preventDefault(); move(false); }
          }}
        >
          {courses.map((course) => {
            const plan = getCoursePlan(course.course);
            if (!plan) return null;
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
                    <Link className="course-plan-details" href={courseDetailsPath(course, returnTo === "landing" ? "landing" : undefined)}>
                      جزئیات بیشتر <span aria-hidden="true">←</span>
                    </Link>
                  </div>
                </div>
              </article>
            );
          })}
        </div>
        <span className="course-plan-edge course-plan-edge--right" data-visible={limits.previous} aria-hidden="true" />
        <span className="course-plan-edge course-plan-edge--left" data-visible={limits.next} aria-hidden="true" />
      </div>
    </section>
  );
}
