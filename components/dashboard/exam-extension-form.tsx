"use client";

import { useState } from "react";
import { cancelExamExtension, setExamExtension } from "@/app/dashboard/counselor/exams/actions";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import { PersianTimePicker } from "@/components/dashboard/persian-time-picker";
import { formatExamSchedule } from "@/lib/exams";
import { tehranDateTime, timeAfter, validWindowEnd } from "@/lib/exam-schedule";
import { tehranToday } from "@/lib/student-planning";

type Extension = {
  starts_at: string;
  ends_at: string;
} | null;

function initialSchedule(extension: Extension) {
  if (!extension) {
    const tomorrow = tehranDateTime(new Date(Date.now() + 24 * 60 * 60 * 1000));
    return { date: tomorrow.date, start: "14:00", end: "18:00" };
  }
  const start = tehranDateTime(new Date(extension.starts_at));
  const end = tehranDateTime(new Date(extension.ends_at));
  return { date: start.date, start: start.time, end: end.time };
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
  const initial = initialSchedule(extension);
  const [open, setOpen] = useState(Boolean(extension));
  const [date, setDate] = useState(initial.date);
  const [startTime, setStartTime] = useState(initial.start);
  const [endTime, setEndTime] = useState(initial.end);

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
      <button
        type="button"
        className="button secondary"
        aria-expanded={open}
        onClick={() => setOpen(current => !current)}
      >
        {extension ? "تغییر تمدید آزمون" : "تمدید آزمون"}
      </button>

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
                onChange={setDate}
                selectionMode="day"
                minDate={tehranToday()}
              />
            </label>
            <label>
              <span>شروع بازه از ساعت</span>
              <PersianTimePicker name="extension_start_time" value={startTime} onChange={changeStart} />
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
