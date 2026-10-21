import { changeUserRole } from "@/app/dashboard/actions";
import type { AppRole } from "@/lib/auth";

export function UserRoleForm({user,canGrantAdmin = false}:{canGrantAdmin?:boolean;user:{id:string;full_name:string;role:AppRole}}) {
 const fieldId=`user-role-${user.id}`;
 return <form action={changeUserRole} className="user-role-form">
  <input type="hidden" name="user_id" value={user.id}/>
  <div className="user-role-field">
   <label htmlFor={fieldId}>نقش حساب</label>
   <select id={fieldId} name="target_role" defaultValue={user.role} aria-label={`نقش ${user.full_name}`}>
    <option value="student">دانش‌آموز</option>
    <option value="counselor">مشاور</option>
    <option value="exam_designer">طراح آزمون</option>
    {canGrantAdmin && <><option value="admin">مدیر</option><option value="content_manager">مدیر محتوا</option></>}
   </select>
  </div>
  <button type="submit" className="role-action promote">ذخیره نقش</button>
 </form>;
}
