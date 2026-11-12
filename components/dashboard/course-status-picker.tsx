"use client";

import { useEffect, useRef, useState } from "react";

const choices = [
  {value: "sale", label: "ثبت‌نام"},
  {value: "reservation", label: "رزرو"},
  {value: "sold_out", label: "تکمیل ظرفیت"},
] as const;
type CourseStatus = (typeof choices)[number]["value"];

export function CourseStatusPicker({initialStatus}: {initialStatus: CourseStatus}) {
  const [status, setStatus] = useState<CourseStatus>(initialStatus);
  const details = useRef<HTMLDetailsElement>(null);
  const summary = useRef<HTMLElement>(null);
  const current = choices.find(choice => choice.value === status)!;

  useEffect(() => {
    function closeOutside(event: PointerEvent) {
      if (details.current && !details.current.contains(event.target as Node)) details.current.open = false;
    }
    document.addEventListener("pointerdown", closeOutside);
    return () => document.removeEventListener("pointerdown", closeOutside);
  }, []);

  return <div className="course-status-picker">
    <span id="course-status-label">وضعیت همهٔ دوره‌ها</span>
    <details ref={details} className="course-status-menu" onKeyDown={event => {
      if (event.key === "Escape" && details.current?.open) {
        event.preventDefault(); details.current.open = false; summary.current?.focus();
      }
    }}>
      <summary ref={summary} aria-label={`وضعیت همهٔ دوره‌ها: ${current.label}`}>
        <span>{current.label}</span><span aria-hidden="true" className="course-status-chevron">⌄</span>
      </summary>
      <fieldset className="course-status-options" aria-labelledby="course-status-label">
        {choices.map(choice => <label key={choice.value} className="course-status-option">
          <input type="radio" name="reservation" value={choice.value} checked={status === choice.value}
            onChange={() => setStatus(choice.value)}
            onClick={() => { if (details.current) details.current.open = false; summary.current?.focus(); }} />
          <span>{choice.label}</span>
        </label>)}
      </fieldset>
    </details>
  </div>;
}
