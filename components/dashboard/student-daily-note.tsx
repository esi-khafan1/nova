"use client";

import { useEffect, useState, useTransition } from "react";
import { saveStudentDailyNote } from "@/app/dashboard/actions";

export function StudentDailyNote({ day, initialNote, editable, onSaved }: {
  day: string; initialNote: string; editable: boolean;
  onSaved: (day: string, note: string) => void;
}) {
  const [text, setText] = useState(initialNote);
  const [status, setStatus] = useState<"idle"|"saved"|"error">("idle");
  const [pending, startTransition] = useTransition();
  useEffect(() => { setText(initialNote); setStatus("idle"); }, [day, initialNote]);
  if (!editable) return initialNote ? <section className="sp-daily-note"><h3>توضیحات تکمیلی دانش‌آموز برای این روز</h3><p>{initialNote}</p></section> : null;
  return <section className="sp-daily-note">
    <h3>توضیحات تکمیلی این روز</h3>
    <p>اگر نکته‌ای دربارهٔ کل این روز داری، اینجا برای مشاورت بنویس.</p>
    <label htmlFor={`daily-note-${day}`}>توضیحات روزانه (اختیاری)</label>
    <textarea id={`daily-note-${day}`} rows={3} maxLength={2000} value={text}
      onChange={event => { setText(event.target.value); setStatus("idle"); }}
      placeholder="مثلاً دلیل تغییر برنامه یا نکته‌ای که می‌خواهی مشاور بداند" />
    <div className="sp-daily-note-actions">
      <button className="button button-secondary" type="button" disabled={pending || text.trim() === initialNote}
        onClick={() => {
          const snapshot = text.trim();
          startTransition(async () => {
            try {
              const result = await saveStudentDailyNote(day, snapshot);
              if (!result.ok) throw new Error("Save failed");
              onSaved(day, snapshot);
              setStatus("saved");
            } catch { setStatus("error"); }
          });
        }}>{pending ? "در حال ذخیره…" : "ذخیره توضیحات"}</button>
      {status === "saved" && <small role="status">توضیحات این روز ذخیره شد و مشاور می‌تواند آن را ببیند.</small>}
      {status === "error" && <small role="alert">ذخیره انجام نشد؛ دوباره تلاش کن.</small>}
    </div>
  </section>;
}
