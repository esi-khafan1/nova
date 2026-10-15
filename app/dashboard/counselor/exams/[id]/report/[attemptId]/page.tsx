import {PrintableExamReport} from "@/components/dashboard/printable-exam-report";
export default function CounselorReport({params}:{params:Promise<{id:string;attemptId:string}>}) {return <PrintableExamReport params={params}/>;}
