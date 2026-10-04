"use client";

import { toPersianDigits } from "@/lib/persian-date";
const toEnglishDigits = (value: string) => value.replace(/[۰-۹]/g, (d) => String("۰۱۲۳۴۵۶۷۸۹".indexOf(d))).replace(/[٠-٩]/g, (d) => String("٠١٢٣٤٥٦٧٨٩".indexOf(d)));

export function PersianNumberStepper({ value, min, max, onChange, label }: { value: number; min: number; max: number; onChange: (value: number) => void; label: string }) {
  const update = (next: number) => onChange(Math.max(min, Math.min(max, Math.round(next))));
  const buttonStyle = { border: "1px solid #e7dccb", borderRadius: 10, background: "#fffaf2", color: "#573d25", font: "inherit", fontSize: "1.2rem", cursor: "pointer" } as const;
  return <div role="group" aria-label={label} style={{ direction: "ltr", display: "grid", gridTemplateColumns: "2.5rem minmax(4.5rem,1fr) 2.5rem", gap: ".35rem" }}>
    <button type="button" style={buttonStyle} onClick={() => update(value - 1)} disabled={value <= min}>−</button>
    <input type="text" inputMode="numeric" pattern="[۰-۹٠-٩0-9]*" aria-label={label} value={toPersianDigits(value)} style={{ direction: "rtl", textAlign: "center", fontVariantNumeric: "tabular-nums" }} onChange={(event) => { const parsed = Number(toEnglishDigits(event.target.value).replace(/\D/g, "")); if (Number.isFinite(parsed)) update(parsed || min); }} />
    <button type="button" style={buttonStyle} onClick={() => update(value + 1)} disabled={value >= max}>+</button>
  </div>;
}
