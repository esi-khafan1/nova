"use client";

import { toPersianDigits } from "@/lib/persian-date";
import styles from "./persian-number-stepper.module.css";

const toEnglishDigits = (value: string) =>
  value
    .replace(/[۰-۹]/g, (digit) => String("۰۱۲۳۴۵۶۷۸۹".indexOf(digit)))
    .replace(/[٠-٩]/g, (digit) => String("٠١٢٣٤٥٦٧٨٩".indexOf(digit)));

export function PersianNumberStepper({ value, min, max, onChange, label }: { value: number; min: number; max: number; onChange: (value: number) => void; label: string }) {
  const update = (next: number) => onChange(Math.max(min, Math.min(max, Math.round(next))));
  return (
    <div className={styles.wrapper} role="group" aria-label={label}>
      <input className={styles.input} type="text" inputMode="numeric" pattern="[۰-۹٠-٩0-9]*" aria-label={label} value={toPersianDigits(value)} onChange={(event) => { const parsed = Number(toEnglishDigits(event.target.value).replace(/\D/g, "")); if (Number.isFinite(parsed)) update(parsed || min); }} />
      <div className={styles.controls}>
        <button type="button" aria-label={`افزایش ${label}`} onClick={() => update(value + 1)} disabled={value >= max}><i className={styles.up} aria-hidden="true" /></button>
        <button type="button" aria-label={`کاهش ${label}`} onClick={() => update(value - 1)} disabled={value <= min}><i className={styles.down} aria-hidden="true" /></button>
      </div>
    </div>
  );
}
