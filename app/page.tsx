import Link from "next/link";
import { ArrowLeft, Book, Calendar, Compass, Users } from "@/components/icons";
import { Logo } from "@/components/logo";
import { MobileMenu } from "@/components/mobile-menu";

const pillars = [
  {
    icon: Compass,
    index: "01",
    title: "برنامه‌ای که واقعاً مال توست",
    text: "بر اساس پایه، هدف، زمان آزاد و سطح فعلی؛ نه یک فایل آماده برای همه.",
  },
  {
    icon: Users,
    index: "02",
    title: "مشاوری که مسیرت را می‌بیند",
    text: "از انتخاب مسیر تا اصلاح برنامه، یک همراه حرفه‌ای روند تو را دنبال می‌کند.",
  },
  {
    icon: Book,
    index: "03",
    title: "منابعی که لازم داری، نه بیشتر",
    text: "انتخاب‌های محدود و دقیق برای کنکور و امتحان نهایی، متناسب با نیاز واقعی تو.",
  },
];

const journey = [
  ["پروفایل کوتاه", "هدفت و شرایط درسی‌ات را ثبت کن."],
  ["نقشه پیشنهادی", "مسیر و مشاور مناسب خودت را ببین."],
  ["اجرای هفتگی", "کارها را شفاف و قابل‌اندازه‌گیری جلو ببر."],
  ["بازبینی مسیر", "با بازخورد واقعی، برنامه را دقیق‌تر کن."],
];

export default function Home() {
  return (
    <main className="landing-v4">
      <header className="site-header">
        <div className="container nav-wrap">
          <Logo />
          <nav className="desktop-nav" aria-label="ناوبری اصلی">
            <a href="#solution">راه‌حل</a>
            <a href="#product">محصول</a>
            <a href="#how">روند کار</a>
            <a href="#about">درباره نووا</a>
          </nav>
          <div className="nav-actions">
            <Link className="v4-login" href="/auth?mode=signin">ورود</Link>
            <Link className="button button-small" href="/auth?mode=signup">شروع رایگان</Link>
          </div>
          <MobileMenu />
        </div>
      </header>

      <section className="v4-hero">
        <div className="container">
          <div className="v4-hero-copy">
            <div className="v4-kicker"><span>✦</span> مشاوره و برنامه‌ریزی تحصیلی، یکپارچه</div>
            <h1>برای درس خواندن،<br /><em>یک مسیر روشن</em> داشته باش.</h1>
            <p>نووا برنامه، مشاور و منابع درست را در یک تجربه ساده کنار هم می‌آورد؛ تا بدانی امروز چه کاری باید انجام بدهی و چرا.</p>
            <div className="v4-actions">
              <Link className="button" href="/auth?mode=signup">ساخت مسیر من <ArrowLeft /></Link>
              <a href="#product">دیدن محیط نووا</a>
            </div>
          </div>

          <div className="v4-product" id="product" aria-label="پیش‌نمایش محیط نووا">
            <div className="v4-windowbar"><div><i /><i /><i /></div><span>app.nova.ir/dashboard</span><b>✦</b></div>
            <div className="v4-app">
              <aside className="v4-app-nav">
                <div className="v4-mini-logo"><span>✦</span><strong>نووا</strong></div>
                <nav><a className="active">نمای کلی</a><a>برنامه من</a><a>جلسه‌ها</a><a>منابع</a></nav>
                <div className="v4-mini-user"><span>ن</span><div><strong>نیما رضایی</strong><small>پایه دوازدهم</small></div></div>
              </aside>
              <div className="v4-app-main">
                <div className="v4-app-heading"><div><small>سه‌شنبه، ۸ مهر</small><h2>صبح بخیر نیما</h2></div><span>هفته ۰۶</span></div>
                <div className="v4-overview">
                  <article className="v4-focus-card">
                    <div><span>تمرکز امروز</span><b>۳ از ۴ کار</b></div>
                    <div className="v4-progress"><i /></div>
                    <p>فقط یک قدم تا تکمیل برنامه امروز مانده.</p>
                  </article>
                  <article className="v4-session-card"><Calendar /><span>جلسه بعدی</span><strong>فردا، ۱۷:۳۰</strong><small>با مریم احمدی</small></article>
                </div>
                <div className="v4-today">
                  <div className="v4-today-head"><h3>کارهای امروز</h3><span>مشاهده همه</span></div>
                  <div className="v4-task done"><b>01</b><div><strong>مرور زیست یازدهم</strong><small>فصل تنظیم عصبی</small></div><span>انجام شد</span></div>
                  <div className="v4-task current"><b>02</b><div><strong>آزمون جمع‌بندی ریاضی</strong><small>۴۵ دقیقه</small></div><span>در حال انجام</span></div>
                  <div className="v4-task"><b>03</b><div><strong>تحلیل آزمون آزمایشی</strong><small>ثبت نقاط ضعف</small></div><span>بعدی</span></div>
                </div>
              </div>
            </div>
            <div className="v4-float v4-float-one"><strong>۷۸٪</strong><span>پایبندی این ماه</span></div>
            <div className="v4-float v4-float-two"><span>م</span><div><strong>پیام مشاور</strong><small>برنامه جدید آماده است</small></div></div>
          </div>

          <div className="v4-proofline"><span>برای پایه‌های دهم تا دوازدهم</span><i /><span>مشاوران تأییدشده</span><i /><span>شروع ساده و سریع</span></div>
        </div>
      </section>

      <section className="v4-section v4-solution" id="solution">
        <div className="container">
          <div className="v4-section-heading"><span>همه‌چیز در یک مسیر</span><h2>کمتر سردرگم شو؛<br />دقیق‌تر جلو برو.</h2><p>به‌جای چند ابزار و چند توصیه پراکنده، یک سیستم روشن برای تصمیم‌گیری و اجرا داشته باش.</p></div>
          <div className="v4-pillar-grid">
            {pillars.map(({ icon: Icon, index, title, text }) => (
              <article className="v4-pillar" key={title}>
                <div><span>{index}</span><Icon /></div><h3>{title}</h3><p>{text}</p><a href="#how">بیشتر بدان <ArrowLeft /></a>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="v4-section v4-journey" id="how">
        <div className="container v4-journey-grid">
          <div className="v4-journey-intro"><span>از ثبت‌نام تا یک مسیر واقعی</span><h2>چهار قدم.<br />بدون پیچیدگی.</h2><p>نووا هر بار فقط همان تصمیمی را جلوی تو می‌گذارد که برای ادامه لازم داری.</p><Link className="button" href="/auth?mode=signup">شروع مسیر <ArrowLeft /></Link></div>
          <ol>
            {journey.map(([title, text], index) => <li key={title}><b>{String(index + 1).padStart(2, "۰")}</b><div><strong>{title}</strong><p>{text}</p></div></li>)}
          </ol>
        </div>
      </section>

      <section className="v4-cta"><div className="container"><div className="v4-cta-card"><span>✦</span><div><small>اولین قدم، فقط چند دقیقه</small><h2>مسیر روشن‌تر از همین‌جا شروع می‌شود.</h2></div><Link className="button" href="/auth?mode=signup">ساخت حساب نووا <ArrowLeft /></Link></div></div></section>

      <footer id="about"><div className="container footer-grid"><Logo /><p>نووا؛ برنامه، مشاور و مسیر روشن برای سال‌های مهم تحصیلی.</p><div><Link href="/auth">ورود / ثبت‌نام</Link></div></div></footer>
    </main>
  );
}
