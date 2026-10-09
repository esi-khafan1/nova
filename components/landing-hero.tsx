import Link from "next/link";
export function LandingHero() {
  return <section className="nova-approved-hero" aria-labelledby="nova-hero-title">
    <img className="nova-hero-background" src="/nova/hero.svg" width="2000" height="667" alt="ستارهٔ دانش‌آموز نوا با کتاب و کوله‌پشتی در محوطه آموزشی روشن" fetchPriority="high" />
    <div className="nova-hero-inner"><div className="nova-hero-copy">
      <p className="nova-eyebrow">یک شروع تازه، با نوا</p>
      <h1 id="nova-hero-title">بهترین نسخهٔ<br /><em>خودت</em> باش.</h1>
      <p className="nova-hero-lead">هدف تو، مسیر تو، برنامهٔ تو.<br />با نوا یاد بگیر، رشد کن و با اطمینان پیش برو.</p>
      <div className="nova-hero-actions">
        <Link className="nova-primary" href="/auth?mode=signup">شروع مشاوره رایگان <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><path d="M19 12H5m6-6-6 6 6 6" /></svg></Link>
        <Link className="nova-secondary" href="/mag">مشاهده دوره‌ها</Link>
      </div>
    </div></div>
  </section>;
}
