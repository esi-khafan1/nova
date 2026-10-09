"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Logo } from "@/components/logo";
import { createClient } from "@/lib/supabase/client";
import { safeReturnPath } from "@/lib/return-path";

type AuthMode = "signin" | "signup";
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

const benefits = [
  "برنامه اختصاصی هفتگی",
  "مشاور تأییدشده و مناسب تو",
  "منابع معتبر و طبقه‌بندی‌شده",
];

export function UnifiedAuth({ initialMode, returnTo = "/dashboard" }: { initialMode: AuthMode; returnTo?: string }) {
  const destination = safeReturnPath(returnTo);
  const router = useRouter();
  const [mode, setMode] = useState<AuthMode>(initialMode);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  const [success, setSuccess] = useState(false);

  function changeMode(nextMode: AuthMode) {
    setMode(nextMode);
    setMessage("");
    setSuccess(false);
    window.history.replaceState(null, "", `/auth?mode=${nextMode}&next=${encodeURIComponent(destination)}`);
  }

  async function submitSignIn(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage("");
    const data = new FormData(event.currentTarget);
    const email = String(data.get("email") ?? "").trim();
    const password = String(data.get("password") ?? "");

    if (!email) return setMessage("لطفاً ایمیل را وارد کن.");
    if (!emailPattern.test(email)) return setMessage("لطفاً یک ایمیل معتبر وارد کن.");
    if (!password) return setMessage("لطفاً رمز عبور را وارد کن.");
    if (password.length < 8) return setMessage("رمز عبور باید حداقل ۸ کاراکتر باشد.");

    setLoading(true);
    const { error } = await createClient().auth.signInWithPassword({ email, password });
    if (error) {
      setMessage("ایمیل یا رمز عبور درست نیست.");
      setLoading(false);
      return;
    }
    router.push(destination);
    router.refresh();
  }

  async function submitSignUp(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage("");
    const data = new FormData(event.currentTarget);
    const fullName = String(data.get("fullName") ?? "").trim();
    const email = String(data.get("email") ?? "").trim();
    const password = String(data.get("password") ?? "");

    if (fullName.length < 2) return setMessage("لطفاً نام و نام خانوادگی را کامل وارد کن.");
    if (!email) return setMessage("لطفاً ایمیل را وارد کن.");
    if (!emailPattern.test(email)) return setMessage("لطفاً یک ایمیل معتبر وارد کن.");
    if (!password) return setMessage("لطفاً رمز عبور را وارد کن.");
    if (password.length < 8) return setMessage("رمز عبور باید حداقل ۸ کاراکتر باشد.");

    setLoading(true);
    const { error } = await createClient().auth.signUp({
      email,
      password,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(destination)}`,
        data: { full_name: fullName },
      },
    });
    if (error) {
      setMessage(
        error.message.includes("registered")
          ? "قبلاً با این ایمیل ثبت‌نام شده است."
          : "ثبت‌نام انجام نشد. اطلاعات را بررسی کن.",
      );
      setLoading(false);
      return;
    }
    setSuccess(true);
    setMessage("حساب ساخته شد. اگر تأیید ایمیل فعال باشد، صندوق ورودی‌ات را بررسی کن.");
    setLoading(false);
  }

  return (
    <main className="auth-gradient-page">
      <header className="auth-gradient-header">
        <Logo />
        <Link className="auth-gradient-back" href="/">
          بازگشت به خانه <span aria-hidden="true">←</span>
        </Link>
      </header>

      <div className="auth-gradient-wrap">
        <div className="auth-gradient-card">
          <section className="auth-gradient-form">
            <div className="auth-gradient-form-head">
              <span>ورود / ثبت‌نام</span>
              <h1>{mode === "signin" ? "خوش برگشتی!" : "ساخت حساب تازه"}</h1>
              <p>
                {mode === "signin"
                  ? "اطلاعاتت را وارد کن تا وارد مسیرت بشوی."
                  : "چند دقیقه وقت بگذار؛ مسیر روشن شروع می‌شود."}
              </p>
            </div>

            <div className="auth-gradient-tabs" role="tablist" aria-label="انتخاب ورود یا ثبت‌نام">
              <button
                className={mode === "signin" ? "active" : ""}
                type="button"
                role="tab"
                aria-selected={mode === "signin"}
                onClick={() => changeMode("signin")}
              >
                ورود به حساب
              </button>
              <button
                className={mode === "signup" ? "active" : ""}
                type="button"
                role="tab"
                aria-selected={mode === "signup"}
                onClick={() => changeMode("signup")}
              >
                ساخت حساب جدید
              </button>
            </div>

            {message && (
              <div className={`auth-gradient-message${success ? " success" : ""}`} role="status">
                {message}
              </div>
            )}

            {mode === "signin" ? (
              <form key="signin" onSubmit={submitSignIn} noValidate>
                <div className="auth-gradient-field">
                  <label htmlFor="signin-email">ایمیل</label>
                  <input
                    id="signin-email"
                    name="email"
                    type="email"
                    dir="ltr"
                    placeholder="you@example.com"
                    autoComplete="email"
                    required
                  />
                </div>
                <div className="auth-gradient-field">
                  <label htmlFor="signin-password">رمز عبور</label>
                  <input
                    id="signin-password"
                    name="password"
                    type="password"
                    dir="ltr"
                    placeholder="••••••••"
                    autoComplete="current-password"
                    minLength={8}
                    required
                  />
                </div>
                <button className="auth-gradient-submit" disabled={loading}>
                  {loading ? "در حال ورود..." : "ورود به حساب ←"}
                </button>
                <p className="auth-gradient-switch">
                  حساب نداری؟{" "}
                  <button type="button" onClick={() => changeMode("signup")}>یک حساب بساز</button>
                </p>
              </form>
            ) : (
              <form key="signup" onSubmit={submitSignUp} noValidate>
                <div className="auth-gradient-field">
                  <label htmlFor="signup-name">نام و نام خانوادگی</label>
                  <input
                    id="signup-name"
                    name="fullName"
                    placeholder="مثلاً: علی رضایی"
                    autoComplete="name"
                    required
                  />
                </div>
                <div className="auth-gradient-field">
                  <label htmlFor="signup-email">ایمیل</label>
                  <input
                    id="signup-email"
                    name="email"
                    type="email"
                    dir="ltr"
                    placeholder="you@example.com"
                    autoComplete="email"
                    required
                  />
                </div>
                <div className="auth-gradient-field">
                  <label htmlFor="signup-password">رمز عبور</label>
                  <input
                    id="signup-password"
                    name="password"
                    type="password"
                    dir="ltr"
                    placeholder="حداقل ۸ کاراکتر"
                    autoComplete="new-password"
                    minLength={8}
                    required
                  />
                </div>
                <button className="auth-gradient-submit" disabled={loading || success}>
                  {loading ? "در حال ساخت حساب..." : success ? "حساب ساخته شد" : "ساخت حساب جدید ←"}
                </button>
                <p className="auth-gradient-switch">
                  حساب داری؟{" "}
                  <button type="button" onClick={() => changeMode("signin")}>وارد شو</button>
                </p>
              </form>
            )}
          </section>

          <aside className="auth-gradient-side">
            <div className="auth-gradient-side-content">
              <Logo />
              <span className="auth-gradient-eyebrow">● مسیر روشن موفقیت تحصیلی</span>
              <h2>یک نقطه شروع، دو مسیر ساده</h2>
              <p>وارد مسیرت شو یا همین‌جا یک حساب تازه بساز. نووا کنار توست، از اولین قدم تا روز نتیجه.</p>
              <div className="auth-gradient-benefits">
                {benefits.map((benefit) => (
                  <div className="auth-gradient-benefit" key={benefit}>
                    <span aria-hidden="true">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3">
                        <path d="m5 12 4 4L19 6" />
                      </svg>
                    </span>
                    <b>{benefit}</b>
                  </div>
                ))}
              </div>
            </div>
            <small>© ۱۴۰۵ نووا. تمام حقوق محفوظ است.</small>
          </aside>
        </div>
      </div>
    </main>
  );
}
