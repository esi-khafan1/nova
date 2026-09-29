import Link from "next/link";
import { ArrowLeft, Book, Calendar, Check, Compass, Menu, Users } from "@/components/icons";
import { Logo } from "@/components/logo";

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
            <Link className="text-link" href="/auth/sign-in">ورود</Link>
            <Link className="button button-small" href="/auth/sign-up">شروع رایگان</Link>
          </div>
          <button className="menu-button" aria-label="باز کردن منو"><Menu /></button>
        </div>
      </header>

      <section className="hero">
        <div className="container hero-grid">
          <div className="hero-copy">
            <div className="eyebrow"><span /> برای مسیر مهمی که پیش رو داری</div>
            <h1>قرار نیست مسیر موفقیت را <em>تنهایی</em> پیدا کنی.</h1>
            <p>نووا کنار دانش‌آموزان دهم تا دوازدهم است؛ با مشاور متخصص، منابع معتبر و برنامه‌ای که واقعاً با زندگی تو هماهنگ است.</p>
            <div className="hero-actions">
              <Link className="button" href="/auth/sign-up">ساخت حساب رایگان <ArrowLeft /></Link>
              <a className="button button-ghost" href="#how">آشنایی با نووا</a>
            </div>
            <div className="trust-row"><span><Check /> مشاوران تأییدشده</span><span><Check /> بدون هزینه برای ثبت‌نام</span></div>
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
          <div><span className="section-kicker">ساده و شفاف</span><h2>از ثبت‌نام تا یک برنامه قابل اجرا</h2><p>در چهار قدم کوتاه، از سردرگمی به یک مسیر مشخص می‌رسی.</p><Link className="button button-dark" href="/auth/sign-up">همین حالا شروع کن <ArrowLeft /></Link></div>
          <ol className="steps">{steps.map((step, index) => <li key={step}><span>{String(index + 1).padStart(2, "۰")}</span><div><b>{step}</b><small>{index === 0 ? "هدفت و شرایط درسی‌ات را به ما بگو." : index === 1 ? "تخصص و سبک مشاورها را مقایسه کن." : index === 2 ? "موضوع و زمان مناسب را مشخص کن." : "جلسه‌ها و پیشرفتت را یکجا دنبال کن."}</small></div></li>)}</ol>
        </div>
      </section>

      <section className="section" id="resources"><div className="container cta"><div><span>شروع یک مسیر تازه</span><h2>آماده‌ای این بار با برنامه جلو بروی؟</h2><p>حسابت را رایگان بساز. اولین قدم فقط چند دقیقه زمان می‌برد.</p></div><Link className="button button-light" href="/auth/sign-up">ثبت‌نام در نووا <ArrowLeft /></Link></div></section>

      <footer id="about"><div className="container footer-grid"><Logo /><p>نووا؛ همراه قابل اعتماد دانش‌آموزان برای ساختن یک مسیر تحصیلی روشن.</p><div><Link href="/auth/sign-in">ورود</Link><Link href="/auth/sign-up">ثبت‌نام</Link></div></div></footer>
    </main>
  );
}
