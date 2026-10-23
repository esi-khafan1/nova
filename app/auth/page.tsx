import "../landing-approved.css";
import "./auth-gradient.css";
import { UnifiedAuth } from "@/components/auth/unified-auth";
import { safeReturnPath } from "@/lib/return-path";
import { getRequestUser } from "@/lib/supabase/request-auth";
import { cookies } from "next/headers";
import { recoveryCookie } from "@/lib/supabase/recovery";
import { validConfirmationHash } from "@/lib/email-confirmation";
import { redirect } from "next/navigation";

export default async function AuthPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const params = await searchParams;
  const resetting = params.mode === "reset" && validConfirmationHash((await cookies()).get(recoveryCookie)?.value);
  const initialMode = resetting ? "reset" : params.mode === "signup" ? "signup" : "signin";

  const returnTo = safeReturnPath(params.next ?? (await cookies()).get("nova_course_return")?.value);
  const { user } = await getRequestUser();
  if (user?.email_confirmed_at && params.confirmed !== "1" && !resetting && params.password_changed !== "1" && params.error !== "recovery" && params.mode !== "reset") redirect(returnTo);
  return <UnifiedAuth initialMode={initialMode} returnTo={returnTo} initialMessage={resetting ? "با رمز عبور جدید وارد شوید." : params.password_changed === "1" ? "با رمز عبور جدید وارد شوید." : params.error === "recovery" || (params.mode === "reset" && !resetting) ? "لینک بازیابی معتبر نیست یا منقضی شده؛ از مدیر لینک جدید بگیر." : params.confirmed === "1" ? "ایمیلت تأیید شد. با ایمیل و رمز عبورت وارد شو." : params.error === "callback" ? "لینک تأیید نامعتبر، منقضی یا قبلاً استفاده شده است. اگر ایمیلت را تأیید کرده‌ای وارد شو؛ در غیر این صورت لینک جدید درخواست کن." : user || params.error === "unconfirmed" ? "ابتدا لینک تأیید ایمیل را باز کن، سپس وارد حساب شو." : ""} />;
}