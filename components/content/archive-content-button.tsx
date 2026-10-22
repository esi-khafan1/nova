"use client";
import {useActionState} from "react";
import {archiveContent} from "@/app/dashboard/content_manager/actions";
import type {EditorialKind} from "@/lib/editorial/types";
export function ArchiveContentButton({kind,id,updatedAt}:{kind:EditorialKind;id:string;updatedAt:string}) {
 const [state,action,pending]=useActionState(archiveContent,{});
 return <form action={action} onSubmit={event=>{if(!window.confirm("این محتوا از نمایش عمومی خارج و بایگانی شود؟ محتوا حذف نمی‌شود و نسخهٔ در انتظار بررسی تغییر نمی‌کند."))event.preventDefault();}}>
  <input type="hidden" name="kind" value={kind}/><input type="hidden" name="content_id" value={id}/><input type="hidden" name="updated_at" value={updatedAt}/>
  <button className="button button-secondary" type="submit" disabled={pending}>{pending?"در حال بایگانی…":"بایگانی و خروج از نمایش عمومی"}</button>
  {state.error&&<p className="portal-alert error" role="alert">{state.error}</p>}
 </form>;
}
