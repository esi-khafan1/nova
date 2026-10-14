"use client";
import { useActionState } from "react";
import { submitRegistration } from "@/app/dashboard/registration/actions";
import { type RegistrationFormValues } from "@/lib/registration";
import { courseTypeLabel, courseDurationLabel, type CourseSelection } from "@/lib/courses";
import { ProvinceCityFields } from "@/components/registration/province-city-fields";
import { studyFieldLabels } from "@/lib/study-catalog";
export function RegistrationForm({ values, mode = "enrollment", selection }: { values: RegistrationFormValues; mode?: "profile" | "enrollment"; selection?: CourseSelection | null }) {
  const [state, action, pending] = useActionState(submitRegistration, {});
  const enrollment = mode === "enrollment";
  return <form action={action} className="registration-form">
    <input type="hidden" name="form_mode" value={mode}/>
    {enrollment && selection && <section className="registration-course-summary" aria-label="دورهٔ انتخابی"><h2>انتخاب تو</h2><dl><div><dt>نوع دوره</dt><dd>{courseTypeLabel(selection.course)}</dd></div><div><dt>بازهٔ انتخابی</dt><dd>{courseDurationLabel(selection.months)}</dd></div><div><dt>پایهٔ تحصیلی</dt><dd>{selection.grade.toLocaleString("fa-IR")}</dd></div><div><dt>رشته</dt><dd>{studyFieldLabels[selection.field]}</dd></div></dl><input type="hidden" name="course" value={selection.course}/><input type="hidden" name="months" value={selection.months}/><input type="hidden" name="grade" value={selection.grade}/><input type="hidden" name="study_field" value={selection.field}/></section>}
    <div className="registration-fields">
      <label className="registration-full-name">نام و نام خانوادگی<input name="full_name" autoComplete="name" required minLength={3} maxLength={121} defaultValue={values.full_name ?? [values.first_name,values.last_name].filter(Boolean).join(" ")}/></label>
      <label>شمارهٔ تلفن همراه<input name="phone" type="tel" inputMode="tel" autoComplete="tel" required maxLength={16} defaultValue={values.phone} placeholder="۰۹۱۲۱۲۳۴۵۶۷" dir="ltr"/></label>
      <label>آیدی تلگرام<input name="telegram_id" required minLength={5} maxLength={33} defaultValue={values.telegram_id} placeholder="@username" dir="ltr"/></label>
      {!selection && <><label>پایهٔ تحصیلی<select name="grade" required defaultValue={values.grade ?? ""}><option value="" disabled>انتخاب پایه</option><option value="10">دهم</option><option value="11">یازدهم</option><option value="12">دوازدهم</option></select></label><label>رشته<select name="study_field" required defaultValue={values.study_field ?? ""}><option value="" disabled>انتخاب رشته</option><option value="mathematics">ریاضی و فیزیک</option><option value="experimental_sciences">علوم تجربی</option><option value="humanities">علوم انسانی</option>{!enrollment && <><option value="arts">هنر</option><option value="foreign_languages">زبان‌های خارجی</option></>}</select></label></>}
      <ProvinceCityFields values={values}/>
    </div>
    <label className="registration-notes">توضیحات تکمیلی <small>(اختیاری)</small><textarea name="additional_notes" maxLength={2000} rows={4} defaultValue={values.additional_notes} placeholder="اگر نکته‌ای دربارهٔ شرایط یا درخواستت داری، اینجا بنویس."/></label>
    {enrollment && <><section className="registration-payment" aria-label="اطلاعات واریز"><h3>واریز و ارسال فیش</h3><p>مبلغ دوره را پس از هماهنگی با نووا، به کارت یا شبای زیر واریز کن؛ سپس عکس خوانای فیش واریزی را در همین فرم ارسال کن.</p><dl><div><dt>شمارهٔ کارت</dt><dd dir="ltr">6219861870360897</dd></div><div><dt>شمارهٔ شبا</dt><dd dir="ltr">IR300560611828006622585901</dd></div><div><dt>صاحب کارت و حساب</dt><dd>یاسمین شریفی نسب</dd></div></dl><small>ارسال فیش به‌تنهایی خدمات را فعال نمی‌کند؛ فیش باید توسط مدیر بررسی و تأیید شود.</small></section><label className="registration-upload">عکس فیش واریزی ثبت‌نام دوره<input name="receipt" type="file" accept="image/jpeg,image/png,image/webp" required={!values.receipt_name}/><small>عکس JPG، PNG یا WebP؛ حداکثر ۵ مگابایت. دسترسی به فیش خصوصی است.</small>{values.receipt_name && <small>فیش فعلی: {values.receipt_name} — برای جایگزینی، عکس جدید انتخاب کن.</small>}</label></>}
    {state.error && <p className="portal-alert error" role="alert">{state.error}</p>}
    {state.success && <p className="portal-alert" role="status">{state.success}</p>}
    <button className="button" disabled={pending}>{pending ? "در حال ارسال…" : enrollment ? "ارسال اطلاعات و فیش برای تأیید" : "ذخیره اطلاعات حساب"}</button>
  </form>;
}
