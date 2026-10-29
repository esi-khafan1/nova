import Link from "next/link";
export function LandingHero() {
  return <section className="nova-approved-hero" aria-labelledby="nova-hero-title">
    <picture>
      <source media="(max-width: 700px)" srcSet="/nova/hero-mobile-outpaint.webp" type="image/webp" />
      <source media="(max-width: 700px)" srcSet="/nova/hero-mobile-outpaint.png" />
      <source srcSet="/nova/hero-desktop.webp" type="image/webp" />
      <img className="nova-hero-background" src="/nova/hero-desktop.png" width="2172" height="724" alt="ستارهٔ دانش‌آموز نووا در کنار برنامهٔ مطالعه، هدف و نمودار پیشرفت" fetchPriority="high" />
    </picture>
    <div className="nova-hero-inner"><div className="nova-hero-copy">
      <p className="nova-eyebrow">نوآ آکادمی | همراه مسیر موفقیت</p>
      <h1 id="nova-hero-title">آینده‌ات رو بساز؛<br /><em>قدم‌به‌قدم تا کنکور</em></h1>
      <p className="nova-hero-lead">با برنامه‌ریزی اصولی، آموزش هدفمند و همراهی مشاوران نوآ،<br />مسیر رسیدن به هدفت رو با اطمینان بیشتری طی کن.</p>
      <div className="nova-hero-actions">
        <Link className="nova-primary" href="/auth?mode=signup">شروع مشاوره رایگان <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><path d="M19 12H5m6-6-6 6 6 6" /></svg></Link>
        <Link className="nova-secondary" href="/#find-path">دوره‌های آموزشی</Link>
      </div>
    </div></div>
  </section>;
}
