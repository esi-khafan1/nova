"use client";

import { useMemo, useState } from "react";

const persianPartsFormatter = new Intl.DateTimeFormat(
  "fa-IR-u-ca-persian-nu-latn",
  {
    year: "numeric",
    month: "numeric",
    day: "numeric",
  },
);

const persianMonthFormatter = new Intl.DateTimeFormat(
  "fa-IR-u-ca-persian",
  {
    year: "numeric",
    month: "long",
  },
);

const persianFullDateFormatter = new Intl.DateTimeFormat(
  "fa-IR-u-ca-persian",
  {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  },
);

const persianNumber = new Intl.NumberFormat("fa-IR");

function addDays(date: Date, days: number) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

function toIsoDate(date: Date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function persianParts(date: Date) {
  const parts = persianPartsFormatter.formatToParts(date);
  const value = (type: Intl.DateTimeFormatPartTypes) =>
    Number(parts.find((part) => part.type === type)?.value ?? 0);
  return {
    year: value("year"),
    month: value("month"),
    day: value("day"),
  };
}

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

export function PersianDatePicker({
  name,
  defaultValue,
}: {
  name: string;
  defaultValue: string;
}) {
  const initialDate = useMemo(() => {
    const [year, month, day] = defaultValue.split("-").map(Number);
    return new Date(year, month - 1, day, 12);
  }, [defaultValue]);
  const [selected, setSelected] = useState(initialDate);
  const [monthAnchor, setMonthAnchor] = useState(initialDate);
  const [open, setOpen] = useState(false);

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
    <div className="persian-date-picker">
      <input type="hidden" name={name} value={toIsoDate(selected)} />
      <button
        type="button"
        className="persian-date-trigger"
        aria-expanded={open}
        onClick={() => setOpen((current) => !current)}
      >
        <span>{persianFullDateFormatter.format(selected)}</span>
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
            <strong>{persianMonthFormatter.format(monthStart)}</strong>
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
            ].map((day) => <span key={day}>{day}</span>)}
          </div>
          <div className="persian-calendar-days">
            {days.map((date) => {
              const parts = persianParts(date);
              const isCurrentMonth =
                parts.year === month.year && parts.month === month.month;
              const isSelected = sameDay(date, selected);
              const isSaturday = date.getDay() === 6;
              return (
                <button
                  type="button"
                  key={toIsoDate(date)}
                  className={[
                    isCurrentMonth ? "" : "outside",
                    isSelected ? "selected" : "",
                    isSaturday ? "week-start" : "",
                  ]
                    .filter(Boolean)
                    .join(" ")}
                  aria-label={persianFullDateFormatter.format(date)}
                  aria-pressed={isSelected}
                  onClick={() => {
                    setSelected(date);
                    setMonthAnchor(date);
                    setOpen(false);
                  }}
                >
                  {persianNumber.format(parts.day)}
                </button>
              );
            })}
          </div>
          <p>شنبه‌ها با حلقه نارنجی مشخص شده‌اند.</p>
        </div>
      )}
    </div>
  );
}