import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { ContentEditorForm } from "./content-editor-form";
import { RichContent } from "./rich-content";
import { parseContent } from "@/lib/content";
import { requireProfile } from "@/lib/auth";
import { loadAuthorEditor } from "@/lib/editorial/queries";
import { authorPaths,kindLabels,type EditorialKind } from "@/lib/editorial/types";
export async function AuthorContentEditor({kind,id}:{kind:EditorialKind;id:string}) {
 const {supabase,profile}=await requireProfile(["counselor"]);
 const {data,submission}=await loadAuthorEditor(supabase,kind,id,profile.id);
 if(!data) notFound();
 return <DashboardShell role="counselor" name={profile.full_name}><section className="portal-heading"><div><span>استودیوی محتوا</span><h1>ویرایش {kindLabels[kind]}</h1><p>نسخهٔ منتشرشده تا تأیید تغییرات جدید، بدون تغییر باقی می‌ماند.</p></div><Link className="button button-ghost" href={`/dashboard/counselor/${authorPaths[kind]}`}>بازگشت</Link></section>
 {submission?.rejection_reason&&<div className="portal-alert error"><strong>دلیل رد: </strong>{submission.rejection_reason}</div>}
 {submission?.state==="pending"?<section className="portal-card"><p>این نسخه در حال بررسی است. بعد از اعلام نتیجه می‌توانی دوباره ویرایش و ارسال کنی.</p><h2>{data.title}</h2>{data.summary&&<p>{data.summary}</p>}{data.audio_url&&<audio controls preload="none" src={data.audio_url}/>}<RichContent document={parseContent(data.body)}/></section>:<ContentEditorForm news={kind==="news"} podcast={kind==="podcasts"} resource={{...data,resource_type:data.resource_type??"konkur",grade:data.grade??null,subject:data.subject??null}}/>}
 </DashboardShell>;
}
