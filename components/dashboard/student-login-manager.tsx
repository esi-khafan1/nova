'use client';
import {useState,type FormEvent} from 'react';
type Student={student_id:string;full_name:string;phone_confirmed:boolean};
type Operation='create'|'password'|'confirm'|'password_confirm';
const labels:Record<Operation,string>={create:'ساخت حساب و اجازهٔ ورود',password:'تغییر رمز عبور',confirm:'تأیید دستی شماره',password_confirm:'تغییر رمز و تأیید دستی شماره'};
async function call(body:object){
 const response=await fetch('/api/admin/student-login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body),cache:'no-store'});
 const result=await response.json();if(!response.ok)throw Error(result.error||'عملیات انجام نشد.');return result;
}
export function StudentLoginManager(){
 const [phone,setPhone]=useState(''),[normalized,setNormalized]=useState(''),[student,setStudent]=useState<Student|null>(null),[searched,setSearched]=useState(false);
 const [action,setAction]=useState<Operation>('create'),[challenge,setChallenge]=useState(''),[otp,setOtp]=useState(''),[password,setPassword]=useState('');
 const [busy,setBusy]=useState(false),[message,setMessage]=useState('');
 async function lookup(event:FormEvent){event.preventDefault();setBusy(true);setMessage('');setChallenge('');setPassword('');setOtp('');setSearched(false);
  try{const result=await call({step:'lookup',phone});setStudent(result.student);setNormalized(result.phone);setAction(result.student?'password':'create');setSearched(true);}
  catch(e){setMessage(e instanceof Error?e.message:'خطا');}finally{setBusy(false);}}
 async function start(event:FormEvent){event.preventDefault();setBusy(true);setMessage('');
  try{const result=await call({step:'start',action,phone:normalized,target_id:student?.student_id??null});setChallenge(result.challenge_id);setMessage('کد به ایمیل تأییدشدهٔ سوپرادمین ارسال شد.');}
  catch(e){setMessage(e instanceof Error?e.message:'خطا');}finally{setBusy(false);}}
 async function verify(event:FormEvent){event.preventDefault();setBusy(true);setMessage('');
  try{await call({step:'verify',challenge_id:challenge,code:otp,password});setChallenge('');setPassword('');setOtp('');setSearched(false);setMessage('عملیات انجام شد. خدمات و مشاور تغییری نکردند.');}
  catch(e){setMessage(e instanceof Error?e.message:'خطا');}finally{setBusy(false);}}
 return <section className="portal-card student-login-manager">
  <p>شماره را از راه مطمئن بررسی کن. تأیید دستی شماره به معنی دریافت پیامک توسط دانش‌آموز نیست.</p>
  <form onSubmit={lookup} className="student-login-form"><label>شمارهٔ دانش‌آموز<input type="tel" dir="ltr" required autoComplete="off" value={phone} onChange={e=>setPhone(e.target.value)} disabled={busy||Boolean(challenge)} placeholder="09xxxxxxxxx"/></label><button className="button" disabled={busy||Boolean(challenge)}>بررسی شماره</button></form>
  {searched&&!challenge&&<form onSubmit={start} className="student-login-form">
   <p>{student?<>حساب دانش‌آموز: <strong>{student.full_name||'نام ثبت نشده'}</strong> · {student.phone_confirmed?'شماره تأیید شده':'شماره تأیید نشده'}</>:<>حساب دانش‌آموزی با این شماره پیدا نشد. اگر شماره متعلق به نقش دیگری باشد، ساخت حساب انجام نمی‌شود.</>}</p>
   <label>عملیات<select value={action} onChange={e=>setAction(e.target.value as Operation)} disabled={busy}>
    {!student&&<option value="create">{labels.create}</option>}
    {student&&<option value="password">{labels.password}</option>}
    {student&&!student.phone_confirmed&&<><option value="confirm">{labels.confirm}</option><option value="password_confirm">{labels.password_confirm}</option></>}
   </select></label>
   <button className="button" disabled={busy}>ارسال کد به ایمیل سوپرادمین</button>
  </form>}
  {challenge&&<form onSubmit={verify} className="student-login-form">
   <p>عملیات: <strong>{labels[action]}</strong> · شماره: <span dir="ltr">{normalized}</span></p>
   <label>کد ایمیل<input dir="ltr" inputMode="numeric" autoComplete="one-time-code" value={otp} onChange={e=>setOtp(e.target.value.replace(/[^0-9]/g,''))} required minLength={8} maxLength={8} disabled={busy}/></label>
   {action!=='confirm'&&<label>رمز عبور جدید<input type="password" dir="ltr" autoComplete="new-password" value={password} onChange={e=>setPassword(e.target.value)} required minLength={8} maxLength={128} disabled={busy}/><small>۸ تا ۱۲۸ نویسه با صفحه‌کلید انگلیسی.</small></label>}
   <div className="student-login-buttons"><button className="button" disabled={busy}>تأیید و انجام عملیات</button><button className="button button-secondary" type="button" disabled={busy} onClick={()=>{setChallenge('');setPassword('');setOtp('');setMessage('');}}>انصراف</button></div>
  </form>}
  {message&&<p role="status" className="student-login-message">{message}</p>}
 </section>;
}
