"use server";

import { cookies } from "next/headers";
import { isEnglishPasswordInput, englishPasswordMessage } from "@/lib/password-input";
import { validConfirmationHash } from "@/lib/email-confirmation";
import { recoveryClient, recoveryCookie } from "@/lib/supabase/recovery";

export async function saveRecoveredPassword(password: string): Promise<{ ok: boolean; message: string }> {
  if (typeof password !== "string" || !isEnglishPasswordInput(password)) return { ok: false, message: englishPasswordMessage };
  if (password.length < 8 || password.length > 128) return { ok: false, message: "رمز جدید باید بین ۸ تا ۱۲۸ کاراکتر باشد." };
  const store = await cookies();
  const token = store.get(recoveryCookie)?.value;
  const clear = () => store.set(recoveryCookie, "", { httpOnly: true, secure: true, sameSite: "lax", path: "/auth", maxAge: 0 });
  const invalid = "لینک بازیابی معتبر نیست یا منقضی شده؛ از مدیر بخواه ایمیل جدید بفرستد.";
  if (!validConfirmationHash(token)) return { ok: false, message: invalid };
  try {
    const client = recoveryClient();
    // The recovery token, not any existing browser session, chooses the account.
    const { data, error } = await client.auth.verifyOtp({ token_hash: token, type: "recovery" });
    clear();
    if (error || !data.session) return { ok: false, message: invalid };
    const { error: updateError } = await client.auth.updateUser({ password });
    await client.auth.signOut({ scope: "local" });
    if (updateError) return { ok: false, message: "ذخیرهٔ رمز انجام نشد. یک لینک جدید از مدیر بگیر و رمز متفاوتی انتخاب کن." };
    return { ok: true, message: "رمز عبور تغییر کرد. با رمز عبور جدید وارد شوید." };
  } catch {
    return { ok: false, message: "ارتباط برقرار نشد. دوباره تلاش کن؛ اگر لینک استفاده شده بود، از مدیر لینک جدید بگیر." };
  }
}
