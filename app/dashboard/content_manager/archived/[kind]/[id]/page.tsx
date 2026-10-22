import Link from "next/link";
import {notFound} from "next/navigation";
import {requireProfile} from "@/lib/auth";
import {DashboardShell} from "@/components/dashboard/dashboard-shell";
import {ContentEditorForm,type EditableResource} from "@/components/content/content-editor-form";
import {ArchivedContentDecisions} from "@/components/content/archived-content-decisions";
import {editorialKinds,tableNames,kindLabels,type EditorialKind} from "@/lib/editorial/types";
import "../../../editorial.css";
export default async function ArchivedEditor({params,searchParams}:{params:Promise<{kind:string;id:string}>;searchParams:Promise<Record<string,string|undefined>>}) {
 const {supabase,profile}=await requireProfile(["content_manager"]);
 const {kind:rawKind,id}=await params;const query=await searchParams;const kind=rawKind as EditorialKind;
 if(!editorialKinds.includes(kind)||!/^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i.test(id))notFound();
 const {data:live,error}=await supabase.from(tableNames[kind]).select("*").eq("id",id).eq("status","archived").maybeSingle();
 if(error)throw new Error("Archived content unavailable");if(!live)notFound();
 const {data:submission,error:submissionError}=await supabase.from("content_submissions").select("id,state,author_id").eq("kind",kind).eq("content_id",id).maybeSingle();
 if(submissionError)throw new Error("Submission unavailable");
 // Profile RLS stays private; the RPC independently validates the author's role.
 const canReturn=Boolean(live.author_id&&(!submission||(submission.state==="published"&&submission.author_id===live.author_id)));
 const resource={...live,resource_type:live.resource_type??"konkur",grade:live.grade??null,subject:live.subject??null} as EditableResource;
 return <DashboardShell role="content_manager" name={profile.full_name}><section className="portal-heading"><h1>{kindLabels[kind]} بایگانی‌شده: {live.title}</h1><Link className="button button-secondary" href="/dashboard/content_manager?state=archived">بازگشت به بایگانی</Link></section>
 {query.saved&&<p className="portal-alert success">ویرایش ذخیره شد؛ محتوا همچنان بایگانی است.</p>}
 <section className="portal-card"><h2>ویرایش محتوای بایگانی‌شده</h2><p>ذخیرهٔ ویرایش به‌تنهایی محتوا را عمومی نمی‌کند. نسخه‌های جداگانهٔ نویسنده بدون تغییر باقی می‌مانند.</p><ContentEditorForm key={live.updated_at} resource={resource} news={kind==="news"} podcast={kind==="podcasts"} archived={{kind,updatedAt:live.updated_at}}/></section>
 {submission&&submission.state!=="published"&&<p><Link className="button button-secondary" href={`/dashboard/content_manager/${submission.id}`}>مشاهدهٔ نسخهٔ جداگانهٔ نویسنده</Link></p>}
 <ArchivedContentDecisions key={live.updated_at} kind={kind} id={id} updatedAt={live.updated_at} canReturn={canReturn}/></DashboardShell>;
}
