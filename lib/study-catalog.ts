export type StudyField =
  | "mathematics"
  | "experimental_sciences"
  | "humanities"
  | "arts"
  | "foreign_languages";

export type StudyBook = {
  subject: string;
  chapters: string[];
};

export const studyFieldLabels: Record<StudyField, string> = {
  mathematics: "ریاضی و فیزیک",
  experimental_sciences: "علوم تجربی",
  humanities: "علوم انسانی",
  arts: "هنر",
  foreign_languages: "زبان‌های خارجی",
};

const numbered = (label: string, count: number) =>
  Array.from(
    { length: count },
    (_, index) => `${label} ${(index + 1).toLocaleString("fa-IR")}`,
  );

const biology10 = [
  "فصل ۱: دنیای زنده",
  "فصل ۲: گوارش و جذب مواد",
  "فصل ۳: تبادلات گازی",
  "فصل ۴: گردش مواد در بدن",
  "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
  "فصل ۶: از یاخته تا گیاه",
  "فصل ۷: جذب و انتقال مواد در گیاهان",
];

const biology11 = [
  "فصل ۱: تنظیم عصبی",
  "فصل ۲: حواس",
  "فصل ۳: دستگاه حرکتی",
  "فصل ۴: تنظیم شیمیایی",
  "فصل ۵: ایمنی",
  "فصل ۶: تقسیم یاخته",
  "فصل ۷: تولید مثل",
  "فصل ۸: تولید مثل نهاندانگان",
  "فصل ۹: پاسخ گیاهان به محرک‌ها",
];

const biology12 = [
  "فصل ۱: مولکول‌های اطلاعاتی",
  "فصل ۲: جریان اطلاعات در یاخته",
  "فصل ۳: انتقال اطلاعات در نسل‌ها",
  "فصل ۴: تغییر در اطلاعات وراثتی",
  "فصل ۵: از ماده به انرژی",
  "فصل ۶: از انرژی به ماده",
  "فصل ۷: فناوری‌های نوین زیستی",
  "فصل ۸: رفتارهای جانوران",
];

export const studyCatalog: Record<
  StudyField,
  Partial<Record<10 | 11 | 12, StudyBook[]>>
> = {
  mathematics: {
    10: [
      { subject: "ریاضی ۱", chapters: numbered("فصل", 7) },
      { subject: "هندسه ۱", chapters: numbered("فصل", 4) },
      { subject: "فیزیک ۱", chapters: numbered("فصل", 5) },
      { subject: "شیمی ۱", chapters: numbered("فصل", 3) },
    ],
    11: [
      { subject: "حسابان ۱", chapters: numbered("فصل", 5) },
      { subject: "هندسه ۲", chapters: numbered("فصل", 4) },
      { subject: "آمار و احتمال", chapters: numbered("فصل", 4) },
      { subject: "فیزیک ۲", chapters: numbered("فصل", 4) },
      { subject: "شیمی ۲", chapters: numbered("فصل", 3) },
    ],
    12: [
      { subject: "حسابان ۲", chapters: numbered("فصل", 5) },
      { subject: "هندسه ۳", chapters: numbered("فصل", 3) },
      { subject: "ریاضیات گسسته", chapters: numbered("فصل", 3) },
      { subject: "فیزیک ۳", chapters: numbered("فصل", 6) },
      { subject: "شیمی ۳", chapters: numbered("فصل", 4) },
    ],
  },
  experimental_sciences: {
    10: [
      { subject: "زیست‌شناسی ۱", chapters: biology10 },
      { subject: "ریاضی ۱", chapters: numbered("فصل", 7) },
      { subject: "فیزیک ۱", chapters: numbered("فصل", 4) },
      { subject: "شیمی ۱", chapters: numbered("فصل", 3) },
    ],
    11: [
      { subject: "زیست‌شناسی ۲", chapters: biology11 },
      { subject: "ریاضی ۲", chapters: numbered("فصل", 7) },
      { subject: "فیزیک ۲", chapters: numbered("فصل", 3) },
      { subject: "شیمی ۲", chapters: numbered("فصل", 3) },
      { subject: "زمین‌شناسی", chapters: numbered("فصل", 7) },
    ],
    12: [
      { subject: "زیست‌شناسی ۳", chapters: biology12 },
      { subject: "ریاضی ۳", chapters: numbered("فصل", 7) },
      { subject: "فیزیک ۳", chapters: numbered("فصل", 4) },
      { subject: "شیمی ۳", chapters: numbered("فصل", 4) },
    ],
  },
  humanities: {
    10: [
      { subject: "ریاضی و آمار ۱", chapters: numbered("فصل", 4) },
      { subject: "علوم و فنون ادبی ۱", chapters: numbered("فصل", 4) },
      { subject: "عربی ۱ تخصصی", chapters: numbered("درس", 8) },
      { subject: "اقتصاد", chapters: numbered("درس", 14) },
      { subject: "تاریخ ۱", chapters: numbered("درس", 16) },
      { subject: "جغرافیای ایران", chapters: numbered("درس", 10) },
      { subject: "جامعه‌شناسی ۱", chapters: numbered("درس", 14) },
      { subject: "منطق", chapters: numbered("درس", 10) },
    ],
    11: [
      { subject: "ریاضی و آمار ۲", chapters: numbered("فصل", 3) },
      { subject: "علوم و فنون ادبی ۲", chapters: numbered("فصل", 4) },
      { subject: "عربی ۲ تخصصی", chapters: numbered("درس", 7) },
      { subject: "تاریخ ۲", chapters: numbered("درس", 16) },
      { subject: "جغرافیا ۲", chapters: numbered("درس", 11) },
      { subject: "جامعه‌شناسی ۲", chapters: numbered("درس", 15) },
      { subject: "فلسفه ۱", chapters: numbered("درس", 11) },
      { subject: "روان‌شناسی", chapters: numbered("درس", 8) },
    ],
    12: [
      { subject: "ریاضی و آمار ۳", chapters: numbered("فصل", 3) },
      { subject: "علوم و فنون ادبی ۳", chapters: numbered("فصل", 4) },
      { subject: "عربی ۳ تخصصی", chapters: numbered("درس", 5) },
      { subject: "تاریخ ۳", chapters: numbered("درس", 12) },
      { subject: "جغرافیا ۳", chapters: numbered("درس", 10) },
      { subject: "جامعه‌شناسی ۳", chapters: numbered("درس", 10) },
      { subject: "فلسفه ۲", chapters: numbered("درس", 11) },
    ],
  },
  arts: {
    10: [
      { subject: "درک عمومی هنر", chapters: numbered("مبحث", 12) },
      { subject: "درک عمومی ریاضی و فیزیک", chapters: numbered("مبحث", 10) },
      { subject: "خلاقیت تصویری و تجسمی", chapters: numbered("مبحث", 10) },
    ],
    11: [
      { subject: "درک عمومی هنر", chapters: numbered("مبحث", 12) },
      { subject: "درک عمومی ریاضی و فیزیک", chapters: numbered("مبحث", 10) },
      { subject: "خلاقیت تصویری و تجسمی", chapters: numbered("مبحث", 10) },
    ],
    12: [
      { subject: "درک عمومی هنر", chapters: numbered("مبحث", 12) },
      { subject: "درک عمومی ریاضی و فیزیک", chapters: numbered("مبحث", 10) },
      { subject: "خلاقیت تصویری و تجسمی", chapters: numbered("مبحث", 10) },
    ],
  },
  foreign_languages: {
    10: [{ subject: "زبان تخصصی", chapters: numbered("درس", 8) }],
    11: [{ subject: "زبان تخصصی", chapters: numbered("درس", 8) }],
    12: [{ subject: "زبان تخصصی", chapters: numbered("درس", 8) }],
  },
};

export const activityTypes = [
  { value: "lesson", label: "مطالعه درسنامه" },
  { value: "notes", label: "کار روی جزوه" },
  { value: "practice_tests", label: "تست‌زنی" },
  { value: "class", label: "کلاس" },
  { value: "exam", label: "آزمون" },
  { value: "review", label: "مرور" },
  { value: "homework", label: "تمرین و تکلیف" },
  { value: "summary", label: "خلاصه‌نویسی" },
  { value: "other", label: "فعالیت دیگر" },
] as const;

export const weekDays = [
  "شنبه",
  "یکشنبه",
  "دوشنبه",
  "سه‌شنبه",
  "چهارشنبه",
  "پنجشنبه",
  "جمعه",
] as const;