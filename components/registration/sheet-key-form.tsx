"use client";
import { useActionState,useState } from "react";
import { issueSheetKey } from "@/app/dashboard/admin/google-sheets/actions";
export function SheetKeyForm(){
 const [state,action,pending]=useActionState(issueSheetKey,{});const [copied,setCopied]=useState<string|null>(null);
 return <form action={action} className="portal-form"><p>این اتصال فقط برای ادمین‌ها و وضعیت ثبت‌نام و فعال‌سازی دانش‌آموزهاست.</p><button className="button" disabled={pending}>{pending?"در حال ساخت…":"ساخت کلید فقط‌خواندنی ۹۰روزه"}</button>{state.error&&<p role="alert">{state.error}</p>}{state.token&&<div className="portal-alert success"><strong>این کلید فقط همین بار نمایش داده می‌شود.</strong><p>آن را تنها در پنجرهٔ تنظیمات اسکریپت خودت وارد کن؛ در چت، شیت یا برای مشاور نفرست.</p><textarea readOnly value={state.token} dir="ltr" aria-label="کلید خصوصی اتصال شیت" style={{width:"100%",minHeight:75,overflowWrap:"anywhere"}}/><button type="button" className="button" onClick={async()=>{await navigator.clipboard.writeText(state.token!);setCopied(state.token!);}}>{copied===state.token?"کپی شد":"کپی کلید"}</button></div>}</form>;
}
