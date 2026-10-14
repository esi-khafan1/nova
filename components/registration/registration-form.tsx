"use client";
import { useActionState } from "react";
import { submitRegistration } from "@/app/dashboard/registration/actions";
import { provinces,type RegistrationFormValues } from "@/lib/registration";
export function RegistrationForm({values}:{values:RegistrationFormValues}){
 const [state,action,pending]=useActionState(submitRegistration,{});
 return <form action={action} className="registration-form"><div className="registration-fields">
 <label>نام<input name="first_name" autoComplete="given-name" required minLength={2} maxLength={50} defaultValue={values.first_name}/></label>
 <label>نام خانوادگی<input name="last_name" autoComplete="family-name" required minLength={2} maxLength={70} defaultValue={values.last_name}/></label>
 <label>شمارهٔ تلفن همراه<input name="phone" type="tel" inputMode="tel" autoComplete="tel" required maxLength={16} defaultValue={values.phone} placeholder="۰۹۱۲۱۲۳۴۵۶۷" dir="ltr"/></label>
 <label>آیدی تلگرام<input name="telegram_id" required minLength={5} maxLength={33} defaultValue={values.telegram_id} placeholder="@username" dir="ltr"/></label>
 <label>پایهٔ تحصیلی<select name="grade" required defaultValue={values.grade??""}><option value="" disabled>انتخاب پایه</option><option value="10">دهم</option><option value="11">یازدهم</option><option value="12">دوازدهم</option></select></label>
 <label>رشته<select name="study_field" required defaultValue={values.study_field??""}><option value="" disabled>انتخاب رشته</option><option value="mathematics">ریاضی و فیزیک</option><option value="experimental_sciences">علوم تجربی</option><option value="humanities">علوم انسانی</option></select></label>
 <label>استان<select name="province" required defaultValue={values.province??""}><option value="" disabled>انتخاب استان</option>{provinces.map(p=><option key={p}>{p}</option>)}</select></label>
 <label>شهر محل سکونت<input name="city" autoComplete="address-level2" required minLength={2} maxLength={60} defaultValue={values.city}/></label>
 </div><label className="registration-upload">عکس فیش واریزی ثبت‌نام<input name="receipt" type="file" accept="image/jpeg,image/png,image/webp" required={!values.receipt_name}/><small>عکس JPG، PNG یا WebP؛ حداکثر ۵ مگابایت. دسترسی به فیش خصوصی است.</small>{values.receipt_name&&<small>فیش فعلی: {values.receipt_name} — برای جایگزینی، عکس جدید انتخاب کن.</small>}</label>
 {state.error&&<p className="portal-alert error" role="alert">{state.error}</p>}
 <button className="button" disabled={pending}>{pending?"در حال ارسال…":"ارسال اطلاعات و فیش برای تأیید"}</button>
 </form>;
}
