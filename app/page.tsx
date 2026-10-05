import Link from "next/link";
import { Book, Compass, Users } from "@/components/icons";
import { Logo } from "@/components/logo";
import { MobileMenu } from "@/components/mobile-menu";
import {
  findFirstImage,
  formatPersianDate,
  parseContent,
  resourceTypeLabels,
  type ResourceType,
} from "@/lib/content";
import { createClient } from "@/lib/supabase/server";
import "./landing-v2d.css";

type LatestResource = {
  id: string;
  title: string;
  summary: string | null;
  body: string;
  resource_type: ResourceType;
  subject: string | null;
  published_at: string | null;
};

const services = [
  {
    icon: Compass,
    title: "مسیر اختصاصی",
    text: "برنامه‌ای متناسب با پایه، هدف و شرایط درسی واقعی خودت.",
    action: "انتخاب مسیر",
    href: "#how",
  },
  {
    icon: Users,
    title: "مشاور تأییدشده",
    text: "مشاوری که سبک یادگیری و هدف تو را می‌شناسد.",
    action: "رزرو جلسه",
    href: "/auth?mode=signup",
  },
  {
    icon: Book,
    title: "منابع معتبر",
    text: "محتوای انتخاب‌شده توسط تیم کارشناسی نووا.",
    action: "مشاهده منابع",
    href: "/mag",
  },
];

const steps = [
  ["پروفایلت را کامل کن", "هدف و شرایط درسی‌ات را به ما بگو."],
  ["مشاور مناسب را پیدا کن", "تخصص و سبک همخوان با تو انتخاب می‌شود."],
  ["برنامه هفتگی بگیر", "یک برنامه واقعی، نه یک لیست غیرقابل اجرا."],
  ["پیشرفت را ببین", "هر هفته گزارش شفاف از مسیرت."],
];

export default async function Home() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("resources")
    .select("id,title,summary,body,resource_type,subject,published_at")
    .eq("status", "published")
    .order("published_at", { ascending: false })
    .limit(3);

  const latestResources = (data ?? []) as LatestResource[];

  return (
    <main className="landing-v2d">
      <header className="site-header">
        <div className="container nav-wrap">
          <Logo />
          <nav className="desktop-nav" aria-label="ناوبری اصلی">
            <a href="#services">خدمات</a>
            <a href="#how">چطور کار می‌کند؟</a>
            <a href="#mag">مجله</a>
            <a href="#about">درباره نووا</a>
          </nav>
          <div className="nav-actions">
            <Link className="btn btn-ghost btn-small" href="/auth?mode=signin">
              ورود
            </Link>
            <Link className="btn btn-primary btn-small" href="/auth?mode=signup">
              ثبت‌نام
            </Link>
          </div>
          <MobileMenu />
        </div>
      </header>

      <section className="hero">
        <div className="container">
          <div className="hero-grid">
            <div>
              <span className="hero-eyebrow">● مسیر روشن موفقیت تحصیلی</span>
              <h1>
                برای مسیر مهمی که پیش رو داری، <span className="accent">نووا</span> کنارت است.
              </h1>
              <p className="lead">
                نووا کنار دانش‌آموزان دهم تا دوازدهم است؛ با مشاور متخصص، منابع معتبر و برنامه‌ای که واقعاً با زندگی تو هماهنگ است. دیگر قرار نیست مسیر موفقیت را تنهایی پیدا کنی.
              </p>
              <div className="mega-cta">
                <Link className="btn-mega" href="/auth?mode=signup">
                  ثبت‌نام در نووا <span className="arrow">←</span>
                </Link>
                <a className="btn btn-ghost" href="#how">آشنایی با نووا</a>
              </div>
              <div className="hero-trust" aria-label="مزیت‌های نووا">
                <span>مشاوران تأییدشده</span><span className="dot" />
                <span>ثبت‌نام سریع</span><span className="dot" />
                <span>برنامه قابل اجرا</span>
              </div>
            </div>

            <div className="hero-visual" aria-label="نمونه داشبورد پیشرفت نووا">
              <div className="visual-card">
                <h3>داشبورد پیشرفت</h3>
                <div className="visual-cta-row">
                  <div className="visual-mini-cta fill">شروع برنامه</div>
                  <div className="visual-mini-cta outline">مشاهده مشاور</div>
                </div>
                <div className="visual-progress">
                  <div className="vp-row"><span>برنامه این هفته</span><span className="v">۷۲٪</span></div>
                  <div className="vp-row"><span>مرور زیست یازدهم</span><span className="v">۸۵٪</span></div>
                  <div className="vp-row"><span>آزمون ریاضی</span><span className="v">۶۰٪</span></div>
                </div>
                <div className="visual-cta-big">
                  <div className="big-text">آماده‌ای شروع کنی؟</div>
                  <div className="sub-text">اولین قدم فقط چند دقیقه</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="proof" aria-label="مسیر تحصیلی">
        <div className="container proof-grid">
          <div className="proof-item"><span className="step-label">دهم</span><h4>ساخت پایه قوی</h4><p>شروع درست با منابع پایه</p></div>
          <div className="proof-item"><span className="step-label">یازدهم</span><h4>پیشروی هدفمند</h4><p>تمرکز بر نقاط قوت</p></div>
          <div className="proof-item"><span className="step-label">دوازدهم</span><h4>جمع‌بندی مطمئن</h4><p>آزمون‌های آزمایشی</p></div>
          <div className="proof-item"><span className="step-label">نتیجه</span><h4>تا روز نتیجه</h4><p>همراهی کامل</p></div>
        </div>
      </section>

      <section className="section" id="services">
        <div className="container">
          <div className="section-title">
            <span className="eyebrow">همراهی واقعی</span>
            <h2>هر چیزی که برای <span className="accent">مسیر روشن</span> نیاز داری</h2>
            <p>نووا ابزار، محتوا و آدم‌های درست را کنار هم می‌آورد تا انرژی تو صرف یادگیری شود، نه سردرگمی.</p>
          </div>
          <div className="services-grid">
            {services.map(({ icon: Icon, title, text, action, href }) => (
              <article className="service-card" key={title}>
                <div className="service-icon"><Icon /></div>
                <h3>{title}</h3>
                <p>{text}</p>
                <Link className="service-cta" href={href}>{action} ←</Link>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="section how" id="how">
        <div className="container">
          <div className="section-title">
            <span className="eyebrow">ساده و شفاف</span>
            <h2>از ثبت‌نام تا <span className="accent">یک برنامه قابل اجرا</span></h2>
            <p>در چهار قدم کوتاه، از سردرگمی به یک مسیر مشخص می‌رسی.</p>
          </div>
          <div className="steps">
            {steps.map(([title, text], index) => (
              <article className="step" key={title}>
                <div className="step-num">{["۱", "۲", "۳", "۴"][index]}</div>
                <h4>{title}</h4><p>{text}</p>
              </article>
            ))}
          </div>
        </div>
      </section>

      <section className="mag-section" id="mag">
        <div className="container">
          <div className="mag-head">
            <div className="left">
              <span className="eyebrow">تازه‌های مجله نووا</span>
              <h2>راهنماهای تازه برای <span className="accent">مسیر تحصیلی تو</span></h2>
              <p>نکته‌های کاربردی مشاوران نووا برای مطالعه، آزمون و روزهای مهم مسیر تحصیلی.</p>
            </div>
            <Link className="all-link" href="/mag">مشاهده همه ←</Link>
          </div>
          {latestResources.length > 0 ? (
            <div className="mag-grid">
              {latestResources.map((resource) => {
                const image = findFirstImage(parseContent(resource.body));
                return (
                  <Link className="mag-card" href={`/mag/${resource.id}`} key={resource.id}>
                    <div className="img-wrap">
                      {image ? <img alt="" loading="lazy" src={image} /> : <div className="article-placeholder" aria-hidden="true">ن</div>}
                      <span className="badge">{resourceTypeLabels[resource.resource_type]}</span>
                    </div>
                    <div className="body">
                      <div className="date">{formatPersianDate(resource.published_at)}{resource.subject ? ` · ${resource.subject}` : ""}</div>
                      <h3>{resource.title}</h3>
                      {resource.summary && <p>{resource.summary}</p>}
                      <div className="read-more"><span>خواندن مقاله</span><span className="arr">←</span></div>
                    </div>
                  </Link>
                );
              })}
            </div>
          ) : (
            <div className="mag-empty">مقاله‌های تازه نووا به‌زودی اینجا منتشر می‌شوند.</div>
          )}
        </div>
      </section>

      <section className="social-section" aria-labelledby="social-title">
        <div className="container">
          <div className="social-head">
            <span className="eyebrow">نووا در کنار تو</span>
            <h2 id="social-title">در شبکه‌های اجتماعی ما را <span className="accent">دنبال کنید</span></h2>
            <p>ویدئوهای آموزشی، نکته‌های برنامه‌ریزی و خبرهای تازه نووا را از کانال‌های رسمی دنبال کن.</p>
          </div>
          <div className="social-grid">
            <a className="social-card yt" href="https://www.youtube.com/@novayas" target="_blank" rel="noreferrer">
              <span className="icon-box"><svg viewBox="0 0 24 24"><path d="M21.6 7.2a2.8 2.8 0 0 0-2-2C17.9 4.7 12 4.7 12 4.7s-5.9 0-7.6.5a2.8 2.8 0 0 0-2 2A29 29 0 0 0 2 12a29 29 0 0 0 .4 4.8 2.8 2.8 0 0 0 2 2c1.7.5 7.6.5 7.6.5s5.9 0 7.6-.5a2.8 2.8 0 0 0 2-2A29 29 0 0 0 22 12a29 29 0 0 0-.4-4.8ZM10 15.4V8.6l5.8 3.4-5.8 3.4Z" /></svg></span>
              <span className="text"><strong>یوتیوب نووا</strong><small>ویدئوهای آموزشی و مسیر مطالعه — هر هفته محتوای تازه برای یادگیری بهتر.</small></span>
              <span className="follow-cta">دنبال کردن ←</span>
            </a>
            <a className="social-card tg" href="https://t.me/novayasyoutube" target="_blank" rel="noreferrer">
              <span className="icon-box"><svg viewBox="0 0 24 24"><path d="m20.7 4.2-3 15c-.2 1.1-.9 1.4-1.8.9l-4.6-3.4-2.2 2.1c-.2.2-.5.5-1 .5l.3-4.7 8.6-7.8c.4-.3-.1-.5-.6-.2L5.8 13.3l-4.6-1.4c-1-.3-1-1 .2-1.5l17.9-6.9c.8-.3 1.6.2 1.4.7Z" /></svg></span>
              <span className="text"><strong>تلگرام نووا</strong><small>اعلان‌ها، فایل‌ها و تازه‌ترین محتوا — اولین نفری باش که از خبرهای نووا مطلع می‌شوی.</small></span>
              <span className="follow-cta">دنبال کردن ←</span>
            </a>
          </div>
        </div>
      </section>

      <section className="cta-block">
        <div className="container cta-content">
          <h2>شروع یک مسیر تازه</h2>
          <p>آماده‌ای این بار با برنامه جلو بروی؟ حسابت را بساز؛ اولین قدم فقط چند دقیقه زمان می‌برد.</p>
          <Link className="btn-light" href="/auth?mode=signup">ثبت‌نام در نووا ←</Link>
        </div>
      </section>

      <footer className="site-footer" id="about">
        <div className="container">
          <div className="footer-grid">
            <div className="footer-about"><Logo /><p>نووا؛ همراه قابل اعتماد دانش‌آموزان برای ساختن یک مسیر تحصیلی روشن.</p></div>
            <div className="footer-col"><h5>نووا</h5><a href="#about">درباره ما</a><a href="#services">خدمات</a><Link href="/mag">مجله</Link><Link href="/auth">ورود</Link></div>
            <div className="footer-col"><h5>خدمات</h5><a href="#services">مشاوره تحصیلی</a><a href="#how">برنامه‌ریزی</a><Link href="/mag">منابع</Link><Link href="/auth?mode=signup">شروع مسیر</Link></div>
            <div className="footer-col"><h5>ارتباط</h5><a href="https://www.youtube.com/@novayas" target="_blank" rel="noreferrer">یوتیوب</a><a href="https://t.me/novayasyoutube" target="_blank" rel="noreferrer">تلگرام</a></div>
          </div>
          <div className="footer-bottom">© ۱۴۰۵ نووا. تمام حقوق محفوظ است.</div>
        </div>
      </footer>
    </main>
  );
}
