"use server";
import { requireProfile } from "@/lib/auth";
export async function searchExamStudents(query: string, offset=0) {
 const {supabase}=await requireProfile(["exam_designer"]);
 const {data,error}=await supabase.rpc("search_exam_students",{search_text:String(query).slice(0,100),page_offset:Math.max(0,Math.floor(offset)),page_size:51});
 if(error) return {students:[],hasMore:false,error:"دریافت دانش‌آموزها انجام نشد؛ دوباره تلاش کن."};
 return {students:(data??[]).slice(0,50),hasMore:(data??[]).length>50};
}
