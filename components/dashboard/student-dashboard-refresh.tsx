"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

function tehranDateIso() {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone: "Asia/Tehran",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date());
  const part = (type: Intl.DateTimeFormatPartTypes) =>
    parts.find((item) => item.type === type)?.value ?? "";
  return `${part("year")}-${part("month")}-${part("day")}`;
}

export function StudentDashboardRefresh({
  currentDate,
}: {
  currentDate: string;
}) {
  const router = useRouter();

  useEffect(() => {
    const refreshIfDayChanged = () => {
      if (tehranDateIso() !== currentDate) router.refresh();
    };
    const onVisibilityChange = () => {
      if (document.visibilityState === "visible") refreshIfDayChanged();
    };

    const interval = window.setInterval(refreshIfDayChanged, 60_000);
    window.addEventListener("focus", refreshIfDayChanged);
    document.addEventListener("visibilitychange", onVisibilityChange);

    return () => {
      window.clearInterval(interval);
      window.removeEventListener("focus", refreshIfDayChanged);
      document.removeEventListener("visibilitychange", onVisibilityChange);
    };
  }, [currentDate, router]);

  return null;
}