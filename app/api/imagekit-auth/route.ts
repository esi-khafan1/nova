import { getUploadAuthParams } from "@imagekit/next/server";
import { NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const supabase = await createClient();
  // Database identity is resolved by auth.uid(); do not trust session metadata.
  // Still wait for fresh getUser before issuing any upload signature.
  const [{data:{user}},{data:profile}]=await Promise.all([
    supabase.auth.getUser(),supabase.rpc("own_dashboard_profile").maybeSingle<{id:string;role:string}>(),
  ]);
  if (!user) return Response.json({ error: "ابتدا وارد حساب شو." }, { status: 401 });

  const purpose = request.nextUrl.searchParams.get("purpose") || "content";
  if (!profile || profile.id !== user.id) return Response.json({error:"برای این نوع آپلود دسترسی نداری."},{status:403});
  let allowed = false;
  if (profile?.role === "content_manager") {
    allowed = ["content", "podcast-audio"].includes(purpose);
  } else if (profile?.role === "counselor") {
    const { data: counselor } = await supabase.from("counselor_profiles").select("approval_status").eq("user_id", user.id).single();
    allowed = counselor?.approval_status === "approved" && ["content", "podcast-audio"].includes(purpose);
  } else if (profile?.role === "exam_designer" && purpose === "exam-question") {
    allowed = true;
  } else if (profile?.role === "student" && purpose === "exam-answer") {
    const { count } = await supabase.from("counselor_students").select("id", { count: "exact", head: true }).eq("student_id", user.id);
    allowed = Boolean(count);
  }
  if (!allowed) return Response.json({ error: "برای این نوع آپلود دسترسی نداری." }, { status: 403 });

  const publicKey = process.env.IMAGEKIT_PUBLIC_KEY;
  const privateKey = process.env.IMAGEKIT_PRIVATE_KEY;
  if (!publicKey || !privateKey) return Response.json({ error: "اتصال ImageKit هنوز کامل نشده است." }, { status: 503 });
  return Response.json({ ...getUploadAuthParams({ publicKey, privateKey }), publicKey });
}
