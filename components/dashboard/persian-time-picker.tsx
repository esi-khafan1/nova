"use client";

import { useEffect, useRef, useState } from "react";
import { toPersianDigits } from "@/lib/persian-date";

const DEFAULT_HOURS = Array.from({ length: 24 }, (_, i) => i);
const DEFAULT_MINUTES = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

const PRESETS = [
  { label: "۰۸:۰۰", value: "08:00" },
  { label: "۰۹:۰۰", value: "09:00" },
  { label: "۱۰:۰۰", value: "10:00" },
  { label: "۱۱:۰۰", value: "11:00" },
  { label: "۱۴:۰۰", value: "14:00" },
  { label: "۱۶:۰۰", value: "16:00" },
  { label: "۱۸:۰۰", value: "18:00" },
  { label: "۲۰:۰۰", value: "20:00" },
];

export function PersianTimePicker({
  name,
  value,
  onChange,
  minTime,
  disabled = false,
}: {
  name: string;
  value: string;
  onChange: (value: string) => void;
  minTime?: string;
  disabled?: boolean;
}) {
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const hourListRef = useRef<HTMLDivElement>(null);
  const minuteListRef = useRef<HTMLDivElement>(null);

  // Parse HH:mm
  const [rawH = "09", rawM = "00"] = (value || "09:00").split(":");
  const hour = Math.max(0, Math.min(23, Number(rawH) || 0));
  const minute = Math.max(0, Math.min(59, Number(rawM) || 0));

  // Parse minTime if given
  let minHour = -1;
  let minMinute = -1;
  if (minTime) {
    const [minH = "0", minM = "0"] = minTime.split(":");
    minHour = Number(minH);
    minMinute = Number(minM);
  }

  // Ensure minute is in minutes list
  const minuteOptions = Array.from(new Set([...DEFAULT_MINUTES, minute])).sort(
    (a, b) => a - b,
  );

  // Close on click outside or Escape
  useEffect(() => {
    if (!open) return;
    const handleClickOutside = (event: MouseEvent) => {
      if (
        containerRef.current &&
        !containerRef.current.contains(event.target as Node)
      ) {
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

  // Scroll active items into view when opened
  useEffect(() => {
    if (open) {
      requestAnimationFrame(() => {
        const activeHour =
          hourListRef.current?.querySelector<HTMLButtonElement>(".selected");
        const activeMin =
          minuteListRef.current?.querySelector<HTMLButtonElement>(".selected");
        activeHour?.scrollIntoView({ block: "nearest" });
        activeMin?.scrollIntoView({ block: "nearest" });
      });
    }
  }, [open]);

  const updateTime = (nextHour: number, nextMinute: number) => {
    const formatted = `${String(nextHour).padStart(2, "0")}:${String(nextMinute).padStart(2, "0")}`;
    onChange(formatted);
  };

  const isHourDisabled = (h: number) => {
    if (minHour < 0) return false;
    return h < minHour;
  };

  const isMinuteDisabled = (m: number) => {
    if (minHour < 0) return false;
    if (hour < minHour) return true;
    if (hour === minHour && m < minMinute) return true;
    return false;
  };

  const formattedDisplay = `${toPersianDigits(hour, 2)}:${toPersianDigits(minute, 2)}`;

  return (
    <div className="persian-time-picker" ref={containerRef}>
      <input type="hidden" name={name} value={value} />
      <button
        type="button"
        className="persian-time-trigger"
        aria-expanded={open}
        aria-haspopup="dialog"
        disabled={disabled}
        onClick={() => setOpen((current) => !current)}
      >
        <span className="persian-time-value" dir="ltr">
          {formattedDisplay}
        </span>
        <svg
          aria-hidden="true"
          viewBox="0 0 20 20"
          className="persian-time-icon"
        >
          <circle
            cx="10"
            cy="10"
            r="7.5"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.8"
          />
          <path
            d="M10 5.5v4.5l3 1.5"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.8"
            strokeLinecap="round"
          />
        </svg>
      </button>

      {open && (
        <div
          className="persian-time-popover"
          role="dialog"
          aria-label="انتخاب ساعت شروع"
        >
          <div className="persian-time-header">
            <span className="persian-time-title">زمان شروع آزمون</span>
            <span className="persian-time-preview" dir="ltr">
              {toPersianDigits(hour, 2)} : {toPersianDigits(minute, 2)}
            </span>
          </div>

          <div className="persian-time-presets" aria-label="زمان‌های پیشنهادی">
            {PRESETS.map((preset) => {
              const [pH, pM] = preset.value.split(":").map(Number);
              const isDisabled =
                minHour >= 0 && (pH < minHour || (pH === minHour && pM < minMinute));
              const isSelected =
                hour === pH && minute === pM;
              return (
                <button
                  type="button"
                  key={preset.value}
                  className={`persian-time-preset-btn ${isSelected ? "active" : ""}`}
                  disabled={isDisabled}
                  onClick={() => {
                    updateTime(pH, pM);
                  }}
                >
                  {preset.label}
                </button>
              );
            })}
          </div>

          <div className="persian-time-grid">
            <div className="persian-time-col">
              <div className="persian-time-col-title">ساعت (۰ تا ۲۳)</div>
              <div className="persian-time-list" ref={hourListRef}>
                {DEFAULT_HOURS.map((h) => {
                  const isSelected = h === hour;
                  const isDisabled = isHourDisabled(h);
                  return (
                    <button
                      type="button"
                      key={h}
                      className={[
                        isSelected ? "selected" : "",
                        isDisabled ? "disabled" : "",
                      ]
                        .filter(Boolean)
                        .join(" ")}
                      disabled={isDisabled}
                      onClick={() => updateTime(h, minute)}
                    >
                      {toPersianDigits(h, 2)}
                    </button>
                  );
                })}
              </div>
            </div>

            <div className="persian-time-col">
              <div className="persian-time-col-title">دقیقه</div>
              <div className="persian-time-list" ref={minuteListRef}>
                {minuteOptions.map((m) => {
                  const isSelected = m === minute;
                  const isDisabled = isMinuteDisabled(m);
                  return (
                    <button
                      type="button"
                      key={m}
                      className={[
                        isSelected ? "selected" : "",
                        isDisabled ? "disabled" : "",
                      ]
                        .filter(Boolean)
                        .join(" ")}
                      disabled={isDisabled}
                      onClick={() => updateTime(hour, m)}
                    >
                      {toPersianDigits(m, 2)}
                    </button>
                  );
                })}
              </div>
            </div>
          </div>

          <button
            type="button"
            className="persian-time-confirm"
            onClick={() => setOpen(false)}
          >
            تأیید ساعت
          </button>
        </div>
      )}
    </div>
  );
}
