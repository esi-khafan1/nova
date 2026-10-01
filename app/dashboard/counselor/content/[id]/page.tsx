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
    .from("resources")
    .select("id,title,summary,body,resource_type,grade,subject,status")
    .eq("id", id)
    .eq("author_id", profile.id)
    .single();

  if (!data) notFound();

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading content-editor-heading">
        <div>
          <span>استودیوی محتوا</span>
          <h1>ویرایش محتوا</h1>
          <p>تغییرات را ذخیره کن یا نسخه تازه را مستقیم منتشر کن.</p>
        </div>
        <Link
          className="button button-ghost"
          href="/dashboard/counselor/content"
        >
          بازگشت به محتواها
        </Link>
      </section>
      <ContentEditorForm resource={data} />
    </DashboardShell>
  );
}
