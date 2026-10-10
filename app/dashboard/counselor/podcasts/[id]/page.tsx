import Link from "next/link";
import { notFound } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { ContentEditorForm } from "@/components/content/content-editor-form";
import { requireProfile } from "@/lib/auth";

export default async function EditContentPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const { supabase, profile } = await requireProfile(["counselor"]);
  const { data } = await supabase
    .from("podcasts")
    .select(
      "id,title,summary,body,status,resource_type,grade,subject,audio_url,audio_seconds",
    )
    .eq("id", id)
    .eq("author_id", profile.id)
    .single();

  if (!data) notFound();

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading content-editor-heading">
        <div>
          <span>پادکست‌های نووا</span>
          <h1>ویرایش پادکست</h1>
          <p>متن، تصویر و ویس را بررسی کن؛ سپس تغییرات را ذخیره یا منتشر کن.</p>
        </div>
        <Link
          className="button button-ghost"
          href="/dashboard/counselor/podcasts"
        >
          بازگشت به پادکست‌ها
        </Link>
      </section>
      <ContentEditorForm
        podcast
        resource={{
          ...data,
        }}
      />
    </DashboardShell>
  );
}
