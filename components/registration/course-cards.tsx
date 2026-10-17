"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useRef, useState, type MouseEvent as ReactMouseEvent, type PointerEvent } from "react";
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
  const drag = useRef<{ pointerId: number; startX: number; lastX: number; moved: boolean } | null>(null);
  const suppressClick = useRef(false);
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
      const nextLimits = {
        previous: first.right > viewport.right + 2,
        next: last.left < viewport.left - 2,
      };
      setLimits((current) => current.previous === nextLimits.previous && current.next === nextLimits.next ? current : nextLimits);
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

  function startDrag(event: PointerEvent<HTMLDivElement>) {
    if (event.pointerType !== "mouse" || event.button !== 0) return;
    if ((event.target as HTMLElement).closest("a, button")) return;
    drag.current = { pointerId: event.pointerId, startX: event.clientX, lastX: event.clientX, moved: false };
    event.currentTarget.setPointerCapture(event.pointerId);
    event.currentTarget.classList.add("is-dragging");
    event.preventDefault();
  }

  function dragTrack(event: PointerEvent<HTMLDivElement>) {
    const activeDrag = drag.current;
    const element = event.currentTarget;
    if (!activeDrag || activeDrag.pointerId !== event.pointerId) return;
    if (Math.abs(event.clientX - activeDrag.startX) > 4) activeDrag.moved = true;
    const delta = event.clientX - activeDrag.lastX;
    activeDrag.lastX = event.clientX;
    if (activeDrag.moved) {
      const direction = getComputedStyle(element).direction === "rtl" ? 1 : -1;
      element.scrollBy({ left: delta * direction, behavior: "auto" });
    }
  }

  function stopDrag(event: PointerEvent<HTMLDivElement>) {
    const activeDrag = drag.current;
    if (!activeDrag || activeDrag.pointerId !== event.pointerId) return;
    event.currentTarget.classList.remove("is-dragging");
    if (activeDrag.moved) {
      suppressClick.current = true;
      window.setTimeout(() => { suppressClick.current = false; }, 0);
    }
    drag.current = null;
  }

  function suppressDraggedClick(event: ReactMouseEvent<HTMLDivElement>) {
    if (!suppressClick.current) return;
    event.preventDefault();
    event.stopPropagation();
    suppressClick.current = false;
  }

  return (
    <section className="course-plan-carousel" aria-label={`${courses.length.toLocaleString("fa-IR")} دوره برای پایه ${grade.toLocaleString("fa-IR")} و رشتهٔ ${fieldLabel}`}>
      <div className="course-plan-viewport">
        <div
          ref={track}
          className="course-plan-grid"
          dir="rtl"
          role="list"
          tabIndex={0}
          aria-label="دوره‌ها؛ با لمس، کشیدن یا کلیدهای جهت‌دار پیمایش کنید"
          onPointerDown={startDrag}
          onPointerMove={dragTrack}
          onPointerUp={stopDrag}
          onPointerCancel={stopDrag}
          onClickCapture={suppressDraggedClick}
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
                    <span className="course-plan-context">پایهٔ {course.grade.toLocaleString("fa-IR")} · {fieldLabel}</span>
                    <span className="course-plan-duration">{courseDurationLabel(course.months)}</span>
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
