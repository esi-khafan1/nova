import Link from "next/link";
import { ArrowLeft, Book, Calendar, Check, Compass, Users } from "@/components/icons";
import { Logo } from "@/components/logo";
import { MobileMenu } from "@/components/mobile-menu";

const features = [
  { icon: Compass, title: "مسیر اختصاصی", text: "برنامه‌ای متناسب با پایه، هدف و شرایط واقعی خودت؛ نه نسخه‌ای یکسان برای همه." },
  { icon: Users, title: "مشاور متخصص", text: "انتخاب آگاهانه از میان مشاوران تأییدشده و همراهی منظم تا روز نتیجه." },
  { icon: Book, title: "منابع مطمئن", text: "معرفی منابع کنکور و امتحان نهایی، دسته‌بندی‌شده بر اساس درس و پایه." },
];

const steps = ["پروفایلت را کامل کن", "مشاور مناسب را پیدا کن", "درخواست مشاوره بفرست", "با برنامه جلو برو"];

export default function Home() {
  return (
    <main>
      <header className="site-header">
        <div className="container nav-wrap">
          <Logo />
          <nav className="desktop-nav" aria-label="ناوبری اصلی">
            <a href="#services">خدمات</a><a href="#how">چطور کار می‌کند؟</a><a href="#resources">منابع</a><a href="#about">درباره نووا</a>
          </nav>
          <div className="nav-actions">
            <Link className="button button-small" href="/auth">ورود / ثبت‌نام</Link>
          </div>
          <MobileMenu />
        </div>
      </header>

      <section className="hero">
        <div className="hero-comet" aria-hidden="true">
          <span className="hero-comet-tail" />
          <span className="hero-comet-core" />
        </div>
        <div className="container hero-grid">
          <div className="hero-copy">
            <div className="eyebrow"><span /> برای مسیر مهمی که پیش رو داری</div>
            <h1>قرار نیست مسیر موفقیت را <em>تنهایی</em> پیدا کنی.</h1>
            <p>نووا کنار دانش‌آموزان دهم تا دوازدهم است؛ با مشاور متخصص، منابع معتبر و برنامه‌ای که واقعاً با زندگی تو هماهنگ است.</p>
            <div className="hero-actions">
              <Link className="button" href="/auth?mode=signup">ثبت‌نام <ArrowLeft /></Link>
              <a className="button button-ghost" href="#how">آشنایی با نووا</a>
            </div>
            <div className="trust-row"><span><Check /> مشاوران تأییدشده</span><span><Check /> ثبت‌نام سریع و ساده</span></div>
          </div>

          <div className="hero-visual" aria-label="نمونه مسیر مشاوره نووا">
            <div className="orbit orbit-one" /><div className="orbit orbit-two" />
            <div className="dashboard-card">
              <div className="card-top"><span>مسیر من</span><span className="status"><i /> در حال پیشرفت</span></div>
              <div className="progress-ring"><strong>۷۲٪</strong><small>برنامه این هفته</small></div>
              <div className="task-list">
                <div><span className="task-check"><Check /></span><p><b>مرور زیست یازدهم</b><small>فصل تنظیم عصبی</small></p></div>
                <div><span className="task-check"><Check /></span><p><b>آزمون جمع‌بندی ریاضی</b><small>امروز، ساعت ۱۸</small></p></div>
                <div className="upcoming"><span className="task-icon"><Calendar /></span><p><b>جلسه با مشاور</b><small>فردا، ساعت ۱۷:۳۰</small></p></div>
              </div>
            </div>
            <div className="floating-card counselor-chip"><div className="avatar">م</div><p><b>مریم احمدی</b><small>مشاور رشته تجربی</small></p><span>۴.۹</span></div>
            <div className="floating-card result-chip"><strong>+۱۸٪</strong><span>رشد میانگین آزمون‌ها</span></div>
          </div>
        </div>
      </section>

      <section className="proof-strip"><div className="container proof-grid"><div><strong>دهم</strong><span>ساخت پایه قوی</span></div><div><strong>یازدهم</strong><span>پیشروی هدفمند</span></div><div><strong>دوازدهم</strong><span>جمع‌بندی مطمئن</span></div><div><strong>کنکور</strong><span>تا روز نتیجه</span></div></div></section>

      <section className="section" id="services">
        <div className="container">
          <div className="section-heading"><span>همراهی واقعی</span><h2>هر چیزی که برای یک مسیر روشن نیاز داری</h2><p>نووا ابزار، محتوا و آدم‌های درست را کنار هم می‌آورد تا انرژی تو صرف یادگیری شود، نه سردرگمی.</p></div>
          <div className="feature-grid">{features.map(({ icon: FeatureIcon, title, text }) => <article className="feature-card" key={title}><div className="feature-icon"><FeatureIcon /></div><h3>{title}</h3><p>{text}</p><a href="#how">بیشتر بدانید <ArrowLeft /></a></article>)}</div>
        </div>
      </section>

      <section className="section soft-section" id="how">
        <div className="container process-grid">
          <div><span className="section-kicker">ساده و شفاف</span><h2>از ثبت‌نام تا یک برنامه قابل اجرا</h2><p>در چهار قدم کوتاه، از سردرگمی به یک مسیر مشخص می‌رسی.</p><Link className="button button-dark" href="/auth?mode=signup">همین حالا شروع کن <ArrowLeft /></Link></div>
          <ol className="steps">{steps.map((step, index) => <li key={step}><span>{String(index + 1).padStart(2, "۰")}</span><div><b>{step}</b><small>{index === 0 ? "هدفت و شرایط درسی‌ات را به ما بگو." : index === 1 ? "تخصص و سبک مشاورها را مقایسه کن." : index === 2 ? "موضوع و زمان مناسب را مشخص کن." : "جلسه‌ها و پیشرفتت را یکجا دنبال کن."}</small></div></li>)}</ol>
        </div>
      </section>

      <section className="section section-cta" id="resources"><div className="container cta"><div><span>شروع یک مسیر تازه</span><h2>آماده‌ای این بار با برنامه جلو بروی؟</h2><p>حسابت را بساز؛ اولین قدم فقط چند دقیقه زمان می‌برد.</p></div><Link className="button button-light" href="/auth?mode=signup">ثبت‌نام در نووا <ArrowLeft /></Link></div></section>

      <section className="social-section" aria-labelledby="social-title">
        <div className="container social-panel">
          <div className="social-copy">
            <span>نووا در کنار تو</span>
            <h2 id="social-title">در شبکه‌های اجتماعی ما را دنبال کنید</h2>
            <p>ویدئوهای آموزشی، نکته‌های برنامه‌ریزی و خبرهای تازه نووا را از کانال‌های رسمی دنبال کن.</p>
          </div>
          <div className="social-links">
            <a className="social-link youtube" href="https://www.youtube.com/@novayas" target="_blank" rel="noreferrer">
              <span className="social-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21.6 7.2a2.8 2.8 0 0 0-2-2C17.9 4.7 12 4.7 12 4.7s-5.9 0-7.6.5a2.8 2.8 0 0 0-2 2A29 29 0 0 0 2 12a29 29 0 0 0 .4 4.8 2.8 2.8 0 0 0 2 2c1.7.5 7.6.5 7.6.5s5.9 0 7.6-.5a2.8 2.8 0 0 0 2-2A29 29 0 0 0 22 12a29 29 0 0 0-.4-4.8ZM10 15.4V8.6l5.8 3.4-5.8 3.4Z" /></svg></span>
              <span><strong>یوتیوب نووا</strong><small>ویدئوهای آموزشی و مسیر مطالعه</small></span>
              <ArrowLeft />
            </a>
            <a className="social-link telegram" href="https://t.me/novayasyoutube" target="_blank" rel="noreferrer">
              <span className="social-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m20.7 4.2-3 15c-.2 1.1-.9 1.4-1.8.9l-4.6-3.4-2.2 2.1c-.2.2-.5.5-1 .5l.3-4.7 8.6-7.8c.4-.3-.1-.5-.6-.2L5.8 13.3l-4.6-1.4c-1-.3-1-1 .2-1.5l17.9-6.9c.8-.3 1.6.2 1.4.7Z" /></svg></span>
              <span><strong>تلگرام نووا</strong><small>اعلان‌ها، فایل‌ها و تازه‌ترین محتوا</small></span>
              <ArrowLeft />
            </a>
          </div>
        </div>
      </section>

      <footer id="about"><div className="container footer-grid"><Logo /><p>نووا؛ همراه قابل اعتماد دانش‌آموزان برای ساختن یک مسیر تحصیلی روشن.</p><div><Link href="/auth">ورود / ثبت‌نام</Link></div></div></footer>
    </main>
  );
}
