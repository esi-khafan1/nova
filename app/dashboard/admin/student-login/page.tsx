import {DashboardShell} from '@/components/dashboard/dashboard-shell';
import {requireSuperAdmin} from '@/lib/super-admin';
import {StudentLoginManager} from '@/components/dashboard/student-login-manager';
import './student-login.css';
export default async function StudentLoginPage(){
 const {profile,user}=await requireSuperAdmin();
 return <DashboardShell role="admin" name={profile.full_name} isSuperAdmin>
  <section className="portal-heading"><div><span>مدیریت نووا</span><h1>مدیریت ورود دانش‌آموزان</h1><p>این بخش فقط اجازهٔ ورود را مدیریت می‌کند؛ خدمات، دوره و مشاور را فعال یا تغییر نمی‌دهد.</p></div></section>
  {user.email&&user.email_confirmed_at ? <StudentLoginManager/> : <p role="alert" className="portal-alert error">برای این عملیات ابتدا باید ایمیل حساب سوپرادمین تأیید شده باشد.</p>}
 </DashboardShell>;
}
