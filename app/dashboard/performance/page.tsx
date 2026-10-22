import Link from "next/link";
import {cookies} from "next/headers";
import {requireProfile} from "@/lib/auth";
import {DashboardShell} from "@/components/dashboard/dashboard-shell";
import {togglePerformance,grantPerformance} from "./actions";
export default async function PerformanceSettings({searchParams}:{searchParams:Promise<Record<string,string|undefined>>}){
 const {supabase,profile}=await requireProfile(["admin","content_manager"]);
 const params=await searchParams;
 const {data:allowed,error}=await supabase.rpc("performance_debug_enabled");
 const isAllowed=!error&&allowed===true;
 let isSuper=false;
 if(profile.role==="admin"){
  const {data}=await supabase.rpc("admin_list_super_admins");
  isSuper=(data??[]).some((a:{user_id:string})=>a.user_id===profile.id);
 }
 const enabled=(await cookies()).get("nova-perf")?.value==="1";
 const {data:users}=isSuper?await supabase.rpc("admin_list_users"):{data:[]};
 const targets=((users??[]) as {id:string;full_name:string;role:string}[]).filter(u=>["admin","content_manager"].includes(u.role));
 return <DashboardShell role={profile.role} name={profile.full_name}>
  <section className="portal-card"><h1>تشخیص موقت کندی</h1><p>بدون نیاز به لاگ سرور، زمان مراحل ورود به داشبورد و دریافت اطلاعات پنل مدیر محتوا یا ادمین را ببین و گزارش را کپی کن. کوکی، توکن، ایمیل و محتوای کاربران در گزارش قرار نمی‌گیرد.</p>
  {params.error&&<p role="alert">عملیات انجام نشد؛ مجوز را بررسی کن.</p>}{params.saved&&<p>مجوز موقت ثبت شد.</p>}
  <p>{isAllowed?"این حساب اجازهٔ اندازه‌گیری دارد.":"این حساب مجوز ندارد. سوپرادمین باید دسترسی موقت یک‌ساعته بدهد."}</p>
  <form action={togglePerformance}><input type="hidden" name="enabled" value={enabled?"0":"1"}/><button className="button" disabled={!isAllowed&&!enabled}>{enabled?"خاموش کردن اندازه‌گیری":"فعال کردن اندازه‌گیری در این مرورگر (یک ساعت)"}</button></form>
  {enabled&&isAllowed&&<p><Link href="/dashboard" prefetch={false}>آزمایش مسیر ورود از /dashboard</Link> · <Link href={`/dashboard/${profile.role}`} prefetch={false}>آزمایش مستقیم پنل</Link></p>}
  <p>بعد از فعال‌سازی به لندینگ برو و روی آدمک بزن. فقط در حالت تشخیص، مسیر واسط /dashboard گزارش خودش را نشان می‌دهد؛ سپس با «ادامه به پنل» گزارش صفحهٔ مقصد را می‌بینی. دو گزارش را همراه Timing درخواست‌ها بفرست.</p>
  <p>بررسی مجوز ابزار یک درخواست اضافه دارد و با نام debug_access جدا نمایش داده می‌شود. این زمان‌ها پایان استریم یا رندر مرورگر را اندازه نمی‌گیرند.</p>
  </section>
  {isSuper&&<section className="portal-card"><h2>مجوز موقت برای حساب مشخص</h2><p>حساب مدیر محتوایی را که می‌خواهی با آن تست کنی انتخاب کن. فقط همان حساب، تا یک ساعت مجاز می‌شود؛ سپس در آن حساب همین صفحه را باز و اندازه‌گیری را فعال کن.</p><form action={grantPerformance} className="portal-form"><label>حساب<select name="user_id" required>{targets.map(u=><option key={u.id} value={u.id}>{u.full_name||"بدون نام"} — {u.role==="content_manager"?"مدیر محتوا":"ادمین"}</option>)}</select></label><button className="button" name="enabled" value="1">اعطای مجوز یک‌ساعته</button><button className="button button-secondary" name="enabled" value="0">لغو مجوز حساب انتخاب‌شده</button></form></section>}
 </DashboardShell>;
}
