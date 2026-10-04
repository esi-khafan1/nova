"use client";

import { useId, useState } from "react";
import { saveExam } from "@/app/dashboard/exams/actions";
import { ExamPdfUpload } from "@/components/dashboard/exam-pdf-upload";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import { PersianTimePicker } from "@/components/dashboard/persian-time-picker";
import { addDays, toIsoDate, toPersianDigits } from "@/lib/persian-date";

type BookletItem = {
  id: string;
  title: string;
  pdfUrl: string;
  questionCount: number;
  durationMinutes: number;
  keyAnswers: Record<string, number>;
};

export function ExamBuilder() {
  const uid = useId();
  const [booklets, setBooklets] = useState<BookletItem[]>([
    {
      id: `${uid}-b1`,
      title: "دفترچه ۱",
      pdfUrl: "",
      questionCount: 20,
      durationMinutes: 30,
      keyAnswers: {},
    },
  ]);

  const today = toIsoDate(new Date());
  const [scheduledDate, setScheduledDate] = useState(toIsoDate(addDays(new Date(), 1)));
  const [scheduledTime, setScheduledTime] = useState("09:00");

  // Calculate question ranges for each booklet
  let currentStart = 1;
  const bookletRanges = booklets.map((b) => {
    const start = currentStart;
    const count = Math.max(1, Number(b.questionCount) || 1);
    const end = start + count - 1;
    currentStart = end + 1;
    return { start, end, count };
  });

  const totalQuestions = bookletRanges.reduce((acc, r) => acc + r.count, 0);
  const totalDuration = booklets.reduce((acc, b) => acc + (Number(b.durationMinutes) || 0), 0);

  const updateBooklet = (index: number, patch: Partial<BookletItem>) => {
    setBooklets((prev) =>
      prev.map((item, idx) => (idx === index ? { ...item, ...patch } : item)),
    );
  };

  const setQuestionKey = (
    bookletIndex: number,
    questionNumber: number,
    option: number,
  ) => {
    setBooklets((prev) =>
      prev.map((item, idx) => {
        if (idx !== bookletIndex) return item;
        const currentVal = item.keyAnswers[String(questionNumber)];
        const nextKeys = { ...item.keyAnswers };
        if (currentVal === option) {
          delete nextKeys[String(questionNumber)];
        } else {
          nextKeys[String(questionNumber)] = option;
        }
        return { ...item, keyAnswers: nextKeys };
      }),
    );
  };

  const addBooklet = () => {
    const nextIdx = booklets.length + 1;
    setBooklets((prev) => [
      ...prev,
      {
        id: `${uid}-b${Date.now()}`,
        title: `دفترچه ${nextIdx}`,
        pdfUrl: "",
        questionCount: 25,
        durationMinutes: 35,
        keyAnswers: {},
      },
    ]);
  };

  const removeBooklet = (index: number) => {
    if (booklets.length <= 1) return;
    setBooklets((prev) => prev.filter((_, idx) => idx !== index));
  };

  const allBookletsHavePdf = booklets.every((b) => Boolean(b.pdfUrl && b.pdfUrl.startsWith("https://")));

  return (
    <form action={saveExam} className="portal-card exam-builder">
      <input type="hidden" name="booklets" value={JSON.stringify(booklets)} />

      <div className="portal-card-title">
        <div>
          <span>آزمون کنکوری</span>
          <h2>ساخت آزمون دفترچه‌ای</h2>
        </div>
        <div className="exam-summary-pill">
          <span>{toPersianDigits(booklets.length)} دفترچه</span>
          <span>·</span>
          <span>{toPersianDigits(totalQuestions)} سؤال</span>
          <span>·</span>
          <span>{toPersianDigits(totalDuration)} دقیقه</span>
        </div>
      </div>

      <div className="exam-meta-grid">
        <label>
          عنوان آزمون
          <input
            name="title"
            required
            minLength={3}
            maxLength={160}
            placeholder="مثلاً شبیه‌ساز کنکور تجربی مرحله ۱"
          />
        </label>
        <label>
          مخاطبان
          <select name="audience" defaultValue="own_students">
            <option value="own_students">فقط دانش‌آموزان خودم</option>
            <option value="all_assigned_students">همه دانش‌آموزانی که مشاور دارند</option>
          </select>
        </label>
        <label>
          روز برگزاری
          <PersianDatePicker
            name="scheduled_date"
            value={scheduledDate}
            onChange={setScheduledDate}
            selectionMode="day"
            minDate={today}
          />
        </label>
        <label>
          ساعت شروع
          <PersianTimePicker
            name="scheduled_time"
            value={scheduledTime}
            onChange={setScheduledTime}
            minTime={
              scheduledDate === today
                ? new Date(Date.now() + 5 * 60_000).toTimeString().slice(0, 5)
                : undefined
            }
          />
        </label>
        <label className="exam-field-wide">
          توضیحات و راهنمای آزمون
          <textarea
            name="description"
            maxLength={3000}
            rows={2}
            placeholder="توضیحات کلی درباره شرایط آزمون، نمره منفی و ترتیب دفترچه‌ها..."
          />
        </label>
      </div>

      {/* Booklets Section */}
      <div className="exam-booklets-section">
        <div className="exam-booklets-heading">
          <div>
            <h3>دفترچه‌های آزمون</h3>
            <p>
              مانند کنکور سراسری، هر دفترچه شامل فایل سؤالات، تعداد سؤال و زمان‌بندی مستقل خود است.
            </p>
          </div>
        </div>

        <div className="exam-booklets-list">
          {booklets.map((booklet, bIndex) => {
            const range = bookletRanges[bIndex];
            const qList = Array.from(
              { length: range.count },
              (_, i) => range.start + i,
            );

            return (
              <article key={booklet.id} className="exam-booklet-card">
                <div className="exam-booklet-header">
                  <div className="exam-booklet-header-title">
                    <span className="exam-booklet-badge">
                      دفترچه {toPersianDigits(bIndex + 1)}
                    </span>
                    <span className="exam-booklet-range">
                      سؤالات {toPersianDigits(range.start)} تا {toPersianDigits(range.end)}
                    </span>
                    <span className="exam-booklet-time">
                      {toPersianDigits(booklet.durationMinutes)} دقیقه
                    </span>
                  </div>

                  {booklets.length > 1 && (
                    <button
                      type="button"
                      className="exam-booklet-delete"
                      onClick={() => removeBooklet(bIndex)}
                      title="حذف این دفترچه"
                    >
                      حذف دفترچه
                    </button>
                  )}
                </div>

                <div className="exam-booklet-fields">
                  <label>
                    عنوان دفترچه
                    <input
                      required
                      value={booklet.title}
                      onChange={(e) => updateBooklet(bIndex, { title: e.target.value })}
                      placeholder={`مثلاً دفترچه شماره ${bIndex + 1} - زیست‌شناسی`}
                      maxLength={160}
                    />
                  </label>
                  <label>
                    تعداد سؤالات این دفترچه
                    <input
                      required
                      type="number"
                      min={1}
                      max={200}
                      value={booklet.questionCount}
                      onChange={(e) =>
                        updateBooklet(bIndex, {
                          questionCount: Math.max(1, Math.min(200, Number(e.target.value) || 1)),
                        })
                      }
                    />
                  </label>
                  <label>
                    مدت پاسخگویی این دفترچه (دقیقه)
                    <select
                      value={booklet.durationMinutes}
                      onChange={(e) =>
                        updateBooklet(bIndex, {
                          durationMinutes: Number(e.target.value) || 30,
                        })
                      }
                    >
                      {[10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 75, 90, 120].map((m) => (
                        <option key={m} value={m}>
                          {toPersianDigits(m)} دقیقه
                        </option>
                      ))}
                    </select>
                  </label>
                </div>

                <div className="exam-booklet-upload">
                  <ExamPdfUpload
                    purpose="exam-question"
                    value={booklet.pdfUrl}
                    onChange={(url) => updateBooklet(bIndex, { pdfUrl: url })}
                    label={`فایل PDF سؤالات ${booklet.title}`}
                  />
                </div>

                {/* Answer Key Grid */}
                <details className="exam-key-accordion" open>
                  <summary>
                    <span>کلید سؤالات {toPersianDigits(range.start)} تا {toPersianDigits(range.end)} (تصحیح خودکار)</span>
                    <span className="exam-key-count">
                      {toPersianDigits(Object.keys(booklet.keyAnswers).length)} از {toPersianDigits(range.count)} تعیین شده
                    </span>
                  </summary>

                  <div className="exam-key-content">
                    <div className="exam-key-grid">
                      {qList.map((qNum) => {
                        const selectedOption = booklet.keyAnswers[String(qNum)];
                        return (
                          <div key={qNum} className="exam-key-item">
                            <span className="exam-key-num">{toPersianDigits(qNum)}</span>
                            <div className="exam-key-options">
                              {[1, 2, 3, 4].map((opt) => (
                                <button
                                  type="button"
                                  key={opt}
                                  className={`exam-key-btn ${selectedOption === opt ? "selected" : ""}`}
                                  onClick={() => setQuestionKey(bIndex, qNum, opt)}
                                >
                                  {toPersianDigits(opt)}
                                </button>
                              ))}
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                </details>
              </article>
            );
          })}
        </div>

        <button
          type="button"
          className="button secondary exam-add-booklet-btn"
          onClick={addBooklet}
        >
          + افزودن دفترچه جدید
        </button>
      </div>

      <div className="exam-actions">
        <button className="button secondary" name="status" value="draft">
          ذخیره پیش‌نویس
        </button>
        <button
          className="button"
          name="status"
          value="published"
          disabled={!allBookletsHavePdf}
          title={!allBookletsHavePdf ? "لطفاً ابتدا PDF تمام دفترچه‌ها را بارگذاری کنید" : undefined}
        >
          انتشار آزمون کنکوری
        </button>
      </div>
    </form>
  );
}

