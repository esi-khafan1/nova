'use server';
import {requireProfile} from '@/lib/auth';
import {revalidatePath} from 'next/cache';

export async function saveStudentName(_state:{error:string},fd:FormData):Promise<{error:string}>{
 const {supabase,user,profile}=await requireProfile(['student'],true);
 const value=fd.get('full_name');
 const name=typeof value==='string' ? value.trim().replace(/\s+/gu,' ') : '';
 if(name.length<3||name.length>121||!/^\S+\s+\S+(?:\s+\S+)*$/u.test(name))return {error:'نام و نام خانوادگی را کامل وارد کن.'};
 // This special form fills a blank name only; it never overwrites an existing name.
 if(profile.full_name?.trim())return {error:'نام قبلاً ثبت شده است. صفحه را تازه کن.'};
 const {data,error}=await supabase.from('profiles').update({full_name:name}).eq('id',user.id).eq('full_name',profile.full_name).select('id');
 if(error||!data?.length)return {error:'نام ثبت نشد؛ صفحه را تازه کن و دوباره تلاش کن.'};
 revalidatePath('/dashboard/student');revalidatePath('/dashboard/student/account');revalidatePath('/dashboard/registration');
 return {error:''};
}
