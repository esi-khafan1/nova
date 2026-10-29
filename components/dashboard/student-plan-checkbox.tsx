"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { togglePlanItemCompletion } from "@/app/dashboard/actions";
import { formatStudyDuration, parseStudyDuration } from "@/lib/study-duration";

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
  const savedEntry = isTestActivity ? defaultCompletedTestCount?.toString() ?? "" : formatStudyDuration(defaultCompletedMinutes);
  const [checked, setChecked] = useState(defaultChecked);
  const [entry, setEntry] = useState(savedEntry);
  // Track successful edits even if the server refresh has not remounted this box yet.
  const [recordedValue, setRecordedValue] = useState<number | null>(isTestActivity ? defaultCompletedTestCount : defaultCompletedMinutes);
  const [hasError, setHasError] = useState(false);
  const [isPending, startTransition] = useTransition();
  const completedValue = isTestActivity
    ? /^[0-9]+$/.test(entry) && Number(entry) >= 1 && Number(entry) <= 5000 ? Number(entry) : null
    : parseStudyDuration(entry);

  const saveProgress = (nextChecked: boolean) => {
    if (isPending) return;
    // An empty input is a full planned activity, not a measured actual value.
    if (nextChecked && entry.trim() !== "" && completedValue === null) {
      setHasError(true);
      return;
    }
    setHasError(false);
    if (nextChecked && !isTestActivity && completedValue !== null) setEntry(formatStudyDuration(completedValue));
    setChecked(nextChecked);
    startTransition(async () => {
      const result = await togglePlanItemCompletion(
        itemId,
        nextChecked,
        nextChecked && isTestActivity ? completedValue : null,
        nextChecked && !isTestActivity ? completedValue : null,
      );
      if (!result.ok) {
        setChecked(!nextChecked);
        setHasError(true);
        return;
      }
      setRecordedValue(nextChecked ? completedValue : null);
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
        <span>{isTestActivity ? `هدف مشاور: ${targetTestCount ? faNumber(targetTestCount) : "—"} تست` : "زمان واقعی را به صورت ساعت:دقیقه وارد کن؛ مثلاً 01:30"}</span>
        <label>
          {isTestActivity ? "تعداد تست زده شده" : isExamActivity ? "مدت آزمون (ساعت:دقیقه)" : "مدت مطالعه (ساعت:دقیقه)"}
          <input
            type={isTestActivity ? "number" : "text"}
            inputMode={isTestActivity ? "numeric" : "text"}
            className={isTestActivity ? undefined : "student-duration-input"}
            min={isTestActivity ? 1 : undefined}
            max={isTestActivity ? 5000 : undefined}
            maxLength={isTestActivity ? undefined : 5}
            step={isTestActivity ? 1 : undefined}
            dir="ltr"
            autoComplete="off"
            value={entry}
            disabled={!canToggle || isPending}
            onChange={(event) => { setEntry(event.target.value); setHasError(false); }}
            onBlur={() => {
              if (!isTestActivity && completedValue !== null) setEntry(formatStudyDuration(completedValue));
              const recordedEntry = isTestActivity ? recordedValue?.toString() ?? "" : formatStudyDuration(recordedValue);
              if (checked && (completedValue === null ? entry !== recordedEntry : completedValue !== recordedValue)) {
                if (entry.trim() === "" || completedValue !== null) saveProgress(true);
                else setHasError(true);
              }
            }}
            placeholder={isTestActivity ? "مثلاً ۳۰" : "01:30"}
          />
        </label>
        <small className="student-progress-optional">{isTestActivity ? "اختیاری؛ اگر خالی بماند، هدف تست کامل حساب می‌شود." : "اختیاری؛ اگر خالی بماند، زمان برنامه کامل حساب می‌شود."}</small>
        {hasError && <small role="alert">{isTestActivity ? "تعداد تست را بین ۱ تا ۵۰۰۰ وارد کن یا خالی بگذار." : "مدت را به شکل ساعت:دقیقه، بین 00:01 و 24:00 وارد کن یا خالی بگذار."}</small>}
      </div>
    </div>
  );
}
