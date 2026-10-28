"use client";

import { useState } from "react";
import { PdfViewer } from "@/components/dashboard/pdf-viewer";
import { toPersianDigits } from "@/lib/persian-date";
import { filterReview, reviewCounts, type ExamReviewQuestion, type ReviewFilter } from "@/lib/exam-review";
import "./student-exam-review.css";

const labels = { all: "همه", correct: "درست", incorrect: "غلط", unanswered: "نزده", ungraded: "بررسی آماده نیست" };
const symbols = { correct: "✓", incorrect: "×", unanswered: "—", ungraded: "؟" };
export function StudentExamReview({ questions }: { questions: ExamReviewQuestion[] }) {
  const booklets = Array.from(new Map(questions.map(q => [q.booklet_id, { id: q.booklet_id, title: q.booklet_title, pdf: q.pdf_url, explanationPdf: q.explanation_pdf_url }])).values());
  const [bookletId, setBookletId] = useState(booklets[0]?.id ?? "");
  const [filter, setFilter] = useState<ReviewFilter>("all");
  const booklet = booklets.find(b => b.id === bookletId) ?? booklets[0];
  const bookletQuestions = questions.filter(q => q.booklet_id === booklet?.id);
  const counts = reviewCounts(bookletQuestions);
  const visible = filterReview(bookletQuestions, filter, booklet?.id ?? "");
  const reviewReady = bookletQuestions.every(q => q.correct_choice !== null && q.answer_status !== "ungraded");
  const filters: ReviewFilter[] = ["all", "correct", "incorrect", "unanswered"];
  return <section id="exam-review" className="exam-konkur-container student-exam-review" aria-labelledby="exam-review-title">
    <div className="exam-konkur-topbar review-heading">
      <div><span className="review-eyebrow">پاسخ‌ها ثبت شده‌اند · حالت فقط‌خواندنی</span><h2 id="exam-review-title">بررسی دفترچه و پاسخ‌برگ</h2><p>همان فایل PDF آزمون و انتخاب‌های ثبت‌شدهٔ تو؛ پاسخ‌ها قابل تغییر نیستند.</p></div>
      <label className="review-booklet-label">دفترچه<select aria-label="دفترچه" value={booklet?.id ?? ""} onChange={event => { setBookletId(event.target.value); setFilter("all"); }}>{booklets.map(b => <option key={b.id} value={b.id}>{b.title}</option>)}</select></label>
    </div>
    {booklet?.explanationPdf && <div className="review-explanation"><a href={booklet.explanationPdf} target="_blank" rel="noopener noreferrer">مشاهده و دریافت پاسخنامهٔ تشریحی {booklet.title} (PDF)</a></div>}
    <div className="exam-konkur-grid review-workspace">
      <div className="exam-pdf-container">{booklet?.pdf ? <PdfViewer key={booklet.id} url={booklet.pdf} title={booklet.title} /> : <p className="exam-pdf-placeholder">فایل دفترچه در دسترس نیست.</p>}</div>
      <aside className="exam-answersheet-panel review-answersheet" aria-label="پاسخ‌برگ ثبت‌شده">
        <div className="exam-answersheet-header"><h3>پاسخ‌برگ ثبت‌شده</h3><span>{toPersianDigits(counts.all)} سؤال</span></div>
        {reviewReady ? <>
        <p className="review-legend"><span className="review-legend-mine">● انتخاب شما</span><span className="review-legend-key">✓ گزینهٔ صحیح</span></p>
        <div className="review-filters" role="group" aria-label="فیلتر پاسخ‌برگ">{filters.map(status => <button key={status} type="button" aria-pressed={filter === status} className="review-filter" onClick={() => setFilter(status)}>{labels[status]} {toPersianDigits(counts[status])}</button>)}</div>
        <p className="review-visible-count" role="status">{toPersianDigits(visible.length)} سؤال در پاسخ‌برگ نمایش داده می‌شود؛ PDF کامل است.</p>
        <div className="exam-bubbles-list review-bubbles-list">
          {!visible.length && <p className="review-empty">سؤالی با این وضعیت در این دفترچه نیست.</p>}
          {visible.map(q => <div key={`${q.booklet_id}-${q.question_number}`} className={`exam-bubble-row review-bubble-row review-row--${q.answer_status}`} aria-label={`سؤال ${toPersianDigits(q.question_number)}، ${labels[q.answer_status]}، پاسخ شما ${q.student_choice === null ? "نزده" : toPersianDigits(q.student_choice)}، پاسخ صحیح ${q.correct_choice === null ? "نامشخص" : toPersianDigits(q.correct_choice)}`}>
            <span className="exam-bubble-num">{toPersianDigits(q.question_number)}</span>
            <div className="exam-bubble-options">{[1,2,3,4].map(opt => <span key={opt} className={`review-bubble ${q.student_choice === opt ? "is-mine" : ""} ${q.correct_choice === opt ? "is-key" : ""} ${q.student_choice === opt && q.answer_status === "incorrect" ? "is-wrong" : ""}`} aria-hidden="true"><span>{toPersianDigits(opt)}</span>{q.correct_choice === opt && <span className="review-key-mark">✓</span>}</span>)}</div>
            <span className="review-row-status"><span aria-hidden="true">{symbols[q.answer_status]}</span> {labels[q.answer_status]}</span>
          </div>)}
        </div>
        </> : <p className="review-unavailable" role="status">بررسی این دفترچه فعلاً آماده نیست. لطفاً با مشاور تماس بگیر.</p>}
        <p className="review-readonly-note">برای پیدا کردن سؤال از شمارهٔ آن و ابزارهای PDF استفاده کن.</p>
      </aside>
    </div>
  </section>;
}
