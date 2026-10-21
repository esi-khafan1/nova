"use server";

import { recoveryClient } from "@/lib/supabase/recovery";
import { emailConfirmationUrl } from "@/lib/auth-urls";

export async function resendConfirmation(email: string): Promise<string> {
  if (typeof email !== "string" || email.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())) {
    return "ایمیلت را در کادر ایمیل وارد کن، سپس ارسال دوباره را بزن.";
  }
  try {
    const { error } = await recoveryClient().auth.resend({
      type: "signup", email: email.trim(), options: { emailRedirectTo: emailConfirmationUrl("/dashboard") },
    });
    if (error) return error.status === 429
      ? "محدودیت ارسال فعال است. کمی صبر کن و دوباره تلاش کن."
      : "ارسال تأییدیه انجام نشد؛ کمی بعد دوباره تلاش کن.";
    // Deliberately do not disclose whether an arbitrary email is registered.
    return "اگر این ایمیل ثبت‌نام شده و تأیید نشده باشد، لینک جدید ارسال می‌شود. جدیدترین ایمیل و پوشهٔ اسپم را بررسی کن.";
  } catch {
    return "ارتباط برقرار نشد؛ کمی بعد دوباره تلاش کن.";
  }
}
