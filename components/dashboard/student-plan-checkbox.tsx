"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { togglePlanItemCompletion } from "@/app/dashboard/actions";

const faNumber = (value: number) => value.toLocaleString("fa-IR");

export function StudentPlanCheckbox({
  itemId,
  defaultChecked,
  canToggle,
  activityType,
  targetTestCount,
  defaultCompletedTestCount,
  defaultCompletedMinutes,
}: {
  itemId: string;
  defaultChecked: boolean;
  canToggle: boolean;
  activityType: string;
  targetTestCount: number | null;
  defaultCompletedTestCount: number | null;
  defaultCompletedMinutes: number | null;
}) {
  const router = useRouter();
  const isTestActivity = activityType === "practice_tests";
  const isExamActivity = activityType === "exam" || activityType === "simulation_exam";
  const [checked, setChecked] = useState(defaultChecked);
  const [entry, setEntry] = useState(
    (isTestActivity ? defaultCompletedTestCount : defaultCompletedMinutes)?.toString() ?? "",
  );
  const [hasError, setHasError] = useState(false);
  const [isPending, startTransition] = useTransition();
  const maximum = isTestActivity ? 5000 : 1440;
  const validEntry = /^[0-9]+$/.test(entry) && Number(entry) >= 1 && Number(entry) <= maximum;

  const saveProgress = (nextChecked: boolean) => {
    if (isPending) return;
    if (nextChecked && !validEntry) {
      setHasError(true);
      return;
    }
    setHasError(false);
    setChecked(nextChecked);
    startTransition(async () => {
      const result = await togglePlanItemCompletion(
        itemId,
        nextChecked,
        nextChecked && isTestActivity ? Number(entry) : null,
        nextChecked && !isTestActivity ? Number(entry) : null,
      );
      if (!result.ok) {
        setChecked(!nextChecked);
        setHasError(true);
        return;
      }
      router.refresh();
    });
  };

  return (
    <div className={`student-progress-control${canToggle ? "" : " locked"}`}>
      <label
        className={`student-plan-check${checked ? " checked" : ""}${canToggle ? "" : " locked"}`}
        title={canToggle ? undefined : "ثبت انجام فعالیت‌های آینده هنوز فعال نیست"}
      >
        <input
          type="checkbox"
          aria-label={canToggle ? checked ? "برداشتن علامت انجام فعالیت" : "ثبت انجام فعالیت" : "هنوز موعد انجام این فعالیت نرسیده"}
          checked={checked}
          disabled={isPending || !canToggle}
          onChange={(event) => saveProgress(event.target.checked)}
        />
        <span aria-hidden="true">{checked ? "✓" : ""}</span>
        <strong>{canToggle ? "انجام داده‌ام" : checked ? "انجام‌شده" : "هنوز موعدش نرسیده"}</strong>
      </label>
      <div className="student-test-count">
        <span>{isTestActivity ? `هدف مشاور: ${targetTestCount ? faNumber(targetTestCount) : "—"} تست` : "زمان واقعی این فعالیت را ثبت کن"}</span>
        <label>
          {isTestActivity ? "تعداد تست زده شده" : isExamActivity ? "دقیقهٔ انجام آزمون" : "دقیقهٔ مطالعهٔ واقعی"}
          <input
            type="number"
            inputMode="numeric"
            min={1}
            max={maximum}
            step={1}
            value={entry}
            disabled={!canToggle || isPending}
            onChange={(event) => { setEntry(event.target.value); setHasError(false); }}
            onBlur={() => {
              if (checked && entry !== ((isTestActivity ? defaultCompletedTestCount : defaultCompletedMinutes)?.toString() ?? "")) {
                if (validEntry) saveProgress(true);
                else setHasError(true);
              }
            }}
            placeholder={isTestActivity ? "مثلاً ۳۰" : "مثلاً ۴۵"}
          />
        </label>
        {hasError && <small role="alert">{isTestActivity ? "برای ثبت انجام، تعداد تست معتبر (۱ تا ۵۰۰۰) را وارد کن." : "برای ثبت انجام، دقیقهٔ معتبر (۱ تا ۱۴۴۰) را وارد کن."}</small>}
      </div>
    </div>
  );
}
