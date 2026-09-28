"use client";
import { FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Logo } from "@/components/logo";
import { createClient } from "@/lib/supabase/client";

export default function SignIn() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setLoading(true); setMessage("");
    const data = new FormData(event.currentTarget);
    const { error } = await createClient().auth.signInWithPassword({ email: String(data.get("email")), password: String(data.get("password")) });
    if (error) { setMessage("ایمیل یا رمز عبور درست نیست."); setLoading(false); return; }
    router.push("/dashboard"); router.refresh();
  }
  return <main className="auth-shell"><aside className="auth-aside"><Logo /><div className="auth-quote"><h1>با یک مسیر روشن، هر روز مطمئن‌تر جلو برو.</h1><p>برنامه، مشاور و منابع تحصیلی تو همه در یک جای امن و ساده.</p></div><small>© نووا</small></aside><section className="auth-main"><form className="auth-card" onSubmit={submit}><h1>خوش برگشتی</h1><p>برای ادامه وارد حساب نووا شو.</p>{message && <div className="form-message" role="alert">{message}</div>}<div className="field"><label htmlFor="email">ایمیل</label><input id="email" name="email" type="email" dir="ltr" autoComplete="email" required /></div><div className="field"><label htmlFor="password">رمز عبور</label><input id="password" name="password" type="password" dir="ltr" autoComplete="current-password" minLength={8} required /></div><button className="button" disabled={loading}>{loading ? "در حال ورود..." : "ورود به حساب"}</button><p className="auth-switch">حساب نداری؟ <Link href="/auth/sign-up">ثبت‌نام کن</Link></p></form></section></main>;
}
