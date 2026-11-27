"use client";
import {useActionState,useState,startTransition,type FormEvent} from 'react';
import {applyRenewalDiscount,submitRenewal} from '@/app/dashboard/registration/renewal-actions';
import {courseDurationLabel,coursePrice,courseTypeLabel,type CourseSelection} from '@/lib/courses';
import type {CourseOffers} from '@/lib/course-offers';
import {RenewalNotice} from '@/components/registration/renewal-notice';
import {studyFieldLabels} from '@/lib/study-catalog';

type Quote={quote_id:string;base_price:number;discount_percent:number;payable_price:number};
export function RenewalForm({selection,offers}:{selection:CourseSelection;offers:CourseOffers}){
 const [state,action,pending]=useActionState(submitRenewal,{}),[code,setCode]=useState(''),[quote,setQuote]=useState<Quote|null>(null),[error,setError]=useState(''),[checking,setChecking]=useState(false);
 const base=coursePrice(selection,offers),money=(n:number)=>n.toLocaleString('fa-IR');
 if(base===null)return <p role="alert">قیمت دوره در دسترس نیست؛ لطفاً وجهی واریز نکن.</p>;
 const apply=async()=>{if(checking)return;setError('');setQuote(null);setChecking(true);
  try{const result=await applyRenewalDiscount(selection,code);if(!result.quote){setError(result.error??'بررسی انجام نشد.');return;}setQuote(result.quote);setCode('');}
  catch{setError('بررسی انجام نشد؛ دوباره تلاش کن.');}finally{setChecking(false);}
 };
 const submit=(event:FormEvent<HTMLFormElement>)=>{event.preventDefault();if(!event.currentTarget.reportValidity())return;if(code.trim()){setError('ابتدا کد را اعمال کن یا کادر را خالی بگذار.');return;}startTransition(()=>action(new FormData(event.currentTarget)));};
 return <form className="registration-form" action={action} onSubmit={submit}>
  <section className="registration-course-summary" aria-label="دورهٔ انتخابی"><h2>درخواست تمدید</h2><dl><div><dt>پلن انتخابی</dt><dd>{courseTypeLabel(selection.course)}</dd></div><div><dt>بازهٔ انتخابی</dt><dd>{courseDurationLabel(selection.months)}</dd></div><div><dt>پایهٔ تحصیلی</dt><dd>{money(selection.grade)}</dd></div>{selection.field&&<div><dt>رشته</dt><dd>{studyFieldLabels[selection.field]}</dd></div>}</dl></section>
  <section className="registration-payment" aria-label="اطلاعات واریز"><h3>واریز و ارسال فیش</h3><RenewalNotice payment/>
   <div className="renewal-code"><label>کد تخفیف<input type="text" autoComplete="off" autoCapitalize="characters" spellCheck={false} maxLength={64} disabled={checking||pending} value={code} onChange={e=>{setCode(e.target.value);setQuote(null);setError('')}} dir="ltr"/></label><button type="button" className="button button-secondary" onClick={()=>void apply()} disabled={checking||pending}>{checking?'در حال بررسی…':'اعمال'}</button></div>
   {error&&<p className="portal-alert error" role="alert">{error}</p>}
   {quote&&<p role="status">تخفیف ۱۵ درصدی اعمال شد. مبلغ تأییدشده برای ارسال فیش تا ۲۴ ساعت معتبر است. <button type="button" onClick={()=>setQuote(null)}>حذف تخفیف</button></p>}
   <p>مبلغ دوره: <strong>{money(quote?.base_price??base)} تومان</strong>{quote&&<> · تخفیف: {money(quote.base_price-quote.payable_price)} تومان</>}</p>
   <p>مبلغ قابل واریز: <strong>{money(quote?.payable_price??base)} تومان</strong></p><p>این مبلغ پس از هماهنگی با نووا به کارت یا شبای زیر واریز شود؛ سپس عکس فیش را ارسال کن.</p>
   <dl><div><dt>شمارهٔ کارت</dt><dd dir="ltr">6219861870360897</dd></div><div><dt>شمارهٔ شبا</dt><dd dir="ltr">IR300560611828006622585901</dd></div><div><dt>صاحب کارت و حساب</dt><dd>یاسمین شریفی نسب</dd></div></dl>
  </section>
  <input type="hidden" name="grade" value={selection.grade}/><input type="hidden" name="field" value={selection.field??''}/><input type="hidden" name="course" value={selection.course}/><input type="hidden" name="months" value={selection.months}/><input type="hidden" name="expected_price" value={base}/><input type="hidden" name="quote_id" value={quote?.quote_id??''}/>
  <label className="registration-upload">عکس فیش تمدید<input name="receipt" type="file" accept="image/jpeg,image/png,image/webp" required/><small>JPG، PNG یا WebP تا ۵ مگابایت؛ فیش خصوصی است.</small></label>
  {state.error&&<p className="portal-alert error" role="alert">{state.error}</p>}{state.success&&<p className="portal-alert" role="status">{state.success}</p>}
  {!state.success&&<button className="button" disabled={pending||checking}>{pending?'در حال ارسال…':'ارسال فیش تمدید برای بررسی'}</button>}
 </form>;
}
