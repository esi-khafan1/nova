"use server";

import { createClient } from "@/lib/supabase/server";
import { cookies } from "next/headers";
import { isEnglishPasswordInput, englishPasswordMessage } from "@/lib/password-input";
import { validConfirmationHash } from "@/lib/email-confirmation";
import { recoveryClient, recoveryCookie } from "@/lib/supabase/recovery";

export async function saveRecoveredPassword(password: string): Promise<{ ok: boolean; message: string; passwordChanged?: boolean }> {
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
    if (updateError) {
      await client.auth.signOut({ scope: "local" });
      return { ok: false, message: "ذخیرهٔ رمز انجام نشد. یک لینک جدید از مدیر بگیر و رمز متفاوتی انتخاب کن." };
    }
    // Only persist the recovered account's session AFTER its password is saved.
    // Never return access/refresh tokens to client-side code.
    const { data: sessionData, error: sessionError } = await client.auth.getSession();
    if (sessionError || !sessionData.session) return { ok: false, passwordChanged: true, message: "رمز تغییر کرد؛ برای ورود، ایمیل و رمز جدیدت را در بخش ورود وارد کن." };
    const browserSession = await createClient();
    const { error: loginError } = await browserSession.auth.setSession({
      access_token: sessionData.session.access_token,
      refresh_token: sessionData.session.refresh_token,
    });
    if (loginError) return { ok: false, passwordChanged: true, message: "رمز تغییر کرد؛ برای ورود، ایمیل و رمز جدیدت را در بخش ورود وارد کن." };
    return { ok: true, message: "رمز ذخیره شد؛ در حال ورود به پنل..." };
  } catch {
    return { ok: false, message: "ارتباط برقرار نشد. دوباره تلاش کن؛ اگر لینک استفاده شده بود، از مدیر لینک جدید بگیر." };
  }
}
