"use client";

export function PrintPlanButton() {
  return (
    <button
      className="button print-plan-action"
      type="button"
      onClick={() => window.print()}
    >
      چاپ برنامه روی A4
    </button>
  );
}
