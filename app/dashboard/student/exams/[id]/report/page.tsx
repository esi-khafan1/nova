import {notFound} from "next/navigation";
import {requireProfile} from "@/lib/auth";
import {PrintableExamReport} from "@/components/dashboard/printable-exam-report";
export default async function StudentReport({params}:{params:Promise<{id:string}>}) {
 const {id}=await params;const {supabase,profile}=await requireProfile(["student"], true);
 const {data:attempt}=await supabase.from("exam_attempts").select("id").eq("exam_id",id).eq("student_id",profile.id).maybeSingle();if(!attempt)notFound();
 // The report RPC independently enforces ownership and global review-release time.
 return <PrintableExamReport viewer="student" params={Promise.resolve({id,attemptId:attempt.id})}/>;
}
