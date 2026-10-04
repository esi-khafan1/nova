"use client";

import { useEffect, useRef, useState } from "react";
import { submitExam } from "@/app/dashboard/exams/actions";
import { toPersianDigits } from "@/lib/persian-date";
import type { ExamBooklet } from "@/lib/exams";
import { PdfViewer } from "@/components/dashboard/pdf-viewer";

export function StudentExamForm({
  examId,
  examTitle,
  booklets,
  studentName = "دانش‌آموز نووا",
}: {
  examId: string;
  examTitle: string;
  booklets: ExamBooklet[];
  studentName?: string;
}) {
  const formRef = useRef<HTMLFormElement>(null);
  const autoSubmitRef = useRef<HTMLButtonElement>(null);
  const storageKey = `nova_exam_${examId}`;

  const [currentBookletIndex, setCurrentBookletIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [bookletStartedAt, setBookletStartedAt] = useState<number>(Date.now());
  const [remainingSeconds, setRemainingSeconds] = useState<number>(0);
  const [focusedQ, setFocusedQ] = useState<number>(1);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [modalForTimeout, setModalForTimeout] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  const currentBooklet = booklets[currentBookletIndex] ?? booklets[0];

  // Load initial saved state from localStorage
  useEffect(() => {
    try {
      const saved = localStorage.getItem(storageKey);
      if (saved) {
        const parsed = JSON.parse(saved);
        if (parsed && typeof parsed === "object") {
          if (parsed.answers) setAnswers(parsed.answers);
          if (
            typeof parsed.bookletIndex === "number" &&
            parsed.bookletIndex < booklets.length
          ) {
            setCurrentBookletIndex(parsed.bookletIndex);
          }
          if (typeof parsed.bookletStartedAt === "number") {
            setBookletStartedAt(parsed.bookletStartedAt);
          }
        }
      } else {
        setBookletStartedAt(Date.now());
      }
    } catch {
      // ignore storage errors
    }
  }, [storageKey, booklets.length]);

  // Save state on change
  useEffect(() => {
    try {
      localStorage.setItem(
        storageKey,
        JSON.stringify({
          answers,
          bookletIndex: currentBookletIndex,
          bookletStartedAt,
        }),
      );
    } catch {
      // ignore storage errors
    }
  }, [storageKey, answers, currentBookletIndex, bookletStartedAt]);

  // Set initial focus to start of booklet
  useEffect(() => {
    if (currentBooklet) {
      setFocusedQ(currentBooklet.start_question_number);
    }
  }, [currentBooklet]);

  // Timer loop for the current booklet
  useEffect(() => {
    if (!currentBooklet || submitting) return;

    const durationSeconds = currentBooklet.duration_minutes * 60;
    const interval = window.setInterval(() => {
      const elapsed = Math.floor((Date.now() - bookletStartedAt) / 1000);
      const left = Math.max(0, durationSeconds - elapsed);
      setRemainingSeconds(left);

      if (left === 0) {
        window.clearInterval(interval);
        setModalForTimeout(true);
        setShowConfirmModal(true);
      }
    }, 1000);

    return () => window.clearInterval(interval);
  }, [currentBooklet, bookletStartedAt, submitting]);

  // Keyboard navigation
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (showConfirmModal || submitting || !currentBooklet) return;

      if (["1", "2", "3", "4"].includes(e.key)) {
        const choice = Number(e.key);
        toggleAnswer(focusedQ, choice);
      } else if (e.key === "ArrowDown") {
        e.preventDefault();
        if (focusedQ < currentBooklet.end_question_number) {
          setFocusedQ((prev) => prev + 1);
        }
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        if (focusedQ > currentBooklet.start_question_number) {
          setFocusedQ((prev) => prev - 1);
        }
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [focusedQ, currentBooklet, showConfirmModal, submitting]);

  const toggleAnswer = (questionNumber: number, option: number) => {
    setFocusedQ(questionNumber);
    setAnswers((prev) => {
      const qKey = String(questionNumber);
      const next = { ...prev };
      if (next[qKey] === option) {
        delete next[qKey];
      } else {
        next[qKey] = option;
      }
      return next;
    });
  };

  // Booklet questions & statistics
  const currentQuestions = currentBooklet
    ? Array.from(
        {
          length:
            currentBooklet.end_question_number -
            currentBooklet.start_question_number +
            1,
        },
        (_, i) => currentBooklet.start_question_number + i,
      )
    : [];

  const answeredInCurrentBooklet = currentQuestions.filter(
    (q) => answers[String(q)] !== undefined,
  ).length;

  const unansweredInCurrentBooklet =
    currentQuestions.length - answeredInCurrentBooklet;

  const progressPercent = currentQuestions.length
    ? Math.round((answeredInCurrentBooklet / currentQuestions.length) * 100)
    : 0;

  const isLastBooklet = currentBookletIndex === booklets.length - 1;

  const proceedToNextOrSubmit = () => {
    setShowConfirmModal(false);
    setModalForTimeout(false);

    if (!isLastBooklet) {
      const nextIdx = currentBookletIndex + 1;
      setCurrentBookletIndex(nextIdx);
      setBookletStartedAt(Date.now());
      if (booklets[nextIdx]) {
        setFocusedQ(booklets[nextIdx].start_question_number);
      }
    } else {
      // Final submit
      setSubmitting(true);
      try {
        localStorage.removeItem(storageKey);
      } catch {}
      formRef.current?.requestSubmit(autoSubmitRef.current ?? undefined);
    }
  };

  const minutes = Math.floor(remainingSeconds / 60);
  const seconds = remainingSeconds % 60;
  const isUrgent = remainingSeconds <= 300 && remainingSeconds > 0;

  return (
    <div className="exam-konkur-container">
      {/* Top Banner */}
      <div className="exam-konkur-topbar">
        <div className="exam-konkur-meta">
          <strong>{studentName}</strong>
          <span className="exam-meta-separator">|</span>
          <span>{examTitle}</span>
          <div className="exam-booklet-pill-badge">
            دفترچه {toPersianDigits(currentBookletIndex + 1)} از {toPersianDigits(booklets.length)}
            {currentBooklet?.title ? ` (${currentBooklet.title})` : ""}
          </div>
        </div>

        <div className={`exam-konkur-timer ${isUrgent ? "urgent" : ""}`}>
          <span className="exam-timer-label">زمان دفترچه</span>
          <strong dir="ltr">
            {toPersianDigits(minutes, 2)}:{toPersianDigits(seconds, 2)}
          </strong>
        </div>
      </div>

      {/* Main Grid: PDF Viewer + Answer Sheet */}
      <div className="exam-konkur-grid">
        {/* PDF Frame */}
        <div className="exam-pdf-container">
          {currentBooklet?.pdf_url ? (
            <PdfViewer
              key={currentBooklet.id || currentBooklet.pdf_url}
              url={currentBooklet.pdf_url}
              title={currentBooklet.title}
            />
          ) : (
            <div className="exam-pdf-placeholder">
              فایل سؤالات برای این دفترچه ثبت نشده است.
            </div>
          )}
        </div>

        {/* Answer Sheet Sidebar */}
        <aside className="exam-answersheet-panel">
          <div className="exam-answersheet-header">
            <h3>پاسخ‌برگ تستی</h3>
            <span className="exam-answersheet-progress-txt">
              {toPersianDigits(progressPercent)}٪
            </span>
          </div>

          <div className="exam-answersheet-progressbar">
            <div
              className="exam-answersheet-progressbar-fill"
              style={{ width: `${progressPercent}%` }}
            />
          </div>

          <div className="exam-answersheet-stats">
            <span>
              پاسخ داده شده: <strong>{toPersianDigits(answeredInCurrentBooklet)}</strong> از {toPersianDigits(currentQuestions.length)}
            </span>
          </div>

          <div className="exam-bubbles-list">
            {currentQuestions.map((qNum) => {
              const selectedChoice = answers[String(qNum)];
              const isAnswered = selectedChoice !== undefined;
              const isFocused = focusedQ === qNum;

              return (
                <div
                  key={qNum}
                  id={`qrow_${qNum}`}
                  className={`exam-bubble-row ${isAnswered ? "answered" : ""} ${isFocused ? "focused" : ""}`}
                  onClick={() => setFocusedQ(qNum)}
                >
                  <span className="exam-bubble-num">{toPersianDigits(qNum)}</span>
                  <div className="exam-bubble-options">
                    {[1, 2, 3, 4].map((opt) => (
                      <button
                        type="button"
                        key={opt}
                        className={`exam-bubble-btn ${selectedChoice === opt ? "selected" : ""}`}
                        onClick={(e) => {
                          e.stopPropagation();
                          toggleAnswer(qNum, opt);
                        }}
                      >
                        {toPersianDigits(opt)}
                      </button>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>

          <button
            type="button"
            className="button exam-next-booklet-btn"
            onClick={() => {
              setModalForTimeout(false);
              setShowConfirmModal(true);
            }}
          >
            {isLastBooklet ? "ثبت نهایی آزمون" : "ثبت و ورود به دفترچه بعدی"}
          </button>
        </aside>
      </div>

      {/* Hidden submission form */}
      <form ref={formRef} action={submitExam} className="hidden">
        <input type="hidden" name="exam_id" value={examId} />
        <input type="hidden" name="answers" value={JSON.stringify(answers)} />
        <button ref={autoSubmitRef} type="submit" />
      </form>

      {/* Modal Dialog for Transition or Finish */}
      {showConfirmModal && (
        <div className="exam-modal-overlay">
          <div className="exam-modal-box">
            <h3>
              {modalForTimeout
                ? "⏱️ پایان زمان دفترچه"
                : isLastBooklet
                  ? "تأیید پایان و ثبت نهایی آزمون"
                  : "تأیید تحویل دفترچه فعلی"}
            </h3>

            <div className="exam-modal-body">
              {modalForTimeout ? (
                <p>
                  زمان پاسخگویی به این دفترچه به پایان رسید. پاسخ‌های شما ثبت شده و اکنون وارد
                  مرحله بعد می‌شوید.
                </p>
              ) : (
                <>
                  <div className="exam-summary-row">
                    <span>تعداد کل سؤالات این دفترچه:</span>
                    <strong>{toPersianDigits(currentQuestions.length)}</strong>
                  </div>
                  <div className="exam-summary-row success">
                    <span>پاسخ داده شده:</span>
                    <strong>{toPersianDigits(answeredInCurrentBooklet)}</strong>
                  </div>
                  <div className="exam-summary-row warning">
                    <span>بدون پاسخ:</span>
                    <strong>{toPersianDigits(unansweredInCurrentBooklet)}</strong>
                  </div>

                  <p className="exam-modal-prompt">
                    {isLastBooklet
                      ? "آیا از ثبت نهایی تمام پاسخ‌ها و ارسال آزمون اطمینان دارید؟"
                      : "آیا می‌خواهید این دفترچه را تحویل داده و دفترچه بعدی را آغاز کنید؟ (پس از ورود به دفترچه بعد، امکان بازگشت به این دفترچه وجود نخواهد داشت)"}
                  </p>
                </>
              )}
            </div>

            <div className="exam-modal-actions">
              <button
                type="button"
                className="button"
                disabled={submitting}
                onClick={proceedToNextOrSubmit}
              >
                {submitting
                  ? "در حال ثبت نهایی..."
                  : isLastBooklet
                    ? "بله، ثبت نهایی آزمون"
                    : "بله، شروع دفترچه بعدی"}
              </button>

              {!modalForTimeout && !submitting && (
                <button
                  type="button"
                  className="button secondary"
                  onClick={() => setShowConfirmModal(false)}
                >
                  انصراف و ادامه
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

