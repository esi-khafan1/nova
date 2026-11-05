"use client";

import { useEffect, useState } from "react";
import { cancelExamExtension, setExamExtension } from "@/app/dashboard/counselor/exams/actions";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import { PersianTimePicker } from "@/components/dashboard/persian-time-picker";
import { formatExamSchedule } from "@/lib/exams";
import { earliestExamSchedule, tehranDateTime, timeAfter, validWindowEnd } from "@/lib/exam-schedule";

type Extension = {
  starts_at: string;
  ends_at: string;
} | null;

function initialSchedule(extension: Extension, bounds: ReturnType<typeof earliestExamSchedule>, now: number) {
  if (extension) {
    const start = tehranDateTime(new Date(extension.starts_at));
    const end = tehranDateTime(new Date(extension.ends_at));
    // A past extension can be replaced, but the editor must never reopen on a
    // day/time that can no longer be selected.
    if (start.date >= bounds.date) {
      return {
        date: start.date,
        start: start.date === bounds.date && start.time < bounds.time ? bounds.time : start.time,
        end: end.time,
      };
    }
  }
  const tomorrow = tehranDateTime(new Date(now + 24 * 60 * 60 * 1000));
  return { date: tomorrow.date, start: "14:00", end: "18:00" };
}

export function ExamExtensionForm({
  examId,
  studentId,
  page,
  extension,
}: {
  examId: string;
  studentId: string;
  page: number;
  extension: Extension;
}) {
  const [clock, setClock] = useState(() => Date.now());
  const scheduleBounds = earliestExamSchedule(new Date(clock));
  const today = scheduleBounds.today;
  const [initial] = useState(() => initialSchedule(extension, scheduleBounds, clock));
  const [open, setOpen] = useState(Boolean(extension));
  const [date, setDate] = useState(initial.date);
  const [startTime, setStartTime] = useState(initial.start);
  const [endTime, setEndTime] = useState(initial.end);

  // Keep an open counselor form aligned with Tehran time, just like the
  // exam-designer schedule controls.
  useEffect(() => {
    const refresh = () => setClock(Date.now());
    const timer = window.setInterval(refresh, 15000);
    window.addEventListener("focus", refresh);
    document.addEventListener("visibilitychange", refresh);
    return () => {
      window.clearInterval(timer);
      window.removeEventListener("focus", refresh);
      document.removeEventListener("visibilitychange", refresh);
    };
  }, []);

  const todayHasTime = scheduleBounds.date === today;

  useEffect(() => {
    if (date === scheduleBounds.date && startTime < scheduleBounds.time) {
      setStartTime(scheduleBounds.time);
    }
  }, [date, startTime, scheduleBounds.date, scheduleBounds.time]);

  useEffect(() => {
    setEndTime(current => validWindowEnd(startTime, current));
  }, [startTime]);

  const changeDate = (nextDate: string) => {
    const bounds = earliestExamSchedule(new Date());
    setClock(Date.now());
    setDate(nextDate);
    if (nextDate === bounds.today && bounds.date === bounds.today) {
      setStartTime(bounds.time);
      setEndTime(current => validWindowEnd(bounds.time, current));
    }
  };

  const changeStart = (value: string) => {
    setStartTime(value);
    setEndTime(current => validWindowEnd(value, current));
  };

  return (
    <div className="exam-extension">
      {extension && (
        <p className="exam-extension-current">
          تمدید فعلی: شروع از {formatExamSchedule(extension.starts_at)} تا {formatExamSchedule(extension.ends_at)}
        </p>
      )}
      {!open && (
        <button
          type="button"
          className="button secondary"
          aria-expanded={open}
          onClick={() => setOpen(true)}
        >
          {extension ? "تغییر تمدید آزمون" : "تمدید آزمون"}
        </button>
      )}

      {open && (
        <>
          <form action={setExamExtension} className="exam-extension-form">
            <input type="hidden" name="exam_id" value={examId} />
            <input type="hidden" name="student_id" value={studentId} />
            <input type="hidden" name="page" value={page} />
            <label>
              <span>روز تمدید</span>
              <PersianDatePicker
                name="extension_date"
                value={date}
                onChange={changeDate}
                selectionMode="day"
                minDate={scheduleBounds.date}
                todayDate={today}
              />
            </label>
            <label>
              <span>شروع بازه از ساعت</span>
              <PersianTimePicker
                name="extension_start_time"
                value={startTime}
                onChange={changeStart}
                minTime={date === scheduleBounds.date ? scheduleBounds.time : undefined}
                disabled={date === today && !todayHasTime}
              />
            </label>
            <label>
              <span>پایان مهلت شروع</span>
              <PersianTimePicker
                name="extension_end_time"
                value={endTime}
                onChange={setEndTime}
                minTime={timeAfter(startTime, 1) ?? undefined}
                disabled={!timeAfter(startTime, 1)}
              />
            </label>
            <p>دانش‌آموز فقط در این بازه می‌تواند آزمون را شروع کند؛ پس از شروع، کل مدت آزمون را دارد.</p>
            <button type="submit" className="button">
              {extension ? "ثبت بازهٔ جدید تمدید" : "ثبت تمدید آزمون"}
            </button>
          </form>

          {extension && (
            <form action={cancelExamExtension} className="exam-extension-cancel">
              <input type="hidden" name="exam_id" value={examId} />
              <input type="hidden" name="student_id" value={studentId} />
              <input type="hidden" name="page" value={page} />
              <button type="submit" className="button secondary">لغو تمدید</button>
            </form>
          )}
        </>
      )}
    </div>
  );
}
