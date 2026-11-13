"use client";

import { useEffect, useState, useTransition } from "react";
import { togglePlanItemCompletion } from "@/app/dashboard/actions";
import { formatStudyDuration, parseStudyDuration } from "@/lib/study-duration";
import { externalSimulationActivity } from "@/lib/external-simulation";

const faNumber = (value: number) => value.toLocaleString("fa-IR");

export function StudentPlanCheckbox({
  itemId,
  defaultChecked,
  canToggle,
  activityType,
  targetTestCount,
  defaultCompletedTestCount,
  defaultCompletedMinutes,
  onSaved,
}: {
  itemId: string;
  defaultChecked: boolean;
  canToggle: boolean;
  activityType: string;
  targetTestCount: number | null;
  defaultCompletedTestCount: number | null;
  defaultCompletedMinutes: number | null;
  onSaved?: (itemId: string, completed: boolean, count: number | null, minutes: number | null) => void;
}) {
  const isTestActivity = activityType === "practice_tests";
  const isExamActivity = activityType === "exam" || activityType === "simulation_exam" || activityType === externalSimulationActivity;
  const savedEntry = isTestActivity ? defaultCompletedTestCount?.toString() ?? "" : formatStudyDuration(defaultCompletedMinutes);
  const [checked, setChecked] = useState(defaultChecked);
  const [entry, setEntry] = useState(savedEntry);
  const [testDuration, setTestDuration] = useState(formatStudyDuration(defaultCompletedMinutes));
  // Track successful edits even if the server refresh has not remounted this box yet.
  const [recordedValue, setRecordedValue] = useState<number | null>(isTestActivity ? defaultCompletedTestCount : defaultCompletedMinutes);
  const [recordedTestMinutes, setRecordedTestMinutes] = useState(defaultCompletedMinutes);
  const [hasError, setHasError] = useState(false);
  const [hasTestDurationError, setHasTestDurationError] = useState(false);
  const [saveFailed, setSaveFailed] = useState(false);
  const [isPending, startTransition] = useTransition();
  useEffect(() => {
    setChecked(defaultChecked);
    setRecordedValue(isTestActivity ? defaultCompletedTestCount : defaultCompletedMinutes);
    setRecordedTestMinutes(defaultCompletedMinutes);
    setTestDuration(formatStudyDuration(defaultCompletedMinutes));
    setEntry(savedEntry);
  }, [itemId, defaultChecked, defaultCompletedTestCount, defaultCompletedMinutes, isTestActivity, savedEntry]);
  const completedValue = isTestActivity
    ? /^[0-9]+$/.test(entry) && Number(entry) >= 1 && Number(entry) <= 5000 ? Number(entry) : null
    : parseStudyDuration(entry);
  const completedTestMinutes = parseStudyDuration(testDuration);

  const saveProgress = (nextChecked: boolean) => {
    if (isPending) return;
    // Empty values remain unrecorded; the report applies the activity's fallback.
    const invalidEntry = nextChecked && entry.trim() !== "" && completedValue === null;
    const invalidTestDuration = nextChecked && isTestActivity && testDuration.trim() !== "" && completedTestMinutes === null;
    setHasError(invalidEntry);
    setHasTestDurationError(invalidTestDuration);
    setSaveFailed(false);
    if (invalidEntry || invalidTestDuration) return;
    if (nextChecked && !isTestActivity && completedValue !== null) setEntry(formatStudyDuration(completedValue));
    if (nextChecked && isTestActivity && completedTestMinutes !== null) setTestDuration(formatStudyDuration(completedTestMinutes));
    const previouslyChecked = checked;
    setChecked(nextChecked);
    startTransition(async () => {
      try {
        const result = await togglePlanItemCompletion(
          itemId,
          nextChecked,
          nextChecked && isTestActivity ? completedValue : null,
          nextChecked ? (isTestActivity ? completedTestMinutes : completedValue) : null,
        );
        if (!result.ok) throw new Error("Progress not saved");
        setRecordedValue(nextChecked ? completedValue : null);
        setRecordedTestMinutes(nextChecked && isTestActivity ? completedTestMinutes : null);
        onSaved?.(itemId, nextChecked,
          nextChecked && isTestActivity ? completedValue : null,
          nextChecked ? (isTestActivity ? completedTestMinutes : completedValue) : null);
      } catch {
        setChecked(previouslyChecked);
        setSaveFailed(true);
      }
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
      <div className={`student-test-count${isTestActivity ? " student-test-count--tests" : ""}`}>
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
        {isTestActivity && <label>
          مدت تست زنی (ساعت:دقیقه)
          <input type="text" inputMode="text" className="student-duration-input" maxLength={5} dir="ltr" autoComplete="off"
            value={testDuration} disabled={!canToggle || isPending} placeholder="01:30"
            onChange={event => {setTestDuration(event.target.value); setHasTestDurationError(false);}}
            onBlur={() => {
              if (completedTestMinutes !== null) setTestDuration(formatStudyDuration(completedTestMinutes));
              const recorded = formatStudyDuration(recordedTestMinutes);
              if (checked && (completedTestMinutes === null ? testDuration !== recorded : completedTestMinutes !== recordedTestMinutes)) {
                if (testDuration.trim() === "" || completedTestMinutes !== null) saveProgress(true);
                else setHasTestDurationError(true);
              }
            }} />
        </label>}
        <small className="student-progress-optional">{isTestActivity ? "هر دو اختیاری‌اند؛ تعداد خالی یعنی هدف کامل و مدت خالی یعنی زمان صفر." : "اختیاری؛ اگر خالی بماند، زمان برنامه کامل حساب می‌شود."}</small>
        {hasError && <small role="alert">{isTestActivity ? "تعداد تست را بین ۱ تا ۵۰۰۰ وارد کن یا خالی بگذار." : "مدت را به شکل ساعت:دقیقه، بین 00:01 و 24:00 وارد کن یا خالی بگذار."}</small>}
        {hasTestDurationError && <small role="alert">مدت تست را به شکل ساعت:دقیقه، بین 00:01 و 24:00 وارد کن یا خالی بگذار.</small>}
        {saveFailed && <small role="alert">ثبت انجام نشد؛ دوباره تلاش کن.</small>}
      </div>
    </div>
  );
}
