import { DashboardShell } from '@/components/dashboard/dashboard-shell';
import { PlannerTopicBankManager } from '@/components/dashboard/planner-topic-bank-manager';
import { requireSuperAdmin } from '@/lib/super-admin';
export default async function PlannerTopicsPage(){
 const {profile}=await requireSuperAdmin();
 return <DashboardShell role="admin" name={profile.full_name} isSuperAdmin>
  <section className="portal-heading"><div><h1>بانک مباحث برنامه‌ریزی</h1><p>مباحث و شمارهٔ صفحهٔ کتاب‌ها را بر اساس چاپ مدیریت کن.</p></div></section>
  <PlannerTopicBankManager/>
 </DashboardShell>;
}
