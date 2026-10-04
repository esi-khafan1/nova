"use client";

export function PrintButton({ label = "چاپ کارنامه" }: { label?: string }) {
  return (
    <button type="button" className="button report-print-button" onClick={() => window.print()}>
      {label}
    </button>
  );
}
