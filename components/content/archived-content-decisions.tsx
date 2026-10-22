"use client";
import {useActionState} from "react";
import {manageArchivedContent} from "@/app/dashboard/content_manager/actions";
import type {EditorialKind} from "@/lib/editorial/types";
export function ArchivedContentDecisions({kind,id,updatedAt,canReturn}:{kind:EditorialKind;id:string;updatedAt:string;canReturn:boolean}) {
 const [state,action,pending]=useActionState(manageArchivedContent,{});
 return <section className="portal-card editorial-decisions"><h2>انتشار مجدد یا بازگشت برای اصلاح</h2><p>ابتدا ویرایش‌ها را ذخیره کن؛ انتشار و بازگشت فقط روی آخرین نسخهٔ ذخیره‌شده انجام می‌شود.</p>
 <form action={action}><input type="hidden" name="kind" value={kind}/><input type="hidden" name="id" value={id}/><input type="hidden" name="updated_at" value={updatedAt}/><input type="hidden" name="operation" value="publish"/><button className="button" disabled={pending}>انتشار مجدد در سایت</button></form>
 {canReturn?<form action={action}><input type="hidden" name="kind" value={kind}/><input type="hidden" name="id" value={id}/><input type="hidden" name="updated_at" value={updatedAt}/><input type="hidden" name="operation" value="return"/><label htmlFor="archive-reason">دلیل رد و موارد نیازمند اصلاح</label><textarea id="archive-reason" name="reason" minLength={5} maxLength={2000} required rows={4}/><button className="button button-secondary" disabled={pending}>رد و بازگشت به نویسنده</button></form>:<p>این محتوا نویسندهٔ قابل بازگشت ندارد یا نسخه‌ای جداگانه در حال اصلاح یا بررسی دارد. در صورت وجود، همان نسخه را از فهرست بررسی باز کن؛ کار نویسنده جایگزین نمی‌شود.</p>}
 {state.error&&<p className="portal-alert error" role="alert">{state.error}</p>}
 </section>;
}
