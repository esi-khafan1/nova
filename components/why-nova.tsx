import type { ReactNode } from "react";

const benefits = [
  { icon: "plan", title: "برنامه‌ای متناسب با تو", text: "برنامه هفتگی با توجه به پایه، هدف و شرایط درسی تو تنظیم می‌شود." },
  { icon: "advisor", title: "همراهی مشاور", text: "برای تصمیم‌های درسی و مسیر مطالعه، یک مشاور کنارت است." },
  { icon: "today", title: "برنامه امروز، روشن و مشخص", text: "فعالیت‌های روزانه را از برنامه منتشرشده مشاور ببین." },
  { icon: "exam", title: "آزمون و تحلیل عملکرد", text: "آزمون‌ها و گزارش آن‌ها کمک می‌کنند نقاط نیازمند توجه را بشناسی." },
  { icon: "progress", title: "پیشرفت قابل پیگیری", text: "زمان مطالعه و فعالیت‌های انجام‌شده را در گزارش‌های پیشرفت دنبال کن." },
  { icon: "guide", title: "راهنماهای کاربردی مطالعه", text: "از محتوای مجله برای برنامه‌ریزی، مرور و آمادگی آزمون استفاده کن." },
];

function BenefitIcon({ name }: { name: string }) {
  const paths: Record<string, ReactNode> = {
    plan: <><rect x="5" y="6" width="22" height="23" rx="4" /><path d="M11 3v6M21 3v6M5 13h22M11 19h4M19 19h2M11 24h4" /></>,
    advisor: <><circle cx="16" cy="10" r="5" /><path d="M6 29v-3a10 10 0 0 1 20 0v3M25 6a5 5 0 0 1 0 9M28 20a8 8 0 0 1 2 6" /></>,
    today: <><circle cx="16" cy="16" r="12" /><path d="M16 8v8l5 3" /></>,
    exam: <><rect x="7" y="5" width="18" height="24" rx="3" /><path d="M12 3h8v5h-8zM12 15h8M12 20h5M12 25h3" /></>,
    progress: <><path d="M5 5v22h23M10 21l6-7 5 3 7-10M22 7h6v6" /><circle cx="10" cy="21" r="1" /></>,
    guide: <><path d="M16 8c-3-3-8-4-13-3v22c5-1 10 0 13 3 3-3 8-4 13-3V5c-5-1-10 0-13 3ZM16 8v22M7 12l5 1M7 18l5 1M20 13l5-1M20 19l5-1" /></>,
  };
  return <svg viewBox="0 0 32 32" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{paths[name]}</svg>;
}

/** Informational benefits only: deliberately no links, buttons or clickable-card styling. */
export function WhyNova() {
  return <section id="services" className="nova-why nova-why--open" aria-labelledby="nova-why-title" data-design="open">
    <div className="nova-why-inner">
      <header className="nova-why-heading">
        <p className="nova-why-eyebrow">همراه مسیر تو، از برنامه تا پیشرفت</p>
        <h2 id="nova-why-title">چرا موسسه مشاوره نووا؟</h2>
        <p className="nova-why-intro">چون مسیر درس خواندن، با یک برنامه روشن و همراهی درست ساده‌تر می‌شود.</p>
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
