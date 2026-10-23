import {requireProfile} from "@/lib/auth";
import {DashboardShell} from "@/components/dashboard/dashboard-shell";
import {SupportInbox} from "@/components/support/inbox";
export default async function SupportPage(){const {profile}=await requireProfile(['support_agent']);return <DashboardShell role="support_agent" name={profile.full_name}><section className="portal-heading"><div><span>پنل پشتیبانی</span><h1>گفت‌وگو با کاربران نووا</h1><p>نام شما به کاربران نمایش داده نمی‌شود. هر پیام تازهٔ کاربر دوباره در بخش بدون پاسخ قرار می‌گیرد.</p></div></section><SupportInbox/></DashboardShell>;}
