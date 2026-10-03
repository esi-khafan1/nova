"use client";

import { useState } from "react";
import { submitExam } from "@/app/dashboard/exams/actions";
import { ExamPdfUpload } from "@/components/dashboard/exam-pdf-upload";

type Question = { id: string; prompt: string; options: string[]; sort_order: number };

export function StudentExamForm({ examId, mode, pdfUrl, questions }: { examId: string; mode: "multiple_choice" | "pdf"; pdfUrl: string | null; questions: Question[] }) {
  const [answerPdfUrl, setAnswerPdfUrl] = useState("");
  return (
    <form action={submitExam} className="exam-take-form">
      <input type="hidden" name="exam_id" value={examId} />
      <input type="hidden" name="mode" value={mode} />
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
    </form>
  );
}
