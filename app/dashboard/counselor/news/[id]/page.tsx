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
    .from("konkur_news")
    .select(
      "id,title,summary,body,status,source_name,source_url,source_published_at",
    )
    .eq("id", id)
    .eq("author_id", profile.id)
    .single();

  if (!data) notFound();

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading content-editor-heading">
        <div>
          <span>اخبار کنکور</span>
          <h1>ویرایش خبر</h1>
          <p>متن و منبع خبر را بررسی کن، سپس تغییرات را ذخیره یا منتشر کن.</p>
        </div>
        <Link className="button button-ghost" href="/dashboard/counselor/news">
          بازگشت به خبرها
        </Link>
      </section>
      <ContentEditorForm
        news
        resource={{
          ...data,
          resource_type: "konkur",
          grade: null,
          subject: null,
        }}
      />
    </DashboardShell>
  );
}
