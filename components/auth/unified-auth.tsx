"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { LandingHeader } from "@/components/landing-header";
import { createClient } from "@/lib/supabase/client";
import { safeReturnPath } from "@/lib/return-path";
import { isEnglishPasswordInput, englishPasswordMessage } from "@/lib/password-input";
import { saveRecoveredPassword } from "@/app/auth/recovery/actions";
import { normalizeMobile } from "@/lib/phone-auth";
import { emailConfirmationUrl } from "@/lib/auth-urls";

type AuthMode = "signin" | "signup" | "reset";
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

const benefits = [
  { title: "مسیر متناسب با تو", detail: "دوره‌ها و منابع مناسب پایه و رشته‌ات" },
  { title: "همراهی در هر قدم", detail: "برنامه‌ریزی و مشاوره، از شروع تا نتیجه" },
];

export function UnifiedAuth({ initialMode, returnTo = "/dashboard", initialMessage = "", phoneSignup = false }: { initialMode: AuthMode; returnTo?: string; initialMessage?: string; phoneSignup?: boolean }) {
  const destination = safeReturnPath(returnTo);
  const router = useRouter();
  const [mode, setMode] = useState<AuthMode>(initialMode);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState(initialMessage);
  const [success, setSuccess] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [passwordValue, setPasswordValue] = useState("");
  const [passwordError, setPasswordError] = useState("");

  const [challenge, setChallenge] = useState<string|null>(null);
  const [otp, setOtp] = useState("");
  const [resendAt, setResendAt] = useState(0);
  async function phoneRequest(body:Record<string,unknown>){
    const response=await fetch('/api/auth/phone',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)});
    const result=await response.json();if(!response.ok)throw Error(result.message||'ارتباط انجام نشد.');return result;
  }
  async function verifyPhone(event:FormEvent<HTMLFormElement>){
    event.preventDefault();if(!challenge||!/^\d{6}$/.test(otp))return setMessage('کد شش‌رقمی را وارد کن.');
    setLoading(true);setMessage('');setSuccess(false);
    try{await phoneRequest({action:'verify',phone:challenge,token:otp,password:passwordValue});setPasswordValue('');setOtp('');window.location.assign(destination);}
    catch(error){setMessage(error instanceof Error?error.message:'کد تأیید نشد.');setLoading(false);}
  }
  async function resendCode(){
    if(!challenge||loading)return;
    if(Date.now()<resendAt){setMessage('برای کد جدید یک دقیقه صبر کن.');return;}
    setLoading(true);
    try{await phoneRequest({action:'resend',phone:challenge});setResendAt(Date.now()+60000);setMessage('کد جدید ارسال شد.');}
    catch(error){setMessage(error instanceof Error?error.message:'ارسال انجام نشد.');}finally{setLoading(false);}
  }
  function changePassword(value: string) {
    if (!isEnglishPasswordInput(value)) {
      // Reject the entire edit/paste rather than silently altering a password.
      setPasswordError(englishPasswordMessage);
      return;
    }
    setPasswordValue(value);
    setPasswordError("");
  }

  function changeMode(nextMode: AuthMode) {
    setMode(nextMode);
    setChallenge(null);setOtp("");setResendAt(0);
    setShowPassword(false);
    setPasswordValue("");
    setPasswordError("");
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

    if (!email) return setMessage("شماره تلفن همراه یا ایمیل را وارد کن.");
    if (!emailPattern.test(email) && !normalizeMobile(email)) return setMessage("شماره تلفن همراه یا ایمیل معتبر وارد کن.");
    if (!isEnglishPasswordInput(password) || passwordError) {
      setPasswordError(englishPasswordMessage);
      return;
    }
    if (!password) return setMessage("لطفاً رمز عبور را وارد کن.");
    if (password.length < 8) return setMessage("رمز عبور باید حداقل ۸ کاراکتر باشد.");

    setLoading(true);
    if(normalizeMobile(email)){
      try{await phoneRequest({action:'signin',phone:email,password});window.location.assign(destination);}
      catch(error){setMessage(error instanceof Error?error.message:'شماره یا رمز عبور درست نیست.');setLoading(false);}return;
    }
    const { error } = await createClient().auth.signInWithPassword({ email, password });
    if (error) {
      setMessage("ایمیل یا رمز عبور درست نیست.");
      setLoading(false);
      return;
    }
    // A single full navigation clears any pre-login App Router cache. push +
    // refresh could start two competing /dashboard requests after sign-in.
    window.location.assign(destination);
  }

  async function submitReset(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage("");
    if (passwordError || !isEnglishPasswordInput(passwordValue)) {
      setPasswordError(englishPasswordMessage);
      return;
    }
    if (passwordValue.length < 8 || passwordValue.length > 128) {
      setMessage("رمز جدید باید بین ۸ تا ۱۲۸ کاراکتر باشد.");
      return;
    }
    setLoading(true);
    try {
      const result = await saveRecoveredPassword(passwordValue);
      if (result.ok) {
        setPasswordValue("");
        router.replace("/dashboard");
        router.refresh();
        return;
      }
      if (result.passwordChanged) {
        setMode("signin");
        setPasswordValue("");
        setShowPassword(false);
        window.history.replaceState(null, "", "/auth?mode=signin&password_changed=1");
      }
      setMessage(result.message);
    } catch {
      setMessage("ارتباط برقرار نشد؛ دوباره تلاش کن.");
    } finally {
      setLoading(false);
    }
  }

  async function submitSignUp(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage("");
    const data = new FormData(event.currentTarget);
    const fullName = String(data.get("fullName") ?? "").trim();
    const email = String(data.get("email") ?? "").trim();
    const password = String(data.get("password") ?? "");

    if (fullName.length < 2) return setMessage("لطفاً نام و نام خانوادگی را کامل وارد کن.");
    if (phoneSignup ? !normalizeMobile(email) : !emailPattern.test(email)) return setMessage(phoneSignup?"شماره تلفن همراه معتبر وارد کن.":"لطفاً یک ایمیل معتبر وارد کن.");
    if (!isEnglishPasswordInput(password) || passwordError) {
      setPasswordError(englishPasswordMessage);
      return;
    }
    if (!password) return setMessage("لطفاً رمز عبور را وارد کن.");
    if (password.length < 8) return setMessage("رمز عبور باید حداقل ۸ کاراکتر باشد.");

    if(phoneSignup){
      if(Date.now()<resendAt)return setMessage('برای دریافت کد جدید حداقل یک دقیقه صبر کن.');
      setLoading(true);
      try{await phoneRequest({action:'signup',phone:email,password,fullName,next:destination});setChallenge(normalizeMobile(email));setResendAt(Date.now()+60000);setSuccess(true);setMessage('کد به شماره‌ات ارسال شد؛ کد را وارد کن تا مستقیم وارد حساب شوی.');}
      catch(error){setSuccess(false);setMessage(error instanceof Error?error.message:'ارسال کد انجام نشد.');}
      finally{setLoading(false);}return;
    }
    setLoading(true);
    const { data: signupData, error } = await createClient().auth.signUp({
      email,
      password,
      options: {
        emailRedirectTo: emailConfirmationUrl(destination),
        data: { full_name: fullName, course_return_to: destination },
      },
    });
    if (error) {
      setMessage(
        error.message.includes("registered")
          ? "این حساب قبلاً ساخته شده است؛ وارد شوید."
          : "ثبت‌نام انجام نشد. اطلاعات را بررسی کن.",
      );
      setLoading(false);
      return;
    }
    if (signupData.user?.identities?.length === 0) {
      changeMode("signin");
      setMessage("این حساب قبلاً ساخته شده است؛ وارد شوید.");
      setLoading(false);
      return;
    }
    setSuccess(true);
    setMessage("حالا ایمیلت را باز کن و روی دکمهٔ تأیید بزن؛ بعد وارد حساب شو. اگر ایمیل را ندیدی، پوشهٔ اسپم را هم چک کن.");
    setLoading(false);
  }

  return (
    <div className="nova-auth-page">
      <LandingHeader isAuthenticated={false} />
      <main className="nova-auth-main" id="auth-content">
        <div className="nova-auth-topline">
          <span className="nova-auth-topline-caption">یک شروع روشن، به سبک خودت</span>
          <Link href="/"><span>بازگشت<span className="nova-auth-home-label"> به خانه</span></span> <AuthIcon name="arrow" /></Link>
        </div>
        <div className="nova-auth-card">
          <section className="nova-auth-form-panel" aria-labelledby="nova-auth-title">
            <div className="nova-auth-heading">
              <span className="nova-auth-eyebrow"><i aria-hidden="true" /> حساب کاربری نووا</span>
              <h1 id="nova-auth-title">{mode === "reset" ? "رمز جدیدت را تعیین کن" : mode === "signin" ? "خوش برگشتی!" : "قدم اول، با تو"}</h1>
              <p>{mode === "reset" ? "رمز جدیدت را وارد کن تا مستقیم وارد پنل شوی." : mode === "signin" ? "وارد حساب شو و مسیرت را از همان‌جا ادامه بده." : "حسابت را بساز؛ مسیر مناسب خودت را پیدا کن."}</p>
            </div>

            {mode !== "reset" && <div className="nova-auth-tabs" role="tablist" aria-label="انتخاب ورود یا ثبت‌نام">
              {(["signin", "signup"] as const).map((tabMode) => (
                <button key={tabMode} id={`auth-tab-${tabMode}`} className={mode === tabMode ? "active" : ""} type="button" role="tab" aria-selected={mode === tabMode} aria-controls="auth-form-panel" tabIndex={mode === tabMode ? 0 : -1} disabled={loading}
                  onClick={() => changeMode(tabMode)}
                  onKeyDown={(event) => {
                    if (!["ArrowLeft", "ArrowRight", "Home", "End"].includes(event.key)) return;
                    event.preventDefault();
                    const nextMode = event.key === "Home" ? "signin" : event.key === "End" ? "signup" : mode === "signin" ? "signup" : "signin";
                    changeMode(nextMode);
                    document.getElementById(`auth-tab-${nextMode}`)?.focus();
                  }}>
                  {tabMode === "signin" ? "ورود به حساب" : "ثبت‌نام"}
                </button>
              ))}
            </div>}

            {message && (
              <div className={`nova-auth-message${success ? " success" : ""}`} role={success ? "status" : "alert"} aria-live="polite">
                <AuthIcon name={success ? "check" : "info"} /><p>{message}</p>
              </div>
            )}

            <div id="auth-form-panel" role={mode === "reset" ? undefined : "tabpanel"} aria-labelledby={mode === "reset" ? "nova-auth-title" : `auth-tab-${mode}`}>
              <form key={mode} onSubmit={mode === "signup" && challenge ? verifyPhone : mode === "reset" ? submitReset : mode === "signin" ? submitSignIn : submitSignUp} noValidate aria-busy={loading}>
                {mode === "signup" && <div className="nova-auth-field">
                  <label htmlFor="signup-name">نام و نام خانوادگی</label>
                  <div className="nova-auth-input-wrap"><span className="nova-auth-input-icon"><AuthIcon name="account" /></span><input id="signup-name" name="fullName" readOnly={!!challenge || loading} placeholder="مثلاً: علی رضایی" autoComplete="name" required /></div>
                </div>}
                {mode !== "reset" && <div className="nova-auth-field">
                  <label htmlFor={`${mode}-email`}>{mode === "signin" ? "شماره تلفن همراه یا ایمیل" : phoneSignup ? "شماره تلفن همراه" : "ایمیل"}</label>
                  <div className="nova-auth-input-wrap"><span className="nova-auth-input-icon"><AuthIcon name="email" /></span><input id={`${mode}-email`} name="email" readOnly={!!challenge || loading} type={mode === "signup" && !phoneSignup ? "email" : "text"} inputMode={mode === "signup" && phoneSignup ? "tel" : "text"} dir="ltr" placeholder={mode === "signup" && phoneSignup ? "09xxxxxxxxx" : "شماره موبایل یا you@example.com"} autoComplete={mode === "signin" ? "username" : phoneSignup ? "tel" : "email"} autoCapitalize="none" spellCheck={false} required /></div>
                </div>}
                <div className="nova-auth-field">
                  <label htmlFor={`${mode}-password`}>{mode === "reset" ? "رمز عبور جدید" : "رمز عبور"}</label>
                  <div className="nova-auth-input-wrap nova-auth-password"><input id={`${mode}-password`} name="password" value={passwordValue} readOnly={!!challenge || loading} maxLength={128} onChange={event => changePassword(event.target.value)} aria-invalid={!!passwordError} aria-describedby={passwordError ? `${mode}-password-error` : undefined} autoCapitalize="none" autoCorrect="off" spellCheck={false} type={showPassword ? "text" : "password"} dir="ltr" placeholder={mode === "signin" ? "رمز عبورت را وارد کن" : "حداقل ۸ کاراکتر"} autoComplete={mode === "signin" ? "current-password" : "new-password"} minLength={8} required /><button type="button" className="nova-auth-reveal" aria-label={showPassword ? "پنهان‌کردن رمز عبور" : "نمایش رمز عبور"} aria-pressed={showPassword} onClick={() => setShowPassword(value => !value)}><AuthIcon name={showPassword ? "eyeOff" : "eye"} /></button></div>
                </div>
                {mode === 'signup' && challenge && <div className="nova-auth-field"><label htmlFor="signup-code">کد تأیید شماره</label><div className="nova-auth-input-wrap"><input id="signup-code" value={otp} onChange={event=>setOtp(event.target.value.replace(/[^0-9]/g,''))} inputMode="numeric" autoComplete="one-time-code" dir="ltr" maxLength={6} autoFocus required /></div><div className="nova-auth-code-actions"><button type="button" disabled={loading} onClick={()=>{setChallenge(null);setOtp('');setSuccess(false);setMessage('شماره را اصلاح کن یا پس از یک دقیقه دوباره دریافت کد را بزن.');}}>اصلاح شماره</button><button type="button" disabled={loading} onClick={resendCode}>دریافت کد جدید</button></div></div>}
                {passwordError && <p id={`${mode}-password-error`} role="alert" className="nova-auth-message">{passwordError}</p>}
                <button className="nova-auth-submit" type="submit" disabled={loading || (mode === "signup" && success && !phoneSignup)}>
                  <span>{mode === "reset" ? (loading ? "در حال ذخیره..." : "ورود با رمز جدید") : loading ? mode === "signin" ? "در حال ورود..." : "در حال ساخت حساب..." : mode === "signin" ? "ورود به حساب" : phoneSignup ? challenge ? "تأیید کد و ورود" : "دریافت کد" : success ? "حساب ساخته شد" : "ساخت حساب جدید"}</span><AuthIcon name={success && mode === "signup" ? "check" : "arrow"} />
                </button>
              </form>
            </div>
            {mode === "signup" && <div className="nova-auth-footnote"><AuthIcon name="shield" /><span>{phoneSignup ? "شماره‌ات را با کد پیامکی تأیید کن؛ سپس مستقیم وارد حسابت می‌شوی." : "بعد از ثبت‌نام، ایمیلت را تأیید کن تا وارد حسابت شوی."}</span></div>}
          </section>

          <aside className="nova-auth-story" aria-labelledby="nova-auth-story-title">
            <div className="nova-auth-story-copy">
              <span className="nova-auth-eyebrow">از اولین قدم تا روز نتیجه</span>
              <h2 id="nova-auth-story-title">آیندهٔ روشن،<br /><em>از همین‌جا.</em></h2>
              <p>هدف تو، مسیر تو، برنامهٔ تو.<br />با نووا، قدم بعدی را مطمئن‌تر بردار.</p>
            </div>
            <div className="nova-auth-benefits">{benefits.map(benefit => <div key={benefit.title}><span className="nova-auth-benefit-icon"><AuthIcon name="check" /></span><div><strong>{benefit.title}</strong><p>{benefit.detail}</p></div></div>)}</div>
          </aside>
        </div>
      </main>
    </div>
  );
}

function AuthIcon({ name }: { name: "arrow" | "account" | "email" | "lock" | "eye" | "eyeOff" | "shield" | "check" | "info" }) {
  const paths = {
    arrow: <path d="M19 12H5m6-6-6 6 6 6" />,
    account: <><circle cx="12" cy="8" r="4" /><path d="M4 21v-2a8 8 0 0 1 16 0v2" /></>,
    email: <><rect x="3" y="5" width="18" height="14" rx="3" /><path d="m4 7 8 6 8-6" /></>,
    lock: <><rect x="5" y="10" width="14" height="11" rx="3" /><path d="M8 10V7a4 4 0 0 1 8 0v3M12 14v3" /></>,
    eye: <><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z" /><circle cx="12" cy="12" r="3" /></>,
    eyeOff: <><path d="m3 3 18 18M9.5 5.3A11 11 0 0 1 12 5c6.5 0 10 7 10 7a17 17 0 0 1-3 3.8M6 6.5A18 18 0 0 0 2 12s3.5 7 10 7a11 11 0 0 0 5-1.2M10 10a3 3 0 0 0 4 4" /></>,
    shield: <><path d="m12 3 8 3v5c0 5-8 10-8 10S4 16 4 11V6l8-3Z" /><path d="m8 12 3 3 5-6" /></>,
    check: <path d="m5 12 4 4L19 6" />,
    info: <><circle cx="12" cy="12" r="9" /><path d="M12 11v5M12 8h.01" /></>,
  };
  return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}
