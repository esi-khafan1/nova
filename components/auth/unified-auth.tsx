"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import { Logo } from "@/components/logo";
import { createClient } from "@/lib/supabase/client";

type AuthMode = "signin" | "signup";

export function UnifiedAuth({ initialMode }: { initialMode: AuthMode }) {
  const router = useRouter();
  const [mode, setMode] = useState<AuthMode>(initialMode);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");
  const [success, setSuccess] = useState(false);

  function changeMode(nextMode: AuthMode) {
    setMode(nextMode);
    setMessage("");
    setSuccess(false);
    window.history.replaceState(null, "", `/auth?mode=${nextMode}`);
  }

  async function submitSignIn(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setLoading(true);
    setMessage("");
    const data = new FormData(event.currentTarget);
    const { error } = await createClient().auth.signInWithPassword({
      email: String(data.get("email")),
      password: String(data.get("password")),
    });
    if (error) {
      setMessage("ایمیل یا رمز عبور درست نیست.");
      setLoading(false);
      return;
    }
    router.push("/dashboard");
    router.refresh();
  }

  async function submitSignUp(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setLoading(true);
    setMessage("");
    const data = new FormData(event.currentTarget);
    const { error } = await createClient().auth.signUp({
      email: String(data.get("email")),
      password: String(data.get("password")),
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
        data: { full_name: String(data.get("fullName")) },
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
    setMessage(
      "حساب ساخته شد. اگر تأیید ایمیل فعال باشد، صندوق ورودی‌ات را بررسی کن.",
    );
    setLoading(false);
  }

  return (
    <main className="auth-shell unified-auth">
      <aside className="auth-aside">
        <Logo />
        <div className="auth-quote">
          <span className="auth-kicker">یک نقطه شروع، دو مسیر ساده</span>
          <h1>وارد مسیرت شو یا همین‌جا یک حساب تازه بساز.</h1>
          <p>
            ورود و ثبت‌نام نووا در یک صفحه کنار هم قرار گرفته‌اند تا انتخاب و
            ادامه مسیر ساده‌تر باشد.
          </p>
        </div>
        <small>© نووا</small>
      </aside>

      <section className="auth-main">
        <div className="auth-card unified-auth-card">
          <div className="auth-mode-heading">
            <span>{mode === "signin" ? "ادامه مسیر" : "شروع مسیر"}</span>
            <h1>{mode === "signin" ? "خوش برگشتی" : "به نووا بپیوند"}</h1>
            <p>
              {mode === "signin"
                ? "اطلاعات حسابت را وارد کن."
                : "اطلاعات اولیه‌ات را ثبت کن."}
            </p>
          </div>

          {message && (
            <div
              className={`form-message${success ? " success" : ""}`}
              role="status"
            >
              {message}
            </div>
          )}

          {mode === "signin" ? (
            <form onSubmit={submitSignIn}>
              <div className="field">
                <label htmlFor="signin-email">ایمیل</label>
                <input
                  id="signin-email"
                  name="email"
                  type="email"
                  dir="ltr"
                  autoComplete="email"
                  required
                />
              </div>
              <div className="field">
                <label htmlFor="signin-password">رمز عبور</label>
                <input
                  id="signin-password"
                  name="password"
                  type="password"
                  dir="ltr"
                  autoComplete="current-password"
                  minLength={8}
                  required
                />
              </div>
              <button className="button" disabled={loading}>
                {loading ? "در حال ورود..." : "ورود به حساب"}
              </button>
              <p className="auth-switch">
                حساب نداری؟{" "}
                <button
                  className="auth-switch-button"
                  type="button"
                  onClick={() => changeMode("signup")}
                >
                  یک حساب بساز
                </button>
              </p>
            </form>
          ) : (
            <form onSubmit={submitSignUp}>
              <div className="field">
                <label htmlFor="signup-name">نام و نام خانوادگی</label>
                <input
                  id="signup-name"
                  name="fullName"
                  autoComplete="name"
                  required
                />
              </div>
              <div className="field">
                <label htmlFor="signup-email">ایمیل</label>
                <input
                  id="signup-email"
                  name="email"
                  type="email"
                  dir="ltr"
                  autoComplete="email"
                  required
                />
              </div>
              <div className="field">
                <label htmlFor="signup-password">رمز عبور</label>
                <input
                  id="signup-password"
                  name="password"
                  type="password"
                  dir="ltr"
                  autoComplete="new-password"
                  minLength={8}
                  required
                />
              </div>
              <button className="button" disabled={loading || success}>
                {loading
                  ? "در حال ساخت حساب..."
                  : success
                    ? "حساب ساخته شد"
                    : "ثبت‌نام"}
              </button>
              <p className="auth-switch">
                قبلاً ثبت‌نام کرده‌ای؟{" "}
                <button
                  className="auth-switch-button"
                  type="button"
                  onClick={() => changeMode("signin")}
                >
                  وارد شو
                </button>
              </p>
            </form>
          )}
        </div>
      </section>
    </main>
  );
}