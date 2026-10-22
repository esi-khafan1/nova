import {getRequestClient} from "@/lib/supabase/request-auth";
import type {StudyPlan,StudyCompletion} from "@/lib/student-planning";
type Page={student_id:string;active:boolean;plans:StudyPlan[];completions:StudyCompletion[];has_more:boolean};
export async function loadStudentDashboard(){
 const plans:StudyPlan[]=[],completions:StudyCompletion[]=[];
 let studentId:string|null=null,active=false;
 try{
  const supabase=await getRequestClient();
  for(let offset=0;;offset+=200){
   const {data,error}=await supabase.rpc("student_dashboard_page",{page_offset:offset});
   const page=data as Page|null;
   if(error||!page||typeof page.student_id!=="string"||typeof page.active!=="boolean"||typeof page.has_more!=="boolean"||!Array.isArray(page.plans)||!Array.isArray(page.completions)||page.plans.length>200||page.has_more&&page.plans.length!==200)throw new Error("Invalid dashboard page");
   if(studentId!==null&&(studentId!==page.student_id||active!==page.active))throw new Error("Dashboard identity/state changed");
   studentId=page.student_id;active=page.active;
   plans.push(...page.plans);completions.push(...page.completions);
   if(!page.has_more)break;
  }
  return {studentId,active,plans,completions,failed:false};
 }catch{
  // Never expose a partially loaded history as a complete report.
  return {studentId:null,active:false,plans:[],completions:[],failed:true};
 }
}
