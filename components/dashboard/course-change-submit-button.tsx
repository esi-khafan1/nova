"use client";

import { courseDurationLabel, courseTypeLabel } from "@/lib/courses";

function describe(course: FormDataEntryValue | null, months: FormDataEntryValue | null) {
  if (typeof course !== "string" || !course) return "بدون دورهٔ اختصاص‌یافته";
  return `${courseTypeLabel(course)} (${courseDurationLabel(Number(months))})`;
}

export function CourseChangeSubmitButton() {
  return <button type="submit" className="button button-secondary" onClick={event => {
    const form = event.currentTarget.form;
    if (!form || !form.reportValidity()) { event.preventDefault(); return; }
    const values = new FormData(form);
    const oldCourse = values.get("expected_service_course_type");
    const oldMonths = values.get("expected_service_course_duration_months");
    const newCourse = values.get("service_course_type");
    const newMonths = values.get("service_course_duration_months") ?? "";
    if (oldCourse === newCourse && oldMonths === newMonths) {
      window.alert("برای اصلاح، دوره یا مدت متفاوتی انتخاب کن.");
      event.preventDefault();
      return;
    }
    const message = `دورهٔ نهایی از «${describe(oldCourse, oldMonths)}» به «${describe(newCourse, newMonths)}» تغییر کند؟ وضعیت خدمات، مشاور، درخواست اولیه و فیش دست‌نخورده می‌مانند.`;
    if (!window.confirm(message)) event.preventDefault();
  }}>ثبت تغییر دوره</button>;
}
