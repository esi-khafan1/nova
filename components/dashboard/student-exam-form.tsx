"use client";

import { useEffect, useRef, useState } from "react";
import { submitExam } from "@/app/dashboard/exams/actions";
import { ExamPdfUpload } from "@/components/dashboard/exam-pdf-upload";

type Question = { id: string; prompt: string; options: string[]; sort_order: number };

export function StudentExamForm({
  examId,
  mode,
  pdfUrl,
  questions,
  endsAt,
}: {
  examId: string;
  mode: "multiple_choice" | "pdf";
  pdfUrl: string | null;
  questions: Question[];
  endsAt: string;
}) {
  const [answerPdfUrl, setAnswerPdfUrl] = useState("");
  const formRef = useRef<HTMLFormElement>(null);
  const autoSubmitRef = useRef<HTMLButtonElement>(null);
  const submittedRef = useRef(false);
  const [remainingSeconds, setRemainingSeconds] = useState(() =>
    Math.max(0, Math.ceil((new Date(endsAt).getTime() - Date.now()) / 1000)),
  );

  useEffect(() => {
    const timer = window.setInterval(() => {
      const remaining = Math.max(
        0,
        Math.ceil((new Date(endsAt).getTime() - Date.now()) / 1000),
      );
      setRemainingSeconds(remaining);
      if (remaining === 0 && !submittedRef.current) {
        submittedRef.current = true;
        formRef.current?.requestSubmit(autoSubmitRef.current ?? undefined);
      }
    }, 1000);
    return () => window.clearInterval(timer);
  }, [endsAt]);

  const minutes = Math.floor(remainingSeconds / 60);
  const seconds = remainingSeconds % 60;

  return (
    <form ref={formRef} action={submitExam} className="exam-take-form">
      <input type="hidden" name="exam_id" value={examId} />
      <input type="hidden" name="mode" value={mode} />
      <div className="exam-timer" role="timer" aria-live="polite">
        <span>زمان باقی‌مانده</span>
        <strong>{minutes.toLocaleString("fa-IR")}:{String(seconds).padStart(2, "0").replace(/\d/g, (digit) => "۰۱۲۳۴۵۶۷۸۹"[Number(digit)])}</strong>
      </div>
      {mode === "pdf" ? (
        <>
          {pdfUrl && <a className="button secondary" href={pdfUrl} target="_blank" rel="noreferrer">دریافت PDF سؤالات</a>}
          <input type="hidden" name="answer_pdf_url" value={answerPdfUrl} />
          <ExamPdfUpload purpose="exam-answer" value={answerPdfUrl} onChange={setAnswerPdfUrl} label="PDF پاسخ خود را بارگذاری کن" />
          <button className="button" disabled={!answerPdfUrl}>ارسال پاسخ PDF</button>
        </>
      ) : (
        <>
          <div className="exam-question-list">
            {questions.map((question, questionIndex) => (
              <fieldset className="exam-question-card" key={question.id}>
                <legend>سؤال {(questionIndex + 1).toLocaleString("fa-IR")}: {question.prompt}</legend>
                {question.options.map((option, optionIndex) => (
                  <label key={optionIndex}><input required type="radio" name={`answer_${question.id}`} value={optionIndex} />{option}</label>
                ))}
              </fieldset>
            ))}
          </div>
          <button className="button">ثبت پاسخ‌ها و پایان آزمون</button>
        </>
      )}
      <button
        ref={autoSubmitRef}
        type="submit"
        formNoValidate
        className="exam-auto-submit"
        aria-hidden="true"
        tabIndex={-1}
      />
    </form>
  );
}
