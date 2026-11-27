"use server";
import {requireProfile} from '@/lib/auth';
import {parseCourseSelection,type CourseSelection} from '@/lib/courses';
import {receiptImageType} from '@/lib/registration';
import {revalidatePath} from 'next/cache';

type Quote = {status:'ok';quote_id:string;base_price:number;discount_percent:number;payable_price:number};
type QuoteResult = {error?:string;quote?:Quote};
const validQuote=(x:unknown):x is Quote => {
 if(!x||typeof x!=='object'||Array.isArray(x))return false;
 const q=x as Record<string,unknown>;
 return q.status==='ok'&&typeof q.quote_id==='string'&&Number.isSafeInteger(q.base_price)&&Number.isSafeInteger(q.payable_price)&&(q.discount_percent===0||q.discount_percent===15);
};
async function quote(supabase:Awaited<ReturnType<typeof requireProfile>>['supabase'],selection:CourseSelection,code:string):Promise<QuoteResult>{
 const {data,error}=await supabase.rpc('quote_student_renewal',{target_grade:selection.grade,target_field:selection.field,target_course:selection.course,target_months:selection.months,target_code:code});
 if(error)return {error:'دریافت مبلغ انجام نشد؛ وضعیت دوره و حساب را بررسی و دوباره تلاش کن.'};
 if(data?.status==='invalid')return {error:'کد معتبر نیست.'};
 if(data?.status==='limited')return {error:'تعداد تلاش‌ها زیاد است؛ پانزده دقیقه بعد دوباره تلاش کن.'};
 return validQuote(data)?{quote:data}:{error:'دریافت مبلغ انجام نشد؛ دوباره تلاش کن.'};
}
export async function applyRenewalDiscount(selection:CourseSelection,code:string):Promise<QuoteResult>{
 const {supabase,profile}=await requireProfile(['student'],true);
 const parsed=parseCourseSelection(selection as unknown as Record<string,unknown>);
 if(profile.registration_status!=='active'||!parsed||typeof code!=='string'||!code.trim()||code.length>64)return {error:'کد را وارد کن.'};
 return quote(supabase,parsed,code);
}
export async function submitRenewal(_state:{error?:string;success?:string},fd:FormData):Promise<{error?:string;success?:string}>{
 const {supabase,profile}=await requireProfile(['student'],true);
 if(profile.registration_status!=='active')return {error:'امکان ارسال درخواست در این حساب وجود ندارد.'};
 const selection=parseCourseSelection({grade:fd.get('grade'),field:fd.get('field'),course:fd.get('course'),months:fd.get('months')});
 if(!selection||!['base','progress'].includes(selection.course))return {error:'دورهٔ انتخابی معتبر نیست.'};
 let id=String(fd.get('quote_id')??'');
 if(!id){
  const result=await quote(supabase,selection,'');if(!result.quote)return {error:result.error};
  const expected=Number(fd.get('expected_price'));
  if(!Number.isSafeInteger(expected)||expected!==result.quote.payable_price)return {error:'قیمت دوره تغییر کرده است؛ صفحه را تازه کن و پیش از واریز مبلغ جدید را بررسی کن.'};
  id=result.quote.quote_id;
 }
 if(!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id))return {error:'قیمت تأییدشده معتبر نیست؛ صفحه را تازه کن.'};
 const file=fd.get('receipt');if(!(file instanceof File)||!file.size||file.size>5*1024*1024)return {error:'عکس فیش را با حجم حداکثر ۵ مگابایت انتخاب کن.'};
 const bytes=new Uint8Array(await file.arrayBuffer()),type=receiptImageType(bytes);if(!type)return {error:'فیش را به صورت عکس JPG، PNG یا WebP ارسال کن.'};
 const path=`${profile.id}/renewal/${crypto.randomUUID()}.${type.extension}`;
 const bucket=supabase.storage.from('registration-receipts');const uploaded=await bucket.upload(path,bytes,{contentType:type.mime,upsert:false});
 if(uploaded.error)return {error:'بارگذاری فیش انجام نشد؛ دوباره تلاش کن.'};
 const name=(file.name.split(/[\\/]/).pop()??'').replace(/[\u0000-\u001f\u007f]/g,'').slice(0,150)||`receipt.${type.extension}`;
 const {error}=await supabase.rpc('submit_student_renewal',{target_quote_id:id,target_receipt:path,target_name:name});
 if(error){await bucket.remove([path]);return {error:'ثبت درخواست انجام نشد؛ ممکن است درخواست دیگری در انتظار بررسی باشد یا اعتبار قیمت پایان یافته باشد. برای پیگیری با پشتیبانی تماس بگیر.'};}
 revalidatePath('/dashboard/admin/registrations');revalidatePath('/dashboard/registration');
 return {success:'درخواست تمدید و فیش ارسال شد و در انتظار بررسی است. خدمات و سوابق فعلی تغییری نکرده‌اند.'};
}
