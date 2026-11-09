'use client';
import {useActionState} from 'react';
import {saveStudentName} from '@/app/dashboard/student/name-actions';
export function StudentNameForm(){
 const [state,action,pending]=useActionState(saveStudentName,{error:''});
 return <section className="portal-card registration-card"><h2>نام و نام خانوادگی خودت را ثبت کن</h2><p>نامت را خودت وارد کن؛ نیازی به انتخاب دوره یا ارسال فیش برای این کار نیست.</p>
  <form action={action} className="registration-form">
   <label>نام و نام خانوادگی<input name="full_name" required minLength={3} maxLength={121} autoComplete="name"/></label>
   <button className="button" type="submit" disabled={pending}>ثبت نام و نام خانوادگی</button>
   {state.error&&<p role="alert">{state.error}</p>}
  </form></section>;
}
