import Link from "next/link";
import { ArrowLeft, Book, Calendar, Check, Users } from "@/components/icons";
import { Logo } from "@/components/logo";
import { MobileMenu } from "@/components/mobile-menu";

const proofs = [
  "مشاور با مدرک و سابقه‌ی تأییدشده",
  "برنامه‌ی هفتگی مخصوص خودتان",
  "ثبت‌نام رایگان و بدون تعهد",
];

const benefits = [
  {
    n: "۰۱",
    icon: Calendar,
    title: "برنامه‌ی مطالعه‌ی شخصی",
    desc: "برنامه بر اساس پایه، رشته، آزمون‌های پیش‌رو و ساعت‌های آزاد شما چیده می‌شود و هر هفته بازبینی می‌شود.",
    points: ["بر پایه‌ی رشته و آزمون‌های پیش‌رو", "بازبینی هفتگی همراه مشاور"],
  },
  {
    n: "۰۲",
    icon: Users,
    title: "مشاور تأییدشده",
    desc: "مدرک و سابقه‌ی هر مشاور پیش از پذیرش بررسی می‌شود. مشاور شما مسیر را دنبال می‌کند، نه فقط یک‌بار پاسخ می‌دهد.",
    points: ["بررسی مدرک و سابقه‌ی کاری", "جلسه‌ی تصویری و بازخورد مکتوب"],
  },
  {
    n: "۰۳",
    icon: Book,
    title: "منابع آموزشی گزینش‌شده",
    desc: "به‌جای انبوهی از لینک و فایل، فقط منابعی که به درس و هدف همان هفته‌ی شما مربوط‌اند پیشنهاد می‌شود.",
    points: ["مرتبط با درس و هدف هفته", "بدون فایل و لینک تکراری"],
  },
];

const steps = [
  { n: "۱", tag: "ثبت‌نام", title: "ثبت‌نام و معرفی خود", desc: "پایه، رشته، هدف آزمون و وضعیت فعلی درس‌هایتان را در چند دقیقه مشخص می‌کنید." },
  { n: "۲", tag: "برنامه", title: "دریافت برنامه‌ی هفته‌ی اول", desc: "نووا بر اساس پاسخ‌های شما برنامه‌ی روزانه و هفتگی را پیشنهاد می‌دهد." },
  { n: "۳", tag: "مشاوره", title: "جلسه با مشاور", desc: "مشاور برنامه را با شما مرور می‌کند، اصلاح می‌کند و اولویت‌ها را روشن می‌کند." },
  { n: "۴", tag: "پیگیری", title: "پیگیری پیشرفت هفتگی", desc: "کارهای انجام‌شده را علامت می‌زنید، گزارش هفته را می‌بینید و برنامه به‌روز می‌شود." },
];

const tasks = [
  { subject: "ریاضی", title: "تابع‌های نمایی؛ ۱۰ تست تشریحی", time: "۴۵ دقیقه", state: "done" },
  { subject: "زیست‌شناسی", title: "فصل ۴ گوارش؛ مرور نکته‌ها", time: "۳۰ دقیقه", state: "done" },
  { subject: "فیزیک", title: "حرکت‌شناسی؛ حل ۸ مسئله", time: "۶۰ دقیقه", state: "doing" },
  { subject: "ادبیات", title: "آرایه‌های ادبی؛ تست ۲۰ سؤالی", time: "۲۵ دقیقه", state: "todo" },
];

const week = [
  ["ش", 100, 100], ["ی", 100, 82], ["د", 100, 100], ["س", 100, 52], ["چ", 82, 0], ["پ", 58, 0], ["ج", 34, 0],
] as const;

function ProductPreview() {
  return (
    <div className="ref-preview" id="preview">
      <div className="ref-preview-offset" aria-hidden="true" />
      <div className="ref-product">
        <div className="ref-appbar">
          <div><Logo /><span>/ داشبورد</span></div>
          <div><small>یازدهم تجربی</small><strong>مینا رضایی</strong><b>م</b></div>
        </div>
        <div className="ref-product-grid">
          <section className="ref-tasks">
            <header><div><strong>برنامه‌ی امروز</strong><small>سه‌شنبه، ۱۴ آبان</small></div><span>۲ از ۴ کار انجام شد</span></header>
            <ul>{tasks.map((task) => <li key={task.title} className={task.state === "doing" ? "doing" : ""}><span className={`ref-state ${task.state}`}>{task.state === "done" ? "✓" : task.state === "doing" ? "•" : ""}</span><div><small>{task.subject}</small><strong>{task.title}</strong></div><time>{task.time}</time></li>)}</ul>
          </section>
          <div className="ref-product-side">
            <section className="ref-week"><h3>پیشرفت این هفته</h3><div className="ref-week-number"><strong>۵۶٪</strong><span>۱۰ از ۱۸ ساعت برنامه</span></div><div className="ref-bars">{week.map(([day, plan, done], index) => <div key={day}><i style={{ height: `${plan}%` }}><b className={index === 3 ? "today" : ""} style={{ height: `${done}%` }} /></i><span>{day}</span></div>)}</div><p>↗ ۱۲٪ بیشتر از هفته‌ی قبل</p></section>
            <section className="ref-session"><h3>جلسه‌ی مشاوره‌ی بعدی</h3><div className="ref-session-row"><div className="ref-date"><b>آبان</b><strong>۱۶</strong><small>پنجشنبه</small></div><div><strong>ساعت ۱۷:۳۰</strong><p>تصویری · ۳۰ دقیقه</p></div></div><div className="ref-advisor"><span>س.ک</span><div><strong>سارا کیانی ◈</strong><small>مشاور تحصیلی · تأییدشده</small></div></div></section>
          </div>
        </div>
        <section className="ref-feedback"><header><strong>بازخورد مشاور</strong><small>دیروز، ۲۱:۱۰</small></header><blockquote>ریتم مطالعه‌ات این هفته خوب بود. فیزیک را صبح‌ها بخوان؛ تمرکزت در آن ساعت بیشتر است. تست‌های ریاضی را هم زمان‌دار حل کن.</blockquote><p>سارا کیانی، مشاور تحصیلی</p></section>
      </div>
    </div>
  );
}

export default function Home() {
  return (
    <main className="reference-landing">
      <header className="site-header"><div className="container nav-wrap"><Logo /><nav className="desktop-nav"><a href="#preview">پیش‌نمایش محصول</a><a href="#features">ویژگی‌ها</a><a href="#steps">مسیر کار</a></nav><div className="nav-actions"><Link className="ref-login" href="/auth?mode=signin">ورود</Link><Link className="button button-small" href="/auth?mode=signup">شروع مسیر مطالعه</Link></div><MobileMenu /></div></header>

      <section className="ref-hero container">
        <div className="ref-hero-copy"><span className="ref-eyebrow">ویژه‌ی دانش‌آموزان دهم، یازدهم و دوازدهم</span><h1>هر هفته، یک قدم <em>روشن‌تر</em> تا کنکور</h1><p>نووا برنامه‌ی مطالعه‌ی شخصی، مشاور تأییدشده و منابع گزینش‌شده را در یک مسیر کنار هم می‌گذارد تا بدانید امروز دقیقاً چه کاری مهم‌تر است.</p><div className="ref-actions"><Link className="button" href="/auth?mode=signup">ساخت حساب و شروع مسیر <ArrowLeft /></Link><a className="ref-outline" href="#preview">دیدن نمونه‌ی برنامه</a></div><ul>{proofs.map((proof) => <li key={proof}><Check />{proof}</li>)}</ul></div>
        <ProductPreview />
      </section>

      <section className="ref-benefits" id="features"><div className="container ref-benefits-grid"><div className="ref-benefits-intro"><span className="ref-eyebrow">چرا نووا</span><h2>سه چیزی که مسیر شما را قابل‌اعتماد می‌کند</h2><p>برنامه‌ریزی فقط جدول نیست؛ باید کسی آن را ببیند، بازخورد بدهد و با شما اصلاحش کند.</p></div><div>{benefits.map(({ n, icon: Icon, title, desc, points }) => <article className="ref-benefit" key={n}><span>{n}</span><div><h3>{title}</h3><p>{desc}</p><ul>{points.map((point) => <li key={point}>{point}</li>)}</ul></div><i><Icon /></i></article>)}</div></div></section>

      <section className="ref-steps" id="steps"><div className="container"><div className="ref-steps-head"><div><span className="ref-eyebrow dark">مسیر کار</span><h2>چهار قدم از ثبت‌نام تا پیشرفتی که می‌توان دید</h2></div><p>هر قدم کوتاه و روشن است؛ بدون فرم‌های طولانی و بدون حدس‌زدن.</p></div><ol>{steps.map((step, index) => <li key={step.n}><i className={index === 0 ? "active" : ""} /><small>قدم {step.n} · {step.tag}</small><h3>{step.title}</h3><p>{step.desc}</p></li>)}</ol></div></section>

      <section className="ref-cta container"><div><span className="ref-comet" aria-hidden="true">✦</span><div><h2>امروز مسیر مطالعه‌تان را شروع کنید.</h2><p>ثبت‌نام چند دقیقه بیشتر طول نمی‌کشد. بعد از آن برنامه‌ی هفته‌ی اول و امکان رزرو جلسه‌ی مشاوره را می‌بینید.</p></div><div><Link className="button" href="/auth?mode=signup">ساخت حساب رایگان <ArrowLeft /></Link><small>بدون نیاز به کارت بانکی</small></div></div></section>

      <footer><div className="container ref-footer"><Logo /><nav><a>درباره‌ی نووا</a><a>مشاوران</a><a>قوانین و حریم خصوصی</a><a>تماس با ما</a></nav><p>© ۱۴۰۵ نووا. همه‌ی حقوق محفوظ است.</p></div></footer>
    </main>
  );
}
