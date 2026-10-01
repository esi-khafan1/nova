"use client";

import { useState, useTransition } from "react";
import { togglePlanItemCompletion } from "@/app/dashboard/actions";

export function StudentPlanCheckbox({
  itemId,
  defaultChecked,
  canToggle,
}: {
  itemId: string;
  defaultChecked: boolean;
  canToggle: boolean;
}) {
  const [checked, setChecked] = useState(defaultChecked);
  const [isPending, startTransition] = useTransition();

  return (
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
        onChange={(event) => {
          const nextChecked = event.target.checked;
          setChecked(nextChecked);
          startTransition(async () => {
            const result = await togglePlanItemCompletion(itemId, nextChecked);
            if (!result.ok) setChecked(!nextChecked);
          });
        }}
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
  );
}