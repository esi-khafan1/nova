"use client";

import { useState } from "react";
import { saveExam } from "@/app/dashboard/exams/actions";
import { ExamPdfUpload } from "@/components/dashboard/exam-pdf-upload";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import { PersianTimePicker } from "@/components/dashboard/persian-time-picker";
import { addDays, toIsoDate } from "@/lib/persian-date";

type Question = { prompt: string; options: string[]; correctOption: number };
const blankQuestion = (): Question => ({ prompt: "", options: ["", "", "", ""], correctOption: 0 });

export function ExamBuilder() {
  const [mode, setMode] = useState<"multiple_choice" | "pdf">("multiple_choice");
  const [questions, setQuestions] = useState<Question[]>([blankQuestion()]);
  const [pdfUrl, setPdfUrl] = useState("");
  const today = toIsoDate(new Date());
  const [scheduledDate, setScheduledDate] = useState(toIsoDate(addDays(new Date(), 1)));
  const [scheduledTime, setScheduledTime] = useState("09:00");

  const updateQuestion = (index: number, patch: Partial<Question>) =>
    setQuestions((current) => current.map((question, itemIndex) => itemIndex === index ? { ...question, ...patch } : question));

  const updateOption = (questionIndex: number, optionIndex: number, value: string) =>
    setQuestions((current) => current.map((question, itemIndex) => itemIndex === questionIndex ? {
      ...question,
      options: question.options.map((option, index) => index === optionIndex ? value : option),
    } : question));

  return (
    <form action={saveExam} className="portal-card exam-builder">
      <input type="hidden" name="questions" value={JSON.stringify(mode === "multiple_choice" ? questions : [])} />
      <input type="hidden" name="question_pdf_url" value={mode === "pdf" ? pdfUrl : ""} />
      <div className="portal-card-title">
        <div><span>آزمون تازه</span><h2>ساخت آزمون</h2></div>
      </div>
      <div className="exam-meta-grid">
        <label>عنوان آزمون<input name="title" required minLength={3} maxLength={160} placeholder="مثلاً آزمون جمع‌بندی زیست" /></label>
        <label>نوع آزمون
          <select name="mode" value={mode} onChange={(event) => setMode(event.target.value as typeof mode)}>
            <option value="multiple_choice">تستی آنلاین</option>
            <option value="pdf">سؤالات PDF و پاسخ PDF</option>
          </select>
        </label>
        <label>مخاطبان
          <select name="audience" defaultValue="own_students">
            <option value="own_students">فقط دانش‌آموزان خودم</option>
            <option value="all_assigned_students">همه دانش‌آموزانی که مشاور دارند</option>
          </select>
        </label>
        <label>روز برگزاری
          <PersianDatePicker
            name="scheduled_date"
            value={scheduledDate}
            onChange={setScheduledDate}
            selectionMode="day"
            minDate={today}
          />
        </label>
        <label>ساعت شروع
          <PersianTimePicker
            name="scheduled_time"
            value={scheduledTime}
            onChange={setScheduledTime}
            minTime={scheduledDate === today ? new Date(Date.now() + 5 * 60_000).toTimeString().slice(0, 5) : undefined}
          />
        </label>
        <label>مدت آزمون
          <select name="duration_minutes" defaultValue="60">
            {[15, 30, 45, 60, 90, 120, 180].map((minutes) => (
              <option value={minutes} key={minutes}>{minutes.toLocaleString("fa-IR")} دقیقه</option>
            ))}
          </select>
        </label>
        <label className="exam-field-wide">توضیحات<textarea name="description" maxLength={3000} rows={3} placeholder="راهنمای کوتاه آزمون" /></label>
      </div>

      {mode === "multiple_choice" ? (
        <div className="exam-question-list">
          {questions.map((question, questionIndex) => (
            <article className="exam-question-editor" key={questionIndex}>
              <div className="exam-question-heading">
                <strong>سؤال {(questionIndex + 1).toLocaleString("fa-IR")}</strong>
                {questions.length > 1 && <button type="button" onClick={() => setQuestions((items) => items.filter((_, index) => index !== questionIndex))}>حذف سؤال</button>}
              </div>
              <textarea required value={question.prompt} onChange={(event) => updateQuestion(questionIndex, { prompt: event.target.value })} placeholder="متن سؤال" maxLength={1000} rows={2} />
              <div className="exam-options-editor">
                {question.options.map((option, optionIndex) => (
                  <label key={optionIndex}>
                    <input type="radio" name={`correct_${questionIndex}`} checked={question.correctOption === optionIndex} onChange={() => updateQuestion(questionIndex, { correctOption: optionIndex })} />
                    <input required value={option} onChange={(event) => updateOption(questionIndex, optionIndex, event.target.value)} placeholder={`گزینه ${(optionIndex + 1).toLocaleString("fa-IR")}`} maxLength={500} />
                  </label>
                ))}
              </div>
            </article>
          ))}
          <button className="button secondary" type="button" onClick={() => setQuestions((items) => [...items, blankQuestion()])}>افزودن سؤال</button>
        </div>
      ) : (
        <ExamPdfUpload purpose="exam-question" value={pdfUrl} onChange={setPdfUrl} label="فایل PDF سؤالات" />
      )}

      <div className="exam-actions">
        <button className="button secondary" name="status" value="draft">ذخیره پیش‌نویس</button>
        <button className="button" name="status" value="published" disabled={mode === "pdf" && !pdfUrl}>انتشار آزمون</button>
      </div>
    </form>
  );
}
