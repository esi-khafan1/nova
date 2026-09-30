"use client";
import { FormEvent, useState } from "react";
import Link from "next/link";
import { Logo } from "@/components/logo";
import { createClient } from "@/lib/supabase/client";

export default function SignUp() {
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  const [success, setSuccess] = useState(false);
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setLoading(true); setMessage("");
    const data = new FormData(event.currentTarget);
    const fullName = String(data.get("fullName"));
    const { error } = await createClient().auth.signUp({ email: String(data.get("email")), password: String(data.get("password")), options: { emailRedirectTo: `${window.location.origin}/auth/callback`, data: { full_name: fullName } } });
    if (error) { setMessage(error.message.includes("registered") ? "قبلاً با این ایمیل ثبت‌نام شده است." : "ثبت‌نام انجام نشد. اطلاعات را بررسی کن."); setLoading(false); return; }
    setSuccess(true); setMessage("حساب ساخته شد. اگر تأیید ایمیل فعال باشد، صندوق ورودی‌ات را بررسی کن."); setLoading(false);
  }
  return <main className="auth-shell"><aside className="auth-aside"><Logo /><div className="auth-quote"><h1>اولین قدم، شناختن مسیر خودت است.</h1><p>حسابت را بساز و تجربه نووا را از یک برنامه ساده و قابل اجرا شروع کن.</p></div><small>© نووا</small></aside><section className="auth-main"><form className="auth-card" onSubmit={submit}><h1>به نووا بپیوند</h1><p>ثبت‌نام اولیه کمتر از دو دقیقه زمان می‌برد.</p>{message && <div className={`form-message${success ? " success" : ""}`} role="status">{message}</div>}<div className="field"><label htmlFor="fullName">نام و نام خانوادگی</label><input id="fullName" name="fullName" autoComplete="name" required /></div><div className="field"><label htmlFor="email">ایمیل</label><input id="email" name="email" type="email" dir="ltr" autoComplete="email" required /></div><div className="field"><label htmlFor="password">رمز عبور</label><input id="password" name="password" type="password" dir="ltr" autoComplete="new-password" minLength={8} required /></div><button className="button" disabled={loading || success}>{loading ? "در حال ساخت حساب..." : success ? "حساب ساخته شد" : "ثبت‌نام"}</button><p className="auth-switch">قبلاً ثبت‌نام کرده‌ای؟ <Link href="/auth/sign-in">وارد شو</Link></p></form></section></main>;
}
