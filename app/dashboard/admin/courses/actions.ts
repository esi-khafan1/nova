"use server";
import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { requireSuperAdmin } from "@/lib/super-admin";

function done(error: boolean) {
  if (!error) revalidatePath("/", "layout");
  redirect(`/dashboard/admin/courses?${error?"error=1":"saved=1"}`);
}
export async function saveCourseOffer(fd: FormData) {
  const {supabase} = await requireSuperAdmin();
  const grade=String(fd.get("grade")??""), plan=String(fd.get("plan")??""), discount=String(fd.get("discount")??""), price=String(fd.get("price")??"");
  if (!/^(9|10|11|12)$/.test(grade) || !["base","progress"].includes(plan) || !/^\d{1,3}$/.test(discount) || Number(discount)>100 || !/^\d{1,9}$/.test(price) || Number(price)>100000000 || Number(price)%10000!==0) done(true);
  const {error}=await supabase.rpc("super_admin_set_course_offer",{p_grade:Number(grade),p_plan:plan,p_discount_percent:Number(discount),p_monthly_price:Number(price)});
  done(Boolean(error));
}
export async function saveCourseReservation(fd: FormData) {
  const {supabase} = await requireSuperAdmin();
  const status=fd.get("reservation");
  if (status!=="sale" && status!=="reservation" && status!=="sold_out") done(true);
  const {error}=await supabase.rpc("super_admin_set_course_status",{p_status:status});
  done(Boolean(error));
}
