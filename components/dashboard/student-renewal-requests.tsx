import Link from 'next/link';
import {requireProfile} from '@/lib/auth';
import {courseDurationLabel,courseTypeLabel} from '@/lib/courses';
import {markRenewalReviewed} from '@/app/dashboard/admin/registrations/renewal-actions';

type Row={id:string;student_id:string;full_name:string;phone:string|null;grade:number;course:string;months:number;base_price:number;discount_percent:number;payable_price:number;created_at:string};
export async function StudentRenewalRequests(){
 const {supabase}=await requireProfile(['admin']);
 const {data,error}=await supabase.rpc('admin_list_student_renewals');
 if(error||!Array.isArray(data))return <section className="portal-card"><p role="alert">دریافت درخواست‌های تمدید انجام نشد؛ صفحه را تازه کن.</p></section>;
 const rows=data as Row[];if(!rows.length)return null;
 return <section className="portal-card renewal-requests" aria-label="درخواست‌های تمدید"><h2>درخواست‌های تمدید در انتظار بررسی</h2><p>فیش و مبلغ را بررسی کن. ثبت بررسی به‌تنهایی دوره یا وضعیت خدمات را تغییر نمی‌دهد.</p>
  {rows.map(row=><article key={row.id}><strong>{row.full_name||'دانش‌آموز'}</strong>{row.phone&&<small dir="ltr">{row.phone}</small>}<p>{courseTypeLabel(row.course)} · {courseDurationLabel(row.months)} · پایه {row.grade.toLocaleString('fa-IR')}</p><p>قیمت دوره: {row.base_price.toLocaleString('fa-IR')} تومان{row.discount_percent>0?` · تخفیف ${row.discount_percent.toLocaleString('fa-IR')}٪`:''} · مبلغ واریز: <strong>{row.payable_price.toLocaleString('fa-IR')} تومان</strong></p><div><Link href={`/api/renewals/${row.id}/receipt`} target="_blank" rel="noopener">مشاهده فیش تمدید</Link><form action={markRenewalReviewed}><input type="hidden" name="request_id" value={row.id}/><button type="submit" className="button button-secondary">ثبت بررسی فیش</button></form></div></article>)}
 </section>;
}
