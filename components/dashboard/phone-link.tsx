"use client";
import {useState,type FormEvent} from 'react';
import {normalizeMobile} from '@/lib/phone-auth';
export function PhoneLink({verifiedPhone,enabled}:{verifiedPhone:string|null;enabled:boolean}){
 const [phone,setPhone]=useState(''),[code,setCode]=useState(''),[pending,setPending]=useState(false),[busy,setBusy]=useState(false),[message,setMessage]=useState(''),[done,setDone]=useState(false),[sentAt,setSentAt]=useState(0);
 if(verifiedPhone||done)return <section className="portal-card"><h2>ورود با شماره تلفن همراه</h2><p>شمارهٔ تأییدشده: <b dir="ltr">{verifiedPhone||phone}</b></p><p>با این شماره و رمز فعلی می‌توانی وارد همین حساب شوی.</p></section>;
 if(!enabled)return null;
 async function submit(event:FormEvent){event.preventDefault();if(busy)return;
  if(!normalizeMobile(phone)){setMessage('شماره معتبر وارد کن.');return;}
  if(pending&&!/^\d{6}$/.test(code)){setMessage('کد شش‌رقمی را وارد کن.');return;}
  if(!pending&&Date.now()<sentAt+60000){setMessage('برای درخواست جدید یک دقیقه صبر کن.');return;}
  setBusy(true);setMessage('');try{
   const response=await fetch('/api/auth/phone',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({action:pending?'verify-link':'link',phone,token:code})});
   const data=await response.json();if(!response.ok)throw Error(data.message);
   if(pending){setCode('');setDone(true);}else{setPending(true);setSentAt(Date.now());setMessage('کد ارسال شد؛ شماره فقط پس از تأیید به همین حساب متصل می‌شود.');}
  }catch(error){setMessage(error instanceof Error?error.message:'ارتباط برقرار نشد.');}finally{setBusy(false);}
 }
 return <section className="portal-card"><h2>اتصال شماره برای ورود به همین حساب</h2><p>ورود ایمیلی و رمز فعلی حفظ می‌شوند. حساب‌ها ادغام نمی‌شوند.</p><form onSubmit={submit}><label>شماره تلفن همراه<input type="tel" dir="ltr" autoComplete="tel" value={phone} onChange={e=>setPhone(e.target.value)} readOnly={pending} required/></label>{pending&&<label>کد تأیید<input dir="ltr" value={code} onChange={e=>setCode(e.target.value.replace(/[^0-9]/g,''))} inputMode="numeric" autoComplete="one-time-code" maxLength={6} required/></label>}<button className="button" disabled={busy}>{busy?'در حال بررسی…':pending?'تأیید و اتصال به حساب':'دریافت کد'}</button>{pending&&<button type="button" disabled={busy} onClick={()=>{setPending(false);setCode('');}}>اصلاح شماره</button>}</form>{message&&<p role="status">{message}</p>}</section>;
}
