import type { StudyField } from "@/lib/study-catalog";

export type KonkurBookletPreset = {
  title: string;
  questionCount: number;
  durationMinutes: number;
};

export const konkurBookletPresets: Record<StudyField, KonkurBookletPreset[]> = {
  mathematics: [
    { title: "ریاضی", questionCount: 40, durationMinutes: 70 },
    { title: "فیزیک", questionCount: 35, durationMinutes: 45 },
    { title: "شیمی", questionCount: 30, durationMinutes: 30 },
  ],
  experimental_sciences: [
    { title: "زیست‌شناسی", questionCount: 45, durationMinutes: 45 },
    { title: "فیزیک", questionCount: 30, durationMinutes: 40 },
    { title: "شیمی", questionCount: 35, durationMinutes: 35 },
    { title: "ریاضی", questionCount: 30, durationMinutes: 45 },
    { title: "زمین‌شناسی", questionCount: 15, durationMinutes: 15 },
  ],
  humanities: [
    { title: "ریاضی", questionCount: 20, durationMinutes: 30 },
    { title: "زبان و ادبیات فارسی", questionCount: 30, durationMinutes: 30 },
    { title: "علوم اجتماعی", questionCount: 15, durationMinutes: 25 },
    { title: "روان‌شناسی", questionCount: 15, durationMinutes: 20 },
    { title: "زبان عربی", questionCount: 20, durationMinutes: 20 },
    { title: "تاریخ", questionCount: 13, durationMinutes: 20 },
    { title: "جغرافیا", questionCount: 12, durationMinutes: 20 },
    { title: "فلسفه و منطق", questionCount: 20, durationMinutes: 20 },
    { title: "اقتصاد", questionCount: 15, durationMinutes: 15 },
  ],
  arts: [
    { title: "درک عمومی هنر", questionCount: 50, durationMinutes: 50 },
    { title: "درک عمومی ریاضی و فیزیک", questionCount: 30, durationMinutes: 40 },
    { title: "خلاقیت تصویری و تجسمی", questionCount: 20, durationMinutes: 25 },
  ],
  foreign_languages: [
    { title: "زبان تخصصی", questionCount: 70, durationMinutes: 105 },
  ],
};

export const allKonkurBookletTitles = Array.from(
  new Set(
    Object.values(konkurBookletPresets)
      .flat()
      .map((booklet) => booklet.title),
  ),
);
