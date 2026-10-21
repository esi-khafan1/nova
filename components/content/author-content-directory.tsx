import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import { formatPersianDate } from "@/lib/content";
import { authorPaths, publicPaths, tableNames, kindLabels, reviewLabels, type EditorialKind, type ReviewState } from "@/lib/editorial/types";

type Row = {id:string;title:string;summary:string|null;status:string;updated_at:string;rejection_reason?:string|null;live?:boolean};
export async function AuthorContentDirectory({kind,saved}:{kind:EditorialKind;saved?:string}) {
 const {supabase,profile}=await requireProfile(["counselor"]);
 const [live,submissions]=await Promise.all([
  supabase.from(tableNames[kind]).select("id,title,summary,status,updated_at").eq("author_id",profile.id),
  supabase.from("content_submissions").select("content_id,state,rejection_reason,updated_at,title:payload->>title,summary:payload->>summary").eq("kind",kind).eq("author_id",profile.id),
 ]);
 const rows=new Map<string,Row>();
 for(const row of live.data??[]) rows.set(row.id,{...row,live:row.status==="published"});
 for(const raw of submissions.data??[]) {
  const row=raw as unknown as {content_id:string;state:string;rejection_reason:string|null;updated_at:string;title:string;summary:string|null};
  rows.set(row.content_id,{id:row.content_id,title:row.title,summary:row.summary,status:row.state,rejection_reason:row.rejection_reason,updated_at:row.updated_at,live:rows.get(row.content_id)?.live});
 }
 const base=`/dashboard/counselor/${authorPaths[kind]}`;
 return <DashboardShell role="counselor" name={profile.full_name}>
  <section className="portal-heading content-dashboard-heading"><div><span>استودیوی محتوا</span><h1>{kindLabels[kind]}‌های من</h1><p>پیش‌نویس را ذخیره کن یا برای مدیر محتوا بفرست. انتشار فقط پس از تأیید انجام می‌شود.</p></div><Link className="button" href={`${base}/new`}>نوشتن {kindLabels[kind]}</Link></section>
  {saved&&<div className="portal-alert success">نسخهٔ جدید ذخیره شد. اگر برای بررسی فرستاده‌ای، نتیجه همین‌جا نمایش داده می‌شود.</div>}
  {live.error||submissions.error?<section className="portal-card" role="alert">دریافت محتوا انجام نشد؛ صفحه را دوباره باز کن.</section>:
  rows.size?<div className="content-dashboard-list">{[...rows.values()].sort((a,b)=>b.updated_at.localeCompare(a.updated_at)).map(row=><article className="portal-card content-dashboard-item" key={row.id}><div><div className="content-dashboard-meta"><span className={`content-status ${row.status}`}>{reviewLabels[row.status as ReviewState]??"بایگانی‌شده"}</span><span>{formatPersianDate(row.updated_at)}</span></div><h2>{row.title}</h2>{row.summary&&<p>{row.summary}</p>}{row.rejection_reason&&<p className="portal-alert error"><strong>دلیل رد: </strong>{row.rejection_reason}</p>}{row.live&&row.status!=="published"&&<p>نسخهٔ قبلی همچنان روی سایت است؛ این تغییرات هنوز منتشر نشده‌اند.</p>}</div><div className="content-dashboard-actions"><Link className="button button-secondary button-small" href={`${base}/${row.id}`}>{row.status==="pending"?"مشاهدهٔ نسخهٔ ارسالی":"ویرایش"}</Link>{row.live&&<Link className="button button-ghost button-small" href={`/${publicPaths[kind]}/${row.id}`}>نسخهٔ منتشرشده</Link>}</div></article>)}</div>:
  <section className="portal-card portal-empty"><h2>هنوز محتوایی نداری</h2><Link className="button" href={`${base}/new`}>نوشتن اولین {kindLabels[kind]}</Link></section>}
 </DashboardShell>;
}
