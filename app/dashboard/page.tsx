import Link from "next/link";
import { redirect } from "next/navigation";
import { requireProfile } from "@/lib/auth";
import {performanceEnabled} from "@/lib/performance/access";
import {measurePerformance} from "@/lib/performance/trace";
import {ServerPerformanceReport} from "@/components/performance/server-performance-report";
export default async function Dashboard() {
  const { profile,supabase } = await requireProfile(undefined, true);
  const diagnostic=await measurePerformance("debug_access",()=>performanceEnabled(supabase));
  if(diagnostic)return <main className="container" style={{paddingBlock:40}}><h1>تشخیص مسیر واسط داشبورد</h1><ServerPerformanceReport route="/dashboard"/><p>در حالت عادی این مسیر خودکار به پنل منتقل می‌شود. این توقف فقط برای مشاهدهٔ اندازه‌گیری است.</p><Link className="button" href={`/dashboard/${profile.role}`} prefetch={false}>ادامه به پنل و اندازه‌گیری صفحهٔ مقصد</Link><p><Link href="/dashboard/performance" prefetch={false}>تنظیمات و خاموش‌کردن اندازه‌گیری</Link></p></main>;
  redirect(`/dashboard/${profile.role}`);
}
