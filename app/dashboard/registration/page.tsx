import Link from "next/link";
import { redirect } from "next/navigation";
import { Logo } from "@/components/logo";
import { signOut } from "@/app/dashboard/actions";
import { requireProfile } from "@/lib/auth";
import { RegistrationForm } from "@/components/registration/registration-form";
import type { RegistrationFormValues } from "@/lib/registration";
import "@/app/registration.css";
export default async function RegistrationPage(){
 const {supabase,profile}=await requireProfile(["student"],true);
 if(profile.registration_status==="active")redirect("/dashboard/student");
 const {data,error}=await supabase.from("student_registrations").select("first_name,last_name,phone,telegram_id,grade,study_field,province,city,receipt_name").eq("student_id",profile.id).maybeSingle();
 return <div className="registration-page" dir="rtl"><header><Logo/><form action={signOut}><button>خروج از حساب</button></form></header><main><section className="registration-welcome"><span>به خانوادهٔ نووا خوش آمدی</span><h1>ثبت‌نامت را کامل کن</h1><p>همهٔ اطلاعات زیر و فیش واریزی را ارسال کن. پس از تأیید فیش و اختصاص مشاور توسط ادمین، پنل برنامه‌ها فعال می‌شود.</p></section>{profile.registration_status==="pending"&&<section className="registration-pending" role="status"><strong>اطلاعاتت ارسال شده و منتظر بررسی است.</strong><p>تا قبل از تأیید می‌توانی اطلاعات یا فیش را اصلاح کنی.</p><Link href="/dashboard/student">بررسی فعال‌شدن پنل ←</Link></section>}<section className="registration-card">{error?<p role="alert">اطلاعات فعلاً دریافت نشد؛ صفحه را دوباره باز کن.</p>:<RegistrationForm values={(data??{}) as RegistrationFormValues}/>}</section></main></div>;
}
