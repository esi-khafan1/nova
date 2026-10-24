import {requireProfile} from '@/lib/auth';
import {DashboardShell} from '@/components/dashboard/dashboard-shell';
import {PhoneLink} from '@/components/dashboard/phone-link';
export default async function AccountPage(){
 const {profile,user}=await requireProfile(undefined,true);
 return <DashboardShell role={profile.role} name={profile.full_name}><PhoneLink enabled={process.env.PHONE_SIGNUP_ENABLED==='true'} verifiedPhone={user.phone_confirmed_at?user.phone||null:null}/></DashboardShell>;
}
