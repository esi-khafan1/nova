const messages: Record<string, string> = {
  metadata: "عنوان، مخاطبان یا رشتهٔ آزمون معتبر نیست. اطلاعات اصلی آزمون را بررسی کن.",
  schedule: "تاریخ و ساعت شروع آزمون باید معتبر و حداقل یک دقیقه در آینده باشد. ساعت‌ها به وقت تهران هستند.",
  booklets: "آزمون باید حداقل یک دفترچهٔ معتبر داشته باشد.",
  booklet_params: "تعداد سؤال هر دفترچه باید بین ۱ تا ۲۰۰ و مدت آن بین ۱ تا ۳۶۰ دقیقه باشد.",
  duration_total: "مجموع زمان دفترچه‌های آزمون نباید بیشتر از ۶۰۰ دقیقه باشد.",
  booklet_pdf: "برای انتشار، فایل PDF تمام دفترچه‌ها باید بارگذاری شده باشد.",
  incomplete_key: "برای انتشار آزمون باید گزینهٔ صحیح تمام سؤال‌ها مشخص شود. سؤال‌های بدون کلید را بررسی کن.",
  permission: "ساخت آزمون فقط برای حساب مشاورِ تأییدشده مجاز است. وضعیت حساب و تأیید مشاور را بررسی کن.",
  submitted_exam: "آزمونی که پاسخ ثبت‌شده دارد قابل ویرایش نیست؛ برای تغییرات، آزمون جدید بساز.",
};

export function examSaveErrorMessage(code: string | undefined): string {
  return code && Object.hasOwn(messages, code) ? messages[code] : "ذخیره آزمون انجام نشد. دوباره تلاش کن؛ اگر خطا ادامه داشت، به مدیر اطلاع بده.";
}

// Never expose raw database errors, SQL, or submitted exam content to readers.
export function examSaveErrorCode(error: { message: string; code?: string }): string {
  const message = error.message.toLowerCase();
  if (message.includes("only approved counselors") || error.code === "42501") return "permission";
  if (message.includes("metadata or schedule")) return "schedule";
  if (message.includes("total exam duration")) return "duration_total";
  if (message.includes("requires a valid pdf")) return "booklet_pdf";
  if (message.includes("answer key") || message.includes("key for every question")) return "incomplete_key";
  if (message.includes("booklet duration") || message.includes("question count")) return "booklet_params";
  if (message.includes("at least one booklet")) return "booklets";
  if (message.includes("with submissions cannot be edited")) return "submitted_exam";
  return "save_failed";
}
