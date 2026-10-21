import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { formatPersianDate } from "@/lib/content";
import { kindLabels,reviewLabels,type EditorialKind,type ReviewState } from "@/lib/editorial/types";
import "./editorial.css";
export default async function ContentManagerPage({searchParams}:{searchParams:Promise<Record<string,string|undefined>>}) {
 const {supabase,profile}=await requireProfile(["content_manager"]);
 const params=await searchParams;
 const page=Math.max(0,Math.min(100000,Math.floor(Number(params.page)||0)));
 const state=["pending","rejected","published"].includes(params.state??"")?params.state!:"pending";
 const [result,authors]=await Promise.all([
  supabase.from("content_submissions").select("id,kind,author_id,state,version,updated_at,rejection_reason,title:payload->>title,summary:payload->>summary",{count:"exact"}).eq("state",state).order("updated_at",{ascending:false}).order("id").range(page*50,page*50+49),
  supabase.rpc("editorial_authors"),
 ]);
 const names=new Map<string,string>((authors.data??[]).map((a:{author_id:string;full_name:string})=>[a.author_id,a.full_name]));
 return <DashboardShell role="content_manager" name={profile.full_name}>
  <section className="portal-heading"><div><span>میز بررسی</span><h1>مدیریت محتوای نووا</h1><p>مقاله، خبر و پادکست ارسالی مشاورها را بررسی، ویرایش و تأیید یا با دلیل رد کن.</p></div></section>
  <nav className="editorial-tabs" aria-label="وضعیت محتوا">{(["pending","published","rejected"] as const).map(item=><Link key={item} href={`/dashboard/content_manager?state=${item}`} aria-current={state===item?"page":undefined}>{reviewLabels[item]}</Link>)}</nav>
  {params.done&&<div className="portal-alert success">نتیجهٔ بررسی ثبت شد و در پنل مشاور قابل مشاهده است.</div>}
  {params.error&&<div className="portal-alert error">عملیات انجام نشد؛ صفحه را دوباره باز کن.</div>}
  {result.error||authors.error?<section className="portal-card" role="alert">دریافت فهرست انجام نشد؛ دوباره تلاش کن.</section>:result.data?.length?<div className="editorial-grid">{result.data.map(raw=>{
   const row=raw as unknown as {id:string;kind:EditorialKind;title:string;summary:string|null;author_id:string;updated_at:string;state:ReviewState;rejection_reason:string|null};
   return <article className="portal-card editorial-card" key={row.id}><div className="editorial-meta"><span>{kindLabels[row.kind]}</span><span>{reviewLabels[row.state]}</span></div><h2>{row.title}</h2><p>{row.summary}</p><p>نویسنده: {names.get(row.author_id)||"نام ثبت نشده"}</p><small>{formatPersianDate(row.updated_at)}</small>{row.rejection_reason&&<p>دلیل رد: {row.rejection_reason}</p>}<Link className="button" href={`/dashboard/content_manager/${row.id}`}>{row.state==="pending"?"بررسی و تصمیم‌گیری":"مشاهدهٔ نتیجه"}</Link></article>;
  })}</div>:<section className="portal-card portal-empty"><h2>محتوایی در این بخش نیست</h2><p>ارسال‌های جدید مشاورها در بخش «در انتظار بررسی» نمایش داده می‌شوند.</p></section>}
  <nav className="editorial-tabs" aria-label="صفحه‌بندی">{page>0&&<Link href={`/dashboard/content_manager?state=${state}&page=${page-1}`}>صفحهٔ قبل</Link>}{(result.count??0)>(page+1)*50&&<Link href={`/dashboard/content_manager?state=${state}&page=${page+1}`}>صفحهٔ بعد</Link>}</nav>
 </DashboardShell>;
}
