import {requireProfile} from '@/lib/auth';
import {hasSuperAdminAccess} from '@/lib/super-admin';
import {DashboardShell} from '@/components/dashboard/dashboard-shell';
import {PhoneLink} from '@/components/dashboard/phone-link';
export default async function AccountPage(){
 const context=await requireProfile(undefined,true);
 const {profile,user}=context;
 const isSuperAdmin=profile.role==='admin' && await hasSuperAdminAccess(context);
 return <DashboardShell role={profile.role} name={profile.full_name} isSuperAdmin={isSuperAdmin}><PhoneLink enabled={process.env.PHONE_SIGNUP_ENABLED==='true'} verifiedPhone={user.phone_confirmed_at?user.phone||null:null}/></DashboardShell>;
}
