"use client";

import { useId, useState, useTransition } from "react";
import { updateCounselorStudentStudy } from "@/app/dashboard/counselor/study-actions";
import { studyFieldLabels, type StudyField } from "@/lib/study-catalog";

type Student = { student_id: string; full_name: string; grade: number | null; study_field: StudyField | null };

export function CounselorStudentStudyEditor({ student }: { student: Student }) {
  const id = useId();
  const [grade, setGrade] = useState(String(student.grade ?? ""));
  const [field, setField] = useState(student.study_field ?? "");
  const [message, setMessage] = useState<{ error?: string; success?: boolean }>({});
  const [pending, startTransition] = useTransition();
  function save() {
    const data = new FormData();
    data.set("student_id", student.student_id);
    data.set("grade", grade);
    data.set("study_field", field);
    setMessage({});
    startTransition(async () => {
      try { setMessage(await updateCounselorStudentStudy(data)); }
      catch { setMessage({ error: "ذخیره انجام نشد؛ دوباره تلاش کن." }); }
    });
  }
  return <section className="portal-card plan-basics portal-form">
    <div className="portal-card-title"><div><span>اطلاعات تحصیلی</span><h2>پایه و رشتهٔ {student.full_name || "دانش‌آموز"}</h2></div></div>
    <p>پایه و رشته را ثبت یا اصلاح کن تا انتخاب درس‌ها برای برنامه‌ریزی آسان‌تر شود. برنامه‌ها و گزارش‌های قبلی تغییر نمی‌کنند.</p>
    <div className="plan-basics-grid">
      <label htmlFor={`${id}-grade`}>پایه<select id={`${id}-grade`} value={grade} disabled={pending} onChange={e => { setGrade(e.target.value); setMessage({}); }}>
        <option value="">انتخاب پایه</option>{[10,11,12].map(g => <option key={g} value={g}>{({10:"دهم",11:"یازدهم",12:"دوازدهم"})[g as 10|11|12]}</option>)}
      </select></label>
      <label htmlFor={`${id}-field`}>رشته<select id={`${id}-field`} value={field} disabled={pending} onChange={e => { setField(e.target.value as StudyField); setMessage({}); }}>
        <option value="">انتخاب رشته</option>{Object.entries(studyFieldLabels).map(([value,label]) => <option key={value} value={value}>{label}</option>)}
      </select></label>
    </div>
    <button type="button" className="button" disabled={pending || !grade || !field} onClick={save}>{pending ? "در حال ذخیره…" : "ثبت پایه و رشته"}</button>
    <div aria-live="polite">{message.error && <p className="portal-alert error" role="alert">{message.error}</p>}{message.success && <p className="portal-alert success">پایه و رشته ثبت شد.</p>}</div>
  </section>;
}
