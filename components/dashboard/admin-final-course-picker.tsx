"use client";

import { useState } from "react";
import { availableCoursePlans } from "@/lib/course-plans";
import { courseDurations } from "@/lib/courses";

export function AdminFinalCoursePicker({ initialCourse = null, initialMonths = null }: {
  initialCourse?: string | null;
  initialMonths?: number | null;
}) {
  const [course, setCourse] = useState(initialCourse ?? "");
  return <div className="registration-final-course">
    <label className="registration-counselor-picker">
      <span>دورهٔ نهایی (اختیاری)</span>
      <select name="service_course_type" value={course} onChange={event => setCourse(event.target.value)}>
        <option value="">بدون دورهٔ اختصاص‌یافته</option>
        {availableCoursePlans.map(plan => <option key={plan.value} value={plan.value}>{plan.label}</option>)}
      </select>
    </label>
    <label className="registration-counselor-picker">
      <span>مدت دوره</span>
      <select name="service_course_duration_months" key={course || "none"}
        defaultValue={course ? String(initialCourse === course ? initialMonths ?? "" : "") : ""}
        required={Boolean(course)} disabled={!course} data-required-message="لطفاً مدت دوره را انتخاب کن">
        <option value="" disabled>انتخاب مدت</option>
        {courseDurations.map(duration => <option key={duration.value} value={duration.value}>{duration.label}</option>)}
      </select>
    </label>
    <small>درخواست دانش‌آموز فقط پیشنهاد است. اگر دوره را خالی بگذاری، هیچ دوره‌ای به حساب اختصاص نمی‌یابد؛ وضعیت فیش جداگانه بررسی می‌شود.</small>
  </div>;
}
