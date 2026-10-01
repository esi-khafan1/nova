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

const math1 = [
  "فصل ۱: مجموعه، الگو و دنباله",
  "فصل ۲: مثلثات",
  "فصل ۳: توان‌های گویا و عبارت‌های جبری",
  "فصل ۴: معادله‌ها و نامعادله‌ها",
  "فصل ۵: تابع",
  "فصل ۶: شمارش، بدون شمردن",
  "فصل ۷: آمار و احتمال",
];

const geometry1 = [
  "فصل ۱: ترسیم‌های هندسی و استدلال",
  "فصل ۲: قضیه تالس، تشابه و کاربردهای آن",
  "فصل ۳: چندضلعی‌ها",
  "فصل ۴: تجسم فضایی",
];

const physics1 = [
  "فصل ۱: فیزیک و اندازه‌گیری",
  "فصل ۲: ویژگی‌های فیزیکی مواد",
  "فصل ۳: کار، انرژی و توان",
  "فصل ۴: دما و گرما",
];

const chemistry1 = [
  "فصل ۱: کیهان، زادگاه الفبای هستی",
  "فصل ۲: ردپای گازها در زندگی",
  "فصل ۳: آب، آهنگ زندگی",
];

const chemistry2 = [
  "فصل ۱: قدر هدایای زمینی را بدانیم",
  "فصل ۲: در پی غذای سالم",
  "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
];

const chemistry3 = [
  "فصل ۱: مولکول‌ها در خدمت تندرستی",
  "فصل ۲: آسایش و رفاه در سایه شیمی",
  "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
  "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
];

const calculus1 = [
  "فصل ۱: جبر و معادله",
  "فصل ۲: تابع",
  "فصل ۳: توابع نمایی و لگاریتمی",
  "فصل ۴: مثلثات",
  "فصل ۵: حد و پیوستگی",
];

const calculus2 = [
  "فصل ۱: تابع",
  "فصل ۲: مثلثات",
  "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "فصل ۴: مشتق",
  "فصل ۵: کاربردهای مشتق",
];

const geometry2 = [
  "فصل ۱: دایره",
  "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "فصل ۳: روابط طولی در مثلث",
  "فصل ۴: تجسم فضایی",
];

const geometry3 = [
  "فصل ۱: ماتریس و کاربردها",
  "فصل ۲: آشنایی با مقاطع مخروطی",
  "فصل ۳: بردارها",
];

const statisticsAndProbability = [
  "فصل ۱: آشنایی با مبانی ریاضیات",
  "فصل ۲: احتمال",
  "فصل ۳: آمار توصیفی",
  "فصل ۴: آمار استنباطی",
];

const discreteMath = [
  "فصل ۱: آشنایی با نظریه اعداد",
  "فصل ۲: گراف و مدل‌سازی",
  "فصل ۳: ترکیبیات",
];

const physics2Math = [
  "فصل ۱: الکتریسیته ساکن",
  "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "فصل ۳: مغناطیس",
  "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
];

const physics2Experimental = [
  "فصل ۱: الکتریسیته ساکن",
  "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "فصل ۳: مغناطیس و القای الکترومغناطیسی",
];

const physics3Math = [
  "فصل ۱: حرکت بر خط راست",
  "فصل ۲: دینامیک و حرکت دایره‌ای",
  "فصل ۳: نوسان و موج",
  "فصل ۴: برهم‌کنش‌های موج",
  "فصل ۵: آشنایی با فیزیک اتمی",
  "فصل ۶: آشنایی با فیزیک هسته‌ای",
];

const physics3Experimental = [
  "فصل ۱: حرکت بر خط راست",
  "فصل ۲: دینامیک",
  "فصل ۳: نوسان و موج",
  "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
];

const experimentalMath2 = [
  "فصل ۱: هندسه تحلیلی و جبر",
  "فصل ۲: هندسه",
  "فصل ۳: تابع",
  "فصل ۴: مثلثات",
  "فصل ۵: توابع نمایی و لگاریتمی",
  "فصل ۶: حد و پیوستگی",
  "فصل ۷: آمار و احتمال",
];

const experimentalMath3 = [
  "فصل ۱: تابع",
  "فصل ۲: مثلثات",
  "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "فصل ۴: مشتق",
  "فصل ۵: کاربردهای مشتق",
  "فصل ۶: هندسه",
  "فصل ۷: احتمال",
];

const geology = [
  "فصل ۱: آفرینش کیهان و تکوین زمین",
  "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "فصل ۳: منابع آب و خاک",
  "فصل ۴: زمین‌شناسی و سازه‌های مهندسی",
  "فصل ۵: زمین‌شناسی و سلامت",
  "فصل ۶: پویایی زمین",
  "فصل ۷: زمین‌شناسی ایران",
];

export const studyCatalog: Record<
  StudyField,
  Partial<Record<10 | 11 | 12, StudyBook[]>>
> = {
  mathematics: {
    10: [
      { subject: "ریاضی ۱", chapters: math1 },
      { subject: "هندسه ۱", chapters: geometry1 },
      {
        subject: "فیزیک ۱",
        chapters: [...physics1, "فصل ۵: ترمودینامیک"],
      },
      { subject: "شیمی ۱", chapters: chemistry1 },
    ],
    11: [
      { subject: "حسابان ۱", chapters: calculus1 },
      { subject: "هندسه ۲", chapters: geometry2 },
      { subject: "آمار و احتمال", chapters: statisticsAndProbability },
      { subject: "فیزیک ۲", chapters: physics2Math },
      { subject: "شیمی ۲", chapters: chemistry2 },
    ],
    12: [
      { subject: "حسابان ۲", chapters: calculus2 },
      { subject: "هندسه ۳", chapters: geometry3 },
      { subject: "ریاضیات گسسته", chapters: discreteMath },
      { subject: "فیزیک ۳", chapters: physics3Math },
      { subject: "شیمی ۳", chapters: chemistry3 },
    ],
  },
  experimental_sciences: {
    10: [
      { subject: "زیست‌شناسی ۱", chapters: biology10 },
      { subject: "ریاضی ۱", chapters: math1 },
      { subject: "فیزیک ۱", chapters: physics1 },
      { subject: "شیمی ۱", chapters: chemistry1 },
    ],
    11: [
      { subject: "زیست‌شناسی ۲", chapters: biology11 },
      { subject: "ریاضی ۲", chapters: experimentalMath2 },
      { subject: "فیزیک ۲", chapters: physics2Experimental },
      { subject: "شیمی ۲", chapters: chemistry2 },
      { subject: "زمین‌شناسی", chapters: geology },
    ],
    12: [
      { subject: "زیست‌شناسی ۳", chapters: biology12 },
      { subject: "ریاضی ۳", chapters: experimentalMath3 },
      { subject: "فیزیک ۳", chapters: physics3Experimental },
      { subject: "شیمی ۳", chapters: chemistry3 },
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