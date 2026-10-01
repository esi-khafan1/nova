export const persianMonthNames = [
  "فروردین",
  "اردیبهشت",
  "خرداد",
  "تیر",
  "مرداد",
  "شهریور",
  "مهر",
  "آبان",
  "آذر",
  "دی",
  "بهمن",
  "اسفند",
] as const;

export const persianNumber = new Intl.NumberFormat("fa-IR", {
  useGrouping: false,
});

const persianPartsFormatter = new Intl.DateTimeFormat(
  "fa-IR-u-ca-persian-nu-latn",
  {
    year: "numeric",
    month: "numeric",
    day: "numeric",
  },
);

export function addDays(date: Date, days: number) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

export function toIsoDate(date: Date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

export function parseIsoDate(value: string) {
  const [year, month, day] = value.split("-").map(Number);
  return new Date(year, month - 1, day, 12);
}

export function persianParts(date: Date) {
  const parts = persianPartsFormatter.formatToParts(date);
  const value = (type: Intl.DateTimeFormatPartTypes) =>
    Number(parts.find((part) => part.type === type)?.value ?? 0);
  return {
    year: value("year"),
    month: value("month"),
    day: value("day"),
  };
}

export function formatPersianMonthYear(date: Date) {
  const parts = persianParts(date);
  return `${persianMonthNames[parts.month - 1]} ${persianNumber.format(parts.year)}`;
}

export function formatPersianWeekRange(weekStart: string | Date) {
  const start =
    typeof weekStart === "string" ? parseIsoDate(weekStart) : weekStart;
  const end = addDays(start, 6);
  const startParts = persianParts(start);
  const endParts = persianParts(end);
  const startLabel = `${persianNumber.format(startParts.day)} ${persianMonthNames[startParts.month - 1]}`;
  const endLabel = `${persianNumber.format(endParts.day)} ${persianMonthNames[endParts.month - 1]}`;
  return `${startLabel} تا ${endLabel} ${persianNumber.format(endParts.year)}`;
}

export function samePersianMonth(first: Date, second: Date) {
  const firstParts = persianParts(first);
  const secondParts = persianParts(second);
  return (
    firstParts.year === secondParts.year &&
    firstParts.month === secondParts.month
  );
}