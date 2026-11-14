import { DashboardShell } from '@/components/dashboard/dashboard-shell';
import { PlannerTopicBankManager } from '@/components/dashboard/planner-topic-bank-manager';
import { requireProfile } from '@/lib/auth';
export default async function PlannerTopicsPage(){
 const {profile}=await requireProfile(['admin']);
 return <DashboardShell role="admin" name={profile.full_name}>
  <section className="portal-heading"><div><h1>بانک مباحث برنامه‌ریزی</h1><p>مباحث و شمارهٔ صفحهٔ کتاب‌ها را بر اساس چاپ مدیریت کن.</p></div></section>
  <PlannerTopicBankManager/>
 </DashboardShell>;
}
