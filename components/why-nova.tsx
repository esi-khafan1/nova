import type { ReactNode } from "react";

const benefits = [
  { icon: "advisor", title: "مشاوره اختصاصی", text: "برنامه‌ای متناسب با هدف‌ها و شرایط تو" },
  { icon: "plan", title: "برنامه‌ریزی منظم", text: "مدیریت بهتر زمان و مطالعه" },
  { icon: "support", title: "پشتیبانی آموزشی", text: "همراهی در مسیر یادگیری" },
  { icon: "progress", title: "ارزیابی مستمر", text: "شناخت نقاط قوت و زمینه‌های پیشرفت" },
  { icon: "guide", title: "منابع آموزشی کاربردی", text: "دسترسی به محتوای مناسب با نیازت" },
  { icon: "target", title: "مسیر پیشرفت روشن", text: "حرکت مرحله‌به‌مرحله به‌سوی هدف" },
];

function BenefitIcon({ name }: { name: string }) {
  const paths: Record<string, ReactNode> = {
    plan: <><rect x="5" y="6" width="22" height="23" rx="4" /><path d="M11 3v6M21 3v6M5 13h22M11 19h4M19 19h2M11 24h4" /></>,
    advisor: <><circle cx="16" cy="10" r="5" /><path d="M6 29v-3a10 10 0 0 1 20 0v3M25 6a5 5 0 0 1 0 9M28 20a8 8 0 0 1 2 6" /></>,
    support: <><path d="M4 17v-2a12 12 0 0 1 24 0v2" /><path d="M4 17h4v8H6a2 2 0 0 1-2-2zM28 17h-4v8h2a2 2 0 0 0 2-2zM24 24v1a4 4 0 0 1-4 4h-4" /></>,
    progress: <><path d="M5 5v22h23M10 21l6-7 5 3 7-10M22 7h6v6" /><circle cx="10" cy="21" r="1" /></>,
    guide: <><path d="M16 8c-3-3-8-4-13-3v22c5-1 10 0 13 3 3-3 8-4 13-3V5c-5-1-10 0-13 3ZM16 8v22M7 12l5 1M7 18l5 1M20 13l5-1M20 19l5-1" /></>,
    target: <><circle cx="16" cy="16" r="12" /><circle cx="16" cy="16" r="7" /><circle cx="16" cy="16" r="2" /><path d="m17.5 14.5 9-9m-5 0h5v5" /></>,
  };
  return <svg viewBox="0 0 32 32" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}

/** Informational benefits only: deliberately no links, buttons or clickable-card styling. */
export function WhyNova() {
  return <section id="services" className="nova-why nova-why--open" aria-labelledby="nova-why-title" data-design="open">
    <div className="nova-why-inner">
      <header className="nova-why-heading">
        <h2 id="nova-why-title">چرا نووا، همراه مسیر موفقیت تونه؟</h2>
        <p className="nova-why-intro">در نووا، هر دانش‌آموز یک مسیر منحصربه‌فرد داره. با برنامه‌ریزی متناسب با توانایی‌ها و شرایطت، آموزش هدفمند و بررسی مداوم پیشرفت، کمک می‌کنیم با شناخت بهتر توانایی‌هات، برای رسیدن به اهدافت قدم برداری.</p>
      </header>
      <div className="nova-why-grid">
        {benefits.map((item) => <article className="nova-why-item" key={item.icon}>
          <div className="nova-why-icon"><BenefitIcon name={item.icon} /></div>
          <div className="nova-why-copy"><h3>{item.title}</h3><p>{item.text}</p></div>
        </article>)}
      </div>
    </div>
  </section>;
}
