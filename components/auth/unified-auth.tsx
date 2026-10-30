"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { LandingHeader } from "@/components/landing-header";
import { safeReturnPath } from "@/lib/return-path";
import { isEnglishPasswordInput, englishPasswordMessage } from "@/lib/password-input";
import { saveRecoveredPassword } from "@/app/auth/recovery/actions";
import { englishPhoneMessage, isEnglishMobileInput, normalizeMobile } from "@/lib/phone-auth";

type AuthMode = "signin" | "signup" | "reset";
type SignupRecoveryHint = "existing" | "uncertain" | null;
class PhoneRequestError extends Error {
  constructor(message: string, readonly status: number | null) { super(message); }
}
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
  const [signupRecoveryHint, setSignupRecoveryHint] = useState<SignupRecoveryHint>(null);
  const [success, setSuccess] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [phoneValue, setPhoneValue] = useState("");
  const [phoneError, setPhoneError] = useState("");
  const [passwordValue, setPasswordValue] = useState("");
  const [passwordError, setPasswordError] = useState("");

  const [challenge, setChallenge] = useState<string|null>(null);
  const [otp, setOtp] = useState("");
  const [resendAt, setResendAt] = useState(0);
  async function phoneRequest(body:Record<string,unknown>){
    // AbortSignal.timeout is absent in older iOS Safari. If it throws before
    // fetch starts, the UI incorrectly reports a network failure on every login.
    const controller = new AbortController();
    const timer = window.setTimeout(() => controller.abort(), 20000);
    try{
      const response=await fetch('/api/auth/phone',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body),signal:controller.signal});
      const result=await response.json();if(!response.ok)throw new PhoneRequestError(result.message||'ارتباط انجام نشد.',response.status);return result;
    }catch(error){
      if(error instanceof Error&&(error.name==='TimeoutError'||error.name==='AbortError'||error.name==='TypeError'))throw new PhoneRequestError('ارتباط با سرور برقرار نشد یا بیش از حد طول کشید؛ کمی بعد دوباره تلاش کن.',null);
      throw error;
    }finally{window.clearTimeout(timer);}
  }
  async function verifyPhone(event:FormEvent<HTMLFormElement>){
    event.preventDefault();if(!challenge||!/^\d{6}$/.test(otp))return setMessage('کد شش‌رقمی را وارد کن.');
    setLoading(true);setMessage('');setSuccess(false);
    // Keep the entered phone/password until navigation actually leaves the page.
    // Clearing them here strands the student on an empty form if navigation fails.
    try{await phoneRequest({action:'verify',phone:challenge,token:otp,password:passwordValue});window.location.assign(destination);}
    catch(error){setMessage(error instanceof Error?error.message:'کد تأیید نشد.');setLoading(false);}
  }
  async function resendCode(){
    if(!challenge||loading)return;
    if(Date.now()<resendAt){setMessage('برای کد جدید یک دقیقه صبر کن.');return;}
    setLoading(true);
    try{await phoneRequest({action:'resend',phone:challenge});setResendAt(Date.now()+60000);setMessage('کد جدید ارسال شد.');}
    catch(error){setMessage(error instanceof Error?error.message:'ارسال انجام نشد.');}finally{setLoading(false);}
  }
  function changePhone(value: string) {
    if (/[^\x20-\x7e]/.test(value)) {
      setPhoneError(englishPhoneMessage);
      return;
    }
    setPhoneValue(value);
    setPhoneError("");
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

  function changeMode(nextMode: AuthMode, keepPhone = false) {
    setMode(nextMode);
    setChallenge(null);setOtp("");setResendAt(0);
    setShowPassword(false);
    if (!keepPhone) setPhoneValue("");
    setPhoneError("");
    setPasswordValue("");
    setPasswordError("");
    setMessage("");
    setSignupRecoveryHint(null);
    setSuccess(false);
    window.history.replaceState(null, "", `/auth?mode=${nextMode}&next=${encodeURIComponent(destination)}`);
  }

  async function submitSignIn(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setMessage("");
    const data = new FormData(event.currentTarget);
    const email = String(data.get("email") ?? "").trim();
    const password = String(data.get("password") ?? "");

    if (phoneError || (!emailPattern.test(email) && normalizeMobile(email) && !isEnglishMobileInput(email))) return setPhoneError(englishPhoneMessage);
    if (!email) return setMessage("شماره تلفن همراه را وارد کن.");
    if (!emailPattern.test(email) && !isEnglishMobileInput(email)) return setMessage("اطلاعات ورود معتبر وارد کن.");
    if (!isEnglishPasswordInput(password) || passwordError) {
      setPasswordError(englishPasswordMessage);
      return;
    }
    if (!password) return setMessage("لطفاً رمز عبور را وارد کن.");
    if (password.length < 8) return setMessage("رمز عبور باید حداقل ۸ کاراکتر باشد.");

    setLoading(true);
    try{
      await phoneRequest({action:'signin',...(normalizeMobile(email)?{phone:email}:{email}),password});
      // One full navigation reads the server-issued cookies and clears old caches.
      window.location.assign(destination);
    }catch(error){setMessage(error instanceof Error?error.message:'ارتباط برقرار نشد؛ دوباره تلاش کن.');}
    finally{setLoading(false);}
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
    setSignupRecoveryHint(null);
    const data = new FormData(event.currentTarget);
    const fullName = String(data.get("fullName") ?? "").trim().replace(/\s+/gu," ");
    const email = String(data.get("email") ?? "").trim();
    const password = String(data.get("password") ?? "");

    if (fullName.length < 3 || fullName.length > 100 || !/^\S+\s+\S+(?:\s+\S+)*$/u.test(fullName)) return setMessage("لطفاً نام و نام خانوادگی را کامل وارد کن.");
    if (phoneError || (normalizeMobile(email) && !isEnglishMobileInput(email))) return setPhoneError(englishPhoneMessage);
    if (!isEnglishMobileInput(email)) return setMessage("شماره تلفن همراه معتبر وارد کن.");
    if (!phoneSignup) return setMessage("ثبت‌نام فعلاً در دسترس نیست؛ کمی بعد تلاش کن.");
    if (!isEnglishPasswordInput(password) || passwordError) {
      setPasswordError(englishPasswordMessage);
      return;
    }
    if (!password) return setMessage("لطفاً رمز عبور را وارد کن.");
    if (password.length < 8) return setMessage("رمز عبور باید حداقل ۸ کاراکتر باشد.");

    if(Date.now()<resendAt)return setMessage('برای دریافت کد جدید حداقل یک دقیقه صبر کن.');
    setLoading(true);
    try{await phoneRequest({action:'signup',phone:email,password,fullName,next:destination});setChallenge(normalizeMobile(email));setResendAt(Date.now()+60000);setSuccess(true);setMessage('درخواست کد ثبت شد؛ اگر پیامک رسید، کد را وارد کن تا وارد حساب شوی.');}
    catch(error){
      setSuccess(false);
      const uncertain = error instanceof PhoneRequestError && error.status === null;
      setSignupRecoveryHint(error instanceof PhoneRequestError && error.status === 409 ? "existing" : uncertain ? "uncertain" : null);
      setMessage(uncertain
        ? 'پاسخ ثبت‌نام نرسید؛ معلوم نیست حساب ساخته شده یا نه. اگر قبلاً کد را تأیید کرده‌ای، ورود را امتحان کن. اگر پیامک رسیده ولی فرم کد باز نشده، درخواست را پیاپی تکرار نکن و با پشتیبانی تماس بگیر.'
        : error instanceof Error ? error.message : 'ارسال کد انجام نشد.');
    }
    finally{setLoading(false);}
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
              <p>{mode === "reset" ? "رمز جدیدت را وارد کن تا مستقیم وارد پنل شوی." : mode === "signin" ? "با شماره تلفن همراه و رمز عبورت وارد شو." : "حسابت را بساز؛ مسیر مناسب خودت را پیدا کن."}</p>
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
                <AuthIcon name={success ? "check" : "info"} />
                <div><p>{message}</p>{mode === "signup" && signupRecoveryHint && (
                  <button type="button" className="nova-auth-signin-hint" onClick={() => changeMode("signin", true)}>
                    {signupRecoveryHint === "existing" ? "اگر شماره‌ات تأیید شده، ورود با همین شماره" : "حساب را قبلاً تأیید کرده‌ای؟ ورود با همین شماره"}
                  </button>
                )}</div>
              </div>
            )}

            <div id="auth-form-panel" role={mode === "reset" ? undefined : "tabpanel"} aria-labelledby={mode === "reset" ? "nova-auth-title" : `auth-tab-${mode}`}>
              <form key={mode} onSubmit={mode === "signup" && challenge ? verifyPhone : mode === "reset" ? submitReset : mode === "signin" ? submitSignIn : submitSignUp} noValidate aria-busy={loading}>
                {mode === "signup" && <div className="nova-auth-field">
                  <label htmlFor="signup-name">نام و نام خانوادگی</label>
                  <div className="nova-auth-input-wrap"><span className="nova-auth-input-icon"><AuthIcon name="account" /></span><input id="signup-name" name="fullName" readOnly={!!challenge || loading} placeholder="مثلاً: علی رضایی" autoComplete="name" required /></div>
                </div>}
                {mode !== "reset" && <div className="nova-auth-field">
                  <label htmlFor={`${mode}-email`}>شماره تلفن همراه</label>
                  <div className="nova-auth-input-wrap"><span className="nova-auth-input-icon"><AuthIcon name="phone" /></span><input id={`${mode}-email`} name="email" value={phoneValue} onChange={event => changePhone(event.target.value)} readOnly={!!challenge || loading} aria-invalid={!!phoneError} aria-describedby={`${mode}-phone-help${phoneError ? ` ${mode}-phone-error` : ""}`} type="text" inputMode={mode === "signup" ? "tel" : "text"} dir="ltr" placeholder="09xxxxxxxxx" autoComplete={mode === "signin" ? "username" : "tel"} autoCapitalize="none" spellCheck={false} required /></div>
                  <small className="nova-auth-input-help" id={`${mode}-phone-help`}>شماره را با اعداد انگلیسی وارد کن.</small>
                  {phoneError && <p id={`${mode}-phone-error`} role="alert" className="nova-auth-input-error">{phoneError}</p>}
                </div>}
                <div className="nova-auth-field">
                  <label htmlFor={`${mode}-password`}>{mode === "reset" ? "رمز عبور جدید" : "رمز عبور"}</label>
                  <div className="nova-auth-input-wrap nova-auth-password"><input id={`${mode}-password`} name="password" value={passwordValue} readOnly={!!challenge || loading} maxLength={128} onChange={event => changePassword(event.target.value)} aria-invalid={!!passwordError} aria-describedby={`${mode}-password-help${passwordError ? ` ${mode}-password-error` : ""}`} autoCapitalize="none" autoCorrect="off" spellCheck={false} type={showPassword ? "text" : "password"} dir="ltr" placeholder={mode === "signin" ? "رمز عبورت را وارد کن" : "حداقل ۸ کاراکتر"} autoComplete={mode === "signin" ? "current-password" : "new-password"} minLength={8} required /><button type="button" className="nova-auth-reveal" aria-label={showPassword ? "پنهان‌کردن رمز عبور" : "نمایش رمز عبور"} aria-pressed={showPassword} onClick={() => setShowPassword(value => !value)}><AuthIcon name={showPassword ? "eyeOff" : "eye"} /></button></div>
                  <small className="nova-auth-input-help" id={`${mode}-password-help`}>رمز عبور را با کیبورد انگلیسی وارد کن.</small>
                </div>
                {mode === 'signup' && challenge && <div className="nova-auth-field"><label htmlFor="signup-code">کد تأیید شماره</label><div className="nova-auth-input-wrap"><input id="signup-code" value={otp} onChange={event=>setOtp(event.target.value.replace(/[^0-9]/g,''))} inputMode="numeric" autoComplete="one-time-code" dir="ltr" maxLength={6} autoFocus required /></div><div className="nova-auth-code-actions"><button type="button" disabled={loading} onClick={()=>{setChallenge(null);setOtp('');setSuccess(false);setMessage('شماره را اصلاح کن یا پس از یک دقیقه دوباره دریافت کد را بزن.');}}>اصلاح شماره</button><button type="button" disabled={loading} onClick={resendCode}>دریافت کد جدید</button></div></div>}
                {passwordError && <p id={`${mode}-password-error`} role="alert" className="nova-auth-message">{passwordError}</p>}
                <button className="nova-auth-submit" type="submit" disabled={loading || (mode === "signup" && !phoneSignup)}>
                  <span>{mode === "reset" ? (loading ? "در حال ذخیره..." : "ورود با رمز جدید") : loading ? mode === "signin" ? "در حال ورود..." : "در حال ساخت حساب..." : mode === "signin" ? "ورود با شماره تلفن همراه" : challenge ? "تأیید کد و ورود" : "دریافت کد"}</span><AuthIcon name={success && mode === "signup" ? "check" : "arrow"} />
                </button>
              </form>
            </div>
            {mode === "signup" && <div className="nova-auth-footnote"><AuthIcon name="shield" /><span>شماره‌ات را با کد پیامکی تأیید کن؛ سپس مستقیم وارد حسابت می‌شوی.</span></div>}
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

function AuthIcon({ name }: { name: "arrow" | "account" | "email" | "phone" | "lock" | "eye" | "eyeOff" | "shield" | "check" | "info" }) {
  const paths = {
    arrow: <path d="M19 12H5m6-6-6 6 6 6" />,
    account: <><circle cx="12" cy="8" r="4" /><path d="M4 21v-2a8 8 0 0 1 16 0v2" /></>,
    email: <><rect x="3" y="5" width="18" height="14" rx="3" /><path d="m4 7 8 6 8-6" /></>,
    phone: <path d="M7 3H4a1 1 0 0 0-1 1c0 9.4 7.6 17 17 17a1 1 0 0 0 1-1v-3l-5-2-2 2a14 14 0 0 1-7-7l2-2-2-5Z" />,
    lock: <><rect x="5" y="10" width="14" height="11" rx="3" /><path d="M8 10V7a4 4 0 0 1 8 0v3M12 14v3" /></>,
    eye: <><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z" /><circle cx="12" cy="12" r="3" /></>,
    eyeOff: <><path d="m3 3 18 18M9.5 5.3A11 11 0 0 1 12 5c6.5 0 10 7 10 7a17 17 0 0 1-3 3.8M6 6.5A18 18 0 0 0 2 12s3.5 7 10 7a11 11 0 0 0 5-1.2M10 10a3 3 0 0 0 4 4" /></>,
    shield: <><path d="m12 3 8 3v5c0 5-8 10-8 10S4 16 4 11V6l8-3Z" /><path d="m8 12 3 3 5-6" /></>,
    check: <path d="m5 12 4 4L19 6" />,
    info: <><circle cx="12" cy="12" r="9" /><path d="M12 11v5M12 8h.01" /></>,
  };
  return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}
