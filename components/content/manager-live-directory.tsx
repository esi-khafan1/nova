import {performanceEnabled} from "@/lib/performance/access";
import {measurePerformance} from "@/lib/performance/trace";
import {ServerPerformanceReport} from "@/components/performance/server-performance-report";
import Link from "next/link";
import type {SupabaseClient} from "@supabase/supabase-js";
import {ArchiveContentButton} from "./archive-content-button";
import {formatPersianDate} from "@/lib/content";
import {kindLabels,publicPaths,type EditorialKind} from "@/lib/editorial/types";
export async function ManagerLiveDirectory({supabase,state,page}:{supabase:SupabaseClient;state:"published"|"archived";page:number}) {
 const {data,error}=await measurePerformance("editorial_live",()=>supabase.rpc("list_editorial_live",{target_status:state,page_number:page}));
 const diagnostic=await measurePerformance("debug_access",()=>performanceEnabled(supabase));
 const rows=(data??[]) as {kind:EditorialKind;content_id:string;title:string;summary:string|null;updated_at:string;total_count:number}[];
 return <>
  <p>{state==="published"?"همهٔ محتواهای منتشرشده، از جمله محتواهای قدیمی، در این فهرست هستند. بایگانی محتوا را حذف نمی‌کند؛ فقط آن را از نمایش عمومی خارج می‌کند.":"این محتواها حذف نشده‌اند، اما در سایت نمایش عمومی ندارند. بایگانی، ارسال‌های در انتظار بررسی را تغییر نمی‌دهد."}</p>
  {error?<section className="portal-card" role="alert">دریافت فهرست انجام نشد؛ دوباره تلاش کن.</section>:rows.length?<div className="editorial-grid">{rows.map(row=><article className="portal-card editorial-card" key={`${row.kind}-${row.content_id}`}><div className="editorial-meta"><span>{kindLabels[row.kind]}</span><span>{state==="published"?"منتشرشده":"بایگانی‌شده"}</span></div><h2>{row.title}</h2><p>{row.summary}</p><small>{formatPersianDate(row.updated_at)}</small>{state==="published"&&<><Link className="button" href={`/${publicPaths[row.kind]}/${row.content_id}`}>مشاهدهٔ نسخهٔ عمومی</Link><ArchiveContentButton kind={row.kind} id={row.content_id} updatedAt={row.updated_at}/></>}</article>)}</div>:<section className="portal-card portal-empty"><h2>محتوایی در این بخش نیست</h2></section>}
  <nav className="editorial-tabs" aria-label="صفحه‌بندی">{page>0&&<Link href={`/dashboard/content_manager?state=${state}&page=${page-1}`}>صفحهٔ قبل</Link>}{Number(rows[0]?.total_count??0)>(page+1)*50&&<Link href={`/dashboard/content_manager?state=${state}&page=${page+1}`}>صفحهٔ بعد</Link>}</nav>
 {diagnostic&&<ServerPerformanceReport route="/dashboard/content_manager"/>}
 </>;
}
