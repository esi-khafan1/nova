import { changeUserRole } from "@/app/dashboard/actions";
import type { AppRole } from "@/lib/auth";

export function UserRoleForm({user,canGrantAdmin = false,search = "",page = 1,filter = "all",blocked = false}:{canGrantAdmin?:boolean;user:{id:string;full_name:string;role:AppRole};search?:string;page?:number;filter?:string;blocked?:boolean}) {
 const fieldId=`user-role-${user.id}`;
 return <form action={changeUserRole} className="user-role-form">
  <input type="hidden" name="user_id" value={user.id}/>
  <input type="hidden" name="directory_search" value={search}/>
  <input type="hidden" name="directory_page" value={page}/>
  <input type="hidden" name="directory_filter" value={filter}/>
  <div className="user-role-field">
   <label htmlFor={fieldId}>نقش حساب</label>
   <select id={fieldId} name="target_role" defaultValue={user.role} disabled={blocked} aria-label={`نقش ${user.full_name}`}>
    <option value="student">دانش‌آموز</option>
    <option value="counselor">مشاور</option>
    <option value="support_agent">پشتیبان سایت</option>
    <option value="exam_designer">طراح آزمون</option>
    {canGrantAdmin && <><option value="admin">مدیر</option><option value="content_manager">مدیر محتوا</option></>}
   </select>
  </div>
  <button type="submit" className="role-action promote" disabled={blocked}>ذخیره نقش</button>
 </form>;
}
