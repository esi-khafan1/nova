"use client";
import {useState,type FormEvent} from 'react';
import './phone-link.css';
import {normalizeMobile} from '@/lib/phone-auth';
export function PhoneLink({verifiedPhone,enabled}:{verifiedPhone:string|null;enabled:boolean}){
 const [phone,setPhone]=useState(''),[code,setCode]=useState(''),[pending,setPending]=useState(false),[busy,setBusy]=useState(false),[message,setMessage]=useState(''),[done,setDone]=useState(false),[sentAt,setSentAt]=useState(0);
 if(verifiedPhone||done)return <section className="portal-card phone-link-card"><h2>ورود با شماره تلفن همراه</h2><p>شمارهٔ تأییدشده: <b dir="ltr">{verifiedPhone||phone}</b></p><p>با این شماره و رمز فعلی می‌توانی وارد همین حساب شوی.</p></section>;
 if(!enabled)return null;
 async function submit(event:FormEvent){event.preventDefault();if(busy)return;
  if(!normalizeMobile(phone)){setMessage('شماره معتبر وارد کن.');return;}
  if(pending&&!/^\d{6}$/.test(code)){setMessage('کد شش‌رقمی را وارد کن.');return;}
  if(!pending&&Date.now()<sentAt+60000){setMessage('برای درخواست جدید یک دقیقه صبر کن.');return;}
  setBusy(true);setMessage('');try{
   const response=await fetch('/api/auth/phone',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({action:pending?'verify-link':'link',phone,token:code}),signal:AbortSignal.timeout(20000)});
   const data=await response.json();if(!response.ok)throw Error(data.message);
   if(pending){setCode('');setDone(true);}else{setPending(true);setSentAt(Date.now());setMessage('کد ارسال شد؛ شماره فقط پس از تأیید به همین حساب متصل می‌شود.');}
  }catch(error){setMessage(error instanceof Error?error.message:'ارتباط برقرار نشد.');}finally{setBusy(false);}
 }
 return <section className="portal-card phone-link-card" aria-labelledby="phone-link-title">
  <div className="phone-link-heading"><span className="phone-link-eyebrow">امنیت و ورود به حساب</span><h2 id="phone-link-title">اتصال شماره برای ورود به همین حساب</h2><p>ورود ایمیلی و رمز فعلی حفظ می‌شوند. حساب‌ها ادغام نمی‌شوند.</p></div>
  <form className="phone-link-form" onSubmit={submit} aria-busy={busy}>
   <label className="phone-link-field">شماره تلفن همراه<input type="tel" dir="ltr" autoComplete="tel" placeholder="09xxxxxxxxx" value={phone} onChange={e=>setPhone(e.target.value)} readOnly={pending} disabled={busy} required/></label>
   {pending&&<label className="phone-link-field">کد تأیید<input dir="ltr" value={code} onChange={e=>setCode(e.target.value.replace(/[^0-9]/g,''))} inputMode="numeric" autoComplete="one-time-code" placeholder="کد شش‌رقمی" maxLength={6} disabled={busy} required autoFocus/></label>}
   <div className="phone-link-actions"><button className="button" disabled={busy}>{busy?'در حال بررسی…':pending?'تأیید و اتصال به حساب':'دریافت کد'}</button>{pending&&<button className="button secondary" type="button" disabled={busy} onClick={()=>{setPending(false);setCode('');setMessage('');}}>اصلاح شماره</button>}</div>
  </form>{message&&<p className="phone-link-status" role="status">{message}</p>}
 </section>;
}
