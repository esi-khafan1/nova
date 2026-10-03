"use client";

import { useEffect, useRef, useState } from "react";
import {
  addDays,
  formatPersianFullDate,
  formatPersianMonthYear,
  formatPersianWeekRange,
  parseIsoDate,
  persianNumber,
  persianParts,
  toIsoDate,
} from "@/lib/persian-date";

function startOfPersianMonth(anchor: Date) {
  let date = new Date(anchor);
  for (let step = 0; step < 32; step += 1) {
    if (persianParts(date).day === 1) return date;
    date = addDays(date, -1);
  }
  return date;
}

function sameDay(first: Date, second: Date) {
  return toIsoDate(first) === toIsoDate(second);
}

function startOfDay(date: Date) {
  return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 12);
}

export function PersianDatePicker({
  name,
  value,
  onChange,
  plannedWeeks = {},
  selectionMode = "week",
  minDate,
}: {
  name: string;
  value: string;
  onChange: (value: string) => void;
  plannedWeeks?: Record<string, "draft" | "published">;
  selectionMode?: "week" | "day";
  minDate?: string;
}) {
  const selected = parseIsoDate(value);
  const today = startOfDay(new Date());
  const currentWeekStart = addDays(today, -((today.getDay() + 1) % 7));
  const selectedRangeEnd =
    selectionMode === "week" ? addDays(selected, 6) : selected;
  const minimumDate = minDate ? startOfDay(parseIsoDate(minDate)) : today;
  const [monthAnchor, setMonthAnchor] = useState(selected);
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setOpen(false);
      }
    };
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "Escape") setOpen(false);
    };
    document.addEventListener("mousedown", handleClickOutside);
    document.addEventListener("keydown", handleKeyDown);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
      document.removeEventListener("keydown", handleKeyDown);
    };
  }, [open]);

  const monthStart = startOfPersianMonth(monthAnchor);
  const month = persianParts(monthStart);
  const saturdayOffset = (monthStart.getDay() + 1) % 7;
  const gridStart = addDays(monthStart, -saturdayOffset);
  const days = Array.from({ length: 42 }, (_, index) =>
    addDays(gridStart, index),
  );

  const moveMonth = (direction: -1 | 1) => {
    const destination =
      direction === 1 ? addDays(monthStart, 35) : addDays(monthStart, -1);
    setMonthAnchor(destination);
  };

  return (
    <div className="persian-date-picker" ref={containerRef}>
      <input type="hidden" name={name} value={value} />
      <button
        type="button"
        className="persian-date-trigger"
        aria-expanded={open}
        onClick={() => setOpen((current) => !current)}
      >
        <span>
          {selectionMode === "week"
            ? formatPersianWeekRange(selected)
            : formatPersianFullDate(selected)}
        </span>
        <svg aria-hidden="true" viewBox="0 0 20 20">
          <path d="m5 7.5 5 5 5-5" />
        </svg>
      </button>

      {open && (
        <div className="persian-calendar" role="dialog" aria-label="تقویم شمسی">
          <header>
            <button
              type="button"
              aria-label="ماه بعد"
              onClick={() => moveMonth(1)}
            >
              ‹
            </button>
            <strong>{formatPersianMonthYear(monthStart)}</strong>
            <button
              type="button"
              aria-label="ماه قبل"
              onClick={() => moveMonth(-1)}
            >
              ›
            </button>
          </header>
          <div className="persian-calendar-weekdays" aria-hidden="true">
            {[
              "شنبه",
              "یکشنبه",
              "دوشنبه",
              "سه‌شنبه",
              "چهارشنبه",
              "پنجشنبه",
              "جمعه",
            ].map((day) => (
              <span key={day}>{day}</span>
            ))}
          </div>
          <div className="persian-calendar-days">
            {days.map((date) => {
              const parts = persianParts(date);
              const isCurrentMonth =
                parts.year === month.year && parts.month === month.month;
              const isSelected = sameDay(date, selected);
              const isSaturday = date.getDay() === 6;
              const weekStatus = isSaturday
                ? plannedWeeks[toIsoDate(date)]
                : undefined;
              const isToday = sameDay(date, today);
              const isInSelectedWeek =
                selectionMode === "week" &&
                date >= selected &&
                date <= selectedRangeEnd;
              const isDisabled =
                selectionMode === "week"
                  ? !isSaturday || startOfDay(date) < currentWeekStart
                  : startOfDay(date) < minimumDate;
              return (
                <button
                  type="button"
                  key={toIsoDate(date)}
                  className={[
                    isCurrentMonth ? "" : "outside",
                    isSelected ? "selected" : "",
                    isToday ? "today" : "",
                    isInSelectedWeek ? "selected-week" : "",
                    selectionMode === "week" && isSaturday ? "week-start" : "",
                    selectionMode === "week" && weekStatus
                      ? `has-plan ${weekStatus}`
                      : "",
                    isDisabled ? "disabled" : "",
                  ]
                    .filter(Boolean)
                    .join(" ")}
                  aria-label={`${formatPersianFullDate(date)}${
                    weekStatus
                      ? weekStatus === "published"
                        ? "، برنامه منتشرشده"
                        : "، دارای پیش‌نویس"
                      : ""
                  }`}
                  aria-pressed={isSelected}
                  disabled={isDisabled}
                  onClick={() => {
                    onChange(toIsoDate(date));
                    setMonthAnchor(date);
                    setOpen(false);
                  }}
                >
                  {persianNumber.format(parts.day)}
                </button>
              );
            })}
          </div>
          <div className="persian-calendar-legend">
            <span className="today-key">امروز</span>
            {selectionMode === "week" && (
              <>
                <span className="week-key">هفته انتخاب‌شده</span>
                <span className="published-key">برنامه منتشرشده</span>
                <span className="draft-key">پیش‌نویس</span>
              </>
            )}
          </div>
          <p>
            {selectionMode === "week"
              ? "فقط شنبه هفته جاری یا هفته‌های آینده قابل انتخاب است."
              : "روزهای گذشته قابل انتخاب نیستند."}
          </p>
        </div>
      )}
    </div>
  );
}
