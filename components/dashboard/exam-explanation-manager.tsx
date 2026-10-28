"use client";

import { useState } from "react";
import { ExamPdfUpload } from "@/components/dashboard/exam-pdf-upload";
import { saveExamExplanation } from "@/app/dashboard/exams/actions";

type Booklet = { id: string; title: string; explanation_pdf_url?: string | null };

function ExplanationBooklet({ examId, booklet }: { examId: string; booklet: Booklet }) {
  const [url, setUrl] = useState(booklet.explanation_pdf_url ?? "");
  return <form className="exam-booklet-card" action={saveExamExplanation}>
    <h3>{booklet.title}</h3>
    <input type="hidden" name="exam_id" value={examId} />
    <input type="hidden" name="booklet_id" value={booklet.id} />
    <input type="hidden" name="explanation_pdf_url" value={url} />
    <ExamPdfUpload purpose="exam-explanation" value={url} onChange={setUrl} label={`پاسخنامهٔ تشریحی PDF ${booklet.title}`} />
    <p>پس از بارگذاری، «ذخیره پاسخنامه» را بزن. فایل فقط پس از ثبت نهایی آزمون به دانش‌آموز نمایش داده می‌شود.</p>
    <button className="button" type="submit" disabled={!url || url === booklet.explanation_pdf_url}>ذخیره پاسخنامه</button>
  </form>;
}

export function ExamExplanationManager({ examId, booklets }: { examId: string; booklets: Booklet[] }) {
  return <section className="portal-card"><h2>پاسخنامه‌های تشریحی</h2><p>آزمون شروع‌شده قابل ویرایش نیست، اما می‌توانی پاسخنامهٔ تشریحی هر دفترچه را بارگذاری یا اصلاح کنی.</p><div className="exam-booklets-list">{booklets.map(booklet => <ExplanationBooklet key={booklet.id} examId={examId} booklet={booklet} />)}</div></section>;
}
