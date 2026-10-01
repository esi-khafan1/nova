"use client";

import { useState, useTransition } from "react";
import { togglePlanItemCompletion } from "@/app/dashboard/actions";

export function StudentPlanCheckbox({
  itemId,
  defaultChecked,
}: {
  itemId: string;
  defaultChecked: boolean;
}) {
  const [checked, setChecked] = useState(defaultChecked);
  const [isPending, startTransition] = useTransition();

  return (
    <label className={`student-plan-check${checked ? " checked" : ""}`}>
      <input
        type="checkbox"
        checked={checked}
        disabled={isPending}
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
      <strong>{checked ? "انجام شد" : "ثبت انجام"}</strong>
    </label>
  );
}