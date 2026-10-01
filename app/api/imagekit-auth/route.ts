import { getUploadAuthParams } from "@imagekit/next/server";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export async function GET() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return Response.json({ error: "ابتدا وارد حساب شو." }, { status: 401 });
  }

  const [{ data: profile }, { data: counselor }] = await Promise.all([
    supabase.from("profiles").select("role").eq("id", user.id).single(),
    supabase
      .from("counselor_profiles")
      .select("approval_status")
      .eq("user_id", user.id)
      .single(),
  ]);

  if (
    profile?.role !== "counselor" ||
    counselor?.approval_status !== "approved"
  ) {
    return Response.json(
      { error: "فقط مشاور تأییدشده می‌تواند تصویر بارگذاری کند." },
      { status: 403 },
    );
  }

  const publicKey = process.env.IMAGEKIT_PUBLIC_KEY;
  const privateKey = process.env.IMAGEKIT_PRIVATE_KEY;
  if (!publicKey || !privateKey) {
    return Response.json(
      { error: "اتصال ImageKit هنوز کامل نشده است." },
      { status: 503 },
    );
  }

  const authenticationParameters = getUploadAuthParams({
    publicKey,
    privateKey,
  });

  return Response.json({
    ...authenticationParameters,
    publicKey,
  });
}
