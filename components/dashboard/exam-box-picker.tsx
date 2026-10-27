"use client";

import { useMemo, useState } from "react";
import { formatPersianFullDate, parseIsoDate, toPersianDigits } from "@/lib/persian-date";

export type ExamBox = {
  item_id: string;
  plan_id: string;
  student_id: string;
  student_name: string;
  box_date: string;
  day_of_week: number;
  week_start: string;
  subject: string;
  chapter: string | null;
  duration_minutes: number;
  linked_exam_id: string | null;
  linked_exam_title: string | null;
  linked_exam_owned: boolean;
};

export function boxLabel(box: ExamBox) {
  try {
    return formatPersianFullDate(parseIsoDate(box.box_date));
  } catch {
    return box.box_date;
  }
}

export function ExamBoxPicker({
  boxes,
  selectedIds,
  onChange,
  examId,
  onPickDate,
}: {
  boxes: ExamBox[];
  selectedIds: string[];
  onChange: (ids: string[]) => void;
  examId?: string;
  onPickDate?: (isoDate: string) => void;
}) {
  const [query, setQuery] = useState("");
  const selected = useMemo(() => new Set(selectedIds), [selectedIds]);
  const pending = boxes.filter((box) => !box.linked_exam_id).length;
  const filtered = useMemo(() => {
    const needle = query.trim().toLocaleLowerCase("fa");
    if (!needle) return boxes;
    return boxes.filter((box) =>
      `${box.student_name} ${box.subject} ${box.chapter ?? ""} ${boxLabel(box)}`
        .toLocaleLowerCase("fa")
        .includes(needle),
    );
  }, [boxes, query]);

  const locked = (box: ExamBox) =>
    Boolean(box.linked_exam_id && box.linked_exam_id !== examId && !box.linked_exam_owned);
  const toggle = (box: ExamBox) => {
    if (locked(box)) return;
    onChange(
      selected.has(box.item_id)
        ? selectedIds.filter((id) => id !== box.item_id)
        : [...selectedIds, box.item_id],
    );
  };

  return (
    <section className="exam-box-picker" id="exam-boxes">
      <h3>باکسهای آزمون برنامهریزیشده</h3>
      <p>
        مشاورها فقط باکسهای «آزمون» را با روز و درس برای تو میفرستند؛ آزمون شبیهساز
        ارسال نمیشود. باکسهایی را انتخاب کن که این آزمون باید در برنامهٔ هفتگی و
        روزانهٔ همان دانشآموز باز شود. دانشآموزان دیگری را هم میتوانی از بخش
        «انتخاب دانشآموزها» به همین آزمون اضافه کنی.
      </p>
      <p className="exam-box-picker-count" aria-live="polite">
        {toPersianDigits(pending)} باکس بدون آزمون · {toPersianDigits(selected.size)} باکس انتخابشده
      </p>
      <label className="exam-box-picker-search">
        جستوجوی دانشآموز، درس یا تاریخ
        <input
          type="search"
          value={query}
          maxLength={100}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="مثلاً زیستشناسی یا نام دانشآموز…"
        />
      </label>
      <div className="exam-box-picker-list" aria-busy="false">
        {filtered.map((box) => {
          const isLocked = locked(box);
          const isSelected = selected.has(box.item_id);
          const linkedHere = Boolean(examId && box.linked_exam_id === examId);
          return (
            <article
              key={box.item_id}
              className={`exam-box-row${isSelected ? " is-selected" : ""}${isLocked ? " is-locked" : ""}`}
            >
              <label className="exam-box-row-main">
                <input
                  type="checkbox"
                  checked={isSelected}
                  disabled={isLocked}
                  onChange={() => toggle(box)}
                />
                <span className="exam-box-row-info">
                  <strong>{box.student_name}</strong>
                  <span>{boxLabel(box)}</span>
                  <span>
                    {box.subject}
                    {box.chapter ? ` · ${box.chapter}` : ""}
                    {` · ${toPersianDigits(box.duration_minutes)} دقیقه`}
                  </span>
                  {isLocked && (
                    <small>به آزمون «{box.linked_exam_title || "طراح دیگری"}» متصل است.</small>
                  )}
                  {linkedHere && !isSelected && <small>این باکس به آزمون حاضر متصل است.</small>}
                </span>
              </label>
              {onPickDate && (
                <button
                  type="button"
                  className="exam-box-row-date"
                  onClick={() => onPickDate(box.box_date)}
                  title="قراردادن تاریخ این باکس بهعنوان تاریخ آزمون"
                >
                  تنظیم تاریخ آزمون
                </button>
              )}
            </article>
          );
        })}
        {!filtered.length && (
          <p className="exam-box-picker-empty">
            {boxes.length ? "باکسی با این جستوجو پیدا نشد." : "فعلاً باکس آزمون تازهای ارسال نشده است."}
          </p>
        )}
      </div>
      {selected.size > 0 && (
        <p className="exam-box-picker-note" role="status">
          دانشآموزان این باکسها بدون نیاز به افزودن دستی، از همان جعبهٔ برنامه به
          آزمون دسترسی پیدا میکنند.
        </p>
      )}
    </section>
  );
}
