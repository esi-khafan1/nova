"use client";

import { useState, useTransition } from "react";
import { togglePlanItemCompletion } from "@/app/dashboard/actions";

const faNumber = (value: number) => value.toLocaleString("fa-IR");

export function StudentPlanCheckbox({
  itemId,
  defaultChecked,
  canToggle,
  activityType,
  targetTestCount,
  defaultCompletedTestCount,
}: {
  itemId: string;
  defaultChecked: boolean;
  canToggle: boolean;
  activityType: string;
  targetTestCount: number | null;
  defaultCompletedTestCount: number | null;
}) {
  const isTestActivity = activityType === "practice_tests";
  const [checked, setChecked] = useState(defaultChecked);
  const [completedTestCount, setCompletedTestCount] = useState(
    defaultCompletedTestCount?.toString() ?? "",
  );
  const [hasError, setHasError] = useState(false);
  const [isPending, startTransition] = useTransition();

  const parsedTestCount = Number(completedTestCount);
  const validTestCount =
    !isTestActivity ||
    (Number.isInteger(parsedTestCount) &&
      parsedTestCount >= 1 &&
      parsedTestCount <= 5000);

  const saveProgress = (nextChecked: boolean) => {
    if (nextChecked && !validTestCount) {
      setHasError(true);
      return;
    }
    setHasError(false);
    setChecked(nextChecked);
    startTransition(async () => {
      const result = await togglePlanItemCompletion(
        itemId,
        nextChecked,
        isTestActivity && nextChecked ? parsedTestCount : null,
      );
      if (!result.ok) {
        setChecked(!nextChecked);
        setHasError(true);
      }
    });
  };

  return (
    <div className={`student-progress-control${canToggle ? "" : " locked"}`}>
      {isTestActivity && (
        <div className="student-test-count">
          <span>
            هدف مشاور: {targetTestCount ? faNumber(targetTestCount) : "—"} تست
          </span>
          <label>
            تعداد تست انجام‌شده
            <input
              type="number"
              inputMode="numeric"
              min={1}
              max={5000}
              value={completedTestCount}
              disabled={!canToggle || isPending}
              onChange={(event) => {
                setCompletedTestCount(event.target.value);
                setHasError(false);
              }}
              onBlur={() => {
                if (checked && validTestCount) saveProgress(true);
              }}
              placeholder="مثلاً ۳۰"
            />
          </label>
          {hasError && (
            <small>برای ثبت انجام، تعداد تست معتبر را وارد کن.</small>
          )}
        </div>
      )}
      <label
        className={`student-plan-check${checked ? " checked" : ""}${
          canToggle ? "" : " locked"
        }`}
        title={canToggle ? undefined : "فقط فعالیت‌های امروز قابل تغییر هستند"}
      >
        <input
          type="checkbox"
          aria-label={
            canToggle
              ? checked
                ? "برداشتن علامت انجام فعالیت"
                : "ثبت انجام فعالیت"
              : "این فعالیت امروز نیست و قابل تغییر نیست"
          }
          checked={checked}
          disabled={isPending || !canToggle}
          onChange={(event) => saveProgress(event.target.checked)}
        />
        <span aria-hidden="true">{checked ? "✓" : ""}</span>
        <strong>
          {canToggle
            ? checked
              ? "انجام شد"
              : "ثبت انجام"
            : checked
              ? "انجام‌شده"
              : "فقط در روز خودش قابل ثبت است"}
        </strong>
      </label>
    </div>
  );
}
