"use client";
import { useState } from "react";
import { courseFields } from "@/lib/courses";
import { studyFieldLabels } from "@/lib/study-catalog";

export function CourseContextPicker() {
  const [grade, setGrade] = useState("");
  return <form className="course-context-picker" action="/courses" method="get">
    <label><span>پایهٔ تحصیلی</span><select name="grade" value={grade} onChange={event => setGrade(event.target.value)} required>
      <option value="" disabled>انتخاب پایه</option>
      {[9, 10, 11, 12].map(value => <option key={value} value={value}>پایهٔ {value.toLocaleString("fa-IR")}</option>)}
    </select></label>
    {grade !== "9" && <label><span>رشتهٔ تحصیلی</span><select name="field" defaultValue="" required>
      <option value="" disabled>انتخاب رشته</option>
      {courseFields.map(field => <option key={field} value={field}>{studyFieldLabels[field]}</option>)}
    </select></label>}
    <button className="course-cta-button" type="submit">مشاهدهٔ دوره‌ها</button>
  </form>;
}
