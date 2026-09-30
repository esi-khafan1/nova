import Link from "next/link";
import { ArrowLeft, Book, Calendar, Compass, Users } from "@/components/icons";
import { Logo } from "@/components/logo";
import { MobileMenu } from "@/components/mobile-menu";

const features = [
  {
    icon: Compass,
    number: "۰۱",
    title: "مسیر اختصاصی، نه نسخه آماده",
    text: "برنامه‌ای که از هدف، پایه و ریتم واقعی زندگی تو ساخته می‌شود و با پیشرفتت تغییر می‌کند.",
  },
  {
    icon: Users,
    number: "۰۲",
    title: "یک مشاور واقعی کنار تو",
    text: "مشاور تأییدشده‌ای که روندت را می‌بیند، بازخورد می‌دهد و اجازه نمی‌دهد وسط مسیر گم شوی.",
  },
  {
    icon: Book,
    number: "۰۳",
    title: "منابع کمتر، انتخاب دقیق‌تر",
    text: "منابع کنکور و امتحان نهایی بر اساس درس، پایه و نیاز تو؛ بدون لیست‌های طولانی و گیج‌کننده.",
  },
];

const steps = [
  ["پروفایلت را بساز", "هدف، پایه و شرایط فعلی‌ات را ثبت کن."],
  ["مسیر مناسب را ببین", "مشاور و پیشنهادهای متناسب با خودت را پیدا کن."],
  ["برنامه را اجرا کن", "کارهای هفته را شفاف و قدم‌به‌قدم جلو ببر."],
  ["پیشرفتت را بسنج", "با بازخورد واقعی، مسیر بعدی را دقیق‌تر انتخاب کن."],
];

export default function Home() {
  return (
    <main className="landing-v2">
      <header className="site-header">
        <div className="container nav-wrap">
          <Logo />
          <nav className="desktop-nav" aria-label="ناوبری اصلی">
            <a href="#services">راه‌حل نووا</a>
            <a href="#how">چطور کار می‌کند؟</a>
            <a href="#resources">شروع مسیر</a>
            <a href="#about">درباره نووا</a>
          </nav>
          <div className="nav-actions">
            <Link className="button button-small" href="/auth">
              ورود / ثبت‌نام
            </Link>
          </div>
          <MobileMenu />
        </div>
      </header>

      <section className="nova-hero">
        <div className="nova-comet-track" aria-hidden="true">
          <span />
        </div>
        <div className="container nova-hero-grid">
          <div className="nova-hero-copy">
            <div className="nova-label"><i /> NOVA / مسیر تحصیلی هوشمند</div>
            <h1>
              مسیرت را حدس نزن؛
              <span> روشن و دقیق جلو برو.</span>
            </h1>
            <p>
              نووا برای دانش‌آموزانی ساخته شده که یک برنامه واقعی، مشاور قابل
              اعتماد و تصویری شفاف از پیشرفتشان می‌خواهند.
            </p>
            <div className="nova-actions">
              <Link className="button" href="/auth?mode=signup">
                مسیرم را شروع می‌کنم <ArrowLeft />
              </Link>
              <a className="nova-text-action" href="#how">
                اول ببین چطور کار می‌کند
              </a>
            </div>
            <div className="nova-trust">
              <div><strong>۳ پایه</strong><span>دهم تا دوازدهم</span></div>
              <div><strong>۱ مسیر</strong><span>متناسب با خودت</span></div>
              <div><strong>همراه</strong><span>تا رسیدن به نتیجه</span></div>
            </div>
          </div>

          <div className="nova-visual" aria-label="نمای برنامه هفتگی نووا">
            <div className="nova-orbit nova-orbit-a" />
            <div className="nova-orbit nova-orbit-b" />
            <div className="nova-board">
              <div className="nova-board-head">
                <div><span>نقشه این هفته</span><strong>مسیر من</strong></div>
                <small>هفته ۰۶</small>
              </div>
              <div className="nova-score">
                <div><strong>۷۲٪</strong><span>پیشرفت برنامه</span></div>
                <div className="nova-score-line"><i /></div>
              </div>
              <div className="nova-plan-list">
                <div className="done"><b>۰۱</b><p><strong>مرور زیست یازدهم</strong><span>انجام شد</span></p></div>
                <div className="active"><b>۰۲</b><p><strong>آزمون جمع‌بندی ریاضی</strong><span>امروز، ساعت ۱۸</span></p></div>
                <div><b>۰۳</b><p><strong>جلسه با مشاور</strong><span>فردا، ساعت ۱۷:۳۰</span></p><Calendar /></div>
              </div>
            </div>
            <div className="nova-float nova-mentor"><span>م</span><div><strong>مریم احمدی</strong><small>مشاور مسیر تجربی</small></div></div>
            <div className="nova-float nova-growth"><strong>+۱۸٪</strong><span>رشد آزمون‌ها</span></div>
          </div>
        </div>
      </section>

      <section className="nova-proof">
        <div className="container">
          <p>برای وقتی که انگیزه کافی نیست و به یک مسیر قابل اجرا نیاز داری.</p>
          <div><span>برنامه شخصی</span><i /> <span>مشاور تأییدشده</span><i /> <span>پیگیری پیشرفت</span></div>
        </div>
      </section>

      <section className="nova-section nova-services" id="services">
        <div className="container">
          <div className="nova-section-head">
            <div><span>راه‌حل نووا</span><h2>سه تکه‌ای که مسیر را کامل می‌کنند</h2></div>
            <p>همه‌چیز کنار هم طراحی شده تا به‌جای جمع‌کردن ابزارهای مختلف، فقط روی پیشرفت تمرکز کنی.</p>
          </div>
          <div className="nova-feature-grid">
            {features.map(({ icon: FeatureIcon, number, title, text }) => (
              <article className="nova-feature" key={title}>
                <div className="nova-feature-top"><span>{number}</span><FeatureIcon /></div>
                <h3>{title}</h3>
                <p>{text}</p>
                <a href="#how">جزئیات مسیر <ArrowLeft /></a>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="nova-section nova-process" id="how">
        <div className="container nova-process-grid">
          <div className="nova-process-copy">
            <span>از تصمیم تا حرکت</span>
            <h2>یک روند ساده؛ بدون شلوغی و سردرگمی</h2>
            <p>هر مرحله فقط همان چیزی را جلوی تو می‌گذارد که همین حالا برای ادامه مسیر لازم داری.</p>
            <Link className="button" href="/auth?mode=signup">شروع مسیر <ArrowLeft /></Link>
          </div>
          <ol className="nova-steps">
            {steps.map(([title, text], index) => (
              <li key={title}>
                <span>{String(index + 1).padStart(2, "۰")}</span>
                <div><strong>{title}</strong><p>{text}</p></div>
              </li>
            ))}
          </ol>
        </div>
      </section>

      <section className="nova-final" id="resources">
        <div className="container nova-final-card">
          <div className="nova-final-star" aria-hidden="true">✦</div>
          <div><span>شروع از همین‌جاست</span><h2>برای مسیر بعدی آماده‌ای؟</h2><p>حسابت را بساز و اولین قدم را با یک تصویر روشن از مسیرت بردار.</p></div>
          <Link className="button button-light" href="/auth?mode=signup">ساخت حساب نووا <ArrowLeft /></Link>
        </div>
      </section>

      <footer id="about"><div className="container footer-grid"><Logo /><p>نووا؛ یک مسیر روشن‌تر برای تصمیم‌های مهم تحصیلی.</p><div><Link href="/auth">ورود / ثبت‌نام</Link></div></div></footer>
    </main>
  );
}
