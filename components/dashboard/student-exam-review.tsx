"use client";

import { useState } from "react";
import { toPersianDigits } from "@/lib/persian-date";
import { filterReview, reviewCounts, type ExamReviewQuestion, type ReviewFilter } from "@/lib/exam-review";
import "./student-exam-review.css";

const labels = { all: "همه", correct: "درست", incorrect: "غلط", unanswered: "نزده", ungraded: "کلید نامشخص" };
const symbols = { correct: "✓", incorrect: "×", unanswered: "—", ungraded: "؟" };
export function StudentExamReview({ questions }: { questions: ExamReviewQuestion[] }) {
  const [filter, setFilter] = useState<ReviewFilter>("all");
  const [bookletId, setBookletId] = useState("all");
  const counts = reviewCounts(questions);
  const booklets = Array.from(new Map(questions.map(q => [q.booklet_id, { id: q.booklet_id, title: q.booklet_title, pdf: q.pdf_url }])).values());
  const visible = filterReview(questions, filter, bookletId);
  const filters: ReviewFilter[] = ["all", "correct", "incorrect", "unanswered", ...(counts.ungraded ? ["ungraded" as const] : [])];
  return <section id="exam-review" className="portal-card student-exam-review" aria-labelledby="exam-review-title">
    <div className="review-heading"><div><span className="review-eyebrow">بعد از آزمون، یک قدم روشن‌تر</span><h2 id="exam-review-title">بررسی پاسخ‌های آزمون</h2><p>انتخاب ثبت‌شدهٔ خودت را با پاسخ صحیح مقایسه کن. پاسخ‌ها در این بخش قابل تغییر نیستند.</p></div>
      <label className="review-booklet-label">دفترچه<select value={bookletId} onChange={event => setBookletId(event.target.value)}><option value="all">همهٔ دفترچه‌ها</option>{booklets.map(b => <option key={b.id} value={b.id}>{b.title}</option>)}</select></label>
    </div>
    <div className="review-filters" role="group" aria-label="فیلتر وضعیت پاسخ‌ها">{filters.map(status => <button key={status} type="button" aria-pressed={filter === status} className={`review-filter review-filter--${status}`} onClick={() => setFilter(status)}>{labels[status]}<span>{toPersianDigits(counts[status])}</span></button>)}</div>
    <p className="review-visible-count" role="status">{toPersianDigits(visible.length)} سؤال نمایش داده می‌شود</p>
    {counts.ungraded > 0 && <p className="review-note">برای بعضی سؤال‌ها کلید معتبر ثبت نشده؛ آن‌ها را درست یا غلط حساب نکرده‌ایم. تعداد «نزده» فقط پاسخ‌های خالی است و ممکن است با کارنامهٔ قدیمی تفاوت داشته باشد.</p>}
    {!visible.length ? <p className="review-empty">در این فیلتر سؤالی وجود ندارد.</p> : booklets.map(booklet => {
      const items = visible.filter(q => q.booklet_id === booklet.id);
      if (!items.length) return null;
      const safePdf = booklet.pdf.startsWith("https://") ? booklet.pdf : null;
      return <div className="review-booklet" key={booklet.id}><div className="review-booklet-heading"><h3>{booklet.title}</h3>{safePdf && <a href={safePdf} target="_blank" rel="noopener noreferrer">مشاهدهٔ دفترچهٔ سؤالات ↗</a>}</div>
        <div className="review-question-grid">{items.map(question => <article key={`${question.booklet_id}-${question.question_number}`} className={`review-question review-question--${question.answer_status}`} aria-label={`سؤال ${toPersianDigits(question.question_number)}، ${labels[question.answer_status]}`}>
          <div className="review-question-heading"><h4>سؤال {toPersianDigits(question.question_number)}</h4><span className="review-status"><span aria-hidden="true">{symbols[question.answer_status]}</span>{labels[question.answer_status]}</span></div>
          <dl><div><dt>پاسخ شما</dt><dd>{question.student_choice === null ? "نزده" : `گزینهٔ ${toPersianDigits(question.student_choice)}`}</dd></div><div><dt>پاسخ صحیح</dt><dd>{question.correct_choice === null ? "ثبت نشده" : `گزینهٔ ${toPersianDigits(question.correct_choice)}`}</dd></div></dl>
        </article>)}</div>
      </div>;
    })}
  </section>;
}
