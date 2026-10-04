"use client";

import { toPersianDigits } from "@/lib/persian-date";
const toEnglishDigits = (value: string) => value.replace(/[۰-۹]/g, (d) => String("۰۱۲۳۴۵۶۷۸۹".indexOf(d))).replace(/[٠-٩]/g, (d) => String("٠١٢٣٤٥٦٧٨٩".indexOf(d)));

export function PersianNumberStepper({ value, min, max, onChange, label }: { value: number; min: number; max: number; onChange: (value: number) => void; label: string }) {
  const update = (next: number) => onChange(Math.max(min, Math.min(max, Math.round(next))));
  const arrowStyle = { width: 28, height: 20, padding: 0, border: 0, background: "transparent", color: "#704b36", font: "inherit", fontSize: ".72rem", lineHeight: 1, cursor: "pointer" } as const;
  return <div role="group" aria-label={label} style={{ position: "relative", width: "100%" }}>
    <input type="text" inputMode="numeric" pattern="[۰-۹٠-٩0-9]*" aria-label={label} value={toPersianDigits(value)} style={{ direction: "rtl", textAlign: "right", paddingLeft: 38, fontVariantNumeric: "tabular-nums" }} onChange={(event) => { const parsed = Number(toEnglishDigits(event.target.value).replace(/\D/g, "")); if (Number.isFinite(parsed)) update(parsed || min); }} />
    <span style={{ position: "absolute", left: 6, top: "50%", transform: "translateY(-50%)", display: "grid", borderRight: "1px solid #ead5c3", zIndex: 2 }}>
      <button type="button" style={arrowStyle} aria-label={`افزایش ${label}`} onClick={() => update(value + 1)} disabled={value >= max}>⌃</button>
      <button type="button" style={arrowStyle} aria-label={`کاهش ${label}`} onClick={() => update(value - 1)} disabled={value <= min}>⌄</button>
    </span>
  </div>;
}
