"use server";
import {requireProfile} from '@/lib/auth';
import {revalidatePath} from 'next/cache';
import {redirect} from 'next/navigation';
export async function markRenewalReviewed(fd:FormData){
 const {supabase}=await requireProfile(['admin']);const id=String(fd.get('request_id')??'');
 if(!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id))redirect('/dashboard/admin/registrations?renewal_error=1');
 const {error}=await supabase.rpc('admin_review_student_renewal',{target_request_id:id});
 if(error)redirect('/dashboard/admin/registrations?renewal_error=1');
 revalidatePath('/dashboard/admin/registrations');redirect('/dashboard/admin/registrations?renewal_reviewed=1');
}
