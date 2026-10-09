import Link from "next/link";
import Image from "next/image";
import { LandingHeader } from "@/components/landing-header";
import { LandingHero } from "@/components/landing-hero";
import { WhyNova } from "@/components/why-nova";
import { PathFinder, type PathFinderDesign } from "@/components/path-finder";
import { MagazineLatest, type MagazineDesign, type LatestResource } from "@/components/magazine-latest";
import { createClient } from "@/lib/supabase/server";
import "./landing-v2d.css";
import "./landing-approved.css";
import "./why-nova.css";
import "./path-finder.css";
import "./magazine-latest.css";
import "./konkur-news.css";
import { KonkurNewsLatest } from "@/components/konkur-news-latest";
import { getPublishedNews } from "@/lib/news";

export default async function Home({ searchParams }: { searchParams: Promise<Record<string, string | string[] | undefined>> }) {
  const params = await searchParams;
  const pathDesign: PathFinderDesign = params.path === "peach" || params.path === "horizon" ? params.path : "sky";
  const magDesign: MagazineDesign = "warm";
  const supabase = await createClient();
  const { data } = await supabase
    .from("resources")
    .select("id,title,summary,body,resource_type,subject,published_at")
    .eq("status", "published")
    .order("published_at", { ascending: false })
    .limit(3);

  const latestResources = (data ?? []) as LatestResource[];
  const { news, error: newsUnavailable } = await getPublishedNews(3);
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <main className="landing-v2d">
      <LandingHeader isAuthenticated={Boolean(user)} />
      <LandingHero />

      <section className="proof" aria-label="مسیر تحصیلی">
        <div className="container proof-grid">
          <div className="proof-item">
            <span className="step-label">دهم</span>
            <h4>ساخت پایه قوی</h4>
            <p>شروع درست با منابع پایه</p>
          </div>
          <div className="proof-item">
            <span className="step-label">یازدهم</span>
            <h4>پیشروی هدفمند</h4>
            <p>تمرکز بر نقاط قوت</p>
          </div>
          <div className="proof-item">
            <span className="step-label">دوازدهم</span>
            <h4>جمع‌بندی مطمئن</h4>
            <p>آزمون‌های آزمایشی</p>
          </div>
          <div className="proof-item">
            <span className="step-label">نتیجه</span>
            <h4>تا روز نتیجه</h4>
            <p>همراهی کامل</p>
          </div>
        </div>
      </section>

      <WhyNova />

      <PathFinder design={pathDesign} />

      <MagazineLatest resources={latestResources} design={magDesign} />

      <KonkurNewsLatest news={news} unavailable={newsUnavailable} />

      <section className="social-section" aria-labelledby="social-title">
        <div className="container">
          <div className="social-head">
            <span className="eyebrow">نووا در کنار تو</span>
            <h2 id="social-title">
              در شبکه‌های اجتماعی ما را{" "}
              <span className="accent">دنبال کنید</span>
            </h2>
            <p>
              ویدئوهای آموزشی، نکته‌های برنامه‌ریزی و خبرهای تازه نووا را از
              کانال‌های رسمی دنبال کن.
            </p>
          </div>
          <div className="social-grid">
            <a
              className="social-card yt"
              href="https://www.youtube.com/@novayas"
              target="_blank"
              rel="noreferrer"
            >
              <span className="icon-box">
                <svg viewBox="0 0 24 24">
                  <path d="M21.6 7.2a2.8 2.8 0 0 0-2-2C17.9 4.7 12 4.7 12 4.7s-5.9 0-7.6.5a2.8 2.8 0 0 0-2 2A29 29 0 0 0 2 12a29 29 0 0 0 .4 4.8 2.8 2.8 0 0 0 2 2c1.7.5 7.6.5 7.6.5s5.9 0 7.6-.5a2.8 2.8 0 0 0 2-2A29 29 0 0 0 22 12a29 29 0 0 0-.4-4.8ZM10 15.4V8.6l5.8 3.4-5.8 3.4Z" />
                </svg>
              </span>
              <span className="text">
                <strong>یوتیوب نووا</strong>
                <small>
                  ویدئوهای آموزشی و مسیر مطالعه — هر هفته محتوای تازه برای
                  یادگیری بهتر.
                </small>
              </span>
              <span className="follow-cta">دنبال کردن ←</span>
            </a>
            <a
              className="social-card tg"
              href="https://t.me/novayasyoutube"
              target="_blank"
              rel="noreferrer"
            >
              <span className="icon-box">
                <svg viewBox="0 0 24 24">
                  <path d="m20.7 4.2-3 15c-.2 1.1-.9 1.4-1.8.9l-4.6-3.4-2.2 2.1c-.2.2-.5.5-1 .5l.3-4.7 8.6-7.8c.4-.3-.1-.5-.6-.2L5.8 13.3l-4.6-1.4c-1-.3-1-1 .2-1.5l17.9-6.9c.8-.3 1.6.2 1.4.7Z" />
                </svg>
              </span>
              <span className="text">
                <strong>تلگرام نووا</strong>
                <small>
                  اعلان‌ها، فایل‌ها و تازه‌ترین محتوا — اولین نفری باش که از
                  خبرهای نووا مطلع می‌شوی.
                </small>
              </span>
              <span className="follow-cta">دنبال کردن ←</span>
            </a>
          </div>
        </div>
      </section>

      <section className="cta-block">
        <div className="container cta-content">
          <h2>شروع یک مسیر تازه</h2>
          <p>
            آماده‌ای این بار با برنامه جلو بروی؟ حسابت را بساز؛ اولین قدم فقط
            چند دقیقه زمان می‌برد.
          </p>
          <Link className="btn-light" href="/auth?mode=signup">
            ثبت‌نام در نووا ←
          </Link>
        </div>
      </section>

      <footer className="site-footer" id="about">
        <div className="container">
          <div className="footer-grid">
            <div className="footer-about">
              <Link className="nova-footer-brand" href="/" aria-label="صفحه اصلی نووا"><Image src="/nova/mark.svg" width={84} height={84} alt="لوگوی N نووا" unoptimized /></Link>
              <p>
                نووا؛ همراه قابل اعتماد دانش‌آموزان برای ساختن یک مسیر تحصیلی
                روشن.
              </p>
            </div>
            <div className="footer-col">
              <h5>نووا</h5>
              <Link href="/about">درباره ما</Link>
              <a href="#services">خدمات</a>
              <Link href="/mag">مجله</Link>
              <Link href="/auth">ورود</Link>
            </div>
            <div className="footer-col">
              <h5>خدمات</h5>
              <a href="#services">مشاوره تحصیلی</a>
              <a href="#find-path">برنامه‌ریزی</a>
              <Link href="/mag">منابع</Link>
              <Link href="/auth?mode=signup">شروع مسیر</Link>
            </div>
            <div className="footer-col">
              <h5>قوانین و ارتباط</h5>
              <Link href="/contact">تماس با ما</Link>
              <Link href="/terms">شرایط استفاده</Link>
              <Link href="/privacy">حریم خصوصی</Link>
              <Link href="/refund">بازگشت وجه</Link>
            </div>
          </div>
          <div className="footer-bottom">© ۱۴۰۵ نووا. تمام حقوق محفوظ است.</div>
        </div>
      </footer>
    </main>
  );
}
