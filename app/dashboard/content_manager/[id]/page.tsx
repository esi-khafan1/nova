import Link from "next/link";
import { ArchiveContentButton } from "@/components/content/archive-content-button";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { ContentEditorForm } from "@/components/content/content-editor-form";
import { RichContent } from "@/components/content/rich-content";
import { parseContent } from "@/lib/content";
import { requireProfile } from "@/lib/auth";
import { editableSubmission,submissionFields,tableNames,kindLabels,reviewLabels,type Submission } from "@/lib/editorial/types";
import { decideSubmission } from "../actions";
import "../editorial.css";
export default async function ReviewPage({params,searchParams}:{params:Promise<{id:string}>;searchParams:Promise<Record<string,string|undefined>>}) {
 const {supabase,profile}=await requireProfile(["content_manager"]);
 const {id}=await params;const query=await searchParams;
 const {data,error}=await supabase.from("content_submissions").select(submissionFields).eq("id",id).maybeSingle();
 if(error)throw new Error("Unable to load editorial submission");if(!data)notFound();
 const submission=data as Submission;
 const {data:live}=await supabase.from(tableNames[submission.kind]).select("id,status,updated_at").eq("id",submission.content_id).eq("status","published").maybeSingle();
 return <DashboardShell role="content_manager" name={profile.full_name}>
  <section className="portal-heading"><div><span>{kindLabels[submission.kind]} · {reviewLabels[submission.state]}</span><h1>{submission.payload.title}</h1></div><Link className="button button-secondary" href="/dashboard/content_manager">بازگشت به فهرست</Link></section>
  {query.saved&&<div className="portal-alert success">ویرایش ذخیره شد؛ اکنون می‌توانی همین نسخه را تأیید یا رد کنی.</div>}
  {query.error&&<div className="portal-alert error">{query.error==="reason"?"دلیل رد باید بین ۵ تا ۲۰۰۰ نویسه باشد.":"نسخه تغییر کرده یا بررسی شده است؛ صفحه را دوباره باز کن."}</div>}
  <section className="portal-card"><h2>پیش‌نمایش نسخهٔ ارسالی</h2>{submission.payload.summary&&<p>{submission.payload.summary}</p>}{submission.payload.audio_url&&<audio controls preload="none" src={submission.payload.audio_url}/>}<RichContent document={parseContent(submission.payload.body)}/></section>
  {submission.state==="pending"?<>
   <section className="portal-card"><h2>ویرایش پیش از انتشار</h2><p>ابتدا ویرایش‌ها را ذخیره کن؛ دکمهٔ تأیید فقط آخرین نسخهٔ ذخیره‌شده را منتشر می‌کند.</p><ContentEditorForm resource={editableSubmission(submission)} news={submission.kind==="news"} podcast={submission.kind==="podcasts"} review={{id:submission.id,kind:submission.kind,version:submission.version}}/></section>
   <section className="portal-card editorial-decisions"><h2>نتیجهٔ بررسی</h2><form action={decideSubmission}><input type="hidden" name="submission_id" value={submission.id}/><input type="hidden" name="version" value={submission.version}/><input type="hidden" name="decision" value="approve"/><button className="button" type="submit">تأیید و انتشار در سایت</button></form>
   <form action={decideSubmission}><input type="hidden" name="submission_id" value={submission.id}/><input type="hidden" name="version" value={submission.version}/><input type="hidden" name="decision" value="reject"/><label htmlFor="rejection-reason">دلیل رد و موارد نیازمند اصلاح</label><textarea id="rejection-reason" name="reason" minLength={5} maxLength={2000} required rows={4}/><button className="button button-secondary" type="submit">رد و بازگشت به مشاور</button></form></section>
  </>:<section className="portal-card"><h2>{reviewLabels[submission.state]}</h2>{submission.rejection_reason&&<p>{submission.rejection_reason}</p>}<p>این نسخه بررسی شده است؛ نسخهٔ ارسالی بعدی جداگانه وارد صف بررسی می‌شود.</p></section>}
 {live&&<section className="portal-card"><h2>بایگانی نسخهٔ عمومی</h2><p>این کار فقط نسخهٔ منتشرشده را از سایت خارج می‌کند؛ نسخهٔ ارسالی بالا و روند بررسی آن تغییر نمی‌کند.</p><ArchiveContentButton kind={submission.kind} id={live.id} updatedAt={live.updated_at}/></section>}
 </DashboardShell>;
}
