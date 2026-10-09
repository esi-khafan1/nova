import type { Metadata } from "next";
import Link from "next/link";
import { Logo } from "@/components/logo";
import { KonkurNewsLatest } from "@/components/konkur-news-latest";
import { getPublishedNews } from "@/lib/news";
import "../magazine-latest.css";
import "../konkur-news.css";

export const metadata: Metadata = {
  title: "آخرین خبرهای کنکور | نووا",
  description: "خبرهای کنکور با تاریخ انتشار و منبع معتبر",
};

export default async function NewsPage() {
  const { news, error } = await getPublishedNews();
  return (
    <main className="mag-shell landing-v2d">
      <header className="mag-header">
        <div className="container mag-nav">
          <Logo />
          <nav aria-label="ناوبری اخبار">
            <Link href="/">صفحه اصلی</Link>
            <Link href="/mag">مجله نووا</Link>
            <Link href="/news" aria-current="page">
              اخبار کنکور
            </Link>
          </nav>
        </div>
      </header>
      <KonkurNewsLatest news={news} unavailable={error} />
      <footer className="mag-footer">
        <div className="container">
          <Logo />
          <p>پیش از اقدام، آخرین اطلاعیه مرجع رسمی را بررسی کن.</p>
        </div>
      </footer>
    </main>
  );
}
