// Publisher only, not a book title. The custom option accepts another publisher.
export const recommendedPublishers = [
  "گاج",
  "خیلی سبز",
  "نشر الگو",
  "مبتکران",
  "مهروماه",
  "قلم‌چی",
  "نشر دریافت",
  "مشاوران آموزش",
  "منتشران",
] as const;

export function canRecommendPublisher(track: string, activityType: string): boolean {
  return track === "konkur" && ["lesson", "practice_tests", "review", "homework"].includes(activityType);
}

export function cleanRecommendedPublisher(value: unknown): string | null | undefined {
  if (value == null || value === "") return null;
  if (typeof value !== "string") return undefined;
  const name = value.trim();
  return name.length > 0 && name.length <= 80 && !/[\u0000-\u001f\u007f]/.test(name) ? name : undefined;
}
